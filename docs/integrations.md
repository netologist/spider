# Integrations

## MCP servers

| MCP | Purpose |
|-----|---------|
| **Context7** | Up-to-date library and framework documentation |
| **Sequential Thinking** | Structured multi-step reasoning |
| **GitHub** | Repository operations, PR management |
| **Web Search** | Current information beyond the training cutoff |
| **Memory Graph** | Cross-session persistent knowledge graph |
| **Filesystem** | Direct filesystem operations within scope |

## Companion skills (mattpocock/skills mapping)

SPIDER wraps these rather than reimplementing their discipline. The repo splits along two axes:
**user-invoked** (orchestration) and **model-invoked** (carries the discipline).

| Skill | Type | SPIDER role | Why |
|-------|------|-------------|-----|
| `grill-with-docs` | user | Inception / Discovery elicitation | Updates CONTEXT/GLOSSARY *during* the conversation; builds a ubiquitous language |
| `domain-modeling` | model | Continuously, across Research / Plan | Stress-tests glossary terms with edge cases; prevents drift |
| `codebase-design` | model | Plan (design.md) + Execute/Refactor | Deep-module discipline (small interface, deep implementation) |
| `prototype` | model | Spike / PoC | Throwaway code answering one design question |
| `diagnosing-bugs` | model | Execute/Quality-Gate fail + Review | reproduce → minimise → hypothesise → instrument → fix → regression-test |
| `tdd` | model | Execute — Red/Green/Refactor | Bans horizontal slicing; enforces vertical-slice / tracer-bullet |
| `to-issues` | user | Plan → Execute handoff | Splits the spec into vertical-slice tasks |
| `to-prd` | user | Plan (optional) | Synthesis-based PRD draft for the spec's Goal / Out-of-scope |
| `improve-codebase-architecture` | user | Discovery + health checks | Scans codebase, ranks deepening opportunities |
| `triage` | user | Retro → Next-story? + tech-debt backlog | State machine over the issue tracker |
| `grilling` | model | Engine of Innovate + Inception | One question at a time, until every decision branch resolves |
| `handoff` | user | Subagent handoff + before Retro/cleanup | "Archive, not summarize" before deleting sessions |
| `writing-great-skills` | reference | Meta — writing `.spider` skills | Vocabulary/principles that keep skills predictable |
| `git-guardrails-claude-code` | hook template | `.spider/hooks/pre-commit.sh` | Blocks `push` / `reset --hard` / `clean` |
| `setup-pre-commit` | hook template | `pre-commit.sh` foundation | Husky + lint-staged + typecheck + test |

**Not used:** `migrate-to-shoehorn` (TS-specific) and `scaffold-exercises` (educational) are outside
SPIDER's scope.

## Skill invocation rule

- **Phase-orchestrator skills are user-invoked** — you trigger them; zero context load.
- **Inner discipline skills are model-invoked** — the agent fires them when their trigger matches.

This maps directly onto the SPIDER phase skills: the `spider-*` orchestrators are user-invoked, the
inner discipline (tdd, domain-modeling, codebase-design) is model-invoked.
