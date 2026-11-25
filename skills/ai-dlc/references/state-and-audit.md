# State, audit and resume

## Directory layout

```
<workspace root>/            application code (never inside aidlc-docs/)
aidlc-docs/
  aidlc-state.md             workflow state (single source of progress)
  audit.md                   append-only verbatim interaction log
  inception/
    plans/                   execution-plan.md, *-plan.md
    reverse-engineering/     brownfield only
    requirements/
    user-stories/
    application-design/      includes unit-of-work*.md
  construction/
    plans/                   {unit}-{stage}-plan.md
    {unit}/                  functional-design/ nfr-requirements/ nfr-design/
                             infrastructure-design/ code/ (summaries only)
    build-and-test/
  operations/
```

## Checkbox states
Use the same markers in `aidlc-state.md` and in plan files.

| Box | Meaning |
|---|---|
| `[ ]` | not started |
| `[-]` | in progress |
| `[?]` | waiting at the approval gate |
| `[R]` | being revised after "Request Changes" |
| `[x]` | done / approved |
| `[S]` | skipped (with a reason) |

Normal flow: `[ ]` → `[-]` → `[?]` → `[x]`. Revision flow: `[?]` → `[R]` → `[?]` → `[x]`.

## `aidlc-state.md` template

```markdown
# AI-DLC State

## Project Information
- **Project**: <name>
- **Type**: Greenfield | Brownfield
- **Started**: <ISO date>
- **Profile**: express | bugfix | feature | full | refactor
- **Depth**: Minimal | Standard | Comprehensive

## Intent
- **Request**: <one-line restatement>
- **Clarity / Type / Scope / Complexity**: <...>

## Workspace State
- **Languages**: ...
- **Build system**: ...
- **Structure**: monolith | microservices | library | empty
- **Workspace root**: <path>

## Code Location Rules
- <e.g. modify existing files in place; new code under src/<unit>/>

## Execution Plan Summary
- **Stages to execute**: ...
- **Stages skipped**: <stage>: <reason>

## Stage Progress
### Inception
- [x] Workspace Detection
- [ ] Reverse Engineering - EXECUTE | SKIP
- [ ] Requirements Analysis
- [ ] User Stories - EXECUTE | SKIP
- [ ] Workflow Planning
- [ ] Application Design - EXECUTE | SKIP
- [ ] Units Generation - EXECUTE | SKIP
### Construction
#### Unit: <unit-a>
- [ ] Functional Design - EXECUTE | SKIP
- [ ] NFR Requirements - EXECUTE | SKIP
- [ ] NFR Design - EXECUTE | SKIP
- [ ] Infrastructure Design - EXECUTE | SKIP
- [ ] Code Generation
- [ ] Build and Test (once, after all Units)
### Operations
- [ ] Deployment - EXECUTE | SKIP
- [ ] Observability - EXECUTE | SKIP
- [ ] Incident Readiness - EXECUTE | SKIP

## Current Status
- **Phase**: Inception
- **Stage**: Requirements Analysis
- **Next**: User Stories
- **Status**: awaiting answers | in progress | awaiting approval
```

## `audit.md` rules
- Log **every** user input with its complete raw text. Never summarise it.
- Log each gate prompt **before** asking it, and the response **after** receiving it.
- Use ISO-8601 timestamps.
- **Append only.** Read the file, then add to the end. Never rewrite the whole file.

```markdown
## <Stage Name | Interaction Type>
**Timestamp**: 2026-01-31T14:05:00Z
**User Input**: "<complete raw input>"
**AI Response**: "<response or action taken>"
**Context**: <stage, action, decision>

---
```

Gate entries use `**AI Prompt**`, `**User Response**` and `**Status**: Approved | Changes Requested`.

Change requests use the heading `## Change Request - <Stage>` with these fields: Timestamp, Request, Current State, Impact Assessment, User Confirmation, Action Taken, Artifacts Affected.

## Resuming a session
1. Read `aidlc-state.md`, then the tail of `audit.md`.
2. Show the welcome-back summary and ask A (continue) / B (review an earlier stage) / X (other).
3. Reload context in proportion to the next stage. Load only what's relevant: refresh the context on purpose, don't dump everything into it.

| Next stage | Load |
|---|---|
| Requirements / User Stories | reverse-engineering artifacts (if any), requirements, answered question files |
| Workflow Planning / Application Design / Units | the above plus stories |
| Per-unit design | requirements, stories, unit-of-work files, that unit's earlier design artifacts, design artifacts of units it depends on |
| Code Generation | the unit's design artifacts, its code-generation plan, and the existing code it touches |
| Build and Test / Operations | all units' code summaries, build-and-test artifacts |

4. Say in one or two lines what you loaded, log the resume in `audit.md`, and continue.
