# Retro *(run periodically)*
>
> Digest completed sessions into actionable learnings, promote decisions, clean up.

**When this runs:** After every epic completion, or at minimum every 2 weeks. Also the terminal phase of the per-story cycle.

```mermaid
flowchart TD
    Sessions["specs/sessions/&lt;date&gt;/<br/>(ephemeral)"] --> Read[READ<br/>All sessions since last retro]
    Read --> Digest[DIGEST<br/>Extract learnings, patterns<br/>failures, wins]
    Digest --> Lessons["_LESSONS_LEARNED.md<br/>(permanent, never deleted)"]
    Digest --> Report["specs/retro/YYYY-MM-DD.md<br/>Action items + summaries"]

    Sessions --> Promote[PROMOTE DECISIONS]
    Promote --> ADR["Formal → specs/architecture/adr-*.md"]
    Promote --> Huddle["Discussion → tech-huddle backlog"]
    Promote --> Debt["Actionable → docs/tech-debts/*.md"]

    Lessons --> Cleanup[CLEANUP<br/>Delete digested sessions]
    Report --> Cleanup

    style Sessions fill:#FAECE7,stroke:#993C1D,color:#712B13
    style Read fill:#E6F1FB,stroke:#185FA5,color:#185FA5
    style Digest fill:#EEEDFE,stroke:#534AB7,color:#3C3489
    style Lessons fill:#EAF3DE,stroke:#3B6D11,color:#3B6D11
    style Report fill:#EAF3DE,stroke:#3B6D11,color:#3B6D11
    style Promote fill:#FAEEDA,stroke:#854F0B,color:#633806
    style ADR fill:#EAF3DE,stroke:#3B6D11,color:#3B6D11
    style Huddle fill:#F1EFE8,stroke:#5F5E5A,color:#444441
    style Debt fill:#FCEBEB,stroke:#A32D2D,color:#A32D2D
    style Cleanup fill:#E1F5EE,stroke:#0F6E56,color:#085041
```

**Promote decisions:** Formal architectural → `specs/architecture/adr-*.md`; items needing team discussion → tech-huddle backlog; actionable improvements → `docs/tech-debts/*.md`.

**Outputs:**

- `specs/sessions/_LESSONS_LEARNED.md` (permanent, never deleted)
- `specs/retro/YYYY-MM-DD.md` (action items + summaries)
- Promoted ADRs / tech-huddle / tech-debt items
- Deleted session directories (cleanup)

**Why sessions are deleted after retro:**

- Git log captures WHAT changed (commits, diffs)
- Memory Graph / graphify captures entity relationships and architectural patterns
- ADRs capture WHY decisions were made
- Retro reports capture learnings and action items
- Detailed session logs are scaffolding — once graph + ADR + retro artifacts exist, they're redundant

**Constraints:** "Archive, not summarize" — before a session is deleted, rejected alternatives, ordering decisions, and fine constraints must be carried into `_LESSONS_LEARNED.md`. This step is done by the `retro-digest-agent` in a context **separate** from the one that wrote the sessions, with human approval before deletion.

Operational discipline: see the `spider-retro` skill.
