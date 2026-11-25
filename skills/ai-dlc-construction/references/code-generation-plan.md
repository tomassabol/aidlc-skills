# Code generation plan template

`aidlc-docs/construction/plans/<unit>-code-generation-plan.md`

```markdown
# Code Generation Plan: <unit>

> This plan is the single source of truth for generating <unit>.
> Steps are executed in order. Each step is ticked [x] as soon as it is done.
> No code is written until this plan is approved.

## Context
- **Bolt**: <n>: <name>. **Definition of Done**: <...>
- **Stories**: US-1, US-3
- **Business rules**: BR-1..BR-4 (functional-design/business-rules.md)
- **NFRs**: NFR-2 p95 < 200 ms, NFR-5 audit log
- **Consumes**: <unit-b> `POST /approvals` (contract: ...)
- **Workspace root**: <path>; **Layout**: existing (brownfield) | src/<unit>/

## Steps
- [ ] 1. Project structure: create `src/ideas/{domain,api,persistence}/` (greenfield only)
- [ ] 2. Domain logic: create `src/ideas/domain/idea.ts` (US-1, BR-1, BR-2)
- [ ] 3. Unit tests for domain: create `src/ideas/domain/idea.test.ts`
- [ ] 4. Persistence: modify `src/db/schema.ts`; create migration `migrations/0007_ideas.sql`
- [ ] 5. Persistence tests: create `src/ideas/persistence/repo.test.ts`
- [ ] 6. API: create `src/ideas/api/routes.ts` (US-1, US-3)
- [ ] 7. API tests: create `src/ideas/api/routes.test.ts`
- [ ] 8. UI: modify `web/src/pages/Ideas.tsx` (data-testid: ideas-submit-button, ...)
- [ ] 9. UI tests: create `web/src/pages/Ideas.test.tsx`
- [ ] 10. Docs: modify `README.md` (API section)
- [ ] 11. Code summary: write `aidlc-docs/construction/<unit>/code/code-summary.md`

## Story completion
- [ ] US-1 Submit idea
- [ ] US-3 Withdraw idea

## Verification
- Command: `npm test -- ideas` (approved by: <name/date>)

## Proposed extras (NOT approved; will not be built unless approved)
- <e.g. rate limiting on submit>
```

## code-summary.md

```markdown
# Code Summary: <unit>

| Story | Files | Tests |
|---|---|---|
| US-1 Submit idea | src/ideas/domain/idea.ts, src/ideas/api/routes.ts | idea.test.ts, routes.test.ts |

**Created**: ...
**Modified**: ...
```
