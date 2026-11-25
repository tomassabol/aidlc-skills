---
name: ai-dlc-spike
description: Time-boxed AI-DLC spike or throwaway prototype that tests the riskiest assumption before committing to requirements or design. Examples are whether a library or API works the way we think, whether a pattern can be implemented cleanly, whether a flow makes sense to users, or whether performance is in range. Code lives outside the source tree and is never shipped; the output is findings plus suggested requirement or design changes. Use when the user asks for a spike, prototype, proof of concept or quick experiment within AI-DLC, or chooses "Spike" at an Inception or design gate, or a Bolt has type spike. Do not use to build production features.
---

# AI-DLC Spike

A spike buys **learning, not code.** Use one when an assumption is risky enough that being wrong would change requirements, design or the plan.

## Inputs and outputs
| | |
|---|---|
| **Inputs** | the question or assumption to test; optionally the requirements, stories or design that depend on it |
| **Writes** | spike code in `spikes/<slug>/` at the workspace root, outside `src/`; findings in `aidlc-docs/spikes/<slug>.md` (or `aidlc-docs/inception/spikes/` during Inception) |
| **Never** | touches the source tree, the phase state checkboxes, or production config; gets merged into the build |

## Steps
1. **Frame it:**
   - **Assumption:** "We believe X."
   - **Test:** "We'll know by Y."
   - **Success signal:** what result confirms it, and what refutes it.
   - **Time box:** a stated limit, e.g. 30 to 60 minutes of agent time, or a fixed number of attempts.
   - **Scope:** at most 3 to 5 stories, or one technical question.

   Confirm the frame with the user before writing anything (a small question file, or one question).
2. **Build the smallest thing that answers the question,** in `spikes/<slug>/`.
   - Hardcoded data is fine.
   - Skip architecture, auth, error handling and full tests, unless they *are* the question.
   - Add a `README.md` that says how to run it and **what is faked**.
   - **UX spikes:** aim the prototype at the riskiest moment, and mark that screen as the "test moment". Never overwrite a version; add v2, v3, and so on, with one line on why each changed.
3. **Run it** and record what actually happened: outputs, timings, errors. Quote the evidence.
4. **Write `aidlc-docs/spikes/<slug>.md`:**

```markdown
# Spike: <slug>
## Summary
Verdict: CONFIRMED | REFUTED | INCONCLUSIVE, <one line>
## Assumption / test / success signal / time box
## What we built (and what was faked)
## Evidence
## Discoveries
## Suggested changes
| Artifact | Change | Why |
|---|---|---|
| requirements.md NFR2 | p95 500 ms → 800 ms, or add caching | vendor API p95 measured at 640 ms |
## New questions / Needs-evidence items
- <capability the prototype implied but nobody confirmed>
```

5. **Gate.** Present the verdict and the suggested changes. Offer:
   - 📝 **Apply suggested changes:** back up the affected artifacts first, then update them through the normal change-request flow
   - ✅ **Proceed unchanged**
   - 🗑️ **Discard spike**

   Log the decision in `audit.md` if an AI-DLC workflow is running.

## Rules
- **The time box is a hard limit.** When it runs out, stop and report what you know.
- Spike code is **never** copied into the source tree. If the approach works, the real implementation goes through a normal Code Generation plan.
- Anything the prototype promised but didn't verify (a vendor capability, data you're allowed to use, performance at scale) becomes a **Needs evidence** item. It never becomes a silent design assumption.
