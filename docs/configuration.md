# Configuration

SPIDER's model selection and policy live as **config**, not embedded in prompt text — so changing
behaviour is a one-file edit. Two files: `.spider/harness.yaml` (model matrix + gates + automations)
and `.spider/config.json` (tiers + approval + gate/review policy).

## Model / effort matrix

| Phase / Skill | Model | Effort | Mode |
|---------------|-------|--------|------|
| Inception | opus-tier | high | interactive |
| Discovery | opus-tier | high | semi-autonomous |
| Research | mid-tier | low | autonomous, tool-heavy |
| Innovate | opus-tier | high | interactive |
| Plan | opus-tier | high | interactive (Gate 3) |
| Spike | mid-tier | low | autonomous, 2h timebox |
| Execute — RED | small/mid-tier | low | autonomous |
| Execute — GREEN | mid-tier | low | autonomous |
| Execute — REFACTOR | mid-tier | medium | autonomous |
| Quality Gate fail → Debug | opus-tier | high | autonomous, isolated |
| gate-checker-agent | opus-tier | medium-high | autonomous, isolated |
| Review (spec + quality) | opus-tier, 2 agents | medium-high | autonomous, isolated |
| Document | small-tier | low | autonomous |
| Retro | mid-high-tier | medium | semi-autonomous |
| **Mechanical gate checks** | **hook script (not LLM)** | — | fully autonomous |

`opus-tier` / `mid-tier` / `small-tier` are labels — map each to a concrete model id in your harness
(e.g. `claude-sonnet`, `gpt-4o-mini`) before running phases.

### `harness.yaml` (excerpt)

```yaml
model_matrix:
  plan:
    model: opus-tier
    effort: high
    mode: interactive
    gate: 3
  spike:
    model: mid-tier
    effort: low
    mode: autonomous
    timebox_min: 120
  debug:
    model: opus-tier
    effort: high
    mode: autonomous
    isolated_context: true

gate_policy:
  max_gate_retries: 3
  retry_rule: same_failure_stops_immediately
  distinct_failure_budget: 3
```

## `config.json`

```json
{
  "complexity_tier": "standard",
  "approval_mode": "interactive",
  "gate_policy": {
    "max_gate_retries": 3,
    "retry_rule": "same_failure_stops_immediately",
    "distinct_failure_budget": 3
  },
  "review_policy": {
    "trivial": { "spec_compliance_review": false, "code_quality_review": false },
    "standard": { "spec_compliance_review": true, "code_quality_review": false },
    "complex": { "spec_compliance_review": true, "code_quality_review": true }
  }
}
```

- **`complexity_tier`** — `trivial` skips the Research/Innovate/Plan gates and the review agents;
  `complex` runs both review lenses. Match the tier to the story.
- **`approval_mode`** — `interactive` (default), `auto-with-diff`, or `scheduled-review`.
- **`gate_policy`** — see [Components → Gates](components.md#gates).
- **`review_policy`** — review agents are expensive; run them only where they add value, by tier.

## Automation layer

A scheduled triage heartbeat feeds `spider-discovery`, so the loop runs itself instead of waiting on
a manual trigger:

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

## Developer tips

- **Thinking mode per task** — simple bug fix → standard mode, small model; new feature design →
  extended thinking / Sequential Thinking MCP; security review → extended thinking + security skill.
- **Context management** — when switching tasks, summarise and compress; don't carry stale context
  across unrelated tasks.
- **Memory management** — use the Memory Graph to persist cross-session knowledge: entities,
  relationships, decisions, patterns that survive context resets. The graph — not session logs — is
  the long-term source of truth for system state.
- **Task management** — tasks with no dependency can run concurrently; define the dependency graph in
  `tasks.md` before spawning parallel work. Use subagent + worktree mode for independent stories.
- **Isolated harness** — run harness code in isolation (sandbox/container), never on the host.
- **Cost optimisation** — prompt caching for repeated context; send diffs not full files for review;
  match model size to task complexity; batch related small tasks.
