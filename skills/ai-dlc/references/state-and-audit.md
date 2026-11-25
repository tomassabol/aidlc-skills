# State, audit, memory, resume and recovery

## Directory layout

```
<workspace root>/              application code (never inside aidlc-docs/)
aidlc-docs/
  aidlc-state.md               workflow state (single source of progress)
  audit.md                     append-only verbatim interaction log
  memory.md                    durable project rules (loaded every session)
  standards/                   tech-stack.md, coding-standards.md, decisions-index.md
  discovery/                   optional: brief.md
  inception/
    plans/  reverse-engineering/  requirements/  user-stories/  application-design/
  construction/
    plans/  {unit}/  build-and-test/  code-generation/  (zero-unit work)
  operations/
  verification/                phase-check-<phase>.md
  archive/<date>-<stage>/      superseded artifacts
  <any stage folder>/reviews/  reviewer reports
  <any stage folder>/memory.md optional stage diary
```

## Checkbox states
These are used in `aidlc-state.md` and in plan files.

| Box | Meaning |
|---|---|
| `[ ]` | not started |
| `[-]` | in progress |
| `[?]` | waiting at the approval gate |
| `[R]` | being revised after "Request Changes" |
| `[x]` | done / approved |
| `[S]` | skipped (reason required) |
| `[!]` | failed (reason required; dependents wait) |

Normal flow: `[ ]` → `[-]` → `[?]` → `[x]`. Revision flow: `[?]` → `[R]` → `[?]` → `[x]`.

Each artifact also has a status: `draft`, `approved` or `outdated`. Editing an upstream artifact marks everything downstream `outdated` but never deletes it. Warn before using an outdated artifact.

## `aidlc-state.md` template

```markdown
# AI-DLC State

## Project Information
- **Project**: <name>   **Type**: Greenfield | Brownfield   **Started**: <ISO date>
- **Profile**: trivial | bugfix | security-patch | feature | full | refactor | infra
- **Depth**: Minimal | Standard | Comprehensive
- **Test strategy**: Minimal | Standard | Comprehensive   **Methodology**: tdd | bdd | test-after
- **Autonomy (Construction)**: review each checkpoint | continue automatically (set after skeleton)

## Intent
- **Request**: <one-line restatement>
- **Clarity / Type / Scope / Complexity**: <...>

## Workspace State
- **Languages / Build / Structure / Workspace root**: ...

## Code Location Rules
- <e.g. modify in place; new code under src/<unit>/>

## Extension Configuration
| Extension | Enabled | Decided at |
|---|---|---|
| security-baseline | yes/no | Requirements Analysis, <date> |
| resiliency | yes/no | ... |
| property-based-testing | full/partial/no | ... |

## Execution Plan Summary
- **Execute**: ...   **Skip**: <stage>: <reason>

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
#### Unit: <unit-a>   (Bolt 1/2)
- [ ] Functional Design - EXECUTE | SKIP
- [ ] NFR Requirements - EXECUTE | SKIP
- [ ] NFR Design - EXECUTE | SKIP
- [ ] Infrastructure Design - EXECUTE | SKIP
- [ ] Code Generation
- [ ] Build and Test (once, after all Units)
### Operations
- [ ] Deployment / Observability / Incident Readiness - EXECUTE | SKIP

## Artifacts
| Artifact | Status |
|---|---|
| inception/requirements/requirements.md | approved |

## Current Status
- **Phase / Stage / Next**: ...
- **Status**: awaiting answers | in progress | awaiting approval | paused
- **Paused note**: <what's in flight, if paused>
```

## `memory.md`: durable project rules
This file is loaded at every start and resume. Append only. If a new rule contradicts an old one, replace the old one and add a note.

```markdown
# Project rules (AI-DLC memory)

## Decided
- DECIDED: PostgreSQL 16 for persistence (NFR Requirements, 2026-01-31)
## Mandated
- ALWAYS: run `pnpm lint` before presenting code (learned 2026-01-31)
## Forbidden
- NEVER: add new npm dependencies without asking (learned 2026-02-02)
## Preferences
- PREFER: small PR-sized Bolts
## Corrections
- <one-line lesson from a Request Changes>, (<stage>, <date>)
```

Retros (see `ai-dlc-adoption`) append to this file too.

## `standards/`: decisions that outlive one Intent
- `tech-stack.md`: languages, frameworks and pinned versions, with each version's source and date.
- `coding-standards.md`: conventions inferred from the repo and confirmed by the user.
- `decisions-index.md`: one line per ADR, plus a **"Read when"** column (e.g. "touching auth"). Load only the decisions that matter for the current stage.

Construction loads `standards/` for every Unit. New Intents reuse it instead of asking again.

## `audit.md` rules
- Log **every** user input with its complete raw text. Never summarise.
- Log each gate prompt **before** asking it, and the response **after** receiving it.
- Use ISO-8601 timestamps.
- **Append only.** Read the file, then add to the end. Never rewrite it.

```markdown
## <Stage Name | Interaction Type>
**Timestamp**: 2026-01-31T14:05:00Z
**User Input**: "<complete raw input>"
**AI Response**: "<response or action taken>"
**Context**: <stage, action, decision>

---
```

Other entry types:
- **Gate entries** use `**AI Prompt**`, `**User Response**` and `**Status**: Approved | Changes Requested`.
- **Change requests** use the heading `## Change Request - <Stage>`, with these fields: Request, Current State, Impact Assessment, User Confirmation, Action Taken, Artifacts Affected.
- **Waivers** (a BLOCK risk or a validation rule the user chose to keep) use `## Waiver - <rule>`, with these fields: Who approved, Reason, Expiry.

History stays append-only: answers, audit entries, archive. Current-state docs (requirements, designs, state) are edited in place. A deferred requirement ID is never reused.

## Resuming a session
1. Read `aidlc-state.md`, `memory.md`, and the tail of `audit.md`.
2. Show a welcome-back summary (project, phase, stage, last step, next step).
   - **If the current stage is `[?]`** (waiting at a gate with no logged reply), present that gate again. A vague "continue" is **not** approval of it.
   - **Otherwise,** ask: A continue / B review an earlier stage / X other.
3. **Load the summaries first.** Read the `## Summary` and `## Decisions Summary` sections of upstream artifacts. Open full files only for the stage being generated.

| Next stage | Load |
|---|---|
| Requirements / Stories | reverse-engineering summaries, requirements, answered question files |
| Workflow Planning / App Design / Units | the above plus stories |
| Per-unit design | requirements, stories, unit-of-work, `standards/`, this unit's design, its dependencies' design |
| Code Generation | the unit's design, its code plan, `standards/`, the existing code it touches |
| Build and Test / Operations | code summaries, build-and-test artifacts |

4. **Keep / Modify / Redo.** When a stage's outputs already exist, list them and ask:
   - Keep: go straight to the gate
   - Modify: edit the files in place
   - Redo: archive them, then start fresh

   Recommend one, with a reason. Skip the question if the user already said which.
5. Say in one line what you loaded, and log the resume.

## After context compaction or a long session
Recover in this order:
1. the anchor block in CLAUDE.md or AGENTS.md
2. `aidlc-state.md`
3. `memory.md`
4. the current phase skill
5. the current stage's inputs

Watch for drift. Signs include:
- skipped gates
- auto-filled answers
- forgotten audit entries
- writing artifacts without re-reading the template

If you spot any of them, stop, say so, and correct it. A fresh session plus resume is cheap. Suggest one between phases or between Units when the user wants it, or when the tool reports high context use. Don't suggest it just because the session feels long.

## Recovery
- **State file missing or corrupt** ("repair"):
  1. Back it up as `.bak`.
  2. Rebuild progress from the artifacts on disk. Treat an existing artifact as done.
  3. Set the current stage to the first one that has no evidence.
  4. Ask the user to confirm.
- **Artifact missing.** If its stage was skipped by design, that's not an error: use the fallback. If its stage is marked done, offer to re-run it or restore the file from git, with a recommendation.
- **Error severity:**
  - Critical/High: stop and ask.
  - Medium: try to resolve, then ask.
  - Low: fix it and log it.
- **The user owns their original documents.** Never delete or overwrite them. Convert them into new files.
