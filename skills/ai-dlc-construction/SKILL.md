---
name: ai-dlc-construction
description: AI-DLC Construction phase. Turns approved Units of Work into tested, operations-ready code through Bolts (short cycles of hours or days) and Mob Construction. Runs Functional Design, NFR Design, Infrastructure Design, Code Generation, and Build & Test, with human approval of the code plan before any code is written. Use when the user asks to build, implement or code a Unit or story under AI-DLC, start a Bolt, do domain/functional design, NFR or infrastructure design, generate code from an approved plan, or run build and test, or when aidlc-state.md shows the Construction phase.
---

# AI-DLC Construction: HOW

Construction turns validated Units of Work into tested, operations-ready **Deployment Units**:
- packaged code
- configuration
- infrastructure as code
- tests

It runs in **Bolts**. A Bolt is a short, adaptive cycle measured in **hours or days, not weeks**, and it replaces the sprint. A Unit takes one or more Bolts.

The work is **AI-driven and human-validated**. The ritual is **Mob Construction**: the team works on a shared screen, the AI proposes, and humans validate in real time. Build & Test adds **Mob Testing**, where the team analyses failures together.

## Shared rules (from the `ai-dlc` orchestrator)
- Docs go in `aidlc-docs/construction/`, and **code never goes inside `aidlc-docs/`**. Brownfield code follows the existing layout, and files are edited in place.
- Questions go in files with `[Answer]:` tags. Validate the answers and follow up on anything vague.
- Plan, then get approval, then execute step by step, ticking `[x]` in the same turn. Log every user input verbatim in `audit.md`.
- Construction gates have **exactly two options**: 🔧 **Request Changes** / ✅ **Continue to Next Stage**. They are hard stops.

## Stage sequence (per Unit, in dependency order)

```
for each Unit (respect unit-of-work-dependency.md):
   [Functional Design] → [NFR Requirements] → [NFR Design] → [Infrastructure Design] → Code Generation
then once:  Build & Test → Summary Report (go/no-go for Operations)
```

**The AI skips stages dynamically, based on complexity.** Use what `execution-plan.md` decided. Without an execution plan:
- A simple bug fix or small change goes **straight to Code Generation**.
- Add design stages only when the change involves new business rules, data models, quality targets, or infrastructure.

Each design stage has the same shape:
1. Read the upstream artifacts.
2. Write the plan `construction/plans/{unit}-{stage}-plan.md`, with checkboxes and embedded `[Answer]:` questions.
3. Validate the answers.
4. Generate the artifacts.
5. Present the 2-option gate.

## Bolt planning
At the start of each Unit, propose its Bolts (or confirm the ones suggested in Inception). Each Bolt gets:
- **Scope:** which stories or tasks it covers.
- **Definition of Done:** acceptance criteria that pass, tests that are green, artifacts that are updated.
- **Confidence hypothesis:** what shipping this Bolt proves or disproves, e.g. "SSO integration works with our IdP".
- **Verification command:** the command that proves it works (test suite, e2e script), approved by the human.

Make the first Bolt of a new system a **walking skeleton**: the thinnest end-to-end slice. Its verification must pass before later Bolts build on it.

---

## a. Functional Design (the domain model)
**Purpose:** model the business entities, rules and workflows in **technology-agnostic** language. Leave out frameworks and databases.

- **Questions:**
  - entities and their lifecycles
  - invariants and business rules
  - workflows and state transitions
  - validation
  - error cases
  - edge scenarios
- **Approach:** DDD tactical patterns, used where they help: aggregates, entities, value objects, domain events, repositories.
- **Output** in `construction/{unit}/functional-design/`:
  - `domain-entities.md`: entities, attributes, relationships, aggregates
  - `business-rules.md`: numbered rules (`BR-n`), each traced to stories
  - `business-logic-model.md`: workflows and state machines (Mermaid)
  - `frontend-components.md`: only if there is a UI (component tree, state, validation, API calls)
- Gate: 🔧 **Functional Design Complete - <unit>**

## b. NFR Requirements
**Purpose:** pin down the quality attributes as measurable targets, and choose the tech stack.

- **Questions:**
  - performance (latency, throughput)
  - scalability
  - availability and RTO/RPO
  - security and compliance
  - reliability
  - maintainability
  - observability
  - tech stack
- Example: "10,000 TPS at 99.99% uptime" is an NFR concern, not a functional one.
- **Output** in `construction/{unit}/nfr-requirements/`:
  - `nfr-requirements.md`: measurable targets
  - `tech-stack-decisions.md`: each choice with its rationale, marked one-way or two-way door
- Gate: 📊 **NFR Requirements Complete - <unit>**

## c. NFR Design (logical design)
**Purpose:** meet the NFRs with **logical components and design patterns**, such as caching, queues, circuit breakers, CQRS, idempotency, retries, and authorisation layers. These are still provider-neutral.

- Check that each pattern is **needed** (traced to an NFR) and **implementable**. Prefer the simpler option. Record the simpler fallback for every complex pattern.
- **Output** in `construction/{unit}/nfr-design/`:
  - `nfr-design-patterns.md`
  - `logical-components.md`
- Gate: 🎨 **NFR Design Complete - <unit>**

## d. Infrastructure Design
**Purpose:** map logical components to **concrete cloud services and deployment architecture**.

- **Questions:**
  - environment(s)
  - compute
  - storage
  - messaging
  - networking
  - identity
  - monitoring
  - shared vs per-unit infrastructure
- Record each significant mapping as an **Architecture Decision Record** (context, options, decision, consequences).
- **Output** in `construction/{unit}/infrastructure-design/`:
  - `infrastructure-design.md`
  - `deployment-architecture.md`
  - `adr/ADR-nnn-<title>.md`
  - `construction/shared-infrastructure.md`, if any infrastructure is shared
- Gate: 🏢 **Infrastructure Design Complete - <unit>**

## e. Code Generation (always)
**Code is generated only after a human approves the AI's detailed execution plan.**

**Part 1: Plan.** Write `construction/plans/{unit}-code-generation-plan.md` (template in [references/code-generation-plan.md](references/code-generation-plan.md)). It must contain:
- numbered checkbox steps in a sensible order: structure → domain logic + unit tests → persistence + tests → API + tests → UI + tests → migrations → docs → deployment artifacts
- the **exact file paths** for each step, marked create or modify. For brownfield work, take them from `reverse-engineering/code-structure.md`.
- **traceability:** which stories and business rules each step implements
- interfaces and contracts consumed from other Units
- a statement that this plan is the single source of truth for the step

Summarise the plan in chat, log the prompt, and **stop for explicit approval**.

**Part 2: Generate.** Loop:
1. Take the first `[ ]` step.
2. Do exactly that step: modify existing files in place, create new files at the planned paths.
3. Mark it `[x]` immediately. Mark each story `[x]` in the plan once its acceptance criteria are implemented.
4. Update `aidlc-state.md`.

Rules:
- No hard-coded business logic that belongs in configuration or data.
- No features outside the plan. If something is missing, stop and propose a plan change.
- Add stable test ids to UI elements (`data-testid="{component}-{role}"`).
- After generating, check that no duplicate or `*_new` files were created.
- If the plan proves wrong mid-execution, **stop** (execution intervention). Explain what diverged and propose a plan update for approval.

Write a short `construction/{unit}/code/code-summary.md` listing:
- files created and modified
- the story → file → test traceability table

Gate: 💻 **Code Generation Complete - <unit>** (list the created and modified files).

Then move to the next Unit, or to Build & Test after the last one.

## Build & Test (always, once after all Units)
Validate the whole system with a **test pyramid**: many unit tests, then fewer integration tests, then a few end-to-end tests.

1. Build the project. Run the unit tests, then the integration tests, then e2e. Add performance and security tests if NFRs require them.
2. On failures, run **Mob Testing**:
   - group the failures by root cause
   - propose fixes, each traced to the plan step or story
   - the human approves fixes before you apply them
   - re-run
3. Write to `construction/build-and-test/`:
   - `build-instructions.md`
   - `unit-test-instructions.md`
   - `integration-test-instructions.md`
   - `e2e-test-instructions.md`
   - `performance-test-instructions.md` or `security-test-instructions.md`, when applicable
   - **`build-and-test-summary.md`** (see below)
4. The **Summary Report** in `build-and-test-summary.md` is the **go/no-go decision document for Operations**. It covers:
   - build status
   - pass/fail counts per test level
   - acceptance-criteria coverage, per story
   - NFR results against targets
   - known issues and risks
   - recommendation: GO or NO-GO, with reasons

Gate: 🔨 **Build and Test Complete**. Ask whether to proceed to Operations (`ai-dlc-operations`) or to finish.

## Leaving Construction: verification gate
- [ ] every story's acceptance criteria map to at least one passing test
- [ ] every plan step is `[x]`, and no unapproved extras are in the diff
- [ ] the ADRs exist for every one-way-door decision
- [ ] the Summary Report recommends GO, or the human has explicitly accepted the listed risks
