---
name: spider-retro
description: SPIDER retro — digest completed sessions into lessons, promote decisions, then clean up.
disable-model-invocation: true
---

# Spider · Retro

Digest completed sessions into actionable learnings, promote decisions, then clean up. Routine — every epic close, or at least every 2 weeks. (Postmortem is the **exceptional** twin, for when something breaks.)

## Steps

1. **Read** all sessions since the last retro.
2. **Digest** — extract learnings, patterns, failures, wins.
3. **Distill** → `specs/sessions/_LESSONS_LEARNED.md` (permanent, never deleted).
4. **Report** → `specs/retro/<YYYY-MM-DD>.md` (action items + summaries).
5. **Promote decisions** — formal → `specs/architecture/adr-*.md`; discussion → tech-huddle backlog; actionable → `specs/tech-debts/*.md`.
6. **Get human approval**, then **cleanup** — delete the digested session directories.

*completion: `_LESSONS_LEARNED.md` updated, a retro report dated today exists, decisions promoted, and (after approval) digested sessions deleted.*

## Archive, don't summarize

Before deleting a session, carry into `_LESSONS_LEARNED.md`: rejected alternatives, ordering decisions, fine constraints. The retro-digest-agent runs in a context **separate** from the one that wrote the sessions — a fresh eye asking "what was left out?".

## Why sessions are deleted

Git log captures WHAT changed; the graph + ADRs capture WHY; `_LESSONS_LEARNED.md` captures distilled wisdom. Once those exist, detailed session logs are scaffolding.

## Constraints

- Never delete `_LESSONS_LEARNED.md` or `_POSTMORTEMS.md` — permanent.
- Never delete without human approval.

> Output tables: see the Retro phase + Directory Structure (session lifecycle). External skill it wraps: `handoff`.
