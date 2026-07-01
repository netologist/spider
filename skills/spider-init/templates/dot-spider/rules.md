# SPIDER Rules

Project custom AI rules, injected into context at every session start by
`hooks/session-start.sh`. The full framework is documented in the SPIDER docs site.

## Non-negotiables

- **Spec is above code.** Code changes → spec updates first; spec changes → human approval.
- **TDD is mandatory.** Tests before implementation, one vertical slice at a time (no horizontal slicing).
- **Every deviation is recorded** in `specs/logs/DRIFT.md` — drift is never silent.
- **Gates are passed, not skipped.** No phase progression without the gate.
- **Never assume.** When context is missing or ambiguous, ask. Do not invent facts.
- **Verification before assertion.** Show the command output before claiming something works.
- **Folder scope.** Work only in the current project folder or `/tmp`.

## Phase order

Discovery/Inception → Research → Innovate → Plan → Spike(opt) → Execute → Review → Document → Retro → next story.

Phases are referenced by full name, never by the SPIDER letters — the letters name capabilities, **not** phase order.

## Execute state contract

`spider-execute` writes `.spider/.state/execute.phase` (`red` | `green` | `refactor`) so
`hooks/pre-commit.sh` can enforce the RED rule (no non-test files while writing tests).
If the file is absent, the RED check is skipped — it is opt-in by adoption.

## Language

Converse in the user's language. All output documents in English.
