# All stages on one page

This is a fallback for when the phase skills aren't installed. The phase skills carry the full instructions and templates.

ALWAYS means the stage runs every time. COND means you decide with the user, recorded in `execution-plan.md`.

## Discovery (optional, before Inception): SHOULD we build it?
Signals and evidence → problems (not features) scored with fixed weights → PR/FAQ → risks and pre-mortem → **commit / pivot / park**. The output is `aidlc-docs/discovery/brief.md`, which Inception reads as the Intent source. Skill: `ai-dlc-discovery`.

## Inception: WHAT and WHY (Mob Elaboration)
| # | Stage | When | Output (in `aidlc-docs/inception/`) |
|---|---|---|---|
| 1 | Workspace Detection | ALWAYS, no gate | `aidlc-state.md` |
| 2 | Reverse Engineering | COND: brownfield, artifacts missing or stale | `reverse-engineering/`: business overview, architecture, code structure, APIs, business rules, security, tech stack, dependencies, quality |
| 3 | Requirements Analysis | ALWAYS, adaptive | `requirements/requirements.md`, plus question files |
| 4 | User Stories | COND: user-facing, multi-persona or complex rules | `user-stories/stories.md`, `personas.md` |
| 5 | Workflow Planning | ALWAYS | `plans/execution-plan.md` |
| 6 | Application Design | COND: new components or services | `application-design/` |
| 7 | Units Generation | COND: 5+ stories, 2+ domains, 3+ user types, or 3+ integrations | `application-design/unit-of-work*.md`, Bolt suggestions |

**Exit:** `verification/phase-check-inception.md` passes, and the risk checklist has no unwaived BLOCK.

## Construction: HOW (Mob Construction), per Unit, in Bolts
Bolt types: **simple** (straight to the code plan), **ddd** (all the design stages), **spike** (time-boxed learning, no production code).

| # | Stage | When | Output (in `aidlc-docs/construction/{unit}/`) |
|---|---|---|---|
| a | Functional Design | COND: data models, business rules | domain entities, business rules, business logic model (technology-agnostic) |
| b | NFR Requirements | COND: quality targets, tech stack | nfr-requirements, tech-stack decisions with a version map |
| c | NFR Design | COND: only if b ran | patterns, logical components |
| d | Infrastructure Design | COND: cloud or deployment | infra design, deployment architecture, ADRs |
| e | Code Generation | ALWAYS | approved plan (Summary / Assumptions / tests), then code, then code-summary |
| — | Build and Test | ALWAYS, once | target verification matrix, coverage matrix, operational readiness, GO/NO-GO |

Each stage gets an independent review before its gate. Units run in dependency order, and the walking skeleton goes first.

## Operations: run it
| Stage | Output (in `aidlc-docs/operations/`) |
|---|---|
| Deployment | per-environment plan with numeric promote and rollback criteria, approved per environment |
| Observability | SLOs plus an error-budget policy, dashboards, alerts mapped to runbooks |
| Incident Response | runbooks with blast-radius and retry limits; SEV-tiered autonomy; AI analyses → human decides → AI executes |
