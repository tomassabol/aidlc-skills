---
name: ai-dlc-discovery
description: Optional AI-DLC step before Inception that decides WHETHER and WHAT to build. It turns signals (customer feedback, tickets, usage data, a feature request) into evidence-labelled problems, scores them with weights fixed in advance, writes a short PR/FAQ, checks the four product risks with a pre-mortem, and ends in commit / pivot / park. The output is a discovery brief that ai-dlc-inception uses as its Intent. Use when the user wants to validate an idea, prioritise feature requests, run product discovery or "working backwards", write a PR/FAQ, or when an AI-DLC Intent is vague and about a new product or feature. Do not use when the problem and solution are already agreed; go to Inception.
---

# AI-DLC Discovery: should we build it?

Inception assumes the Intent is worth building. Discovery checks that first, cheaply.

It stays deliberately free of architecture. It decides **what problem** to solve and **how we'll know** it worked.

## Inputs and outputs
| | |
|---|---|
| **Inputs** | any of: a feature request, customer feedback, support tickets, interview notes, usage or telemetry data, market notes, existing product docs |
| **Writes** | `aidlc-docs/discovery/`: `signals.md`, `use-cases.md`, `prfaq.md`, `risks.md`, and **`brief.md`** (the handoff) |
| **Hands off to** | `ai-dlc-inception`, which reads `brief.md` as the Intent source |

Use the AI-DLC question-file format for every question, and log inputs in `audit.md` when a workflow is running.

## Shared rules
- **Label every claim:**
  - **Known:** backed by evidence; cite it.
  - **Assumed:** believed, not shown.
  - **Needs evidence:** must be tested.
- **Find facts yourself.** Read the files and data the user gave you before asking them anything.
- **Write problems, not features:** "managers can't see pending approvals", not "add a dashboard".
- **Don't bias the team.** Record what they expect *before* showing your analysis, and give no recommendation on questions about goals or expectations.
- **Anonymise quotes** from customers.

## Steps
1. **Expectations first** (one short question file):
   - What does the team expect to find?
   - What's the business metric, and which direction is better?
   - Who owns the decision?

   Record the answers before any analysis.
2. **Signals.** Read the inputs and cluster them into themes. Write `signals.md`:
   - themes, each with its frequency, quotes and source
   - a **say vs do** table, if usage data exists
   - testable hypotheses
3. **Use cases and scoring.** See [references/scoring.md](references/scoring.md).
   1. Write the candidates as problems.
   2. Put each through the 5-point entry gate.
   3. **Fix the weights before scoring.**
   4. Score each candidate with a confidence rating.
   5. Apply the decision table.

   Only one "build first" per team. Write `use-cases.md`.
4. **Working Backwards** for the top candidate. Write `prfaq.md`:
   - a one-page press release: the customer, the problem, the solution, a quote, how to start
   - an external and internal FAQ
   - a 7-question readiness check rated GREEN, AMBER or RED (in the reference)
   - **the riskiest assumption** called out
5. **Risks and pre-mortem.** Write `risks.md`:
   - **The four risks:** valuable, usable, feasible, viable. For each, give the assumption, the evidence for and against, a verdict, and the cheapest test that would settle it.
   - **Pre-mortem:** "It's 90 days after launch and this failed. Why?" The team names its reasons first; then add yours. Each reason gets an early warning sign and a prevention.
   - If the riskiest assumption is cheap to test, offer an `ai-dlc-spike`.
6. **Decision gate: commit / pivot / park.**
   - **Commit:** list the conditions that must hold before or during the build.
   - **Pivot:** reframe the problem and repeat steps 3 to 5.
   - **Park:** a good outcome. Record why, and what would reopen it.

   Log the decision.
7. **Handoff: write `brief.md`.** Use only the sections below. Refuse to write a partial brief: list what's missing and which step produces it.

```markdown
# Discovery Brief: <name>
## Summary            (≤10 lines)
## Decision           commit | pivot | park, conditions before build
## Problem & evidence (Known / Assumed / Needs evidence; anonymised quotes)
## Personas
## Scored use cases   (table, weights, confidence)
## PR/FAQ summary
## Success criteria   | Metric | Baseline | Target | Check at 30/60/90 days |
## Scope              in / out
## Backlog            P0 / P1 / P2 problems (not solutions)
## Constraints        (business, legal, timeline; no architecture)
## Open hypotheses    → become Assumptions & Open Questions in Inception
## Roadmap            Now / Next / Later (no dates)
## Links              to signals.md, use-cases.md, prfaq.md, risks.md
```

Then offer to start `ai-dlc-inception` with this brief.
