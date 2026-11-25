---
name: ai-dlc-inception
description: AI-DLC Inception phase. Turns a business Intent (or a discovery brief / PR-FAQ / PRD) into approved requirements, User Stories and independently buildable Units of Work through Mob Elaboration, where the AI proposes and humans validate. Includes brownfield reverse engineering and the execution plan that decides which later stages run. Use when starting a feature or project with AI-DLC, when asked to elaborate or break down an intent, write requirements or user stories, plan units of work, or reverse-engineer a codebase before changing it, or when aidlc-state.md shows Inception in progress. Do not use for one-line fixes or ad-hoc questions about code.
---

# AI-DLC Inception: WHAT and WHY

Inception answers three questions:
- **Why:** the **Intent**, meaning the business purpose.
- **What:** **User Stories**, meaning the outcomes that deliver value.
- **How:** **Units of Work**, meaning independently buildable clusters of stories.

**Success:** teams can start building straight away, with no further clarification meetings.

The ritual is **Mob Elaboration**. The AI proposes breakdowns, and product, development and QA give real-time reality checks. Tag every question by role so a single user can pull in the right people.

## Inputs and outputs
| | |
|---|---|
| **Required** | the user's request (the Intent) |
| **Optional** | `aidlc-docs/discovery/brief.md`, a PR/FAQ or PRD, tickets, existing docs, the existing codebase |
| **Writes** | `aidlc-docs/inception/**`, `aidlc-state.md`, `audit.md`, `verification/phase-check-inception.md`, `standards/` (brownfield) |
| **Hands off to** | `ai-dlc-construction`, starting with the first Unit in dependency order |

**Running without the orchestrator.** If `ai-dlc` isn't installed or no state exists, create `aidlc-docs/aidlc-state.md` and `audit.md` lazily, the first time you need them. The shared rules below still apply.

## Shared rules (full versions in the `ai-dlc` skill)
- Docs go in `aidlc-docs/`, code never does.
- Questions go in files, with 2 to 4 options plus X) Other, a role tag, and a `Recommended:` line. Look things up in the repo before asking.
- Plan, then approval, then execute step by step, ticking `[x]` in the same turn. Log every user input verbatim.
- Every artifact opens with a `## Summary` of 10 lines or fewer. Every question file ends with a `## Decisions Summary`.
- **Assumptions stay assumptions** until they're confirmed in a question file.
- Each stage gets an advisory review before its gate.
- Every stage except Workspace Detection ends at a **hard-stop gate**: Request Changes / [Add Skipped Stage] / Approve & Continue.

## Stage sequence

```
Workspace Detection → [Reverse Engineering] → Requirements Analysis → [User Stories]
   → Workflow Planning → [Application Design] → [Units Generation] → exit checks → Construction
```

---

## 1. Workspace Detection (always, no gate)
1. Log the request verbatim. If state already exists, resume instead.
2. Scan source, build, test, CI and IaC files. Record the languages, build system, structure and workspace root.
3. Brownfield: if the reverse-engineering artifacts are missing, or older than the last significant code change, run Reverse Engineering. Otherwise load their summaries and skip it.
4. **Practices (brownfield, first Intent only).** If `aidlc-docs/standards/` doesn't exist:
   - Infer the coding conventions, branching, test setup and CI from the repo and git history.
   - Confirm them in 1 to 3 questions. **Put these questions in the Requirements question file.** Never open a separate question round just for practices.
   - Write `standards/coding-standards.md` and `standards/tech-stack.md`.
5. Write the state file, print a 3 to 5 line summary, and **continue automatically**.

## 2. Reverse Engineering (brownfield)
Build a semantic model **before** proposing changes, because legacy code hides business rules.
- The **static model** covers components, responsibilities and relationships.
- The **dynamic model** covers how components interact for the key business transactions.

**Procedure** (it can be resumed; progress goes in `reverse-engineering/progress.md`):
1. **Structure scan:** a cheap pass over the folders, build files and entry points. List the modules.
2. **Module by module:**
   - Read the files in one module, write its findings, then move to the next.
   - Split modules with 150+ files.
   - Every claim cites `file:line`.
   - With 6+ modules and subagents available, use one subagent per module.
3. **Cross-cutting pass:** read only the generated findings and write the outputs below.

For **bugfix** and **security-patch** profiles, scope the work to the touched area and its direct dependencies.

| File (`inception/reverse-engineering/`) | Contents |
|---|---|
| `business-overview.md` | business context, business transactions, glossary |
| `architecture.md` | Mermaid component and data-flow diagrams, integrations, infra |
| `code-structure.md` | build, key modules, **inventory of existing files** (the candidates for change), patterns |
| `business-rules.md` | rules found in the code, state machines as tables, with `file:line`. This is the baseline for A/B refactors. |
| `api-documentation.md` | external APIs, internal interfaces, data models |
| `security.md` | auth coverage, unprotected endpoints, secrets handling, env-var inventory |
| `technology-stack.md`, `dependencies.md` | versions, internal graph, external dependencies and their licenses |
| `code-quality-assessment.md` | tests and coverage, lint, CI, tech debt heatmap (module × risk) |
| `reverse-engineering-timestamp.md` | the date and commit it was generated from |

Gate: 🔍 **Reverse Engineering Complete**. Humans validate both models.

## 3. Requirements Analysis (always, adaptive depth)
Act as the product owner.

1. **Intent intake.**
   - **If there's a discovery brief, PR/FAQ or PRD, use it as the Intent source.** Map it like this:
     - decision and conditions → constraints
     - success criteria → Success Measures
     - open hypotheses → Assumptions & Open Questions
     - personas → stories input
   - Then ask only about the gaps, starting with a Q0 that confirms what you took from the documents.
2. **Intent analysis.** Classify clarity, type, scope and complexity, and pick a depth.
3. **Check the Intent's quality.** A good Intent is in business language, names specific capabilities, and makes **no premature technology choices**. For example, "a React + PostgreSQL portal for ideas" fails. Rewrite it with the user.
4. **Check completeness** across functional needs, NFRs, user scenarios, business context, technical context and quality attributes.
5. **Corner-case sweep** (Standard and Comprehensive depth). Cross each named component with [references/corner-checklist.md](references/corner-checklist.md). Settle every corner that applies as exactly one of:
   - a requirement or AC
   - an assumption with a reason
   - out of scope

   Ask only about facts in the user's world. Turn corners that have a sensible default into assumptions.
6. **Questions file:** `requirements/requirement-verification-questions.md`. It must include:
   - **team size and timeline** (the conflict rules use these)
   - the opt-in question for each extension (security, resiliency, PBT), **only when it's relevant**:
     - **bugfix and trivial profiles:** skip the opt-ins, unless the fix touches auth, input handling, data storage or deployment.
     - **security-patch profile:** security is on automatically; just say so.
     - **other profiles:** ask, as usual.
   - For small fixes, aim for **one question round in total**, and 5 questions or fewer.

   Validate the answers, apply the Requirements conflict rules, and get the summary confirmed. **Stop** until everything is answered.
7. **Write `requirements/requirements.md`** from [references/templates.md](references/templates.md):
   - a Summary, the Intent analysis and the rewritten Intent
   - **Success Measures** as metric, baseline, target and check date
   - FRs and NFRs, each with hierarchical IDs (`FR1`, `FR1.2`, `NFR2`) and **source tags** (`[desc]`, `[Q3]`, `[doc]`, `[assumption]`)
   - Assumptions & Open Questions, with each item labelled Known, Assumed or Needs evidence
   - out of scope, and open decisions
8. Gate: 🔍 **Requirements Analysis Complete**. Offer "📝 Add User Stories" if that stage will be skipped. Offer "🧪 Spike first" (`ai-dlc-spike`) if a key assumption is risky.

## 4. User Stories (conditional)
- **Run it** for user-facing features, UX changes, multiple personas, customer-facing APIs, complex rules, or cross-team work.
- **Skip it** only for pure refactors, isolated bugfixes, infra-only work, tooling or docs.
- When in doubt, run it.

**Part 1, plan:**
1. Write `plans/user-stories-assessment.md` and `plans/story-generation-plan.md`. The plan has embedded questions on personas, granularity, the breakdown approach (journey, feature, persona, domain or hybrid) and the AC format.
2. Validate the answers, confirm the summary, and get **plan approval**.

**Part 2, generate:**
- `user-stories/personas.md` and `stories.md`. Each story:
  - is the smallest negotiable slice of value
  - follows INVEST
  - has testable ACs in Given/When/Then form, with IDs `US1.3` / `AC1.3.2`
  - traces to FRs
- A coverage table from FR to story, using OK / GAP / Deferred / N/A.

Gate: 📚 **User Stories Complete**.

## 5. Workflow Planning (always): the Level 1 plan
Load the summaries of all prior artifacts.

1. **Impact:** user-facing, structural, data model, API, NFR, infra, ops.
2. **Risk:** Low, Medium, High or Critical.
3. **Brownfield:** for each component, the change type, reason, priority and update order; what can run in parallel; the critical path; rollback.
4. **Decide EXECUTE or SKIP** for each remaining stage, with a one-line rationale. Use the thresholds in §7 for Units Generation.
5. **Pick the Bolt type** for each unit (simple, ddd or spike). See the `ai-dlc-construction` skill.
6. Write `plans/execution-plan.md` with:
   - a Summary
   - a Mermaid flow with a text fallback
   - a checklist with the rationale for each stage
   - the change sequence
   - success criteria and quality gates
   - open decisions
7. Update the state file.

Gate: 📋 **Workflow Planning Complete**: Request Changes / Add Skipped Stages / Approve & Continue.

## 6. Application Design (conditional: new components or services)
1. Write the plan with questions on component boundaries, responsibilities, interfaces, communication style and patterns. Get approval.
2. Generate into `application-design/`:
   - `components.md`: each entity has **exactly one owning component**
   - `component-methods.md`: signatures only
   - `services.md`
   - `component-dependency.md`
   - `application-design.md`
   - `decisions.md`: ADRs for one-way doors; also add each one to `standards/decisions-index.md` with a "Read when" line
3. **Check traceability both ways:** every story maps to at least one component, and every component maps back to a story or is justified as `scaffold`.

Gate: 🏗️ **Application Design Complete**. Offer "📝 Add Units Generation" if it's skipped, and "🧪 Spike" for a risky pattern.

## 7. Units Generation (conditional)
**Run it when any of these hold:** 5+ stories, 2+ business domains, 3+ user types, 3+ external integrations, or parallel teams. For brownfield work that extends one existing module, raise the bar to 10+ stories *and* 3+ domains.

A **Unit of Work** is a self-contained, loosely coupled cluster of stories that one team can build and deploy on its own. Think of it as a bounded context. It has a `kind`: service, ui, library, infra or spec.

**Finding the boundaries:**
- clusters of stories that change together
- nouns that appear together
- where ownership of the data changes
- ask "if this changed, what else would have to change?"

**Sizing:** 3 to 8 stories per unit is healthy. Merge units with 1 to 2, and split units with 15+.

**Pitfalls to avoid:**
- several units writing to the same tables
- anemic CRUD-only units
- units that all depend on everything

**Foundation unit (optional, greenfield):** a "Unit 0" with no stories. It covers repo structure, auth, error format, contracts, DB setup and CI base. It runs first, and later units follow its conventions without asking again.

**Part 1, plan:** `plans/unit-of-work-plan.md`, with questions on grouping, bounded contexts, dependencies, team alignment and code organisation. Get approval.

**Part 2, generate** into `application-design/`:
- `unit-of-work.md`: for each unit, its purpose, kind, stories, owned entities, commands, published and consumed events, interfaces, code location and suggested Bolts
- `unit-of-work-dependency.md`: a DAG with **no cycles**, plus a context map (customer/supplier, shared kernel, ACL, pub/sub)
- `unit-of-work-story-map.md`: every story in **exactly one** unit, plus the screen, command or endpoint it's "reached through"
- **Delivery notes:**
  - Bolts per unit: type, Definition of Done, confidence hypothesis
  - the walking skeleton first
  - external dependencies, each with an owner, lead time and fallback
  - the sequencing rationale: risk-first, value-first or skeleton-first

Apply the Units conflict rules. Gate: 🔧 **Units Generation Complete**.

## Leaving Inception
1. **Risk checklist:** run [references/risk-checklist.md](references/risk-checklist.md).
   - Settle every BLOCK, or record a waiver in `audit.md` (who, why, expiry).
2. **Phase check:** write `aidlc-docs/verification/phase-check-inception.md` and confirm that:
   - [ ] every FR is covered by a story, or is Deferred or out of scope with a reason
   - [ ] every story has testable ACs and belongs to exactly one unit
   - [ ] the unit graph has no cycles, and integration contracts are named
   - [ ] no question or clarification is open, and no assumption is used as if it were confirmed
   - [ ] `execution-plan.md` is approved
3. Report any gaps. Then hand off to `ai-dlc-construction`.

## Common failures
- Writing requirements that copy the request's tech choices instead of describing capabilities.
- Asking things the repo already answers, or asking again what an earlier file settled.
- Stories with untestable ACs ("fast", "user-friendly").
- Treating an assumption or an unselected option as a decided requirement.
- Too many tiny units, or a cycle between units.
- Skipping Reverse Engineering on brownfield work "because the change is small". Scope it instead.
- Generating artifacts from memory instead of from the template file.
