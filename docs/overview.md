# Overview

## What is SPIDER?

SPIDER is a **development framework for AI coding agents**. It defines a fixed sequence of phases,
each ending on a **gate**, that an agent follows to take a feature from idea to shipped code. The
goal is *predictability*: not that the agent produces the same output every time, but that it runs
the **same process** every time.

It is built around four convictions:

- **Thinking precedes writing.** Each phase produces input for the next; the order is unbreakable.
- **Spec is above code.** The specification is the source of truth; code obeys it, not the reverse.
- **TDD is mandatory.** Tests before implementation is a protocol rule, not a suggestion.
- **Gates are passed, not skipped.** No phase progresses without approval and quality checks.

## Where the name comes from

**SPIDER** is the framework's brand name. The letters stand for the framework's **capabilities** —
they name *what* the framework can do, **not the phase order**:

| Letter | Capability | Type |
|--------|-----------|------|
| **S** | Spike / PoC | Optional risk-reduction step |
| **P** | Plan | Spec + test plan, gate-enforced |
| **I** | Innovate · Inception | Greenfield bootstrap + solution-space exploration |
| **D** | Documentation · Discovery | Brownfield analysis + session records + postmortems |
| **E** | Execute | TDD implementation (Red → Green → Refactor) |
| **R** | Research · Review | External research + spec validation |

Because the letters are capabilities and not order, phases are **always referenced by their full
name** — "the Research phase", "the Review phase" — never by single letter.

The **spider** metaphor fits: the agent sits at the center of a *web* of specs, skills, gates, and
hooks, and like a web, the framework is built to **catch problems early** — drift, scope creep,
untested code — before they reach production.

## The actual flow order

```
Entry:    DISCOVERY (brownfield)  or  INCEPTION (greenfield)
            ↓
Cycle:    RESEARCH → INNOVATE → PLAN → SPIKE(opt) → EXECUTE → REVIEW → DOCUMENT → RETRO
```

## Core philosophy

1. **Thinking precedes writing.** Each phase produces input for the next; order is unbreakable.
2. **Spec is above code.** Code changes → spec updates; spec changes → approval required.
3. **TDD is mandatory** — tests before implementation is a protocol rule, not a suggestion.
4. **Every deviation is recorded.** Drift doesn't happen silently; it's documented and actioned.
5. **Gates are passed, not skipped.** No phase progression without approval and quality gates.
6. **Simplicity always wins.** Prefer the simplest solution that meets requirements.
7. **Retro always happens.** Every session's learnings are digested into action items; sessions are then cleaned up.

## Language

Conversations with the harness may be in any language, but **all output documents are in English**.
