# Bolts: types, files and lifecycle

A **Bolt** replaces the sprint. It is a cycle of hours or days that implements one unit, or a slice of one. A unit takes one or more Bolts.

## Types
| Type | Use when | Stages | Output |
|---|---|---|---|
| **simple** | CRUD, UI tweaks, bugfixes, well-understood changes | Code Generation (plan, then generate) | code and tests |
| **ddd** | new business rules, data models, quality targets or infra | the design stages the execution plan selects, then Code Generation | design artifacts, code and tests |
| **spike** | a risky assumption: an unfamiliar library or API, a performance doubt, a pattern you're unsure the AI can implement well | a time-boxed experiment (see `ai-dlc-spike`) | findings plus suggested requirement or design changes. **No production code.** |

When a Bolt's type is unclear, pick the lighter one and promote it if questions pile up.

## Bolt file
Keep one file per Bolt at `aidlc-docs/construction/{unit}/bolts/bolt-<n>.md`:

```markdown
# Bolt <n>: <name>   (type: simple | ddd | spike)
- **Status**: planned | in progress | awaiting approval | done | failed
- **Scope**: US1.1, US1.2 (or: task description)
- **Depends on**: Bolt <m> / unit U2 contract
- **Definition of Done**: AC1.1.* green; lint clean; code-summary written
- **Confidence hypothesis**: shipping this proves <assumption> (e.g. SSO + DB work end to end)
- **Verification command**: `pnpm --filter ideas test` (approved <date>)

## Boundaries
- **Input**: approved design summaries, code plan
- **Changes**: files and folders this Bolt may touch
- **Done evidence**: test output excerpt, reviewer report path, code-summary path
```

## Lifecycle
`planned → in progress → awaiting approval → done`, or `failed`, which leads to Retry, Skip or Abort.

- **Re-planning.** Append, split or reorder Bolts when what you learn changes the plan. Present the change, get approval, and log it as a Change Request.
- **Walking skeleton.** On a new system, Bolt 1 of the first unit is the thinnest end-to-end slice. Nothing else starts until its verification passes and a human approves.
- **Hypothesis result.** At the end of each Bolt, record whether the hypothesis held. If it didn't, propose how to adjust the remaining Bolts.
