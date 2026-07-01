# Installation

SPIDER is a set of **markdown skills + bash hooks** distributed as a GitHub repo. Installing means
getting the skills onto your machine **once**; then you run `spider-init` inside each project.

| Step | Command | How often |
|------|---------|-----------|
| **Install** (skills → machine) | `install.sh` | once per machine |
| **Init** (scaffold a project) | `/spider-init` | once per project |

## Prerequisites

- `git` (required)
- `curl` (only needed for the one-line install)
- An AI harness that reads skills from a directory: **Claude Code**, **Codex**, or any
  `.agents/`-compatible harness (e.g. Pi)

## Quick install (interactive)

```bash
curl -fsSL https://raw.githubusercontent.com/netologist/spider/main/install.sh | bash
```

The script asks two questions and installs:

1. **Harness** — `claude` / `codex` / `agents`
2. **Scope** — `local` (current dir) or `global` (your home, reusable everywhere)

> **About `curl | bash`:** the pipe means the script reads your answers from the controlling
> terminal (`/dev/tty`), so interactive prompts still work. If you'd rather inspect it first,
> download it: `curl -fsSL …/install.sh -o install.sh`, read it, then `bash install.sh`.

## Non-interactive install

For CI, Dockerfiles, or scripts — pass the answers as flags:

```bash
curl -fsSL https://raw.githubusercontent.com/netologist/spider/main/install.sh \
  | bash -s -- --harness agents --scope global
```

Or run a local copy:

```bash
bash install.sh --harness claude --scope global --force
```

## Options

| Option | Values | Default | Description |
|--------|--------|---------|-------------|
| `--harness` | `claude` \| `codex` \| `agents` | prompt → `agents` | Target harness (decides the install directory) |
| `--scope` | `local` \| `global` | prompt → `global` | `local` = current dir, `global` = home dir |
| `--target <path>` | any path | *(from harness/scope)* | Explicit skills directory; overrides harness/scope |
| `--repo` | `owner/name` or URL | `netologist/spider` | Repo to install from |
| `--branch` | branch or tag | `main` | Version to install |
| `--cache-dir <path>` | any path | `~/.cache/spider/<name>` | Where the repo is cloned |
| `--force` | *(flag)* | off | Overwrite existing skills without prompting |
| `--no-cache` | *(flag)* | off | Discard the cached checkout and clone fresh |
| `--dry-run` | *(flag)* | off | Print every action, change nothing |
| `-h`, `--help` | *(flag)* | — | Show usage |

## Where it installs

Determined by `--harness` × `--scope` (same mapping `spider-init` uses):

| Harness | `--scope global` | `--scope local` |
|---------|------------------|-----------------|
| `agents` | `~/.agents/skills/` | `./.agents/skills/` |
| `claude` | `~/.claude/skills/` | `./.claude/skills/` |
| `codex`  | `~/.codex/skills/`  | `./.codex/skills/` |

Pass `--target /some/path` to install anywhere else.

## Verify

After install, list the skills:

```bash
ls ~/.agents/skills/spider-*     # adjust the path to your harness/scope
```

You should see 13 directories: `spider-init`, `spider-router`, and the 11 phase skills.

## Next step

Install only places the skills on your machine. To actually use SPIDER in a project, scaffold it:

```bash
cd your-project
/spider-init          # creates .spider/ + specs/, wires the git hook
```

See [Getting Started](getting-started.md) for the full bootstrap.

## Manual install (without the script)

If you prefer no installer:

```bash
git clone --depth 1 https://github.com/netologist/spider ~/.cache/spider
cp -r ~/.cache/spider/skills/spider-* ~/.agents/skills/   # or your harness's skills dir
```

## Update

Re-run the installer — it refreshes the cache and (with `--force`) overwrites the installed skills:

```bash
curl -fsSL https://raw.githubusercontent.com/netologist/spider/main/install.sh \
  | bash -s -- --harness agents --scope global --force
```

## Uninstall

Remove the installed skills and the cache:

```bash
rm -rf ~/.agents/skills/spider-* ~/.cache/spider   # adjust the skills path to your harness
```

`spider-init`'s per-project artifacts (`.spider/`, `specs/`) are independent and stay unless you
delete them yourself.
