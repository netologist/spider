---
name: spider-research
description: SPIDER external research — best practices and library docs for one story, before solution design.
disable-model-invocation: true
---

# Spider · Research

Research best practices, library docs, and patterns for the **current story**. This is **external** research — not codebase reading (Discovery already did that).

## Before starting

Read `specs/context/*`, `specs/postmortems/`, the ADR index (`specs/architecture/README.md`), and `specs/logs/DECISIONS.md` + `DRIFT.md`.

## Steps

1. **Library docs** — use Context7 MCP for framework/library docs (with versions).
2. **Post-cutoff info** — use Web Search for anything past the training cutoff.
3. **Structure the reasoning** — use Sequential Thinking MCP for non-trivial chains.
4. **Write feature context** → `specs/features/<name>/context.md`: new libraries/versions/doc links, established patterns, known pitfalls & edge cases, integration with `specs/context/STACK.md`.

*completion: `specs/features/<name>/context.md` exists with sections for libraries, patterns, pitfalls, and integration.*

## Exit gate

Gate 1 (Research → Innovate): context documented, best practices researched, relevant docs reviewed, risks/pitfalls identified — full checklist: see the Research phase reference.

## Constraints

- No code. No implementation proposals. No spec writing. Only external research and the context file.

> Discovery asked "what does OUR code look like?"; Research asks "what does the OUTSIDE world say?".
