# Code generation plan template

Path: `aidlc-docs/construction/plans/<unit>-code-generation-plan.md`. For zero-unit work, use `construction/code-generation/plan.md`.

```markdown
# Code Generation Plan: <unit>

## Summary
- **Builds:** idea submission and listing (API + UI) for u1-ideas
- **Touches:** src/ideas/**, src/db/schema.ts, migrations/, web/src/pages/Ideas.tsx
- **Tests:** 14 (9 unit, 4 integration, 1 e2e)
- **Adds:** 1 data-model element no requirement asks for: `ideas.submitted_ip`. See Assumptions.

> This plan is the single source of truth for <unit>. Steps run in order and are ticked [x] as each finishes.
> No code is written until this plan is approved.

## Context
- **Bolt**: 1, walking skeleton (ddd). **DoD**: AC1.1.1, AC1.1.2 green
- **Stories / rules / NFRs**: US1.1, US1.2 / BR1-BR4 / NFR1 (p95 < 200 ms)
- **Consumes**: U2 `POST /approvals` (contract: application-design/services.md § Approvals)
- **Standards**: standards/coding-standards.md, tech-stack.md; memory.md rules applied
- **Test strategy**: Standard. **Methodology**: test-after. **Verification**: `pnpm --filter ideas test`
- **Layout**: existing (brownfield), so modify in place

## Steps
- [ ] 1. Test runner ready: confirm vitest config covers src/ideas (scaffold)
- [ ] 2. Domain: create `src/ideas/domain/idea.ts`. Ref: US1.1, BR1, BR2
- [ ] 3. Domain tests: create `src/ideas/domain/idea.test.ts`. Ref: AC1.1.1, AC1.1.2
- [ ] 4. Schema: modify `src/db/schema.ts`: table `ideas` (id, title, description, status, author_id, created_at, submitted_ip). Migration `migrations/0007_ideas.sql`. Ref: FR1
- [ ] 5. Repository and tests: create `src/ideas/persistence/repo.ts`, `repo.test.ts`. Ref: FR1
- [ ] 6. API and tests: create `src/ideas/api/routes.ts`, `routes.test.ts`. Ref: US1.1, US1.2
- [ ] 7. UI and tests: modify `web/src/pages/Ideas.tsx` (data-testid: ideas-submit-button, ideas-title-input). Ref: US1.1
- [ ] 8. e2e: create `e2e/ideas.spec.ts`. Ref: AC1.1.1
- [ ] 9. Code summary: write `aidlc-docs/construction/u1-ideas/code/code-summary.md`

## Execution waves (optional)
| Wave | Steps | Owns |
|---|---|---|
| 1 | 2-5 | src/ideas/domain, src/ideas/persistence, src/db, migrations |
| 2 | 6, 7 | src/ideas/api, web/src/pages |

## Story completion
- [ ] US1.1 Submit idea
- [ ] US1.2 List my ideas

## Assumptions
- `ideas.submitted_ip`: needed for the abuse audit trail (NFR5 implies it, but doesn't state it). **Confirm or remove.**

## Proposed extras (NOT approved; will not be built unless approved)
- Rate limiting on submit
```

Rules:
- Docs for new code go inline or as API docs. **Don't modify README** unless the user asked. Put setup notes in `code-summary.md`.
- Never put a generic "schema changes" step. Name every element.

## code-summary.md

```markdown
# Code Summary: <unit>

## Summary
<≤10 lines>

| Story | AC | Files | Tests | Status |
|---|---|---|---|---|
| US1.1 | AC1.1.1 | src/ideas/domain/idea.ts, api/routes.ts | idea.test.ts, routes.test.ts, e2e/ideas.spec.ts | OK |
| US1.3 | — | — | — | Deferred: "phase 2" (user, 2026-02-03) |

**Created**: ...
**Modified**: ...
**How to verify**: `pnpm --filter ideas test && pnpm e2e ideas`
**Setup notes**: new env var IDEAS_MAX_LEN (default 120)
**Accepted risks**: no load test yet (NFR1 Unverified until Build & Test)
```
