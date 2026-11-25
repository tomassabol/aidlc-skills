# All stages on one page

This is a fallback for when the phase skills (`ai-dlc-inception`, `ai-dlc-construction`, `ai-dlc-operations`) aren't installed. They carry the full instructions and templates.

ALWAYS means the stage runs every time. COND means you decide with the user, recorded in `execution-plan.md`.

## Inception: WHAT and WHY (Mob Elaboration)
| # | Stage | When | Output (in `aidlc-docs/inception/`) |
|---|---|---|---|
| 1 | Workspace Detection | ALWAYS, no gate | `aidlc-state.md` |
| 2 | Reverse Engineering | COND: brownfield, artifacts missing or stale | `reverse-engineering/`: business-overview, architecture, code-structure, api-documentation, component-inventory, technology-stack, dependencies, code-quality-assessment |
| 3 | Requirements Analysis | ALWAYS, adaptive depth | `requirements/requirements.md`, plus question files |
| 4 | User Stories | COND: user-facing, multi-persona or complex logic | `user-stories/stories.md`, `personas.md` |
| 5 | Workflow Planning | ALWAYS | `plans/execution-plan.md`: which stages run or skip, and why |
| 6 | Application Design | COND: new components or services | `application-design/` components, methods, services, dependencies |
| 7 | Units Generation | COND: more than one Unit or parallel teams | `application-design/unit-of-work*.md` |

Three questions drive the phase:
- **Why:** the Intent, in business language, with no premature technology choices.
- **What:** User Stories, the smallest negotiable slices of value, each with testable acceptance criteria.
- **How:** Units of Work, cohesive and loosely coupled clusters of stories that independent teams can build in parallel.

Inception is done when teams can start building with no further clarification meetings.

## Construction: HOW (Mob Construction), per Unit, in Bolts
| # | Stage | When | Output (in `aidlc-docs/construction/{unit}/`) |
|---|---|---|---|
| a | Functional Design | COND: data models, business rules | business-logic-model, business-rules, domain-entities (technology-agnostic) |
| b | NFR Requirements | COND: performance, security, scale, tech stack | nfr-requirements, tech-stack-decisions |
| c | NFR Design | COND: only if b ran | nfr-design-patterns, logical-components |
| d | Infrastructure Design | COND: cloud resources or deployment | infrastructure-design, deployment-architecture, ADRs |
| e | Code Generation | ALWAYS | plan approved first, then code in the workspace with traceability to stories |
| — | Build and Test | ALWAYS, once after all Units | `construction/build-and-test/`: instructions, results, Summary Report (go/no-go) |

Simple tasks such as a bug fix skip straight to Code Generation.

## Operations: run it
| Stage | Output (in `aidlc-docs/operations/`) |
|---|---|
| Deployment | deployment plan per environment, approved before rollout; rollback runbook |
| Observability | metrics, dashboards, alerts and SLOs, built AI-DLC style |
| Incident Response | runbooks; at incident time: AI analyses → recommends → human decides → AI executes; code fixes go back to Construction |
