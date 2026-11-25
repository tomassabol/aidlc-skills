---
name: ai-dlc-construction
description: AI-DLC Construction phase. Turns approved Units of Work into tested, operations-ready code through Bolts (cycles of hours or days) and Mob Construction. Runs Functional Design, NFR Requirements, NFR Design and Infrastructure Design as needed, then Code Generation from a human-approved plan, then Build & Test with a target verification matrix and a GO/NO-GO report. Use when the user asks to build, implement or code a Unit or story under AI-DLC, start or plan a Bolt, do domain/functional, NFR or infrastructure design, generate code from an approved plan, or run build and test, or when aidlc-state.md shows Construction. Do not use for quick edits outside an AI-DLC workflow.
---

# AI-DLC Construction: HOW

Construction turns validated Units of Work into tested, operations-ready **Deployment Units**: code, configuration, IaC and tests.

It runs in **Bolts**, short cycles measured in **hours or days, not weeks**. The work is **AI-driven and human-validated**:
- **Mob Construction:** the team works on a shared screen. The AI proposes and humans validate.
- **Mob Testing:** the team analyses failures together.

## Inputs and outputs
| | |
|---|---|
| **Required** | the requirements, plus either the stories or a clear task description |
| **Optional** | `unit-of-work*.md`, `execution-plan.md`, `standards/`, reverse-engineering artifacts, `memory.md` |
| **Writes** | `aidlc-docs/construction/**`, code and tests in the workspace, `standards/decisions-index.md`, `verification/phase-check-construction.md` |
| **Hands off to** | `ai-dlc-operations`, when the Summary Report says GO |

**Running without the orchestrator or Inception:**
- Ask for the requirements or story, or point at a ticket, in a short question file.
- Treat the whole change as **one zero-unit scope**: run Code Generation once under `construction/code-generation/`.
- Create the state and audit files lazily, the first time you need them.

## Shared rules (full versions in the `ai-dlc` skill)
- Docs go in `aidlc-docs/construction/`. **Code never goes in `aidlc-docs/`.** Brownfield files are edited in place.
- Questions go in files. Plan, then approval, then execute, ticking `[x]` in the same turn. Log every user input verbatim.
- Load `memory.md` and `standards/` for every unit. Use the `## Summary` sections of upstream artifacts. Open full files only when generating.
- **Never weaken a quality target** to get green: no lowering an NFR, coverage floor, timeout, lint rule or test assertion.
- **Leave user-owned files alone:** no README, LICENSE or existing docs unless the user asked.
- Construction gates have **exactly two options**: 🔧 Request Changes / ✅ Continue to Next Stage. They are hard stops.

## Bolts
See [references/bolt-types.md](references/bolt-types.md). At the start of each unit, confirm its Bolts. Each Bolt has:
- **Type:**
  - `simple`: straight to the code plan
  - `ddd`: the needed design stages, then code
  - `spike`: time-boxed learning, no production code
- **Scope:** the stories or tasks it covers.
- **Definition of Done.**
- **Confidence hypothesis:** what shipping it proves or disproves.
- **Verification command:** an exact command scoped to the unit, approved by the human. Never a bare `npm test`.

Bolts can be re-planned (split, appended, reordered) when the human approves. Log the change.

**Walking skeleton.** On a new system, the first unit's first Bolt is the thinnest end-to-end slice.
- It runs through **all** its stages, including Code Generation, before any other unit starts.
- Its verification command must pass, and then a human approves the checkpoint.
- A design review on its own doesn't count as a walking skeleton.

**Autonomy (asked once, after the skeleton):** Review each checkpoint, or Continue automatically.
- **Continue automatically** waives only the ordinary stage-completion gates for later units.
- It **never** waives:
  - code-plan approval
  - summary confirmations
  - the choice of verification command
  - failure decisions
  - anything production-affecting

## Stage sequence (per unit, in dependency order)

```
for each Unit:  [Functional Design] → [NFR Requirements] → [NFR Design] → [Infrastructure Design] → Code Generation
then once:      Build & Test → Summary Report (GO/NO-GO)
```

**Skip stages dynamically.** Use `execution-plan.md`. Without it:
- A simple change or bugfix goes **straight to Code Generation**.
- Add design stages only for new business rules, data models, quality targets or infrastructure.

**Every design stage follows the same shape:**
1. Read the upstream summaries.
2. Write the plan `construction/plans/{unit}-{stage}-plan.md`, with checkboxes and `[Answer]:` questions.
3. Validate the answers: apply the conflict rules and confirm the summary.
4. Generate the artifacts, each opening with a `## Summary`.
5. **Review loop:** an independent reviewer checks the artifacts. Fix the findings, then re-review, **at most 2 rounds**.
6. Present the 2-option gate, with the Review line.

---

## a. Functional Design (the domain model)
Model the business entities, rules and workflows in **technology-agnostic** language.
- **Questions:** entity lifecycles, invariants, rules, state transitions, validation, error cases, edge scenarios.
- **Approach:** DDD tactical patterns where they help: aggregates, entities, value objects, domain events, repositories.
- **Output** in `construction/{unit}/functional-design/`:
  - `domain-entities.md`
  - `business-rules.md`: `BR` IDs, each traced to stories
  - `business-logic-model.md`: state machines in Mermaid, with a text fallback
  - `frontend-components.md`: only if there's a UI
  - **Testable properties**, per rule: round-trip, invariant, idempotence and so on. Required when the PBT extension is on.

Gate: 🔧 **Functional Design Complete - <unit>**

## b. NFR Requirements
Turn the quality attributes into **measurable targets**, and choose the stack.
- **Questions:**
  - performance, scalability, availability and RTO/RPO
  - security and compliance, reliability, maintainability
  - tech stack
  - **three ops questions:**
    - observability level: minimal, standard or full
    - error-tracking approach
    - lifecycle: health only; or health, readiness and graceful shutdown; or all of those plus startup probe and drain
- **Output:**
  - `nfr-requirements.md`
  - `tech-stack-decisions.md`, with a **version map**:

    | Tool | Version | Source | Date | Verified |
    |---|---|---|---|---|

    Look up each tool's current stable or LTS version from its registry. Never write "latest". Avoid major versions under 3 months old. Mark a version unverified if you're offline. Then copy the result into `standards/tech-stack.md`.

Gate: 📊 **NFR Requirements Complete - <unit>**

## c. NFR Design (logical design)
Meet the NFRs with **logical components and patterns**, still provider-neutral: caching, queues, circuit breakers, idempotency, retries, CQRS, authorisation layers.
- Each pattern traces to an NFR and has a **simpler fallback** written down. Prefer the simpler one unless the NFR demands more.
- **Output:** `nfr-design-patterns.md`, `logical-components.md`.

Gate: 🎨 **NFR Design Complete - <unit>**

## d. Infrastructure Design
Map the logical components to **concrete services and deployment architecture**.
- **Questions:** environments, compute, storage, messaging, networking, identity, monitoring, and shared vs per-unit infrastructure.
- Record each significant mapping as an **ADR** (context, options, decision, consequences). Add each ADR to `standards/decisions-index.md` with a "Read when" line.
- **Output:**
  - `infrastructure-design.md`
  - `deployment-architecture.md`
  - `adr/ADR-nnn-*.md`
  - `construction/shared-infrastructure.md`, if any infrastructure is shared

Gate: 🏢 **Infrastructure Design Complete - <unit>**

## e. Code Generation (always)
**No code before a human approves the detailed plan.**

**Part 1: Plan.** Write `construction/plans/{unit}-code-generation-plan.md` from [references/code-generation-plan.md](references/code-generation-plan.md).

- **Summary**, three lines:
  - `Builds:` what this plan builds
  - `Touches:` the main files or folders
  - `Tests:` how many tests, and of what kind
  - add `Adds:` whenever the plan creates data-model elements that no requirement asked for
- **Steps:** numbered checkboxes, each with exact file paths (create or modify) and a `Ref:` (US, AC, BR or NFR), or marked `scaffold`.
- **Name every entity, table, column or field** a step creates or changes. Anything not asked for upstream goes under `## Assumptions`, with the reason it's needed.
- **Tests go in the plan,** never deferred to Build & Test:
  - Put test-runner setup before the first test step.
  - Test volume follows the **test strategy**:
    - Minimal: one test per AC, plus one happy-path test per component
    - Standard: 5 to 8 per component, unit plus key integration
    - Comprehensive: 10 to 15 per component, plus e2e, and performance and security tests if NFRs need them
  - **Floors:**
    - bugfix and security-patch: start with a **regression test at the narrowest level that reproduces the defect**
    - feature and full: 80% line coverage on new code unless the user changes it
  - **Methodology** (`tdd`, `bdd` or `test-after`, from the state file or `standards/`) sets the step order.
- **Traceability, checked both ways:** every AC in scope maps to a step and a test, and every step maps back to a Ref or is marked `scaffold`.
- **Optional execution waves** for big units: group the steps into waves, each owning separate files. Overlapping steps move to the next wave.

Apply the code-plan conflict rules. Summarise the plan in chat, log the prompt, and **stop for explicit approval**.

**Part 2: Generate.**
- **If you can spawn subagents,** delegate each unit, or each wave, to a **fresh** subagent. Give it:
  - this unit's design summaries and plan
  - `standards/` and `memory.md`
  - the test command
  - this instruction: "tick checkboxes as you go; never relax targets; add any new data-model element to the plan first"
- **The loop:**
  1. Take the first `[ ]` step.
  2. Do exactly that step: modify files in place, or create them at the planned path.
  3. Tick `[x]`, and tick each story once its ACs are implemented.
  4. Update the state file.
- **Before the gate:**
  - Run the unit's test command, plus lint and type-check. Fix failures within the plan's scope.
  - Check that no duplicate or `*_new` files exist.
  - Check that the diff contains no unplanned files.
- **The plan proves wrong mid-way:** stop (execution intervention), explain what diverged, and propose a plan update for approval.
- **A step keeps failing,** after at most 2 attempts at the same error: **halt and ask: Retry with change / Skip (mark `[S]` with a reason; dependents wait) / Abort (pause the workflow)**. This applies whatever the autonomy setting.

**Write `construction/{unit}/code/code-summary.md`:**
- a Summary
- files created and modified
- a story → AC → file → test table, with Deferred and N/A rows and their reasons
- how to verify
- accepted risks
- setup notes (instead of editing README)

Gate: 💻 **Code Generation Complete - <unit>**. The reviewer must have run the tests.

## Build & Test (always, once after all units)
Validate the whole system with a **test pyramid**: unit, then integration, then e2e.

1. **Target inventory.** Collect every measurable target from the NFRs and the code plans.
2. **Run** the build, then unit, integration and e2e tests. Add performance and security tests where the NFRs or extensions require them.
3. **Failure ladder:**
   1. **Config, environment or scaffolding problems:** fix them in this stage, at most 2 attempts.
   2. **Classify the root cause:** generated code, or a design choice. Estimate each fix's effort and risk.
   3. **Loop back to Code Generation** for only the affected unit. This needs the human's OK, unless autonomy was granted. At most 3 loop-backs, each recorded in `## Loop-Back Log`.
   4. **Halt and ask.** List every candidate fix with its impact. Giving up is always the human's call.

   **Mob Testing:** group failures by root cause, so each cause is fixed once.
4. **Operational readiness** (advisory):
   - health and readiness endpoints respond
   - a missing required env var exits with a clear message
   - SIGTERM exits cleanly
   - structured logging is used
   - metrics are exposed
5. **Write `construction/build-and-test/`:**
   - instructions: build, unit, integration, e2e, and performance or security when applicable
   - `test-results.md`: build output, counts per level, the Loop-Back Log, and tests written but not run, with the reason
   - **`build-and-test-summary.md`**, the **GO/NO-GO** document for Operations. It contains:
     - **Target Verification Matrix**

       | Target ID | Source | Expected | Actual | Evidence | Verdict |
       |---|---|---|---|---|---|

       The verdict is exactly one of Met, Not Met or Unverified. N/A is allowed only with a reason. Node or jsdom runs count as integration evidence, not browser evidence.
     - **Requirement coverage matrix:** each AC marked Covered, Partial or Not implemented, plus cross-unit handoffs that nobody built.
     - operational-readiness results, known issues, enabled extension compliance
     - **Recommendation: GO or NO-GO,** with reasons. Any failed command, or any Not Met or Unverified target, means NO-GO, unless the human explicitly accepts it.

Gate: 🔨 **Build and Test Complete**. Ask whether to go on to Operations (`ai-dlc-operations`) or finish.

## Leaving Construction
Write `verification/phase-check-construction.md` and confirm:
- [ ] every in-scope AC maps to a passing test, or is Deferred with a reason
- [ ] every plan step is `[x]` or `[S]`, and the diff has no unapproved extras or unrequested data-model elements
- [ ] ADRs exist for every one-way-door decision, and are indexed in `standards/decisions-index.md`
- [ ] the reviews have no open Critical findings, unless they were explicitly accepted
- [ ] the Summary Report says GO, or the human has accepted the listed risks

For a cross-unit consistency check (2+ units), run `ai-dlc-review` in design mode before the first Code Generation.

## Common failures
- Writing code before the plan is approved, or drifting from the plan without saying so.
- Deferring all tests to Build & Test.
- "Fixing" a red build by loosening a threshold or deleting an assertion.
- Inventing tables or fields nobody asked for.
- Claiming NFRs are met without running anything.
- Editing README or other user-owned files by default.
- Reusing one long context across many units. Use fresh subagents and load summaries.
- Looping forever on a failing step instead of halting with Retry / Skip / Abort.
