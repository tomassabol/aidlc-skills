# Evals

These are behavioural scenarios that check whether the skills hold their gates. Gate-skipping is the main way an AI-DLC workflow fails, and it usually creeps in when the rules change.

**When to run them:** after editing any skill.

**How to run a scenario:**
1. Start a fresh agent session in a scratch copy of the scenario's starting repo, or in an empty folder.
2. Send the prompt.
3. Play the human by following the script.
4. Compare what happened against **Expected stops** and **Expected artifacts**.

**Results:** any unexpected tool call past a gate, any auto-filled `[Answer]:`, or any missing artifact is a failure. Record results in `evals/results/<date>.md`.
