# Scenario 04: resume and repair

**Setup:** a repo with `aidlc-docs/` from an earlier run. The state file says "Units Generation [?] awaiting approval". `unit-of-work.md` exists.

**Prompt (session A):** "continue"

## Expected
- The agent shows a welcome-back summary (phase, stage, last step, next step) and asks continue / review / other.
- It loads summaries, not whole files. It asks **Keep / Modify / Redo** for the existing `unit-of-work.md`.

**Prompt (session B, after deleting `aidlc-state.md`):** "AI-DLC status"

## Expected
- The agent notices the state is missing and offers **repair**.
- It rebuilds progress from the artifacts on disk, backing up first, and asks for confirmation before it continues.
