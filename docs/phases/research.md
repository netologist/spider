# Research
>
> Research best practices, library documentation, and patterns relevant to the current story — **external** research, not codebase reading.

**When this runs:** After Inception/Discovery; first phase of the per-story cycle (before Innovate).

**Before starting:**

- Read `specs/context/` files (filled by Inception or Discovery)
- Review `specs/postmortems/` for relevant lessons
- Review `specs/architecture/README.md` (ADR index) for past decisions
- Read `specs/logs/DECISIONS.md` and `DRIFT.md`

**During research:**

- Use Context7 MCP for library/framework documentation
- Use Web Search for post-training-cutoff information
- Use Sequential Thinking MCP for structured reasoning

**Outputs** — mandatory feature-level context in `specs/features/<name>/context.md`:

- New libraries/frameworks to be used (with versions, docs links)
- Established patterns from the ecosystem
- Known pitfalls and edge cases from community experience
- Integration considerations with existing `specs/context/STACK.md`

**Exit gate — Gate 1 (Research → Innovate):**

- [ ] Context fully documented?
- [ ] Best practices researched?
- [ ] Relevant library docs reviewed?
- [ ] Risks and known pitfalls identified?

**Constraints:** No code writing. No implementation proposals. No spec writing. Only external research and document.

**Key distinction from Discovery:**

- Discovery = "What does OUR codebase look like?" (internal)
- Research = "What does the OUTSIDE world say about this problem?" (external)

Operational discipline: see the `spider-research` skill.
