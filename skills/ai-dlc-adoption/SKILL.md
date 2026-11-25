---
name: ai-dlc-adoption
description: Plan, roll out and measure AI-DLC adoption for a team. Covers a readiness assessment (technical readiness, cross-functional co-location, domain knowledge), choosing an implementation mechanism (manual prompts, system prompts/steering rules, MCP servers), running the first Mob Elaboration session, and defining lifecycle metrics (time saved including rework, requirements precision, design stability, code acceptance). Use when a lead or team asks how to introduce or pilot AI-DLC, prepare a mob session, compare AI-DLC with ad hoc AI usage, or measure whether it's working.
---

# AI-DLC adoption: plan, implement, measure

Successful AI-DLC adoption mostly comes down to preparing the foundation, so that the first session is spent solving real problems. It shouldn't go on installing tools or waiting on offline reviews and email chains.

This skill produces an **adoption plan** for a team. Write it to `aidlc-docs/adoption/adoption-plan.md`, or to a path the user names. Use the question-file format from the `ai-dlc` skill for anything you need to ask.

## 1. Readiness assessment
Write a checklist and mark each item ✅, ⚠️ or ❌, with an owner for each gap.

**Technical readiness**
- [ ] AI coding agent installed and licensed for every participant, and tested on the target repo
- [ ] the agent can build and run the tests locally (or in a dev container)
- [ ] repo access, cloud sandbox access and credentials are sorted *before* the session
- [ ] AI-DLC rules/skills installed (`npx skills add <this repo>`), and a dry run done on a toy Intent
- [ ] a shared screen or room set up for mob sessions

**Cross-functional co-location**
- [ ] product owner, developers, QA, and (as needed) security, ops and UX are **in the session at the same time**, physically or virtually
- [ ] decision-makers are present, or have delegated authority, so the five critical decision points don't wait on email
- [ ] a facilitator is named, to keep the mob to time-boxes and run the one-way/two-way door calls

**Domain knowledge**
- [ ] the domain experts are identified, and niche knowledge gaps listed (regulations, legacy quirks, integrations)
- [ ] the existing docs, tickets and architecture notes are gathered as input for Inception
- [ ] brownfield: the legacy system's owners are available to validate the reverse-engineered static and dynamic models

## 2. Choose an implementation mechanism

| Mechanism | What it is | Best for | Trade-off |
|---|---|---|---|
| **Manual prompts** | people paste AI-DLC prompt templates per stage | trying it out, workshops, maximum flexibility | inconsistent; depends on individual discipline |
| **System prompts / steering rules / skills** | rules loaded automatically (CLAUDE.md, AGENTS.md, Kiro steering, these skills) | team-wide consistency with little setup | rules can drift per repo; enforcement is advisory |
| **Skills + harness hooks** | the skills, plus agent hooks that enforce gates: e.g. a stop-hook that refuses to end a turn past an unapproved gate, a pre-tool hook that blocks writes to secret files, and a tool-call audit log | teams that want enforcement without running an engine | specific to one agent harness; hooks need setup and upkeep |
| **MCP servers / workflow engine** | programmatic orchestration, with state, gates and audit enforced by tools. The official example is the engine in `awslabs/aidlc-workflows` (installed with the `aidlc` CLI; runs on Claude Code, Kiro, Codex, Cursor and Copilot) | regulated environments, many teams, maximum consistency | most technical setup and maintenance |

Recommend one with a one-paragraph rationale. Most teams start with **skills or system prompts** and add hooks or an engine once the process has settled. These skills are the lightweight tier: plain markdown, modelled on the original AI-DLC rules plus selected ideas from the newer engine.

## 3. Pilot plan
1. **Pick the pilot Intent.** It should be real, of moderate complexity, with a cooperative product owner and clear success measures. Avoid both a trivial demo and a mission-critical deadline.
2. **Mob Elaboration session** (2 to 4 hours, time-boxed):
   - the PO presents the Intent
   - the AI writes requirements questions, and the mob answers them live
   - the AI proposes stories and Units, and the mob validates them
   - the session ends with approved Units
3. **Construction Bolts.** The first Bolt is a walking skeleton. Hold a short Mob Construction for design approvals and code-plan approvals, and Mob Testing on failures.
4. **Retrospective.** Run it after the first Units ship: what slowed decisions, which questions were missing, and which rules to change.

Add a calendar sketch, attendee list and agenda to the plan.

## 4. Measurement
AI-DLC can take **slightly longer up front** than ad hoc AI use. Its payoff shows when you measure the **whole lifecycle, including rework**. Measure a comparable baseline before the pilot.

**Time saved**, measured end to end:
- requirements and stories: time from Intent to approved stories
- design: time to approved design and ADRs
- development: time to merged code, **including rework and revision cycles**
- total cycle time from Intent to production

**Accuracy and quality**
- **Requirements precision:** the share of stories that needed no change after Inception
- **Design stability:** the number of design changes after approval
- **Code acceptance rate:** the share of AI-generated code accepted without major rewrite, plus review revision cycles
- **Defects:** escaped defects per Unit, and test pass rate on the first Build & Test

**Alignment**
- number of clarification meetings needed after Inception (target: zero)
- team survey on shared understanding

**Process conformance** (is the method actually being followed?)
- **Gates honoured:** the share of gates with a logged prompt and an explicit approval in `audit.md`. Look for skipped or inferred approvals.
- **Questions answered by humans vs auto-filled.**
- **Plan drift:** files in diffs that weren't in the approved plan.
- **Eval runs:** re-run the scenarios in the skills repo's `evals/` folder after changing rules or skills, and check that the expected stops and artifacts still happen.

Expect the quality metrics to **improve over time** as teams master the workflow and give better context. Report trends, not single data points. Review them at each retro, and append the lessons to `aidlc-docs/memory.md` as ALWAYS, NEVER or PREFER rules, or turn them into rule or skill updates.

## Output
The adoption plan should contain:
1. readiness checklist with owners
2. chosen mechanism and rationale
3. pilot Intent and session plan
4. metric definitions, baseline, and collection method
5. risks and mitigations
6. a 30/60/90-day rollout outline

Present it with a review gate (Request Changes / Approve).
