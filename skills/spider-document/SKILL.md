---
name: spider-document
description: SPIDER Document — capture every session output (postmortem, tech-debt, ADR, session log, threat note) before closing. Use when a story or session closes and its artifacts must be recorded.
---

# Spider · Document

Capture all session outputs before the session closes. Nothing learned or decided is lost.

## Steps

Write each artifact **if its trigger fired this session**:

1. **Postmortem** — any rollback, failed approach, or lesson → `specs/postmortems/<slug>.md` (and `_POSTMORTEMS.md` for incidents).
2. **Tech debt** — any improvement spotted → `specs/tech-debts/<slug>.md`.
3. **ADR** — any architecture decision → `specs/architecture/adr-<NNN>-<slug>.md` + update the index.
4. **Session log** — every session → `specs/sessions/<date>/session.md`.
5. **Tasks** — update `specs/sessions/<date>/tasks.md` on each completion.
6. **Threat note** — any security-sensitive change → a short note in the session file.
7. **Working decisions** — feature-level → `specs/features/<name>/DECISIONS.md`.

*completion: every trigger that fired has a matching artifact; `session.md` lists all changed files + a summary.*

## Constraints

- Postmortems are not blame documents — record how the system failed and what changed so it doesn't recur.
- `done` status from Review is a precondition; Document records, it doesn't re-validate.

> Output tables: see the Document phase + Record Files references.
