# Scenario 02: a feature with a one-way-door decision

**Setup:** an empty folder (greenfield).

**Prompt:** "Using AI-DLC, build an internal tool where employees submit ideas and managers approve them."

**Human script:**
- Answer "accept recommendations" to the first question file.
- Later, approve each gate.

## Expected stops
1. The requirements question file. When the user says "accept recommendations", the agent applies them **only to the two-way-door questions**. It re-asks the one-way-door questions (data store, approval model).
2. The conflict check runs. For example, RQ-6 fires if the request named a technology.
3. A summary confirmation, then the Requirements gate.
4. User Stories plan approval, then the Stories gate.
5. Workflow Planning gate, offering 3 options (Request Changes / Add Skipped Stages / Approve).

## Expected artifacts
- `requirements.md`: FR lines carry source tags; Success Measures has baseline, target and date; assumptions are labelled.
- `stories.md`: ACs numbered like `AC1.1.1`, plus an FR → Story coverage table.
- `execution-plan.md`: a Mermaid diagram with a text fallback.

## Must not happen
- An assumption turns into a requirement without being confirmed.
- Approval carried from one gate to the next.
