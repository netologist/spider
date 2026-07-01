# The Flow

SPIDER runs one fixed flow. Entry happens once per project; the cycle repeats per story until the
project is done. Every transition through a red node is a **gate** — passed, never skipped.

```mermaid
flowchart TD
    Start([New project]) --> B{Existing code?}
    B -- No --> Inception["INCEPTION<br/>Greenfield<br/>Elicit · ADR · Design · Stack · Env"]
    B -- Yes --> Discovery["DISCOVERY<br/>Brownfield<br/>Read code · Map domain · Tech-debt · Recommend"]

    Inception --> R1
    Discovery --> R1

    R1["RESEARCH<br/>Best practices · library docs<br/>patterns · post-training-cutoff info"] --> G1{"Gate 1<br/>Context documented?<br/>Coverage known?<br/>Dependencies listed?"}
    G1 -->|Pass| I1
    G1 -->|Fail| R1

    I1["INNOVATE<br/>Brainstorm 2-3 alternatives<br/>Testability scored"] --> G2{"Gate 2<br/>≥2 alternatives?<br/>Testability scored?<br/>Selection documented?"}
    G2 -->|Pass| P1
    G2 -->|Fail| I1

    P1["PLAN<br/>feature.spec.md + TEST-PLAN.md<br/>Layering: behavior → design → tech → tasks"] --> G3{"Gate 3 — CRITICAL<br/>Spec approved?<br/>Test plan approved?"}
    G3 -->|Pass| S1
    G3 -->|Fail| P1

    S1{"Unknown risks?"}
    S1 -- Yes --> Spike["SPIKE / PoC<br/>Time-boxed validation<br/>(optional)"]
    S1 -- No --> E1
    Spike -->|Validated| E1
    Spike -->|Invalidated| P1

    subgraph TDD["EXECUTE — TDD Mandatory"]
        direction LR
        Red["🔴 RED<br/>Write failing test<br/>No implementation"] --> Green["🟢 GREEN<br/>Minimum code to pass<br/>No new behavior"]
        Green --> Refactor["🔵 REFACTOR<br/>Clean & improve<br/>Tests still pass"]
        Refactor -.->|"next story"| Red
    end

    E1 --> TDD
    TDD --> QG{"Quality Gate<br/>All tests green?<br/>Coverage met?<br/>No spec deviation?"}
    QG -->|Pass| R2
    QG -->|Fail| TDD

    R2["REVIEW<br/>Validate against spec<br/>Acceptance criteria<br/>Threat notes"] --> D1["DOCUMENT<br/>Postmortems · Tech-debt · ADR<br/>Session log · Tasks update"]

    D1 --> Retro{"RETRO?"}
    Retro -->|"Yes (routine)"| Lessons["_LESSONS_LEARNED.md<br/>Distilled wisdom<br/>(permanent)"]
    Retro -->|"Yes (routine)"| RetroDoc["specs/retro/YYYY-MM-DD.md<br/>Action items + summaries"]
    Lessons --> Promote["PROMOTE DECISIONS<br/>Formal → ADR<br/>Discussion → tech-huddle<br/>Actionable → tech-debt"]
    Promote --> Cleanup["CLEANUP<br/>Delete digested sessions"]

    D1 --> Incident{"Incident?"}
    Incident -->|"Yes (exceptional)"| Postmortem["_POSTMORTEMS.md<br/>Root cause + actions<br/>(append-only, permanent)"]

    Retro -->|Skip| NextStory
    Cleanup --> NextStory{"Next story?"}
    Postmortem --> NextStory
    D1 --> NextStory

    NextStory -->|Yes| R1
    NextStory -->|No| Done([Done ✓])

    style Inception fill:#EEEDFE,stroke:#534AB7,color:#3C3489
    style Discovery fill:#E1F5EE,stroke:#0F6E56,color:#085041
    style G1 fill:#FCEBEB,stroke:#A32D2D,color:#A32D2D
    style G2 fill:#FCEBEB,stroke:#A32D2D,color:#A32D2D
    style G3 fill:#FCEBEB,stroke:#A32D2D,color:#A32D2D
    style QG fill:#FCEBEB,stroke:#A32D2D,color:#A32D2D
    style Red fill:#FCEBEB,stroke:#A32D2D,color:#A32D2D
    style Green fill:#EAF3DE,stroke:#3B6D11,color:#3B6D11
    style Refactor fill:#E6F1FB,stroke:#185FA5,color:#185FA5
    style Lessons fill:#EAF3DE,stroke:#3B6D11,color:#3B6D11
    style Postmortem fill:#FCEBEB,stroke:#A32D2D,color:#A32D2D
```

## Loops within the flow

| Loop | Scope | Limit |
|------|-------|-------|
| **Main flow** | Discovery/Inception → … → Retro → next story | Unlimited (until the project ends) |
| **TDD micro-loop** | Red → Green → Refactor, **vertical-slice** | Until the story completes |
| **Grilling loop** | Inception elicitation + Innovate alternatives | Until every branch of the decision tree is resolved |
| **Gate-retry loop** | When any gate fails | `max_gate_retries: 3` — see [Components](components.md#gates) |
| **Debugging loop** | When the Quality Gate fails on an unexpected bug | reproduce → minimise → hypothesise → instrument → fix → regression-test |
| **Retro loop** | Periodic | Every epic close, or at least every 2 weeks |

## Entry vs cycle

**Entry** (Discovery or Inception) runs **once**, at project start — it fills the `specs/context/`
files everything else reads. The **cycle** (Research → … → Retro) repeats per story.
