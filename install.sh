#!/usr/bin/env bash
# install.sh — install the SPIDER skills onto this machine (once per machine).
#
# After install, run `/spider-init` inside a project to scaffold .spider/ + specs/.
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/netologist/spider/main/install.sh | bash
#   curl -fsSL .../install.sh | bash -s -- --harness agents --scope global
#   bash install.sh --harness claude --scope local --dry-run
#
# Options:
#   --harness <claude|codex|agents>   target harness (default: prompt, fallback: agents)
#   --scope   <local|global>          install location (default: prompt, fallback: global)
#   --target <path>                   explicit skills dir (overrides harness/scope)
#   --repo <owner/name|url>           repo to install from (default: netologist/spider)
#   --branch <name>                   branch or tag to install (default: main)
#   --cache-dir <path>                clone location (default: ~/.cache/spider/<name>)
#   --force                           overwrite existing skills without prompting
#   --no-cache                        re-clone fresh (discard the cached checkout)
#   --dry-run                         print actions, change nothing
#   -h, --help                        show this help and exit
set -euo pipefail

REPO_DEFAULT="netologist/spider"
BRANCH_DEFAULT="main"

harness=""
scope=""
target=""
repo="$REPO_DEFAULT"
branch="$BRANCH_DEFAULT"
cache_dir=""
force=0
no_cache=0
dry_run=0

usage() {
	cat "$0" | sed -n '2,21p' 2>/dev/null ||
		grep -E '^# ' "$0" | sed 's/^# \{0,1\}//'
}

die() {
	echo "install: error: $*" >&2
	exit 1
}
run() { # run: print under --dry-run, otherwise execute
	if [[ "$dry_run" -eq 1 ]]; then
		echo "  DRY-RUN: $*"
	else
		"$@"
	fi
}

# --- parse args ---
while [[ $# -gt 0 ]]; do
	case "$1" in
	--harness)
		harness="${2:-}"
		shift 2
		;;
	--scope)
		scope="${2:-}"
		shift 2
		;;
	--target)
		target="${2:-}"
		shift 2
		;;
	--repo)
		repo="${2:-}"
		shift 2
		;;
	--branch)
		branch="${2:-}"
		shift 2
		;;
	--cache-dir)
		cache_dir="${2:-}"
		shift 2
		;;
	--force)
		force=1
		shift
		;;
	--no-cache)
		no_cache=1
		shift
		;;
	--dry-run)
		dry_run=1
		shift
		;;
	-h | --help)
		usage
		exit 0
		;;
	*) die "unknown option: $1 (try --help)" ;;
	esac
done

# --- dependency check ---
command -v git >/dev/null 2>&1 || die "git is required but not found in PATH."

# --- normalize + validate harness/scope given on the command line ---
lower() { printf '%s' "$1" | tr '[:upper:]' '[:lower:]'; }
if [[ -n "$harness" ]]; then
	harness="$(lower "$harness")"
	case "$harness" in claude | codex | agents) ;; *) die "--harness must be claude|codex|agents (got: $harness)" ;; esac
fi
if [[ -n "$scope" ]]; then
	scope="$(lower "$scope")"
	case "$scope" in local | global) ;; *) die "--scope must be local|global (got: $scope)" ;; esac
fi

# --- interactive prompt for anything not provided (works under curl|bash via /dev/tty) ---
ask() { # ask <outvar> <prompt> <default> <opt1> [opt2...]
	local outvar="$1" prompt="$2" def="$3"
	shift 3
	local val opt
	while true; do
		printf '%s (default: %s): ' "$prompt" "$def" >&2
		if ! read -r val </dev/tty 2>/dev/null; then val="$def"; fi
		val="$(lower "${val:-$def}")"
		for opt in "$@"; do
			if [[ "$val" == "$opt" ]]; then
				printf -v "$outvar" '%s' "$val"
				return 0
			fi
		done
		printf '  invalid choice "%s" — expected one of: %s\n' "$val" "$*" >&2
	done
}

if [[ -z "$harness" ]]; then
	if [[ -t 0 ]] || [[ -e /dev/tty ]]; then
		ask harness "Target harness [claude/codex/agents]" "agents" claude codex agents
	else
		harness="agents"
		echo "install: no tty — defaulting --harness to 'agents' (override with --harness)." >&2
	fi
fi
if [[ -z "$scope" && -z "$target" ]]; then
	if [[ -t 0 ]] || [[ -e /dev/tty ]]; then
		ask scope "Install scope [local/global]" "global" local global
	else
		scope="global"
		echo "install: no tty — defaulting --scope to 'global' (override with --scope)." >&2
	fi
fi

# --- resolve repo url + name ---
if [[ "$repo" =~ ^[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+$ ]]; then
	repo_url="https://github.com/$repo"
else
	repo_url="$repo"
fi
repo_name="${repo_url##*/}"
repo_name="${repo_name%.git}"

# --- resolve clone (cache) dir ---
if [[ -z "$cache_dir" ]]; then
	cache_dir="${HOME:-$PWD}/.cache/spider/${repo_name}"
fi

# --- resolve install (target) dir ---
if [[ -n "$target" ]]; then
	install_dir="$target"
else
	base="$HOME"
	[[ "$scope" == "local" ]] && base="$PWD"
	case "$harness" in
	agents) install_dir="$base/.agents/skills" ;;
	claude) install_dir="$base/.claude/skills" ;;
	codex) install_dir="$base/.codex/skills" ;;
	esac
fi

echo "SPIDER install"
echo "  repo:       $repo_url @ $branch"
echo "  cache:      $cache_dir"
echo "  harness:    $harness${scope:+ ($scope)}"
echo "  install to: $install_dir"
[[ "$dry_run" -eq 1 ]] && echo "  mode:       DRY-RUN (no changes)"
echo

# --- clone / update the cache ---
if [[ "$no_cache" -eq 1 && -d "$cache_dir" ]]; then
	run rm -rf "$cache_dir"
fi
if [[ -d "$cache_dir/.git" ]]; then
	run git -C "$cache_dir" fetch --depth 1 origin "$branch"
	run git -C "$cache_dir" checkout -B "$branch" "origin/$branch"
else
	run git clone --depth 1 --branch "$branch" "$repo_url" "$cache_dir"
fi

skill_src="$cache_dir/skills"
[[ -d "$skill_src" ]] || die "no skills/ directory in $cache_dir — wrong repo or branch?"

# --- existing-skills guard ---
existing="$(ls -d "$install_dir"/spider-* 2>/dev/null || true)"
if [[ -n "$existing" ]]; then
	if [[ "$force" -eq 1 ]]; then
		echo "notice: overwriting existing spider-* skills in $install_dir (--force)"
	elif [[ "$dry_run" -eq 1 ]]; then
		echo "  DRY-RUN: would overwrite existing spider-* skills in $install_dir (use --force)"
	else
		# refuse silently in non-interactive; prompt otherwise
		overwrite="n"
		if [[ -t 0 ]] || [[ -e /dev/tty ]]; then
			printf 'Overwrite existing spider-* skills in %s? [y/N]: ' "$install_dir" >&2
			if read -r ow </dev/tty 2>/dev/null; then overwrite="$(lower "$ow")"; fi
		fi
		[[ "$overwrite" == "y" || "$overwrite" == "yes" ]] ||
			die "existing skills found in $install_dir — re-run with --force to overwrite."
	fi
fi

# --- copy skills ---
run mkdir -p "$install_dir"
[[ -n "$existing" ]] && run rm -rf "$install_dir"/spider-*
run cp -r "$skill_src"/spider-* "$install_dir"/

# --- done ---
if [[ "$dry_run" -eq 0 ]]; then
	count="$(find "$install_dir" -maxdepth 1 -name 'spider-*' -type d 2>/dev/null | wc -l | tr -d ' ')"
	echo "✓ Installed $count SPIDER skill(s) → $install_dir"
	echo
	echo "Next: cd into a project and run:  /spider-init"
	echo "Docs: https://netologist.github.io/spider/"
else
	echo "✓ Dry-run complete (nothing was changed)."
fi
