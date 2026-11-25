# Scenario 01: bugfix on an existing codebase

**Setup:** a small existing repo, e.g. an Express or FastAPI app with tests, that has an off-by-one bug in pagination.

**Prompt:** "Using AI-DLC, fix: page 2 of /items repeats the last item of page 1."

**Human script:**
- Answer the questions with the recommended options.
- Approve each gate.

## Expected stops
1. A short question file, or a question tool batch with at most 4 options per question. The agent ends its turn.
2. A Requirements gate (minimal depth). The agent ends its turn.
3. A code-plan approval. The plan starts with a **regression test at the narrowest level that reproduces the bug**. The agent ends its turn.
4. A Code Generation gate. The reviewer ran the tests.
5. A Build & Test gate.

## Expected artifacts
- `aidlc-docs/aidlc-state.md` (profile: bugfix) and `audit.md`, with verbatim inputs
- `inception/reverse-engineering/`, scoped to the pagination module (not the whole repo)
- `construction/code-generation/plan.md`, with Summary lines (Builds / Touches / Tests)
- `build-and-test-summary.md`, with a Target Verification Matrix

## Must not happen
- README edited
- A test threshold or assertion loosened
- Any code written before plan approval
