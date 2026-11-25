# Question files

In AI-DLC the AI asks and the human decides. All questions go in markdown files so the answers survive across sessions and become part of the project's context memory.

## Where questions live
- **Stage questions:** `aidlc-docs/<phase>/<area>/<stage>-questions.md`, for example `aidlc-docs/inception/requirements/requirement-verification-questions.md`.
- **Plan questions:** embed them directly in the stage's `*-plan.md`, next to the step they affect.
- **Follow-ups:** `<stage>-clarification-questions.md`, in the same folder as the original questions.

## Format

```markdown
# <Stage> Questions

> Fill in a letter after each `[Answer]:`. If none fits, choose X and describe what you want.
> For multi-select questions, list letters separated by commas (e.g. `A, C`).

## Q1. [product] Who are the primary users of the approval flow?
Context: decides the personas, and so the stories and the permission model.

A) Employees only, with a fixed approval committee

B) Employees and line managers, where managers approve first

C) Configurable approval chains per department

X) Other (please describe after [Answer]: below)

[Answer]:
```

Rules:
- Give **2 to 5 meaningful, mutually exclusive options**, with **X) Other** always last. Never add filler options.
- Leave a blank line between options so markdown renderers don't merge them.
- Tag each question with the role best placed to answer it, such as `[product]`, `[dev]`, `[qa]`, `[ops]` or `[security]`, and group questions by role. This lets a mob session hand the right questions to the right person.
- Give each question one line of context explaining why the answer matters.
- Write identifiers in full ("FR-3 Submit idea", not "FR3").
- Never ask again about something already answered in any earlier question file. Read those files first.
- If the user supplied documents, you may start with "Q0. Answers taken from your documents. Please confirm (A: correct, B: corrections below)".

## How many questions
| Depth | Per stage |
|---|---|
| Minimal | 2 to 4 |
| Standard | 5 to 8 |
| Comprehensive | 8 to 12+ |

Inception asks the most. Construction asks only about real gaps.

## Hand-off message
After writing the file, tell the user:
- the file path
- the number of questions
- how to answer: fill in letters, or say "guide me" to answer one by one in chat
- to say "done" when finished

Then **stop and wait**.

Three ways to answer, with the file as the source of truth in all of them:
1. **Edit the file**, then say "done".
2. **Guide me:** ask the questions in chat in small batches (or with a structured question tool) and write each answer into the file.
3. **Chat freely:** pull the decisions out of the conversation and write them into the file. Show the result for confirmation.

## Validating answers
When the user says done:
1. **Missing:** list any unanswered question numbers.
2. **Invalid:** a letter that isn't an option. Ask for a valid one.
3. **Prose instead of a letter:** map it to the closest option and confirm, or treat it as X.
4. **Vague:** words such as "mix of", "somewhere between", "depends", "maybe", "probably", "not sure", "standard" or "typical" need a follow-up.
5. **Contradictions:** look for scope, risk, timeline and impact clashes between answers.

If 4 or 5 turns anything up, write `<stage>-clarification-questions.md`. Each entry names the conflict, cites the originals (e.g. "Q1:A vs Q4:C"), and asks one targeted multiple-choice question. Don't proceed until everything is resolved, unless the user explicitly says to proceed with the stated assumptions. If they do, record those assumptions in the artifact.
