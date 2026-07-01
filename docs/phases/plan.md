# Plan
>
> Produce an approvable, complete technical spec.

**When this runs:** After Innovate passes Gate 2; before Execute (or Spike).

**Mandatory outputs:**

`feature.spec.md`:

- Goal (one sentence)
- Out of scope (prevents AI scope creep)
- User stories (behavior-driven, manually testable)
- Data model (types, relationships, validations)
- Acceptance criteria (concrete, measurable)
- Edge cases
- Open decisions (blocks Gate 3 until resolved)
- Status: `draft` → human approval → `approved`

`TEST-PLAN.md`:

- Coverage target (%)
- Test sequence per user story
- Excluded tests with rationale
- Test type distribution (unit / integration / e2e)

**Exit gate — Gate 3 (Plan → Execute — MOST CRITICAL):**

- [ ] `feature.spec.md` status: approved?
- [ ] `TEST-PLAN.md` approved?
- [ ] Coverage target set?
- [ ] All edge cases covered?
- [ ] Open decisions resolved?

**Constraints:** No code writing. No test writing. Status stays `draft` — human approval required for `approved`.

Operational discipline: see the `spider-plan` skill.
