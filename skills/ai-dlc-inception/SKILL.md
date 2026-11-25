---
name: ai-dlc-inception
description: AI-DLC Inception phase. Turns a business Intent into approved requirements, User Stories and independently buildable Units of Work through Mob Elaboration (AI proposes, humans validate). Use when starting a new feature or project with AI-DLC, when the user asks to "elaborate", "break down an intent", write requirements or user stories, plan units of work, reverse-engineer an existing codebase before changing it, or when aidlc-state.md shows the Inception phase in progress.
---

# AI-DLC Inception: WHAT and WHY

Inception turns a business idea into clearly defined work. It answers three questions:
- **Why:** the **Intent**, meaning the business purpose.
- **What:** **User Stories**, meaning the outcomes that deliver value.
- **How:** **Units of Work**, meaning independently buildable clusters of stories.

**Success criterion:** when Inception ends, teams can start building straight away. No more clarification meetings are needed.

The ritual is **Mob Elaboration**. The AI proposes breakdowns, and product, development and QA give real-time reality checks. When working with one person, tag every question by role (`[product]`, `[dev]`, `[qa]`, `[ops]`, `[security]`) so they can pull in the right people.

## Shared rules (from the `ai-dlc` orchestrator)
If the `ai-dlc` skill is installed, its rules and references apply: question format, state, audit, gates. In short:
- Docs go in `aidlc-docs/`, code never does.
- Questions go in files with `[Answer]:` tags. Never decide critical things alone.
- Plan, then get approval, then execute step by step, ticking `[x]` in the same turn.
- Log every user input verbatim in `aidlc-docs/audit.md`, append-only.
- Every stage except Workspace Detection ends at a **hard-stop gate** with Request Changes / [Add Skipped Stage] / Approve & Continue.

## Stage sequence

```
Workspace Detection → [Reverse Engineering] → Requirements Analysis → [User Stories]
   → Workflow Planning → [Application Design] → [Units Generation] → Construction
```
Stages in brackets are conditional. Workflow Planning decides them, and the user can override.

---

## 1. Workspace Detection (always, no gate)
1. Log the request verbatim in `audit.md`.
2. If `aidlc-docs/aidlc-state.md` exists, resume instead (see the `ai-dlc` skill).
3. Scan for source, build, test, CI and IaC files. Record languages, build system, structure, and workspace root.
4. Decide greenfield or brownfield. For brownfield:
   - If reverse-engineering artifacts are missing, or older than the last significant code change, run Reverse Engineering.
   - Otherwise load them and skip it.
5. Create `aidlc-state.md`, print a 3 to 5 line summary, and **continue automatically**.

## 2. Reverse Engineering (brownfield only)
Build a semantic model **before** proposing changes. Legacy code hides business rules.
- **Static model:** packages, components, responsibilities, relationships.
- **Dynamic model:** how components interact for the key business transactions.

Write these to `aidlc-docs/inception/reverse-engineering/`:

| File | Contents |
|---|---|
| `business-overview.md` | business context, list of business transactions, glossary |
| `architecture.md` | Mermaid component and data-flow diagrams, integrations, infra |
| `code-structure.md` | build system, key modules, **inventory of existing files** (the candidates for change), patterns |
| `api-documentation.md` | external APIs, internal interfaces, data models |
| `component-inventory.md` | application, infra, shared and test packages |
| `technology-stack.md` | languages, frameworks, versions, runtime |
| `dependencies.md` | internal dependency graph, external dependencies and licenses |
| `code-quality-assessment.md` | tests and coverage, lint, CI, tech debt, risky areas |
| `reverse-engineering-timestamp.md` | when it was generated, and at which commit |

Gate: 🔍 **Reverse Engineering Complete**. Ask humans to validate both models, since they are the base for every later decision.

## 3. Requirements Analysis (always, adaptive depth)
Act as the product owner.
1. **Intent analysis.** Classify clarity, type, scope and complexity. Pick a depth: Minimal, Standard or Comprehensive.
2. **Check the Intent's quality.** A good Intent:
   - is in **business language**
   - describes **specific capabilities**
   - **avoids premature technology choices**

   For example, "Build a portal with React and PostgreSQL where employees submit ideas" fails: it fixes the tech stack and doesn't say what the system must do. If the Intent fails, ask questions to rewrite it before going further.
3. Gather what the user already provided: docs, tickets, pasted text. Convert it to markdown under `requirements/`.
4. Check completeness across six areas: functional, non-functional, user scenarios, business context, technical context, quality attributes.
5. Write `requirements/requirement-verification-questions.md` (see [references/templates.md](references/templates.md)). Skip it only when the requirements are exceptionally clear. **Stop** until all answers are in and validated, and write a clarification file for anything vague or contradictory.
6. Write `requirements/requirements.md`:
   - intent analysis
   - the rewritten Intent statement
   - functional requirements (`FR-n`)
   - non-functional requirements (`NFR-n`)
   - assumptions
   - out of scope
7. Gate: 🔍 **Requirements Analysis Complete**. Offer "📝 Add User Stories" if the stories stage is going to be skipped.

## 4. User Stories (conditional)
- **Run it** for:
  - user-facing features
  - UX changes
  - multiple personas
  - customer-facing APIs
  - complex business rules
  - cross-team work
- **Skip it** only for pure refactors, isolated bug fixes, infra-only work, tooling or docs.
- When in doubt, run it.

**Part 1: Plan.**
1. Write `inception/plans/user-stories-assessment.md` (why the stories add value).
2. Write `inception/plans/story-generation-plan.md`: checkbox steps plus embedded questions on:
   - personas
   - granularity
   - breakdown approach (by journey, feature, persona, domain, or a hybrid)
   - acceptance-criteria format
3. Validate the answers.
4. Get **explicit plan approval**.

**Part 2: Generate.** Work through the plan, ticking steps as you go:
- `user-stories/personas.md`
- `user-stories/stories.md`

Each story:
- is the **smallest negotiable slice of functionality that delivers user value**
- follows INVEST
- has **clear, testable acceptance criteria** in Given/When/Then form
- maps to one or more personas
- traces to FR or NFR ids

Gate: 📚 **User Stories Complete**.

## 5. Workflow Planning (always): the Level 1 plan
Load all prior artifacts, then analyse:
- **Impact:** user-facing, structural, data model, API, NFR, infra, ops.
- **Risk level:** Low, Medium, High or Critical.
- **Brownfield:** components touched, with change type, reason and priority; update order; what can run in parallel; critical path; rollback strategy.
- **EXECUTE or SKIP decision** for each remaining stage: Application Design, Units Generation, and per-unit Functional Design, NFR Requirements, NFR Design, Infrastructure Design, plus Operations stages. Give a one-line rationale for each.

Write `inception/plans/execution-plan.md` (template in [references/templates.md](references/templates.md)). It contains:
- the summary
- a Mermaid flowchart of the stages, marked EXECUTE, SKIP or COMPLETED
- a checklist with rationale
- the change sequence
- success criteria and quality gates

Update the Stage Progress list in `aidlc-state.md`.

Gate: 📋 **Workflow Planning Complete**, with three options:
- 🔧 Request Changes
- 📝 Add Skipped Stages
- ✅ Approve & Continue

## 6. Application Design (conditional: new components or services)
1. Write the plan `inception/plans/application-design-plan.md`, with questions on:
   - component boundaries
   - responsibilities
   - interfaces
   - communication style
   - patterns
2. Get approval.
3. Generate into `application-design/`:
   - `components.md`: each entity has exactly one owning component
   - `component-methods.md`: signatures only, since business rules come later in Functional Design
   - `services.md`
   - `component-dependency.md`: a dependency matrix and the communication patterns
   - `application-design.md`: consolidates the above
   - `decisions.md`: ADR log for one-way-door decisions

Gate: 🏗️ **Application Design Complete**, offering "📝 Add Units Generation" if that stage is skipped.

## 7. Units Generation (conditional: more than one Unit, or parallel teams)
A **Unit of Work** is a self-contained, loosely coupled cluster of related stories that one team can build and deploy independently. Think of it as a DDD bounded context or an epic.
- In microservices, each service is a Unit.
- A monolith is one Unit with modules.

**Part 1: Plan.** Write `inception/plans/unit-of-work-plan.md`, with questions on:
- story grouping
- bounded contexts
- dependencies
- team alignment
- code organisation (greenfield)

Get approval.

**Part 2: Generate** into `application-design/`:
- `unit-of-work.md`: for each Unit, its purpose, stories, owned entities, interfaces, and (greenfield) code location
- `unit-of-work-dependency.md`: the dependency matrix as a DAG. **No cycles.** If you find one, propose a merge or a split.
- `unit-of-work-story-map.md`: **every story assigned to exactly one Unit**
- **Suggested Bolts:** for each Unit, 1 or more Bolts (hours to days each) with a Definition of Done. Consider making the first Bolt a **walking skeleton**: the thinnest end-to-end slice.

Gate: 🔧 **Units Generation Complete**.

## Leaving Inception: verification gate
Before you offer to start Construction, check:
- [ ] every FR is covered by at least one story (or is explicitly out of scope)
- [ ] every story has testable acceptance criteria and belongs to exactly one Unit
- [ ] the Unit dependency graph has no cycles, and the integration contracts between Units are named
- [ ] all question files are answered, and no clarification is open
- [ ] `execution-plan.md` is approved

Report any gaps. Once everything passes, hand off to `ai-dlc-construction` for the first Unit in dependency order.
