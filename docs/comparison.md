# Comparison: Loop Engineering (Addy Osmani)

Source: [addyosmani.com/blog/loop-engineering](https://addyosmani.com/blog/loop-engineering/)

Osmani's framework is 5 components + 1 support layer: **Automations, Worktrees, Skills,
Plugins/Connectors (MCP), Sub-agents, State/Memory**. How SPIDER maps to each:

| Osmani component | SPIDER equivalent | Status |
|------------------|-------------------|--------|
| **Sub-agents** (maker ≠ checker) | `gate-checker-agent`, `spec-compliance-review-agent`, `code-quality-review-agent` | Full overlap. The argument that the writing model goes soft on its own work, and a second agent with different instructions (sometimes a different model) catches those errors, is identical to SPIDER's principle "self-grading is a weak signal". |
| **Worktrees** | `story-subagent` + git worktree parallel execution | Full overlap. |
| **Skills** | `.spider` skills as real Skill format | Full overlap — the mechanism that stops the agent starting every session from scratch, keeping convention/rationale knowledge external. |
| **State / memory** | `specs/sessions/`, ADRs, `_LESSONS_LEARNED.md`, Memory Graph MCP | SPIDER is **richer** — Osmani suggests a single markdown file/board; SPIDER defines a full hierarchy (spec/behavior/design/tech/tasks/changelog). |
| **Plugins/Connectors (MCP)** | Context7, Memory Graph MCP, `to-issues` over the issue tracker | Partially present; not yet formalized as a general "connector layer". |
| **`/goal` pattern** (a small model checks "done?" each turn) | `post-gate.sh` (mechanical) + `gate-checker-agent` (judgmental) | Full overlap — maker-checker applied to the stopping condition. |
| **Automations (heartbeat)** | Discovery phase — but its trigger was undefined | **Closed** by the daily-triage automation (see [Configuration](configuration.md#automation-layer)). |

## What was missing: a scheduled automation layer

What makes a loop a *loop* in Osmani's framework is not manual triggering each time, but a
scheduled, self-running discovery/triage layer: the automation scans the repo, the `triage` skill
reads CI errors/open issues, findings are recorded, and when value is found a subagent drafts a
solution in an isolated worktree while a second subagent reviews it. SPIDER's Discovery phase
covered this conceptually, but *when it runs* was undefined — now bound to the cron schedule.

## Osmani's warnings confirm SPIDER's gates

The three risks at the end of the article — **verification still on the engineer**, **comprehension
debt** (as the loop speeds up, ununderstood code accumulates), and **cognitive surrender** (accepting
every output without questioning the loop) — justify SPIDER's Gate 3 (Plan approval) and the
human approval before deletion in Retro.

**Rule:** as the automation layer is added, these human-approval points must **not** loosen. As
automation increases, the criticality of the checker-agent + human approval rises, it does not fall.

## Token cost → bind to the complexity tier

Each sub-agent costs extra tokens (its own model/tool calls), so the second opinion is used only
where it genuinely adds value. SPIDER runs review agents **only in `standard`/`complex` tiers**;
in `trivial`, they are skipped entirely — otherwise opening 3–4 agent contexts for every small fix
is needless cost.
