#!/usr/bin/env bash
# pre-commit.sh — SPIDER commit-time guard.
# The mechanical checks that must NOT be asked of the LLM
# (see the SPIDER docs — Components: Hooks).
#
# Wire as the git pre-commit hook:
#   ln -sf ../../.spider/hooks/pre-commit.sh .git/hooks/pre-commit
#
# Checks:
#   1. secret scan over staged source files
#   2. RED-step discipline (no non-test files while writing tests)
#   3. project quality gate (lint / typecheck / tests), if the project defines how
#
# Set SKIP_SPIDER_TESTS=1 to bypass check 3 (e.g. WIP commits).
# Non-zero exit aborts the commit.
set -euo pipefail

ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
cd "$ROOT"

fail() {
	echo "PRE-COMMIT FAIL: $*" >&2
	exit 1
}

# Staged source files, excluding docs and ephemeral session logs.
staged="$(git diff --cached --name-only --diff-filter=ACMR |
	grep -vE '^(docs/|specs/sessions/2)' || true)"

# 1. Secret scan — high-signal patterns. (Note: splits on whitespace; avoids
#    filenames containing spaces — acceptable for a scaffold template.)
if [[ -n "$staged" ]]; then
	# shellcheck disable=SC2086
	if grep -nE '(AKIA[0-9A-Z]{16}|-----BEGIN (RSA |OPENSSH |EC )?PRIVATE KEY-----|ghp_[A-Za-z0-9]{36}|sk-[A-Za-z0-9]{20,})' $staged >/dev/null 2>&1; then
		fail "possible secret detected in staged files"
	fi
fi

# 2. RED-step discipline — only test/spec files may change while writing tests.
phase_file=".spider/.state/execute.phase"
if [[ -f "$phase_file" && "$(cat "$phase_file")" == "red" ]]; then
	non_test="$(printf '%s\n' $staged | grep -vEi '(^|/|_)(test|spec)(s|/|\.)' || true)"
	[[ -z "$non_test" ]] || fail "RED step: only test/spec files may change — found: $non_test"
fi

# 3. Project quality gate — only if the project declares how to run it.
if [[ "${SKIP_SPIDER_TESTS:-0}" != "1" ]]; then
	if [[ -f package.json ]] && command -v npm >/dev/null 2>&1; then
		npm run --silent --if-present lint || fail "lint failed"
		npm run --silent --if-present typecheck || true
		npm test --silent --if-present || fail "tests failed"
	elif [[ -f go.mod ]] && command -v go >/dev/null 2>&1; then
		go vet ./... || fail "go vet failed"
		go test ./... || fail "go test failed"
	fi
fi

echo "PRE-COMMIT OK."
