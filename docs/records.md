# Record Files

SPIDER records *why* decisions were made and *where* the implementation drifted from the spec.
These files are append-only where noted, and permanent where noted — they survive session cleanup.

## DRIFT.md (`specs/logs/DRIFT.md`)

Every spec deviation. Write during Execute — don't wait for Review. Empty while there is no drift.

```markdown
## [YYYY-MM-DD] Drift title

**Phase:** Which phase detected it?
**Spec had:** Original expectation
**What happened:** What actually happened
**Reason:** Why the deviation?
**Action:**
- [ ] Update spec
- [ ] Revert code to spec
- [ ] New decision (add to DECISIONS.md)
**Status:** open / acknowledged / resolved
```

## DECISIONS.md — two levels

**Project-level** (`specs/logs/DECISIONS.md`) — append-only timeline of all decisions:

```markdown
## [YYYY-MM-DD] Decision title

**Context:** Why was this decision needed?
**Selected:** What was chosen?
**Rationale:** Why this?
**Rejected alternatives:**
- Alternative A — why rejected
- Alternative B — why rejected
**Consequences:** What are the impacts?
```

**Feature-level** (`specs/features/<name>/DECISIONS.md`) — working decisions made during a session.
Temporary; at Retro they are promoted to ADRs, tech-huddle, or tech-debt backlog.

## POSTMORTEM (`specs/sessions/_POSTMORTEMS.md`)

Incident postmortems — **exceptional** events, not routine. Append-only, permanent, never deleted.
Not blame documents: record how the system failed and what changed so it doesn't happen again.

```markdown
## [YYYY-MM-DD] Short title

**What happened:** Event summary
**Why it happened:** Root cause
**Affected users:** ~N
**Duration:** X hours

**Root Cause Analysis:**
- Contributing factor 1
- Contributing factor 2

**Resolution:** What was done, how it was fixed

**Actions:**
→ task added to relevant .tasks.md
→ logged to ARCH_LOG.md
→ _LESSONS_LEARNED.md updated
```

## CHANGELOG (`specs/features/<name>/<platform>.changelog.md`)

Per-feature change log with an **impact tree** — documents what changed **and** what did **not**.
Every entry lists affected *and* unaffected files explicitly.

```markdown
## [YYYY-MM-DD] Change title

**Type:** tech | design | business-logic | ux-behavior
**Why:** Rationale for the change

**Impact Tree — Changed:**
→ file.that.changed.md          ← what was updated
→ another.affected.file.md       ← follow-on change
→ ARCH_LOG.md                    ← major decisions logged globally

**Impact Tree — Unchanged:**
→ platform-independent.spec.md   ← behavior unchanged
→ platform.design.md             ← architecture unchanged, only tool changed
```

## _LESSONS_LEARNED (`specs/sessions/_LESSONS_LEARNED.md`)

Distilled from retros. **Permanent — never deleted.** Organized by topic.

```markdown
# Lessons Learned

## <Topic>
- Lesson one
- Lesson two

## General
- Write impact tree before implementing tech changes
- Test rate limits from day one, not as an afterthought
```

## ADR index (`specs/architecture/README.md`)

The single source of truth for all architectural decisions, read at session start. When a new ADR
is created: write `adr-<NNN>-<slug>.md`, add a row to the index, and reference it from design docs.

```markdown
# Architecture Decision Records

| ID | Date | Title | Status |
|----|------|-------|--------|
| 001 | 2026-06-03 | Use SPIDER as structured development framework | Accepted |
```
