---
name: ai-dlc-review
description: Independent AI-DLC review in two modes. Code mode reviews a diff, paths or a unit against its approved design, plan and acceptance criteria. Design mode checks consistency across several units' designs before implementation (API style, shared entities, error formats, auth, integration points, ownership). Each finding has a severity and a fix, and the result is a READY/NOT-READY or Go/No-Go verdict. Use when the user asks for an AI-DLC code review, design review, solutions or cross-unit review, or a pre-gate check, or when another AI-DLC skill dispatches a reviewer. Works standalone, falling back to general best practice when design docs are missing. Do not use for a casual "look at this function" question.
---

# AI-DLC Review

A fresh-eyes check that catches what the author missed.

**It never edits what it reviews,** unless the user explicitly asks it to apply fixes (see "Applying fixes"). It writes only its own report.

## Inputs and outputs
| | |
|---|---|
| **Code mode inputs** | a scope: the full repo, paths, a git diff/branch, or a unit. Optional: the unit's code plan, design artifacts, requirements/ACs, `standards/`, `memory.md`, enabled extensions |
| **Design mode inputs** | 2+ units' design artifacts (`construction/*/functional-design`, `nfr-*`, `infrastructure-design`, `application-design/*`), and the foundation unit if there is one |
| **Writes** | `aidlc-docs/<phase>/<stage>/reviews/<name>-review-<n>.md`, or `aidlc-docs/reviews/<date>-<scope>.md` when running standalone |

**Standalone:** with no AI-DLC docs, review against the repo's own conventions (lint config, existing patterns, README) and general best practice. Say in the report which inputs were missing.

## Code mode
1. **Establish the scope,** and the baseline the code must satisfy: plan steps, ACs, business rules, NFRs, standards.
2. **Run the evidence.** Run the unit's test or verification command, plus lint and type-check. Quote the results. If you can't run them, record that as a finding. Never assume green.
3. **Check, in priority order:**
   1. **Security:**
      - injection
      - authn/authz gaps, IDOR
      - secrets in code
      - unsafe deserialisation
      - PII in logs
      - enabled `SEC-*` rules
   2. **Correctness:**
      - every in-scope AC implemented
      - edge cases from the corner checklist
      - error handling
      - concurrency and idempotency
   3. **Design compliance:**
      - matches the approved plan and design: structure, data model, API, layout
      - no libraries outside `standards/tech-stack.md`
      - no unrequested data-model elements
      - brownfield files edited in place
   4. **Quality targets:** no relaxed thresholds, skipped tests or deleted assertions.
   5. **Performance:** N+1 queries, unbounded loops or queries, missing pagination, blocking I/O on hot paths.
   6. **Tests:** cover the ACs, meet the test-strategy volume, the regression test exists for bugfixes, no flaky sleeps.
   7. **Maintainability:** naming, duplication, dead code, comments that explain *why*.
   8. **Accessibility** (when there's a UI): labels, keyboard navigation, contrast, stable `data-testid` values.
4. **Be proportional.** Every finding has a concrete fix. Say so when something is good. Don't pad the report with style nits.

## Design mode (cross-unit, before implementation)
Check:
- **API consistency:** style (REST, RPC, events), naming, versioning, pagination, error format, auth scheme.
- **Shared entities:** the same concept defined differently in two units. Two units claiming ownership of one entity.
- **Integration:** every consumed interface is provided somewhere. Published events have consumers, or are documented as public. Contracts agree on both sides.
- **Foundation conventions:** deviations from the foundation unit or `standards/`.
- **Dependency graph:** no cycles, no unit with 3+ dependents unless it's intended as a platform unit.
- **NFR alignment:** units in one request path have compatible latency, availability and security assumptions.

The verdict is **Go / Conditional Go (fix listed items first) / No-Go**. Each finding gets an effort estimate (S, M or L).

## Report format

```markdown
# Review: <scope>  (mode: code | design, round <n>)
Verdict: READY | NOT-READY      (design mode: Go | Conditional Go | No-Go)
Evidence: `<command>` → <pass/fail counts, quoted summary>

| ID | Severity | Location | Finding | Fix | Effort |
|---|---|---|---|---|---|
| CR-1 | Critical | src/ideas/api/routes.ts:42 | No authz check on PATCH /ideas/:id (IDOR) | verify author_id = session user | S |

## Good
- <what's solid>

## Prior findings (round 2+)
| ID | Fixed / Still applies |

## Missing inputs
- <e.g. no design docs; reviewed against repo conventions>
```

- **Severities:**
  - **Critical:** security hole, data loss, AC broken
  - **Major:** design violation, missing tests for an AC, relaxed target
  - **Minor:** maintainability or performance with low impact
  - **Suggestion:** optional
- **READY** means 0 Critical and at most 2 Major findings.

## Applying fixes (only on explicit request)
1. Back up the touched files to `aidlc-docs/reviews/backup/<date>/`. Don't use `git stash`, which can lose uncommitted work.
2. Apply the Critical fixes first. Run the tests after each fix.
3. If tests fail, restore that file from the backup and report.
4. Re-run the review and append the round to the report.
