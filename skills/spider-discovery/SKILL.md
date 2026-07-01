---
name: spider-discovery
description: SPIDER brownfield entry — map an existing codebase before proposing any change.
disable-model-invocation: true
---

# Spider · Discovery

Understand an existing codebase before proposing or executing **any** change. This is the brownfield entry — the twin of Inception (greenfield). Run **once**, at project start.

## Steps

1. **Read the codebase** — structure, entry points, dependencies, test coverage, build scripts. Note the build/test commands you'll reuse every session.
2. **Map the domain** — entities, boundaries, data flows, external integrations → write `specs/architecture/as-is.md`.
3. **Hunt tech-debts** — for each smell, risk, or outdated dependency: write `specs/tech-debts/<slug>.md`.
4. **Rank recommendations** — security > correctness > performance > maintainability.
5. **Infer the context files** — fill `specs/context/PROJECT.md`, `STACK.md`, `CONVENTIONS.md`, `GLOSSARY.md` from the code. Mark anything unclear `[NEEDS CLARIFICATION]` — never invent.
6. **Record findings** — session context → `specs/sessions/<date>/context.md`.

*completion: every `specs/context/*` file exists; `as-is.md` and ≥1 tech-debt file exist; every `[NEEDS CLARIFICATION]` is listed for the human.*

## Constraints

- No code changes. No implementation proposals. No new spec writing beyond `as-is.md`, tech-debts, and inferred context.
- This is **internal** reading — "what does OUR code look like?". External world-knowledge belongs to Research.

> Output tables: see the Discovery phase reference. External skill it wraps: `improve-codebase-architecture`.
