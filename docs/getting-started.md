# Getting Started

SPIDER is bootstrapped into a project with the **`spider-init`** skill. It scaffolds the `.spider/`
harness and the `specs/` tree, installs the phase skills for your harness, and wires the git hook —
all from one command.

## Prerequisite: install the skills

`spider-init` assumes the SPIDER skills are already on your machine. If you haven't installed
them yet, see [Installation](installation.md) — one command, once per machine.

## Run `spider-init`

Invoke the skill in the project you want to bootstrap:

```text
/spider-init        # or: run the spider-init skill
```

It will **ask two questions** and wait for your answer:

1. **Harness** — where do the SPIDER skills install?
   - `claude` — Claude Code
   - `codex` — Codex
   - `agents` — universal `.agents/` (harness-agnostic)
2. **Scope** — `local` (this project only) or `global` (user home, reusable across projects)?

Install mapping:

| Harness | Scope=local | Scope=global | Root AI file |
|---------|-------------|--------------|--------------|
| `claude` | `.claude/skills/` | `~/.claude/skills/` | `CLAUDE.md` + `AGENTS.md` |
| `codex` | `AGENTS.md` (+ `.codex/`) | `~/.codex/` | `AGENTS.md` |
| `agents` | `.agents/skills/` | `~/.agents/skills/` | `AGENTS.md` |

## What `spider-init` creates

```
your-project/
├── README.md                    ← for humans (you fill it in)
├── AGENTS.md                    ← SPIDER rules for AI
└── .spider/
    ├── harness.yaml             # model matrix + gate policy + automations
    ├── config.json              # complexity tier, approval mode, gate/review policy
    ├── rules.md                 # SPIDER non-negotiables (injected at session start)
    └── hooks/                   # the six mechanical gate scripts (executable)
        ├── session-start.sh
        ├── pre-phase.sh
        ├── post-phase.sh
        ├── pre-commit.sh
        ├── post-gate.sh
        └── pre-merge.sh

your-project/specs/
├── context/                     ← Inception/Discovery fills these
├── architecture/README.md       ← ADR index (seeded)
├── logs/{DECISIONS,DRIFT,ARCH_LOG,DESIGN_LOG,INTENT_CHANGES}.md   ← seeded
├── sessions/{_LESSONS_LEARNED,_POSTMORTEMS}.md                    ← seeded (permanent)
└── … (features/, design/, retro/, postmortems/, tech-debts/, inception/)
```

The pre-commit git hook is symlinked so it tracks `.spider/hooks/`:

```bash
ln -sf ../../.spider/hooks/pre-commit.sh .git/hooks/pre-commit
```

## After init: run the flow

1. **Entry** — no existing code? Run **Inception**. Existing codebase? Run **Discovery**. Either
   fills `specs/context/`.
2. **Per story** — follow the cycle: Research → Innovate → Plan → *(Spike if risky)* → Execute →
   Review → Document → Retro.
3. **Lost on which phase is next?** Run the **`spider-router`** skill — it reads `specs/` state and
   tells you which phase should run.

## Manual setup (without `spider-init`)

If you need to scaffold by hand instead of using the skill, the templates live in this repo at
`skills/spider-init/templates/`. Copy `templates/dot-spider/` → `.spider/`, `chmod +x .spider/hooks/*.sh`,
create the `specs/` tree, and copy the phase skills from `skills/spider-*` into your install dir.

> The legacy three-pass meta-prompt (skeleton → skill contents → hooks/model config) is now
> automated by `spider-init` and its templates. See the [Components](components.md) page for the
> hook and agent contracts.
