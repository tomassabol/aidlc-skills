# Risk checklist (leaving Inception; re-run at the Operations entry)

Cross-read the requirements, the design and `execution-plan.md` against each category below. Mark each one:
- **PASS:** considered and handled
- **WARN:** a risk that is acceptable once noted
- **BLOCK:** must be resolved, or waived by a named decision-maker

Phrase each finding as: "Found X in the design, which could cause Y. Was Z considered?" Never ask about something the artifacts already answer.

| # | Category | Check | BLOCK when |
|---|---|---|---|
| 1 | Business continuity | What happens to current users during the change? Migration path? | Existing users lose data or access with no plan |
| 2 | Security | Auth on every non-public path, secrets handling, PII | PII or secrets exposed, or an unauthenticated write path |
| 3 | External integrations | Contracts, rate limits, IP allowlists, sandbox availability | A dependency has no contract or owner and blocks the critical path |
| 4 | Data consistency | Ownership, transactions, idempotency, migration of existing data | Two writers to the same data with no strategy |
| 5 | Cost | Per-request costs, egress, always-on resources, AI token usage | No estimate for a design that scales cost with usage |
| 6 | Performance baseline | Measurable targets, and the current baseline for brownfield | "Fast" with no number on a user-facing path |
| 7 | Compliance | Regulated data, retention, audit trail, residency | A regulated data type with no handling rule |
| 8 | Availability | The target matches the topology, single points of failure | The availability target can't be met by the chosen topology |
| 9 | Blast radius | What breaks if this component fails, and isolation | One failure takes down unrelated features with no mitigation |
| 10 | Operational complexity | Who runs it, on-call, observability plan | No owner for a production component |
| 11 | Dependencies | CVEs, licenses, maintenance status, pinned versions | A known critical CVE, or a license incompatible with distribution |
| 12 | Rollback | Reversible deploys and migrations, feature flags | An irreversible migration with no backup or restore plan |

Record the results in `aidlc-docs/verification/risk-check-<phase>.md`. Record each waiver as `## Waiver - <category>` in `audit.md`.
