---
name: spider-innovate
description: SPIDER solution-space exploration — score ≥2 alternatives before committing to an approach.
disable-model-invocation: true
---

# Spider · Innovate

Explore the solution space **before** committing to an approach. Commit only after the trade-offs are on the table.

## Steps

1. **Generate ≥2 (aim 2–3) alternatives** — genuinely distinct, not renamed copies of one idea.
2. **Score each** — technical fit, testability (★☆☆☆☆ — ★★★★★), trade-offs.
3. **Select** — document the rationale.
4. **Record the rejects** — every rejected alternative, **with its reason**, goes to `specs/logs/DECISIONS.md` (non-deletable).

*completion: ≥2 alternatives scored with a testability rating, one selected with rationale, and each reject logged in `DECISIONS.md`.*

## Exit gate

Gate 2 (Innovate → Plan): ≥2 alternatives, testability scored, selection documented, rejects in `DECISIONS.md` — full checklist: see the Innovate phase reference.

## Constraints

- No code. No spec writing. Only evaluate and recommend.
- Use the grilling loop — one question at a time, resolve every branch of the decision tree.

> Output tables: see the Innovate phase reference. External skill it wraps: `grilling`.
