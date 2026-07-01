---
name: spider-spike
description: SPIDER Spike / PoC — time-boxed validation of an unfamiliar library, integration, or architecture before the full build. Use when significant unknowns make Execute risky.
---

# Spider · Spike

Validate (or invalidate) an approach before the full build, when significant unknowns exist. Wrap the `prototype` skill — throwaway code that answers **one** question.

## Steps

1. **Name the single question** the spike must answer (unfamiliar library, untested integration, novel architecture).
2. **Time-box** — default 2h max. Set a deadline; stop when it rings.
3. **Build the minimum** that answers the question — throwaway, not production.
4. **Decide** — validated or invalidated.
5. **Record** → `specs/sessions/<date>/spike-<slug>.md`: the question, the finding, the decision.

*completion: a `spike-<slug>.md` exists with a binary outcome (validated / invalidated) and the finding.*

## Routing

- Validated → Execute.
- Invalidated → back to Plan.

## Constraints

- Time-boxed. Throwaway. One question. No production code.
