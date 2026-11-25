# Decision validation rules

Apply this after each question round, as validation step 6. Each rule names a pattern that commonly signals over-engineering, missing work or a contradiction.

When a rule fires:
1. State what you found.
2. Ask one question.
3. Offer 2 to 3 resolutions. One of them is always **"keep, with justification"**, which is recorded in the artifact.

## Severity
- **High:** resolve before generating.
- **Medium:** resolve, or keep with justification.
- **Low:** mention it at the gate.

Adjust severity by context. **Team size and timeline** are mandatory Requirements questions, so these rules can use them.
- **Solo dev, small team, or short timeline:** raise rules about complexity and operational burden by one level.
- **Enterprise or regulated scope:** raise rules about security, compliance and availability by one level.
- **POC or spike:** lower everything except security and data loss by one level.

## Requirements
| ID | Fires when | Severity |
|---|---|---|
| RQ-1 | Enterprise-grade scope (multi-tenant, HA, compliance), but a solo dev or a timeline under 1 month | High |
| RQ-2 | Compliance (GDPR, HIPAA, PCI, SOC2) or PII mentioned, but no story or NFR covers privacy, retention or access control | High |
| RQ-3 | "Real-time", "scalable", "fast" or "secure" used with no measurable NFR | Medium |
| RQ-4 | 5+ external integrations with no phasing or priority | Medium |
| RQ-5 | A success measure has no baseline, target or check date | Medium |
| RQ-6 | A requirement names a technology without a stated constraint (premature tech choice in the Intent) | Medium |
| RQ-7 | Scope "MVP", but 15+ must-have stories | Low |

## Units / decomposition
| ID | Fires when | Severity |
|---|---|---|
| UN-1 | The dependency graph has a cycle | High |
| UN-2 | 4+ units for 10 or fewer stories, or microservices with a team of 3 or fewer | High |
| UN-3 | A unit has fewer than 2 stories (merge?) or more than 15 (split?) | Medium |
| UN-4 | One unit has more than 3 dependents (bottleneck) | Medium |
| UN-5 | 3+ units share an entity with no single owner or shared-kernel decision | High |
| UN-6 | A story maps to no unit, or to two units | High |

## NFR / tech stack / design
| ID | Fires when | Severity |
|---|---|---|
| DS-1 | Separate services share one database with multiple writers | High |
| DS-2 | A high-availability target (99.9%+) on a single instance or single AZ | High |
| DS-3 | Serverless functions for work that runs longer than the platform timeout | High |
| DS-4 | PII or secrets stored without encryption at rest, or secrets in config files | High |
| DS-5 | Wildcard CORS, or auth disabled, in a production configuration | High |
| DS-6 | Event sourcing, CQRS or a microservice split for plain CRUD with no NFR that needs it | Medium |
| DS-7 | A pattern with no NFR or requirement that justifies it | Medium |
| DS-8 | A library or version that couldn't be verified as current, or chosen as "latest" | Low |

## Code generation plan
| ID | Fires when | Severity |
|---|---|---|
| CP-1 | A test framework is chosen but the plan has no test steps, or tests are deferred to Build & Test | High |
| CP-2 | A database is in use but schema changes have no migration step | High |
| CP-3 | A step creates a data-model element no requirement asks for, and it isn't listed under Assumptions | High |
| CP-4 | Cloud and IaC are in scope but there are no infra steps | Medium |
| CP-5 | A step has no story, business rule or NFR reference and isn't marked `scaffold` | Medium |
| CP-6 | A step edits a user-owned file (README, LICENSE, existing docs) without being asked to | Medium |
| CP-7 | 30+ steps, 3 or fewer people, and no parallel waves considered | Low |

## Deployment / operations
| ID | Fires when | Severity |
|---|---|---|
| OP-1 | A production rollout with no tested rollback | High |
| OP-2 | Production with no secrets management, or secrets in the plan text | High |
| OP-3 | Canary or blue/green chosen on a target that can't split traffic | High |
| OP-4 | Destructive migrations run automatically on startup | High |
| OP-5 | Alerts with no runbook or owner | Medium |
| OP-6 | Rollout proposed while the error budget is in the freeze band | High |
