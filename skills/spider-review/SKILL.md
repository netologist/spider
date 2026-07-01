---
name: spider-review
description: SPIDER Review — validate the implementation against the approved spec, acceptance criteria one by one. Use when Execute passes the Quality Gate and the work must be checked against the spec.
---

# Spider · Review

Validate the implementation **against the spec** — not by feel. Maker ≠ checker: prefer an isolated review context — the agent that wrote the code shouldn't approve it.

## Steps

1. **Spec compliance** — for each acceptance criterion: ✅ pass / ❌ fail / ⚠️ attention. (First review lens.)
2. **Code quality** — architecture, readability, the deep-module discipline. (Second review lens, separate.)
3. **Manual edge cases** — run the edge cases from `feature.spec.md`.
4. **Coverage** — review the coverage report against `TEST-PLAN.md`.
5. **Drift** — update `specs/logs/DRIFT.md` with anything found.
6. **Mark status** — `done` if all pass; if failures, name which phase to return to.

*completion: an acceptance-criteria table exists with a verdict per row; coverage reviewed; `DRIFT.md` updated; status set (`done` or return-to-phase).*

## Constraints

- Two separate lenses (spec compliance, code quality) — run as separate review agents in `standard` / `complex` tiers; skip in `trivial` (see Configuration).
- No code changes here — Review reports, it doesn't fix. Fixes return to Execute.

> Output tables: see the Review phase reference.
