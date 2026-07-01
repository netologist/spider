# Document
>
> Capture all session outputs before closing.

**When this runs:** After Review marks the feature `done`; before Retro.

**Mandatory outputs (session close):**

| Artifact | Trigger | Location |
|----------|---------|----------|
| Postmortem | Any rollback or lesson learned | `specs/postmortems/<slug>.md` |
| Tech debt | Any improvement spotted | `specs/tech-debts/<slug>.md` |
| ADR | Any architecture decision made | `specs/architecture/adr-<NNN>-<slug>.md` + update `specs/architecture/README.md` |
| Session log | Every session | `specs/sessions/<date>/session.md` |
| Tasks | Updated on each task completion | `specs/sessions/<date>/tasks.md` |
| Threat note | Security-sensitive changes | In session file |
| Working decisions | Feature-level decisions during session | `specs/features/<name>/DECISIONS.md` |

**Exit gate:** All mandatory artifacts triggered by this session are recorded at the locations above.

**Constraints:** No new code; recording and cross-linking only. Working decisions in `specs/features/<name>/DECISIONS.md` are temporary and get promoted at Retro.

Operational discipline: see the `spider-document` skill.
