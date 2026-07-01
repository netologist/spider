# Execute (TDD Mandatory)
>
> Implement user stories with strict TDD discipline.

**When this runs:** After Plan passes Gate 3 (and after any Spike is validated); before Review.

Execute uses three internal prompts (Red → Green → Refactor) enforced by the AI harness. These are **not separate workflow phases** — they are implementation discipline within Execute.

```mermaid
flowchart LR
    subgraph Story["One User Story"]
        direction LR
        Red["🔴 RED<br/>Write test only<br/>Verify it FAILS<br/>No implementation"] --> Green["🟢 GREEN<br/>Minimum code to pass<br/>No new behavior<br/>No refactoring"]
        Green --> Refactor["🔵 REFACTOR<br/>Clean & improve<br/>No new behavior<br/>Tests still pass"]
    end
    Refactor -.->|"next story"| Story
    Story --> QG{"Quality Gate<br/>All green?<br/>Coverage?<br/>No drift?"}
    QG -->|Pass| Review[→ REVIEW]
    QG -->|Fail| Story

    style Red fill:#FCEBEB,stroke:#A32D2D,color:#A32D2D
    style Green fill:#EAF3DE,stroke:#3B6D11,color:#3B6D11
    style Refactor fill:#E6F1FB,stroke:#185FA5,color:#185FA5
    style Story fill:#FAECE7,stroke:#993C1D,color:#712B13
    style QG fill:#FCEBEB,stroke:#A32D2D,color:#A32D2D
    style Review fill:#FAECE7,stroke:#993C1D,color:#712B13
```

**Sub-steps:**

| Sub-step | Rule | Constraint |
|----------|------|------------|
| **Red** | Write test only, verify it fails | No implementation code. No touching non-test files. |
| **Green** | Minimum code to pass tests | No new behavior beyond spec. No refactoring. |
| **Refactor** | Clean up, improve readability | No new behavior. Spec unchanged. Tests must still pass. |

**Vertical-slice / tracer-bullet discipline (mandatory):**
The `tdd` skill explicitly bans the **"horizontal slicing" anti-pattern** — writing all tests first, then all implementation, for a story. Within a story, work **one test → one implementation → repeat** (the tracer-bullet / vertical-slice discipline). Each user story completes the full Red → Green → Refactor cycle before moving to the next story.

**Exit gate — Quality Gate (Execute → Review, machine-passed):**

- [ ] All tests green
- [ ] Coverage target met
- [ ] No type/lint errors
- [ ] No deviation from `feature.spec.md`
- [ ] DRIFT.md empty or all drifts acknowledged

**Execution modes — asked at Execute start:**
> "This feature has N user stories. Execute inline (sequential, default) or via subagents with git worktrees (parallel, isolated commits)?"

| Mode | Behavior |
|------|----------|
| **Inline** (default) | All stories run in current session, sequential TDD per story |
| **Subagent + Worktree** | Each story → separate subagent in isolated git worktree; parallel execution; results merged; full test suite on merge; Review phase on merged result |

**Constraints:** No new behavior beyond `feature.spec.md`. No refactoring during Green. Tests must still pass after Refactor.

Operational discipline: see the `spider-execute` skill.
