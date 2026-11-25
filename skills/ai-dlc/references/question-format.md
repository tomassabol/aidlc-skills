# Question files

In AI-DLC the AI asks and the human decides. Questions live in markdown files so the answers survive across sessions and become part of the project's context memory.

## Before asking
- **Look it up first.** Never ask about something you can read in the repo, the docs, the earlier question files, or `memory.md` (especially `## Decided`). Use subagents to search when they're available.
- **Order by dependency.** If question B depends on the answer to A, ask A in this round and B in the next.
- **Never re-ask** a question that was skipped or already answered. Carry a skipped question forward as an open item.

## Where questions live
- **Stage questions:** `aidlc-docs/<phase>/<area>/<stage>-questions.md`.
- **Plan questions:** embedded in the stage's `*-plan.md`, next to the step they affect.
- **Follow-ups:** `<stage>-clarification-questions.md`, in the same folder.

## Format

```markdown
# <Stage> Questions

> Fill in a letter after each `[Answer]:` (X = other, then describe), or say "guide me".
> Questions marked *two-way door* can be answered in bulk with "accept recommendations".

## Q1. [product] Who approves submitted ideas?
Context: decides personas, permissions and the approval workflow. *One-way door.*

A) A fixed committee

B) Line manager first, then the committee

C) Configurable chains per department

X) Other (please describe after [Answer]: below)

Recommended: B, because it matches the org chart in docs/org.md.

[Answer]:

## Decisions Summary
<!-- filled in by the AI after validation: one line per decision -->
- Q1: B, line manager then committee
```

Rules:
- **2 to 4 meaningful, mutually exclusive options,** plus **X) Other**, always last. Never add filler options. The limit of 4 lets every question go through Claude Code's `AskUserQuestion` tool.
- **Blank lines between options,** so markdown renderers don't merge them.
- **Tag each question with the role** best placed to answer it: `[product]`, `[dev]`, `[qa]`, `[ops]`, `[security]`, `[ux]`. Group questions by role.
- **One line of context** per question. Also mark the question *one-way door* or *two-way door*.
- **A `Recommended:` line** with a one-line reason. Leave it out where it would bias the answer, for example on goals, expectations or priorities.
- **Write identifiers in full** ("FR1 Submit idea", not "FR1").
- **If the team's documents already answer things,** start the file with "Q0. Taken from your documents. Please confirm". List each answer with its document and a short quote.
- **Fill in `## Decisions Summary` after validation.** Downstream stages read only this section.

## How many questions
| Depth | Per stage |
|---|---|
| Minimal | 2 to 4 |
| Standard | 5 to 8 |
| Comprehensive | 8 to 12+ |

## Hand-off message
After writing the file, tell the user:
- the file path
- how many questions it has
- the three ways to answer (below)

Then **stop and wait**.

1. **Edit the file,** then say "done".
2. **Guide me:** you ask the questions in chat or through a question tool, in batches, and write each answer back into the file **after every batch**.
3. **Chat freely:** you pull the decisions out of the conversation into the file, and show the result for confirmation.

### Rendering with a question tool (e.g. Claude Code `AskUserQuestion`)
- **Limits:** at most 4 questions per call, and 2 to 4 options per question. Never make a one-option call.
- **Don't add "Other" as an option.** The tool supplies its own free-text row. Before the first batch, tell the user they can pick it to answer in their own words.
- **An empty free-text pick is not an answer.** Discuss, then ask again.
- **A question with more options than the tool allows** goes in chat as one numbered list. End it with "Reply like `Q1: 2`, or just tell me".
- **Put the role tag in front of the question text.** Record the chosen label verbatim in the file.
- **Never print the raw question spec.**

## Bulk acceptance
- **"Accept recommendations"** applies only to *two-way-door* questions in the current file. One-way-door questions still need an explicit answer.
- **"Yes, except Q3: C"** is fine.
- **Log bulk acceptance** in `audit.md`, and list back what was accepted.

## Validating answers
When the user says done:
1. **Missing:** list the question numbers that have no answer.
2. **Invalid:** a letter that isn't one of the options. Ask again.
3. **Prose instead of a letter:** map it to the closest option and confirm, or treat it as X.
4. **Vague:** words such as "mix of", "somewhere between", "depends", "maybe", "probably", "not sure", "standard" or "typical". Write a follow-up.
5. **Contradictions:** scope, risk, timeline or impact clashes between answers.
6. **Conflict rules:** apply this stage's table in [decision-validation-rules.md](decision-validation-rules.md). Present conflicts grouped by severity. Each one offers resolution options, including "keep, with justification". If the user says "skip validation", log it in `audit.md` with a warning.

If anything turns up, write `<stage>-clarification-questions.md`. Each entry names the conflict, cites the original questions (e.g. "Q1:A vs Q4:C"), and asks one targeted multiple-choice question. Don't continue until it's resolved, unless the user explicitly says to proceed on stated assumptions. If they do, record those assumptions.

## Summary confirmation (Standard and Comprehensive depth)
Before generating the stage's artifact:
1. Show the decisions as short bullets and ask **Looks correct** / **Request changes**.
2. Append `## Consolidated Summary Confirmation` with `[Answer]:` to the question file.
3. If the user requests changes, fix the affected answers and show the summary again.

This catches a misread answer before a long artifact is written.
