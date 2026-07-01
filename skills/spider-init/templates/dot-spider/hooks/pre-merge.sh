#!/usr/bin/env bash
# pre-merge.sh — run before merging a story-subagent worktree branch
# (subagent + worktree execution mode; see the SPIDER docs — Components: Hooks).
# Usage: pre-merge.sh <branch>
# Non-zero exit aborts the merge.
set -euo pipefail

branch="${1:?usage: pre-merge.sh <branch>}"
ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
cd "$ROOT"

fail() {
	echo "PRE-MERGE FAIL: $*" >&2
	exit 1
}

# Resolve the branch to an object (fails fast if it doesn't exist).
git rev-parse --verify --quiet "$branch^{}" >/dev/null ||
	fail "branch '$branch' does not exist"

# 1. Best-effort conflict check via merge-tree (git-version portable).
base="$(git merge-base HEAD "$branch" 2>/dev/null || true)"
if [[ -n "$base" ]]; then
	# Old merge-tree form: <base> <branch1> <branch2>. Non-zero / conflict
	# markers in output indicate a would-be conflict.
	if ! git merge-tree "$base" HEAD "$branch" 2>/dev/null | grep -q .; then
		: # empty output — nothing to merge; continue
	elif git merge-tree "$base" HEAD "$branch" 2>/dev/null | grep -qE '^(<<<<<<<|=======|>>>>>>>)'; then
		fail "merge of '$branch' would conflict — resolve first"
	fi
fi

# 2. Full test suite green.
if [[ -f package.json ]] && command -v npm >/dev/null 2>&1; then
	npm test --silent --if-present || fail "npm test failed on pre-merge"
elif [[ -f go.mod ]] && command -v go >/dev/null 2>&1; then
	go test ./... || fail "go test failed on pre-merge"
fi

echo "PRE-MERGE OK [$branch]."
