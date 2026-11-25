# Independent pre-gate review

Before each gate, a reviewer with fresh eyes checks the artifact. It catches the things the author misses:
- broken cross-references
- cycles
- NFRs that can't be measured
- missing error cases
- tests that were claimed but never run

## When to run it
| Stage | Mode |
|---|---|
| Requirements, User Stories, Application Design, Units Generation | **Advisory:** one pass. The findings go to the human at the gate. |
| Functional Design, NFR Requirements/Design, Infrastructure Design, Code Generation | **Fix loop:** you fix the findings and the reviewer checks again, **at most 2 rounds** |
| Trivial profile, or Minimal depth | skip, or self-review only |

**Acting on findings.** Mechanical findings you may fix yourself:
- broken references
- untestable wording
- missing IDs or tags
- formatting

Findings that need a **product or policy decision**, such as who can see or do what, lifecycle rules, or limits, are **not yours to decide**:
- In advisory mode, list them at the gate as questions or open decisions, each with a recommended answer.
- If you do add a default so the artifact is complete, mark it `[assumption]`, name it in the gate summary under "Decided by me, please confirm", and keep the count small.

Never report a finding as "fixed" when you resolved it by inventing a rule.

## How to run it
- **If the agent can spawn subagents,** dispatch a fresh one. Give it:
  - the stage's artifacts
  - the upstream artifacts they must satisfy
  - `memory.md` and `standards/`
  - the checklist below
- **What the reviewer must not do:**
  - see your plan reasoning or diary
  - edit the artifacts
- **The reviewer writes only** `aidlc-docs/<phase>/<stage>/reviews/<stage>-review-<n>.md`.
- **If you can't spawn subagents,** do a separate self-review step against the same checklist, and say so at the gate.

## Report format

```markdown
# <Stage> review <n>
Verdict: READY | NOT-READY

| Severity | Location (file § section) | Finding | Required action |
|---|---|---|---|
| Critical | requirements.md § FR3 | AC not testable ("fast") | state p95 target |

## Prior findings (round 2+)
| Finding | Fixed / Still applies |
```

- **READY** means 0 Critical and at most 2 Major findings.
- **Every finding needs checkable evidence:** an ID that doesn't resolve, a failing command, a contradicted contract, a missing AC.
- **Code Generation:** the reviewer must **run the unit's test or verification command** and quote the result. A claim that wasn't run counts as a finding in itself.
- **Leftover findings never block the gate.** Show them in the gate's Review line, and let the human decide.

## Checklists

**Product lens** (Inception):
- The Intent is in business language, with no premature tech choices.
- Every FR has a source tag, and every story traces to an FR.
- Every AC is Given/When/Then and testable.
- Corner cases are settled: each is a requirement, an assumption or out of scope.
- Success measures have a baseline, a target and a date.
- No assumption is presented as a confirmed requirement.

**Architecture lens** (design and Units):
- Every entity has exactly one owner.
- The unit graph is acyclic, and each story belongs to exactly one unit.
- Every pattern traces to an NFR and has a simpler fallback.
- Every NFR is measurable.
- One-way-door decisions have ADRs.
- Interfaces between units are named and consistent: style, error format, auth.

**Code lens** (Code Generation):
- The plan steps are all `[x]`, and the diff matches the plan, with no unapproved extras.
- Tests exist for every AC in scope and pass when run.
- No quality target was relaxed.
- No secrets in the code, and no unrequested data-model elements.
- Brownfield files were edited in place, with no `*_new` copies.
- Enabled extension rules are met.
