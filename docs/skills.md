# Skills

SPIDER ships **13 skills** under `skills/`. Each is a real skill — a trigger condition, a step
discipline ending on a checkable completion criterion, and an output schema — not just prompt text.
They follow the `writing-great-skills` discipline: **user-invoked** skills orchestrate phases and
cost no context load; **model-invoked** skills carry the discipline and can fire on their own.

## Phase skills

| Skill | Type | Purpose |
|-------|------|---------|
| [`spider-init`](../skills/spider-init/SKILL.md) | user | Bootstrap `.spider/` + `specs/`, install skills, wire the git hook |
| [`spider-router`](../skills/spider-router/SKILL.md) | model | Decide which phase runs next, from the current `specs/` state |
| [`spider-discovery`](../skills/spider-discovery/SKILL.md) | user | Brownfield entry — map an existing codebase before changes |
| [`spider-inception`](../skills/spider-inception/SKILL.md) | user | Greenfield entry — elicit decisions, stack, environment from scratch |
| [`spider-research`](../skills/spider-research/SKILL.md) | user | External research — best practices & library docs for one story |
| [`spider-innovate`](../skills/spider-innovate/SKILL.md) | user | Explore the solution space; score ≥2 alternatives before committing |
| [`spider-plan`](../skills/spider-plan/SKILL.md) | user | Produce an approvable `feature.spec.md` + `TEST-PLAN.md` |
| [`spider-spike`](../skills/spider-spike/SKILL.md) | model | Time-boxed PoC to validate an unknown before the full build |
| [`spider-execute`](../skills/spider-execute/SKILL.md) | model | Implement stories with strict TDD, one vertical slice at a time |
| [`spider-debug`](../skills/spider-debug/SKILL.md) | model | Disciplined root-cause loop when the Quality Gate fails repeatedly |
| [`spider-review`](../skills/spider-review/SKILL.md) | model | Validate the implementation against the approved spec |
| [`spider-document`](../skills/spider-document/SKILL.md) | model | Capture every session output before closing |
| [`spider-retro`](../skills/spider-retro/SKILL.md) | user | Digest sessions into lessons, promote decisions, clean up |

## Invocation model

- **user-invoked** — you type the name; the agent does not fire it on its own. Zero context load.
  These are the phase orchestrators (init, discovery, inception, research, innovate, plan, retro).
- **model-invoked** — the agent can fire it itself when its trigger matches. These carry the
  discipline (spike, execute, debug, review, document, router).

## Companion skills (wrapped)

Several SPIDER skills wrap external skills rather than reimplementing their discipline:

| SPIDER skill | Wraps | Why |
|--------------|-------|-----|
| `spider-inception` | `grill-with-docs` | Updates CONTEXT/GLOSSARY *during* the conversation, builds a ubiquitous language |
| `spider-innovate` | `grilling` | One question at a time, until every branch of the decision tree is resolved |
| `spider-discovery` | `improve-codebase-architecture` | Scans the codebase, ranks deepening opportunities, strengthens tech-debt identification |
| `spider-plan` | `to-issues`, `to-prd`, `codebase-design` | Splits the spec into vertical-slice tasks; deep-module discipline for design |
| `spider-spike` | `prototype` | Throwaway code answering one design question |
| `spider-execute` | `tdd` | Vertical-slice / tracer-bullet discipline; bans horizontal slicing |
| `spider-debug` | `diagnosing-bugs` | reproduce → minimise → hypothesise → instrument → fix → regression-test |
| `spider-retro` | `handoff` | "Archive, not summarize" before deleting sessions |

## Shared discipline

All skills share a vocabulary of **leading words** that bind the phases:

- **spec** — source of truth, above the code
- **drift** — every deviation recorded, never silent
- **gate** — passed, not skipped
- **story** — the unit of work
- **red / green / refactor** — the TDD loop
- **archive** — retro carries decisions forward before cleanup

See [the rules](rules.md) for the non-negotiables every skill enforces.
