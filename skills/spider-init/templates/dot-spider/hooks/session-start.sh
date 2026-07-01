#!/usr/bin/env bash
# session-start.sh — SPIDER session bootstrap.
# Prints the context files the harness should inject at every session start
# (see the SPIDER docs — Directory Structure / Components: Hooks).
# Usage: session-start.sh   # the harness captures stdout into context
set -euo pipefail

ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
cd "$ROOT"

emit() { # emit <file> <label>
	if [[ -f "$1" ]]; then
		printf '\n===== %s (%s) =====\n' "$2" "$1"
		cat "$1"
	fi
}

emit "AGENTS.md" "Project rules for AI"
emit ".spider/rules.md" "SPIDER custom rules"
emit "specs/sessions/_LESSONS_LEARNED.md" "Distilled lessons (permanent)"
emit "specs/sessions/_POSTMORTEMS.md" "Incident postmortems (permanent)"
emit "specs/architecture/README.md" "ADR index"

# Active session tasks, if a session directory exists.
latest_session="$(ls -d specs/sessions/2*/ 2>/dev/null | tail -1 || true)"
if [[ -n "$latest_session" && -f "${latest_session}tasks.md" ]]; then
	emit "${latest_session}tasks.md" "Active session tasks"
fi
