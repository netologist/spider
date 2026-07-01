# Components

SPIDER's determinism comes from three component layers: **agents** for judgment,
**hooks** for mechanical checks, and **loops** to bind phases together. Self-grading is a weak
signal — so judgmental gates go to agents in a **separate context**, and mechanical checks go to
deterministic hooks.

## Agents (subagents)

| Agent | Task | Why a separate context |
|-------|------|------------------------|
| **gate-checker-agent** | Evaluates the judgmental part of Gate 1/2/3 and the Quality Gate | The agent that wrote the spec/code shouldn't approve its own work |
| **story-subagent** | Runs one user story in an isolated git worktree with `spider-execute` | Parallel execution; a faulty story doesn't affect the others |
| **spec-compliance-review-agent** | Review lens 1: does the code match the spec | Assessment independent from the spec-writing agent |
| **code-quality-review-agent** | Review lens 2: architecture/readability (deep-module discipline) | A different lens, separate from spec compliance |
| **retro-digest-agent** | Reads all sessions since the last retro, digests with "archive, not summarize", then approves deletion | A fresh eye asking "what was left out?" — different from the session authors |
| **debugging-agent** (optional) | Runs `diagnosing-bugs` when the Quality Gate fails 2+ times for the same reason | Breaks out of the ordinary Execute loop into disciplined root-cause analysis |

Each agent has a definition YAML under `.spider/agents/` — scaffolded by `spider-init` and
shipped in `skills/spider-init/templates/dot-spider/agents/`. The YAML records the
agent's `name`, `skill`, `isolated_context`, `model_tier`, `description`, and `trigger`.
The harness reads these to spawn the agent with the right context and model.

## Hooks

The **mechanical** part of gates is checked deterministically — never asked of the LLM.

| Hook | When it runs | What it checks |
|------|--------------|----------------|
| `session-start.sh` | Every session start | Injects `AGENTS.md`, `rules.md`, `_LESSONS_LEARNED.md`, `_POSTMORTEMS.md`, ADR index into context |
| `pre-phase.sh` | Before the next phase skill | Previous phase's mandatory outputs present; `status` field correct |
| `post-phase.sh` | When a phase completes | Appends an entry to `session.md` / `tasks.md` |
| `pre-commit.sh` | Every commit attempt | Secret scan + RED-step guard (no non-test files while writing tests) + lint/typecheck/test |
| `post-gate.sh` | Every gate passage | Parses mechanical criteria (`status: approved`, checkboxes, coverage %); enforces retry/escalation |
| `pre-merge.sh` | Before a worktree merge | Full test suite + conflict check |

Hooks live in `.spider/hooks/` and ship as executable scripts inside the `spider-init` templates.

## Gates

Gates split into two kinds:

- **Mechanical** (hook-checked): file existence, frontmatter `status`, checkbox state, coverage %.
- **Judgmental** (isolated subagent): does the spec actually cover the cases? does the code actually
  match the spec? These go to `gate-checker-agent` / review agents.

### Gate retry & escalation policy

```json
{
  "gate_policy": {
    "max_gate_retries": 3,
    "retry_rule": "same_failure_stops_immediately",
    "distinct_failure_budget": 3
  }
}
```

**Logic** (`post-gate.sh`):

1. On a gate **fail**, the hook records the reason and increments the counter.
2. If the next attempt fails for the **same** reason → escalate to a human **immediately**, without
   spending remaining retries. Insisting on the same error is a token waste.
3. If each attempt fails for a **different** reason (the agent is genuinely learning) → continue up
   to `max_gate_retries` (3).
4. When retries are exhausted → the agent **stops** and notifies the human (which reasons + last
   diff). It does not proceed, nor return to the previous phase — it waits.
5. **Gate 3** (Plan → Execute) is exempt — it needs human approval, not a retry.

Exit-code contract from `post-gate.sh`: `0` = pass/proceed · `1` = retryable fail · `2` = escalate.

### Review policy by complexity tier

Review agents are expensive, so they run only where they add value:

```json
{
  "review_policy": {
    "trivial": { "spec_compliance_review": false, "code_quality_review": false },
    "standard": { "spec_compliance_review": true, "code_quality_review": false },
    "complex": { "spec_compliance_review": true, "code_quality_review": true }
  }
}
```

## Loops

| Loop | Scope | Limit |
|------|-------|-------|
| **Main flow** | Discovery/Inception → … → Retro → next story | Unlimited |
| **TDD micro-loop** | Red → Green → Refactor, vertical-slice | Until the story completes |
| **Grilling loop** | Inception elicitation + Innovate alternatives | Until every decision branch is resolved |
| **Gate-retry loop** | When any gate fails | `max_gate_retries: 3` |
| **Debugging loop** | Quality Gate fails on an unexpected bug | reproduce → … → regression-test |
| **Retro loop** | Periodic | Every epic close, or ≥ every 2 weeks |

## Automation layer

A scheduled triage heartbeat (cron) scans the repo and feeds `spider-discovery`, so the loop runs
itself instead of waiting on a manual trigger:

```yaml
automations:
  daily-triage:
    schedule: "cron: 0 9 * * *"
    skill: spider-discovery
    scope: [ci-failures, open-tech-debts, drift-log]
    output: specs/triage-inbox/<date>.md
    on_finding: "open worktree + story-subagent draft + spec-compliance-review-agent check"
    on_empty: "auto-archive, no notification"
```

As automation increases, the human-approval points (Gate 3, retro cleanup) must **not** loosen —
their criticality rises, it does not fall.
