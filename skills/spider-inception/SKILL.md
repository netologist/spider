---
name: spider-inception
description: SPIDER greenfield entry — elicit decisions, architecture, stack, and environment from scratch.
disable-model-invocation: true
---

# Spider · Inception

Establish every decision, architecture, stack, and environment **from scratch**. Greenfield entry — the twin of Discovery (brownfield). Run **once**, at project start.

**Ask — never assume** until everything is unambiguous.

## Steps

1. **Elicit decisions** — ask every open question; do not invent answers.
2. **Write ADRs** — for each significant decision: `specs/architecture/adr-<NNN>-<slug>.md`; update the index `specs/architecture/README.md`.
3. **Design docs** — `specs/design/system-overview.md`, `specs/design/nfr.md`.
4. **Pick the stack** — `specs/design/tech-stack.md`.
5. **Set up the environment** — repo, CI/CD, isolated harness, `README.md`.
6. **Save context** — fill `specs/context/PROJECT.md`, `STACK.md`, `CONVENTIONS.md`, `GLOSSARY.md`; write the first-story intent → `specs/sessions/<date>/intent.md`.

*completion: every `specs/context/*` file is filled (no `[NEEDS CLARIFICATION]`), the ADR index lists ≥1 ADR, and the environment builds.*

## Constraints

- Update `GLOSSARY.md` / `CONVENTIONS.md` **during** the conversation (grill-with-docs pattern), not at the end — build the shared ubiquitous language as you go.
- No feature code yet — this phase bootstraps the project, not a story.

> Output tables: see the Inception phase reference. External skill it wraps: `grill-with-docs`.
