---
name: ai-dlc
description: Run software work through the AI-Driven Development Lifecycle (AI-DLC), where the AI plans, asks and proposes while a human approves every critical decision. Use when the user says "using AI-DLC", "AI-DLC", "aidlc", asks to start or resume an AI-DLC workflow, mentions Intent / Units of Work / Bolts / Mob Elaboration / Mob Construction, or when an aidlc-docs/aidlc-state.md file exists in the repo. This is the entry point. It detects the workspace, sets up state and audit files, picks which phases and stages run, and hands off to ai-dlc-inception, ai-dlc-construction and ai-dlc-operations.
---

# AI-DLC: AI-Driven Development Lifecycle (orchestrator)

AI-DLC is an AI-native way to build software. **The AI drives the workflow and the human approves.** The AI breaks work down, writes plans, asks clarifying questions and proposes options. The human sets the destination, answers questions, and approves or redirects at every gate. Think of it like a navigation app: the human picks where to go, the AI gives turn-by-turn directions, and the human can always change the route.

This skill is the conductor. It owns the workflow loop, the state file, the audit log and the approval gates. The phase skills own the stage details:

| Phase | Answers | Skill | Core ritual |
|---|---|---|---|
| **Inception** | WHAT and WHY | `ai-dlc-inception` | Mob Elaboration |
| **Construction** | HOW | `ai-dlc-construction` | Mob Construction and Mob Testing |
| **Operations** | RUN IT | `ai-dlc-operations` | AI recommends, human decides, AI executes |

If a phase skill is not installed, carry out that phase using the summary in [references/phases-overview.md](references/phases-overview.md).

## The core loop (applies to every stage)

```
Task → Plan → Clarify → Refine → Approve → Execute → Verify
```

1. **Task.** Restate what this stage must produce.
2. **Plan.** Write a plan file with a `- [ ]` checkbox for every step.
3. **Clarify.** Put every open question in a question file. Never decide something critical alone.
4. **Refine.** Fold in the answers. Ask follow-ups until no ambiguity is left.
5. **Approve.** Stop at the gate and wait for explicit human approval.
6. **Execute.** Do the approved plan one step at a time, ticking `[x]` as each step finishes.
7. **Verify.** Check the output against the plan and acceptance criteria, then present the completion gate.

## Non-negotiable rules

1. **Never single-shot a multi-step problem.** Always plan first, then execute in steps.
2. **Human approval is a hard stop.** At a gate, end your turn and make no more tool calls until the user explicitly approves. Never infer approval from silence or vague replies. "Looks good but rename X" counts as approval plus a change: make the change and say what you changed in one line.
3. **Questions go in files, not in chat.** Use the format in [references/question-format.md](references/question-format.md). If the agent has a structured question tool, you may ask through it, but write the answers back into the file. The file is always the source of truth.
4. **Default to asking.** If in doubt, ask. Check every answer for vagueness ("depends", "mix of", "probably", "standard") and contradictions, and follow up before going on.
5. **Documentation lives in `aidlc-docs/`; code never does.** Application code goes in the workspace root, using the existing layout for brownfield projects.
6. **Tick checkboxes in the same turn you finish the work.** This applies to plan files and to the stage list in `aidlc-state.md`.
7. **Log every user input verbatim** in `aidlc-docs/audit.md`, append-only. See [references/state-and-audit.md](references/state-and-audit.md).
8. **Adapt to the work.** A one-line bug fix doesn't need a domain model. Whether a stage runs is a yes/no decision. Depth (Minimal, Standard or Comprehensive) only sets how much detail goes into the artifacts that do get made.
9. **Rein yourself in.** Build what was asked for. Don't add features, layers or patterns nobody approved. If you believe something extra is needed, propose it as a question.
10. **Brownfield files are edited in place.** Never create `foo_new.ts` or `foo_modified.py` copies.

## Starting or resuming

### Step 1: Check for existing state
- If `aidlc-docs/aidlc-state.md` exists, **resume**:
  1. Read the state file and `audit.md`.
  2. Show a short welcome-back summary: project, phase, current stage, last completed step, next step.
  3. Ask (A: continue where we left off, B: review or redo an earlier stage, X: other).
  4. Before continuing, reload the artifacts the next stage needs (see the Resume section of the state reference).
- Otherwise, start a new workflow:
  1. Create `aidlc-docs/` and log the user's request verbatim in `audit.md`.
  2. Show a 5-line welcome explaining the phases and how gates work.

### Step 2: Workspace detection (automatic, no gate)
Scan the repo for source files, build files (`package.json`, `pom.xml`, `pyproject.toml`, `go.mod`, `*.csproj`, IaC, and so on), tests and CI. Record:
- greenfield or brownfield
- languages, build system and structure (monolith, microservices, library or empty)
- workspace root and code-location rules

Create `aidlc-state.md` from the template, print a short "Workspace Detection Complete" summary, and continue straight into Inception.

### Step 3: Classify the intent
Classify the request on four axes and write the result into the state file:
- **Clarity:** clear, vague or incomplete
- **Type:** new project, new feature, enhancement, bug fix, refactor, upgrade, migration or infra
- **Scope:** one file, one component, several components, system-wide or cross-system
- **Complexity:** trivial, simple, moderate or complex

Use the classification to propose a **workflow profile**. The user can override it at any gate.

| Profile | Typical request | Stages |
|---|---|---|
| **express / bugfix** | trivial or simple fix, clear intent | Requirements (minimal) → Workflow Planning → Code Generation → Build & Test |
| **feature** | moderate change to an existing system | + Reverse Engineering (if no current artifacts), User Stories, Functional Design as needed |
| **full** | new product, complex or multi-team work | all Inception stages, all Construction stages per Unit, Operations |
| **refactor / modernize** | legacy change | Reverse Engineering (static and dynamic model) → Requirements → Workflow Planning → per-unit design → Code Generation with A/B comparison → Build & Test |

### Step 4: Run phases through their skills
- Inception: follow `ai-dlc-inception`. It ends with an approved `execution-plan.md` that lists which stages run.
- Construction: follow `ai-dlc-construction`, Unit by Unit, in Bolts.
- Operations: follow `ai-dlc-operations` when deployment, observability or incident work is in scope.

Between phases, run a **verification gate**. Check that:
- every requirement maps to at least one story
- every story maps to a Unit (and, after Construction, to code and tests)
- no artifact is orphaned

Report any gaps before asking to move to the next phase.

## Completion gate format (use it exactly)

At the end of every stage except Workspace Detection:

```markdown
# <emoji> <Stage Name> Complete[ - <unit name>]

- <factual bullet: what was produced>
- <factual bullet: key decisions captured>

| Artifact | Contents |
|---|---|
| aidlc-docs/... | ... |

> **REVIEW REQUIRED:** please review `aidlc-docs/<path>`.

> **WHAT'S NEXT?**
> 🔧 **Request Changes**: tell me what to change
> [📝 **Add <Skipped Stage>**: Inception only, when a stage was skipped]
> ✅ **Approve & Continue**: proceed to <next stage>
```

- In Construction stages, offer exactly two options: **Request Changes** and **Continue to Next Stage**.
- Keep instructions such as "please review" out of the bullet summary.
- Log the gate prompt in `audit.md` **before** asking, and the user's response **after** they reply. Then update the state file.
- If the user asks for changes, update the artifacts and present the gate again.

## Human decision framework

Five decision points decide quality. Use them to judge how much to pause:
1. clarification questions
2. plan approval
3. execution intervention (stop if the plan turns out to be wrong)
4. artifact quality review
5. iterate or call it complete

Separate **one-way doors** (hard to reverse: data models, public APIs, service boundaries, cloud provider, security model) from **two-way doors** (easy to reverse: config format, naming, comment style, folder layout). Ask about one-way doors with care. For two-way doors, propose a sensible default and let the user override it; the 70% rule applies. More in [references/collaboration.md](references/collaboration.md).

## Mid-workflow changes

The user can do any of these at any time:
- add or skip a stage
- restart the current stage or an earlier one (everything downstream is affected)
- change depth
- pause
- change an architectural decision
- add or remove Units

For each one:
1. Assess the impact.
2. Get explicit confirmation.
3. Log a `Change Request - <Stage>` entry in `audit.md`.
4. Update the state file and plans.
5. Archive the affected artifacts instead of silently deleting them.

## References
- [references/question-format.md](references/question-format.md): question file format, validation and clarification files
- [references/state-and-audit.md](references/state-and-audit.md): `aidlc-state.md` and `audit.md` templates, checkbox states, resume rules
- [references/collaboration.md](references/collaboration.md): decision-making at AI speed, mob rituals, roles
- [references/best-practices.md](references/best-practices.md): seven practices that keep AI-DLC from going wrong
- [references/phases-overview.md](references/phases-overview.md): every stage on one page, as a fallback when phase skills aren't installed
