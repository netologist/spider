---
name: spider-plan
description: SPIDER spec authoring — produce an approvable feature.spec.md + TEST-PLAN.md before any code.
disable-model-invocation: true
---

# Spider · Plan

Produce a complete, **approvable** technical spec. The spec is above the code — everything downstream obeys it.

## Steps

1. **Write `feature.spec.md`** — goal (one sentence), out-of-scope (blocks scope creep), user stories (behavior-driven, manually testable), data model, acceptance criteria (concrete, measurable), edge cases, open decisions, `status: draft`.
2. **Write `TEST-PLAN.md`** — coverage target (%), test sequence per story, excluded tests + rationale, test-type distribution (unit / integration / e2e).
3. **Layer the feature files** — spec → behavior → design → tech → tasks → changelog, in descending stability (see Rules, rule 16).
4. **Hold for approval** — status stays `draft` until a human sets `approved`.

*completion: `feature.spec.md` and `TEST-PLAN.md` exist, all open decisions resolved, status `draft` awaiting human approval.*

## Exit gate — MOST CRITICAL

Gate 3 (Plan → Execute): spec `approved`, test-plan approved, coverage target set, edge cases covered, open decisions resolved — full checklist: see the Plan phase reference. Gate 3 needs **human approval**, not a retry.

## Constraints

- No code. No test writing. Status stays `draft` — human approval is required for `approved`.

> Output tables: see the Plan phase reference. External skills it wraps: `to-issues`, `to-prd`, `codebase-design`.
