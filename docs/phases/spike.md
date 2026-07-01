# Spike / PoC *(optional)*
>
> Validate an approach before full build when significant unknowns exist.

**When this runs:** Optional, after Plan; triggered by unknown risks. Skipped when risks are known.

**Trigger:** Unfamiliar library, untested integration, novel architecture.

**Rules:**

- Time-boxed (default: 2h max)
- Outcomes: validate or invalidate the approach
- Findings saved to `specs/sessions/<date>/spike-<slug>.md`
- If invalidated, return to Plan

**Outputs:**

- `specs/sessions/<date>/spike-<slug>.md`

**Exit gate:** Binary outcome — **validated** → proceed to Execute; **invalidated** → return to Plan.

**Constraints:** Throwaway prototype to answer a single design question — not part of the shipped code.

Operational discipline: see the `spider-spike` skill.
