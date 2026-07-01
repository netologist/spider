#!/usr/bin/env bash
# pre-phase.sh — verify the PRECEDING phase produced its mandatory outputs
# before <next-phase> may run (see the SPIDER docs — Components: Hooks).
# Usage: pre-phase.sh <next-phase>
# Exit 0 = ok to proceed; non-zero = block.
set -euo pipefail

phase="${1:?usage: pre-phase.sh <next-phase>}"
ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
cd "$ROOT"

fail() {
	echo "PRE-PHASE FAIL [$phase]: $*" >&2
	exit 1
}

case "$phase" in
research) # after Discovery / Inception
	[[ -f specs/context/PROJECT.md ]] ||
		fail "missing specs/context/PROJECT.md (run discovery/inception)"
	;;
innovate) # after Research
	ls specs/features/*/context.md >/dev/null 2>&1 ||
		fail "no specs/features/*/context.md (run research)"
	;;
plan) # after Innovate
	[[ -s specs/logs/DECISIONS.md ]] ||
		fail "specs/logs/DECISIONS.md empty (run innovate)"
	;;
execute) # after Plan — Gate 3 (human approval)
	spec="$(ls specs/features/*/feature.spec.md 2>/dev/null | head -1 || true)"
	[[ -n "$spec" ]] || fail "no feature.spec.md (run plan)"
	grep -qi '^status:.*approved' "$spec" ||
		fail "feature.spec.md not approved — Gate 3 needs human approval"
	;;
review) # after Execute — Quality Gate is checked separately
	;;
*) ;;
esac

echo "PRE-PHASE OK [$phase]: predecessor outputs present."
