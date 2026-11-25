---
name: ai-dlc
description: Run software work through the AI-Driven Development Lifecycle (AI-DLC), where the AI plans, asks and proposes and a human approves every critical decision. Use when the user says "using AI-DLC", "AI-DLC" or "aidlc", asks to start, resume, check status of or repair an AI-DLC workflow, mentions Intent / Units of Work / Bolts / Mob Elaboration, or when aidlc-docs/aidlc-state.md exists in the repo. This is the entry point. It detects the workspace, keeps state, audit and memory files, picks the workflow profile, runs approval gates, and hands off to the phase skills. Do not use for ordinary coding requests that don't mention AI-DLC and have no aidlc-docs/ folder.
---

# AI-DLC: AI-Driven Development Lifecycle (orchestrator)

AI-DLC is an AI-native way to build software. **The AI drives the workflow and the human approves.** The AI breaks the work down, writes plans, asks questions and proposes options. The human sets the destination, answers the questions, and approves or redirects at every gate.

This skill is the conductor. It owns:
- the workflow loop
- `aidlc-docs/aidlc-state.md` (state)
- `aidlc-docs/audit.md` (audit log)
- `aidlc-docs/memory.md` (project rules)
- the approval gates

The phase skills own the stage details:

| Phase | Answers | Skill | Ritual |
|---|---|---|---|
| (optional) Discovery | SHOULD we build it? | `ai-dlc-discovery` | evidence and scoring |
| **Inception** | WHAT and WHY | `ai-dlc-inception` | Mob Elaboration |
| **Construction** | HOW | `ai-dlc-construction` | Mob Construction and Mob Testing |
| **Operations** | RUN IT | `ai-dlc-operations` | AI recommends, human decides, AI executes |
| any time | review | `ai-dlc-review`, `ai-dlc-spike` | independent review, throwaway prototype |

If a phase skill isn't installed, carry out that phase from [references/phases-overview.md](references/phases-overview.md).

## The core loop (every stage)

```
Task → Plan → Clarify → Refine → Approve → Execute → Review → Verify (gate)
```
1. **Task.** Restate what this stage must produce, in one sentence.
2. **Plan.** Write a plan file with a `- [ ]` checkbox for every step.
3. **Clarify.** Put open questions in a question file ([references/question-format.md](references/question-format.md)). Look things up in the repo before asking anything you could read yourself.
4. **Refine.**
   - Validate the answers against the conflict rules ([references/decision-validation-rules.md](references/decision-validation-rules.md)).
   - At Standard or Comprehensive depth, confirm a short summary of the answers before you generate anything.
5. **Approve.** Stop at the plan gate.
6. **Execute.** Work one step at a time and tick `[x]` as you go. Re-read the artifact's template from disk; never write it from memory.
7. **Review.** Get an independent check before the gate ([references/reviewer.md](references/reviewer.md)).
8. **Verify.** Present the completion gate.

## Non-negotiable rules

1. **Never single-shot a multi-step problem.** Plan first, then execute in steps.
2. **Human approval is a hard stop.**
   - At a gate, end your turn and make no more tool calls until the user explicitly approves. Never infer approval.
   - Autonomy and "use your recommendations" apply only to the stage where they were given. Never carry them forward.
   - How to read replies:
     - **"Looks good, but rename X"** is approval plus a change. Make the change and say what you changed in one line.
     - **A request with no approval in it** ("from now on, one unit at a time"): do it, confirm it in one line, and keep the gate open.
     - **A question:** answer it and end the turn.
     - **"Up to you":** choose. Log it as "chosen on the user's instruction" and tell them what you chose.
3. **Questions go in files.** The file is the source of truth, even when you ask through a question tool.
4. **Default to asking on one-way doors** (hard to reverse). On two-way doors, propose a default the user can override.
5. **Never weaken a quality target to make something pass.** Don't lower an NFR, a coverage floor, a timeout or a lint rule. Surface the gap instead.
6. **Assumptions stay assumptions.** A later stage never upgrades an assumption, open question or unselected option into a requirement. To use one, ask.
7. **Docs go in `aidlc-docs/`, code never does.** Code goes in the workspace, using the existing layout for brownfield work. Edit brownfield files in place; never create `*_new` copies.
8. **Leave user-owned files alone.** Don't touch README, LICENSE, existing docs or config the work didn't create, unless the user asks or the build can't work without the change.
9. **Tick checkboxes in the same turn you finish the work.**
10. **Log every user input verbatim** in `audit.md`, append-only ([references/state-and-audit.md](references/state-and-audit.md)).
11. **Adapt to the work.** Whether a stage runs is a yes/no decision. Depth sets how much detail goes into the artifacts.
12. **Rein yourself in.** Every plan step, component and data-model element traces to a requirement, story, business rule or approved NFR, or is labelled `scaffold`. List anything else as "Proposed extras (not approved)".
13. **Every artifact opens with a `## Summary` of 10 lines or fewer.** Later stages and resume read the summaries first, and open full files only when generating from them.

## Starting, resuming, status, repair

### Step 1: Load context
- **Resume.** If `aidlc-docs/aidlc-state.md` exists:
  1. Read it, `memory.md`, and the tail of `audit.md`.
  2. Show the welcome-back summary.
  3. Ask: continue / review an earlier stage / other.
  4. Follow the resume rules in the state reference: load summaries first, and ask Keep / Modify / Redo when a stage's outputs already exist.
- **"Status".** Print the phase, the stage, a stage checklist with markers, and open questions. Change nothing.
- **"Repair".** The state file is missing or doesn't match the files on disk: follow the Recovery section of the state reference.
- **New workflow:**
  1. Create `aidlc-docs/` and log the request verbatim.
  2. Create `memory.md` if it doesn't exist.
  3. Restate the request in one sentence.

### Step 2: Workspace detection (automatic, no gate)
1. Scan for source, build, test, CI and IaC files.
2. Record greenfield or brownfield, the languages, the build system, the structure and the workspace root.
3. If the project has a CLAUDE.md, AGENTS.md or team rules, read them. Their rules win over these defaults.
4. Write `aidlc-state.md` and continue.
5. **Optional, ask once:** offer to add a 6-line AI-DLC anchor block to the project's CLAUDE.md or AGENTS.md, so the hard-stop rules survive long sessions. This changes a persistent file, so write it only on a yes:

```markdown
## AI-DLC
- Workflow state: aidlc-docs/aidlc-state.md; project rules: aidlc-docs/memory.md (always load).
- Approval gates are hard stops; never infer approval; never auto-answer question files.
- Questions go in files with [Answer]: tags; docs in aidlc-docs/, code never there.
- Never relax a quality target to pass; never promote an assumption to a requirement.
- If you notice you skipped a gate: stop, say so, and present it now.
- Resume via the ai-dlc skill.
```

### Step 3: Classify and pick a profile
Classify the request on four axes:
- **clarity:** clear, vague or incomplete
- **type**
- **scope**
- **complexity**

Then pick three settings, and record them all in the state file:
- **Depth:** Minimal, Standard or Comprehensive.
- **Test strategy:** Minimal, Standard or Comprehensive. It defaults to the depth level. Volumes are defined in the `ai-dlc-construction` skill.
- **Profile:** propose one from the table below. The user can override it at any gate.

| Profile | Use for | Stages |
|---|---|---|
| **trivial** | typo, config value, one-line fix; the user explicitly accepts the fast path | one plan line, then the change, then run the existing tests. **One gate, on the diff.** One audit entry. No question files. |
| **bugfix** | a defect with a clear reproduction | Reverse Engineering, scoped to the touched area (brownfield) → Requirements (minimal) → Code Generation, starting with a regression test at the narrowest level that reproduces the bug → Build & Test |
| **security-patch** | a CVE or dependency bump | scoped Reverse Engineering → Requirements (minimal) → Code Generation → Build & Test, with the security extension on |
| **feature** | a moderate change to an existing system | Reverse Engineering (if artifacts are missing or stale) → Requirements → Stories → Workflow Planning → per-unit design as needed → Code → Build & Test |
| **full** | a new product, or complex or multi-team work | every Inception stage, every Construction stage per Unit, then Operations |
| **refactor** | modernizing legacy code | Reverse Engineering (static and dynamic models) → Requirements → Workflow Planning → design → Code with A/B equivalence → Build & Test |
| **infra** | IaC, platform or pipeline work | Requirements → Infrastructure Design → Code (IaC) → Build & Test (plan/validate) → Deployment |

- If **clarity is vague** and the type is a new product or feature, offer `ai-dlc-discovery` first.
- **Trivial** and "no plan approval" happen only when the user explicitly accepts them. Never infer them.

### Step 4: Run the phases
Run Inception, then Construction, then Operations through their skills.

At each phase boundary, run the **verification gate**:
1. Write `aidlc-docs/verification/phase-check-<phase>.md`, with a coverage table using the statuses OK, GAP, ORPHAN, Deferred and N/A.
2. Any GAP or ORPHAN blocks the transition until it is fixed, or the user explicitly marks it Deferred.

### Extensions (opt-in)
Security baseline, resiliency and property-based testing are optional rule packs ([references/extensions.md](references/extensions.md)).
- Ask their opt-in questions during Requirements.
- Record the choices under `## Extension Configuration` in the state file.
- An enabled rule that is violated is a **blocking finding**.

## Completion gate format

```markdown
# <emoji> <Stage> Complete[ - <unit>]

## Summary
- <factual: what was produced>
- <factual: key decisions>

| Artifact | Contents |
|---|---|
| aidlc-docs/... | ... |

Review: READY | NOT-READY, N open findings (aidlc-docs/.../reviews/...)
[Extensions: SECURITY-03 compliant, ... | n/a]

> **REVIEW REQUIRED:** `aidlc-docs/<path>`

> **WHAT'S NEXT?**
> 🔧 **Request Changes**
> [📝 **Add <Skipped Stage>**: Inception only]
> ✅ **Approve & Continue**: proceed to <next stage>
```

- **Construction** gates offer exactly two options: Request Changes / Continue to Next Stage.
- **After two revision cycles,** also offer **Accept as-is**.
- **The first gate of a session** also states the depth and test strategy, and says both can be changed at any gate.
- **Logging:** log the gate prompt before asking, and the reply after it. Then update the state file.
- **Learnings, in a separate turn before the gate.** If the user corrected you during the stage and the correction generalises, ask once: "Keep that for next time?" Offer:
  - this project (`aidlc-docs/memory.md`)
  - the whole repo (CLAUDE.md or AGENTS.md)
  - no

  Anything said as "from now on…" is saved without asking. Tell the user where you put it.

## Talking to the user
- **At gates,** say three things: what was produced, which file to look at, and what happens after approval.
- **Between steps,** stay quiet. Don't narrate the machinery or use internal jargon.
- **Errors:** one plain sentence, then the exact command or path.
- **Refusals:** one sentence on what was declined, and one on what the user can do.
- Reply in the user's language, but keep IDs, paths and method terms in English.

## Human decision framework
There are five decision points:
1. clarification questions
2. plan approval
3. execution intervention
4. artifact quality
5. iterate vs complete

Separate **one-way doors** from **two-way doors** ([references/collaboration.md](references/collaboration.md)):
- **One-way doors** (data model, public API, service boundaries, auth model, cloud or vendor choice): give options and trade-offs, and wait.
- **Two-way doors** (naming, config format, folder layout): propose a default and let the user override.

## Mid-workflow changes and recovery
Supported changes:
- add or skip a stage
- restart the current stage, or an earlier one (everything downstream becomes `outdated`)
- change depth or test strategy
- pause
- change an architecture decision
- add, remove or split Units

For each change:
1. Assess the impact and get explicit confirmation.
2. Log `Change Request - <Stage>` in the audit log.
3. Archive the affected artifacts to `aidlc-docs/archive/<date>-<stage>/`.
4. Update the state and plans.

After any approved change, search `aidlc-docs/` for stale values and fix them, with each fix as a ticked plan step.

Other cases:
- **New reference material mid-stage** (a spec, an example repo, sample data) is input for the *current* stage. It is never a reason to skip ahead.
- **Contradictions between stages:** quote both sources and ask. Never pick one silently.
- **Pause:** write a "Paused" note in the state file saying what is in flight, then stop.
- **On resume:** report missing artifacts rather than regenerating them, and continue partial work rather than rewriting it.

## Closing the workflow
When the last selected stage is approved:
1. Write the final phase check.
2. Offer to write **`OUTCOMES.md`** at the workspace root, a handover so the team can own the system. It covers:
   - what was built
   - the repo structure
   - setup
   - build and deploy
   - decisions, with the alternatives that were rejected
   - known limitations and next steps
3. Offer a **replay** on request: a stakeholder narrative printed in chat, built from `audit.md` and the artifacts.

Take every count from the files. Never estimate.

## References
- [question-format.md](references/question-format.md): question files, the question-tool limits, recommendations, validation, summary confirmation
- [decision-validation-rules.md](references/decision-validation-rules.md): named conflict rules per gate, with severities
- [state-and-audit.md](references/state-and-audit.md): state, audit and memory templates, markers, resume, recovery
- [reviewer.md](references/reviewer.md): independent pre-gate review
- [extensions.md](references/extensions.md): opt-in security, resiliency and property-based-testing rules
- [collaboration.md](references/collaboration.md): decision-making at AI speed, mob rituals, roles
- [best-practices.md](references/best-practices.md): seven practices, context hygiene, content validation
- [phases-overview.md](references/phases-overview.md): every stage on one page
