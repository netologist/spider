---
name: spider-router
description: SPIDER Router — decide which SPIDER phase or skill should run now, from the current specs/ state. Use when unsure which phase is next, or to resume a paused SPIDER project without re-deriving the state by hand.
---

# Spider · Router

Read the current project state and decide **which phase runs next** — so a human doesn't trigger every phase by hand. Inspired by the ask-matt router pattern.

## Steps

1. **Read state** — `specs/context/*`, `specs/features/*/feature.spec.md` (status field), `specs/logs/DRIFT.md`, `specs/architecture/README.md`, the latest `specs/sessions/*/tasks.md`, and the latest retro date.
2. **Locate the active story** — the newest session dir; read its `tasks.md` and `intent.md`.
3. **Decide the next phase** from the state machine below.
4. **State the decision** in one sentence with the evidence (which file/status led there), then hand off to that phase skill.

## State machine

```
No specs/context/* filled                  → Discovery (brownfield) or Inception (greenfield)
Context filled, no feature research        → Research
Research context.md exists, no alternatives → Innovate
Alternatives in DECISIONS.md, no spec      → Plan
feature.spec.md status: approved, not done → Execute (or Spike if unknowns)
Execute done, Quality Gate not passed      → Execute / Debug
Quality Gate passed, status ≠ done         → Review
Review done                                → Document
Document done, epic/sprint closed          → Retro
Retro done, more stories                   → Research (next story)
```

*completion: one phase named, with the file/status evidence that justifies it, and a handoff to that skill.*

## Constraints

- Router decides; it does not execute the phase. Hand off cleanly.
- If two phases are plausible, prefer the earlier one — never skip a gate.

> Flow order: Overview + The Flow. Gate policy: Components (Gates).
