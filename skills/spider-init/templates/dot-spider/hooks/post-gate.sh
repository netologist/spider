#!/usr/bin/env bash
# post-gate.sh — mechanical gate check + retry/escalation policy
# (see the SPIDER docs — Components: Gates).
#
# Usage: post-gate.sh <gate> <status> [reason]
#   gate   : gate-1 | gate-2 | gate-3 | quality
#   status : pass | fail
#   reason : short description (required when status=fail)
#
# Exit codes:
#   0  pass / proceed
#   1  fail but RETRYABLE (different reason, budget remaining)
#   2  ESCALATE to human (same reason twice, or retries exhausted, or gate-3 awaiting approval)
#
# Reads gate_policy from .spider/config.json (jq if available, else defaults).
set -uo pipefail

gate="${1:?usage: post-gate.sh <gate> <status> [reason]}"
status="${2:?usage: post-gate.sh <gate> <status> [reason]}"
reason="${3:-}"
ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
cd "$ROOT"

cfg=".spider/config.json"
state_dir=".spider/.state"
mkdir -p "$state_dir"
counter="$state_dir/${gate}.count"
last_reason="$state_dir/${gate}.last"

read_cfg() { # read_cfg <jq-expr> <default>
	if command -v jq >/dev/null 2>&1 && [[ -f "$cfg" ]]; then
		jq -r "$1" "$cfg" 2>/dev/null || echo "$2"
	else
		echo "$2"
	fi
}

max=$(read_cfg '.gate_policy.max_gate_retries // 3' 3)
rule=$(read_cfg '.gate_policy.retry_rule // "same_failure_stops_immediately"' same_failure_stops_immediately)

# Gate 3 is human-approval only — no retry semantics.
if [[ "$gate" == "gate-3" ]]; then
	if [[ "$status" == "pass" ]]; then
		echo "POST-GATE [$gate]: human-approved."
		exit 0
	fi
	echo "POST-GATE [$gate]: awaiting human approval." >&2
	exit 2
fi

# PASS — reset the counter and last reason.
if [[ "$status" == "pass" ]]; then
	echo 0 >"$counter"
	rm -f "$last_reason"
	echo "POST-GATE [$gate]: PASS. Retry counter reset."
	exit 0
fi

# FAIL.
prev_reason="$(cat "$last_reason" 2>/dev/null || true)"
count="$(cat "$counter" 2>/dev/null || echo 0)"
count=$((count + 1))

# same_failure_stops_immediately: same reason as last time → escalate now.
if [[ "$rule" == "same_failure_stops_immediately" &&
	-n "$prev_reason" && "$prev_reason" == "$reason" ]]; then
	echo "POST-GATE [$gate]: SAME failure as last attempt ('$reason'). Escalating — no retry spent." >&2
	exit 2
fi

echo "$reason" >"$last_reason"
echo "$count" >"$counter"

if ((count >= max)); then
	echo "POST-GATE [$gate]: retries exhausted ($count/$max). Last reason: '$reason'. Pausing for human." >&2
	exit 2
fi

echo "POST-GATE [$gate]: FAIL ($count/$max) '$reason'. Retry allowed (different reason)."
exit 1
