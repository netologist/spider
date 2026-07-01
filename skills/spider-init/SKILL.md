---
name: spider-init
description: SPIDER bootstrap — scaffold .spider/ and specs/ in a project, then install the skills for Claude, Codex, or universal .agents (local or global).
disable-model-invocation: true
---

# Spider · Init

Bootstrap SPIDER into a project: create the `.spider/` harness and the `specs/` source-of-truth tree, then install the phase skills for the chosen harness. Run **once** per project.

This skill is self-contained — its templates live next to this file under `templates/`. Resolve them from **this skill's own directory**, not the cwd.

## Step 1 — Ask the harness question

Ask the user two things, then **stop and wait** for the answer:

1. **Harness** — where do the SPIDER skills install? `claude` (Claude Code) · `codex` (Codex) · `agents` (universal `.agents/`, harness-agnostic).
2. **Scope** — `local` (this project only) or `global` (user home, reusable across projects)?

Install mapping:

| Harness | Scope=local | Scope=global | Root AI file |
|---|---|---|---|
| `claude` | `.claude/skills/` | `~/.claude/skills/` | `CLAUDE.md` + `AGENTS.md` |
| `codex` | `AGENTS.md` (+ `.codex/`) | `~/.codex/` | `AGENTS.md` |
| `agents` | `.agents/skills/` | `~/.agents/skills/` | `AGENTS.md` |

*completion: harness + scope chosen and recorded.*

## Step 2 — Scaffold `.spider/` (harness infrastructure)

Copy this skill's `templates/dot-spider/` → `<project>/.spider/`, then `chmod +x .spider/hooks/*.sh`.

Contents: `harness.yaml` (model matrix + gate policy + automations), `config.json` (complexity tier, approval mode, gate/review policy), `rules.md`, and `hooks/` (the six mechanical gate scripts).

*completion: `.spider/` exists with `harness.yaml`, `config.json`, `rules.md`, and executable `hooks/*.sh`.*

## Step 3 — Scaffold `specs/` (source of truth)

Create the full tree (mirrors the Directory Structure reference), then drop in the seeded files:

```
mkdir -p specs/{context,inception,features/_template,architecture,design,retro,postmortems,tech-debts,logs,sessions}
cp -r <skill-dir>/templates/specs/. specs/
```

Seeded files provided: `architecture/README.md` (ADR index), `logs/{DECISIONS,DRIFT,ARCH_LOG,DESIGN_LOG,INTENT_CHANGES}.md`, `sessions/{_LESSONS_LEARNED,_POSTMORTEMS}.md` (permanent).

*completion: every `specs/` subdir exists; the 8 seeded files are present with header content.*

## Step 4 — Root files

Write `<project>/README.md` (for humans — what this project is) and `<project>/AGENTS.md` (for AI — SPIDER rules summary that points into `.spider/rules.md` and `specs/`). For `claude`, also write `CLAUDE.md` that includes `AGENTS.md`.

*completion: both root files exist; no overlap between them (README = humans, AGENTS = AI).*

## Step 5 — Install the phase skills

Copy every `skills/spider-*` directory from the SPIDER distribution into the install dir chosen in Step 1:

- `agents` local → `.agents/skills/` · global → `~/.agents/skills/`
- `claude` local → `.claude/skills/` · global → `~/.claude/skills/`
- `codex` → `AGENTS.md` references them; copy under `.codex/skills/` (local) or `~/.codex/skills/` (global).

*completion: all `spider-*` skills (init, router, discovery … retro) present in the chosen dir, each with its `SKILL.md`.*

## Step 6 — Wire the git hook

Link the mechanical pre-commit guard so commits are checked:

```
ln -sf ../../.spider/hooks/pre-commit.sh .git/hooks/pre-commit
```

(Symlink — so hook updates track `.spider/`. The other hooks are invoked by the harness/agents, not git, so need no wiring.) If `.git/` is absent, skip and note it.

*completion: `.git/hooks/pre-commit` resolves to `.spider/hooks/pre-commit.sh`, or the skip is noted.*

## Constraints

- Run once. Idempotent: **refuse to overwrite** an existing `.spider/` or `specs/` — ask before clobbering.
- Never assume the harness — always ask (Step 1).
- The skills install is a copy, not a symlink, unless the user asks otherwise.

> Tree reference: Directory Structure. Hook contract: Components (Hooks) + Getting Started.
