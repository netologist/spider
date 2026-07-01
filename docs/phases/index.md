# Phases

SPIDER phases run in a fixed order. They are referenced by their **full name** ("Research phase", "Review phase") — the **SPIDER** letters name capabilities, **not** phase order.

> **Project Entry Gate:** no existing code → **Inception** (greenfield); existing code → **Discovery** (brownfield). Discovery/Inception run **once** at project start.

Canonical flow order:

```
Entry:    DISCOVERY (brownfield)  or  INCEPTION (greenfield)
            ↓
Cycle:    RESEARCH → INNOVATE → PLAN → SPIKE(opt) → EXECUTE → REVIEW → DOCUMENT → RETRO
```

Ordered list of phases:

1. **Entry** → [entry.md](entry.md) — Project Entry Gate routes to Inception (greenfield, no existing code) or Discovery (brownfield, existing code). Runs once at project start.
2. **Research** → [research.md](research.md) — external best practices, library docs, and patterns relevant to the current story.
3. **Innovate** → [innovate.md](innovate.md) — explore the solution space; at least 2–3 alternatives, each with a testability score.
4. **Plan** → [plan.md](plan.md) — produce an approvable `feature.spec.md` + `TEST-PLAN.md`; Gate 3 (most critical) enforced.
5. **Spike** *(optional)* → [spike.md](spike.md) — time-boxed PoC when significant unknowns remain.
6. **Execute** → [execute.md](execute.md) — TDD implementation (Red → Green → Refactor) with vertical-slice discipline.
7. **Review** → [review.md](review.md) — validate implementation against spec; acceptance criteria ✅ / ❌ / ⚠️.
8. **Document** → [document.md](document.md) — capture all session outputs before closing.
9. **Retro** → [retro.md](retro.md) — digest sessions into learnings, promote decisions, clean up.

Note: **Discovery/Inception run once at project start.** The cycle from Research onward repeats per story.
