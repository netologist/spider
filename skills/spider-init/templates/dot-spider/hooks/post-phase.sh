#!/usr/bin/env bash
# post-phase.sh — log phase completion into the active session record
# (see the SPIDER docs — Components: Hooks).
# Usage: post-phase.sh <phase>
set -euo pipefail

phase="${1:?usage: post-phase.sh <phase>}"
ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
cd "$ROOT"

session_dir="$(ls -d specs/sessions/2*/ 2>/dev/null | tail -1 || true)"
if [[ -z "$session_dir" ]]; then
	echo "post-phase: no active session dir, skipping" >&2
	exit 0
fi

ts="$(date -u +%Y-%m-%dT%H:%M:%SZ)"
log="${session_dir}session.md"
touch "$log"
printf -- '- [%s] phase `%s` completed\n' "$ts" "$phase" >>"$log"
echo "POST-PHASE OK: appended to $log"
