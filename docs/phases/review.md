# Review
>
> Validate implementation against the spec.

**When this runs:** After Execute passes the Quality Gate; before Document.

**What happens:**

- Acceptance criteria checked one by one: ✅ pass / ❌ fail / ⚠️ attention
- Edge cases manually tested
- Coverage report reviewed
- DRIFT.md updated
- Feature marked `status: done` if all pass
- If failures: specify which phase to return to

**Two independent review agents** (run in a context separate from the writing agent — self-grading is a weak signal):

- **Phase 1 — spec-compliance-review-agent:** does the code match the spec?
- **Phase 2 — code-quality-review-agent:** architecture / readability, using the `codebase-design` ("deep module") discipline.

**Exit:** Feature marked `status: done` if all acceptance criteria pass; otherwise the failing phase is named for return.

**Constraints:** No new implementation in this phase — validation only. Runs in a separate context from the agent that wrote the spec/code.

Operational discipline: see the `spider-review` skill.
