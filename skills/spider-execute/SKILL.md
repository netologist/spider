---
name: spider-execute
description: SPIDER Execute — implement approved stories with strict TDD (Red → Green → Refactor), one vertical slice at a time. Use when the spec is approved and stories must be built test-first.
---

# Spider · Execute

Implement user stories with strict TDD discipline, one **vertical slice** at a time. Wrap the `tdd` skill.

## Execution mode

At start, ask: *"This feature has N stories. Inline (sequential, default) or subagents with git worktrees (parallel, isolated)?"* — then run each story through the loop.

## Per story — the TDD loop

1. **🔴 RED** — write one failing test that captures one slice of behavior; confirm it **fails** for the right reason. *(completion: one test, red, no implementation touched.)*
2. **🟢 GREEN** — write the **minimum** code to pass it. No new behavior, no refactoring. *(completion: that test green, nothing more.)*
3. **🔵 REFACTOR** — clean and improve readability. Spec unchanged. Tests must still pass. *(completion: tests still green, behavior unchanged.)*

Loop until the story's acceptance criteria are met, then the next story.

**Vertical slice, not horizontal** — never write all tests then all implementation for a story. One test → one implementation → repeat (tracer bullet). Horizontal slicing is banned.

## Exit gate

Quality Gate (machine-passed, Execute → Review): all tests green, coverage target met, no type/lint errors, no deviation from `feature.spec.md`, `DRIFT.md` empty or acknowledged — full checklist: see the Execute phase reference.

## Drift

Any spec deviation during Execute → log to `specs/logs/DRIFT.md` **immediately**. Don't wait for Review.

## Constraints

- **RED**: no implementation code, no non-test files touched.
- **GREEN**: no new behavior beyond spec, no refactoring.
- **REFACTOR**: no new behavior, spec unchanged, tests still green.

> Output: code + tests, `<platform>.changelog.md`. Output tables: see the Execute phase reference.
