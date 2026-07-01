---
name: spider-debug
description: SPIDER Debug — disciplined root-cause loop when the Quality Gate fails repeatedly for the same reason. Use when Execute is stuck retrying the same failure, instead of ad-hoc "try again".
---

# Spider · Debug

Break out of the ordinary Execute loop and run a disciplined root-cause analysis. Triggered when the Quality Gate fails 2+ times for the **same** reason. Wrap `diagnosing-bugs`.

## The loop

reproduce → minimise → hypothesise → instrument → fix → regression-test.

## Steps

1. **Reproduce** — make the failure deterministic. No fix without a reproducing test.
2. **Minimise** — strip everything unrelated until the failure is at its smallest.
3. **Hypothesise** — state one falsifiable cause.
4. **Instrument** — add the assertion/log/probe that would prove or disprove it.
5. **Fix** — the smallest change that removes the root cause.
6. **Regression-test** — a test that fails without the fix, passes with it.

*completion: a regression test exists that captures the bug, the root cause is named in one sentence, and the Quality Gate passes on the merged result.*

## Constraints

- Run in an isolated context — separate from the Execute loop it was stuck in.
- No fix without a reproducing test. No fixing symptoms while the cause is unnamed.
- This enters the gate-retry counter separately — see Components (Gates).
