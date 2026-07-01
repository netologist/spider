# Directory Structure

SPIDER splits a project by **ownership of truth**. Four zones, each with one owner:

- `.spider/` — **harness infrastructure** (prompts, gates, hooks, config). Hidden.
- `specs/` — **AI-managed**, the single source of truth for anything AI can create or update.
- `docs/` — **human-maintained**; references `specs/`, never duplicates it.
- `README.md` (humans) and `AGENTS.md` (AI) at the root — no overlap between them.

```
project/
├── README.md                         ← Humans only
├── AGENTS.md                         ← AI only (harness-agnostic)
│
├── .spider/                          ← Harness infrastructure (hidden)
│   ├── harness.yaml                  # MCPs, skills, agents, model matrix
│   ├── rules.md                      # Custom AI rules
│   ├── config.json                   # Internal framework config
│   ├── gates/                        # Gate checklists
│   └── hooks/                        # Automation scripts
│
├── specs/                            ← AI-managed — truth of source
│   ├── context/                      # Filled by Inception & Discovery
│   │   ├── PROJECT.md
│   │   ├── STACK.md
│   │   ├── CONVENTIONS.md
│   │   └── GLOSSARY.md
│   ├── inception/README.md
│   ├── features/
│   │   ├── _template/
│   │   │   ├── feature.spec.md       # Platform-independent behavior
│   │   │   ├── <platform>.behavior.md
│   │   │   ├── <platform>.design.md
│   │   │   ├── <platform>.tech.md
│   │   │   ├── <platform>.tasks.md
│   │   │   ├── <platform>.changelog.md
│   │   │   ├── TEST-PLAN.md
│   │   │   ├── DECISIONS.md
│   │   │   └── feature.feature       # Gherkin BDD
│   │   └── auth/                     # Example feature
│   ├── architecture/
│   │   ├── README.md                 # ADR index
│   │   ├── as-is.md                  # Discovery: current state
│   │   ├── adr-001-*.md
│   │   ├── data-models.md
│   │   └── api-contracts.md
│   ├── design/
│   │   ├── system-overview.md
│   │   ├── nfr.md
│   │   └── tech-stack.md
│   ├── retro/2026-06-09.md
│   ├── postmortems/auth-service-outage.md
│   ├── tech-debts/add-load-testing.md
│   ├── logs/
│   │   ├── DECISIONS.md
│   │   ├── DRIFT.md
│   │   ├── ARCH_LOG.md
│   │   ├── DESIGN_LOG.md
│   │   └── INTENT_CHANGES.md
│   └── sessions/                     ← Ephemeral — deleted after retro
│       ├── _LESSONS_LEARNED.md       # Permanent, distilled from retros
│       ├── _POSTMORTEMS.md           # Permanent, incident timeline (append-only)
│       └── 2026-06-09-auth-login/
│           ├── intent.md
│           ├── tasks.md
│           └── session.md
│
├── docs/                             ← Human-maintained — references specs/
│   ├── onboarding.md
│   ├── contributing.md
│   └── product-roadmap.md
```

## Truth-of-source decision

```mermaid
flowchart TD
    Q{"Who updates<br/>this artifact?"}
    Q -->|"AI agent<br/>(or both)"| Specs["specs/<br/>Truth of Source"]
    Q -->|"Only humans"| Docs["docs/<br/>References specs/<br/>Never copies"]

    style Specs fill:#EAF3DE,stroke:#3B6D11,color:#3B6D11
    style Docs fill:#F1EFE8,stroke:#5F5E5A,color:#444441
    style Q fill:#E6F1FB,stroke:#185FA5,color:#185FA5
```

In practice:

- `specs/features/*` — AI writes and updates
- `specs/logs/*`, `specs/architecture/*` — AI writes, humans read → stays in `specs/`
- `docs/onboarding.md`, `docs/contributing.md`, `docs/product-roadmap.md` — only humans write/read

## Feature file layering

Every feature has layers in **descending order of stability**:

```mermaid
flowchart TD
    Spec["feature.spec.md<br/>Platform-independent behavior<br/>🔒 MOST STABLE"] --> Behavior["&lt;platform&gt;.behavior.md<br/>Platform-specific behavior"]
    Behavior --> Design["&lt;platform&gt;.design.md<br/>Architecture & design decisions"]
    Design --> Tech["&lt;platform&gt;.tech.md<br/>Selected technologies"]
    Tech --> Tasks["&lt;platform&gt;.tasks.md<br/>FR, NFR, task list"]
    Tasks --> Changelog["&lt;platform&gt;.changelog.md<br/>Change log with impact tree<br/>🔄 MOST VOLATILE"]

    style Spec fill:#EEEDFE,stroke:#534AB7,color:#3C3489
    style Changelog fill:#FCEBEB,stroke:#A32D2D,color:#A32D2D
```

## Session lifecycle

Sessions are raw, date-stamped directories — temporary scaffolding. Two permanent artifacts
survive: `_LESSONS_LEARNED.md` (from retros) and `_POSTMORTEMS.md` (from incidents).

```mermaid
stateDiagram-v2
    [*] --> StoryStart: Story starts
    StoryStart --> SessionActive: intent.md + tasks.md created
    SessionActive --> SessionClose: story complete<br/>session.md saved
    SessionClose --> FeatureClose: feature/sprint closes
    FeatureClose --> Retro: retro triggered

    state Retro {
        [*] --> ReadSessions
        ReadSessions --> Distill: extract learnings
        Distill --> Lessons: write _LESSONS_LEARNED.md
        Distill --> Report: write retro report
        Lessons --> DeleteSessions: cleanup
        Report --> DeleteSessions: cleanup
        DeleteSessions --> [*]
    }

    SessionClose --> Incident: incident occurs
    Incident --> Postmortem: write _POSTMORTEMS.md<br/>(preserves session)
    Postmortem --> [*]
```

### Retro vs Postmortem

| | Retro | Postmortem |
|---|---|---|
| **When** | Routine — every feature/sprint close | Exceptional — when something breaks |
| **Question** | "What did we learn, let's move forward." | "Why did it happen, never again." |
| **Learns from** | Success | Failure |
| **Output** | `_LESSONS_LEARNED.md` (distilled) | `_POSTMORTEMS.md` (append-only) |
| **Deletes sessions?** | Yes | No (preserves the incident session) |

**Why sessions are deleted after retro:** Git log captures *what* changed; the knowledge graph +
ADRs capture *why*; `_LESSONS_LEARNED.md` captures distilled wisdom. Once those exist, detailed
session logs are redundant scaffolding.
