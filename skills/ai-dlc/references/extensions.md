# Opt-in extensions

Extensions are rule packs you switch on for production or regulated work. They're off by default, so a bugfix never pays for them.

**How the opt-in works:**
1. During Requirements Analysis, add each extension's opt-in question to the questions file.
2. Record the answers under `## Extension Configuration` in `aidlc-state.md`.
3. Once a pack is enabled:
   - Check its rules at every stage where they apply.
   - **A violated rule is a blocking finding.** Offer only Request Changes until it's fixed, or until the user records a waiver.
   - Each gate lists every rule that applies, as compliant, non-compliant or N/A.

The rules below are condensed paraphrases. Treat them as the minimum bar, and tighten them with your organisation's own policies.

## Security baseline (`SEC-*`)
**Opt-in question:** "[security] Apply the security baseline? A) Yes, enforce it  B) No (prototype or internal tool)  X) Other"

| Rule | Requirement |
|---|---|
| SEC-01 | Encrypt data at rest and in transit (TLS 1.2+). |
| SEC-02 | Keep secrets in a secrets manager or env injection, never in code, config files or plans. |
| SEC-03 | Validate and encode all external input at trust boundaries. Use parameterised queries only. |
| SEC-04 | Authenticate every non-public endpoint. Authorise per resource (no IDOR). Deny by default. |
| SEC-05 | Least privilege for service identities and IAM. No wildcard actions on sensitive resources. |
| SEC-06 | Log security events (auth, permission changes, admin actions) without PII or secrets in the logs. |
| SEC-07 | Set security headers and restrictive CORS for web surfaces. No wildcard origins in prod. |
| SEC-08 | Pin dependencies, scan them for known CVEs and licenses, and use no unmaintained packages. |
| SEC-09 | Rate-limit and size-limit public inputs and uploads. |
| SEC-10 | Return safe error messages, with no stack traces or internals to clients. |
| SEC-11 | Keep PII to the minimum. Document retention and deletion. |
| SEC-12 | Include security tests for the auth and input-validation paths in Build & Test. |

## Resiliency (`RES-*`)
**Opt-in question:** "[ops] Apply resiliency rules? A) Yes, and I'll give RTO/RPO targets  B) No  X) Other". **Never choose RTO/RPO yourself. Ask.**

| Rule | Requirement |
|---|---|
| RES-01 | RTO and RPO are stated by a human and recorded as NFRs. |
| RES-02 | Topology matches the availability target (multi-AZ for 99.9%+). |
| RES-03 | Every outbound call has a timeout, bounded retries with backoff and jitter, and idempotency where it retries. |
| RES-04 | Failing dependencies degrade gracefully or open a circuit breaker. No cascade. |
| RES-05 | Health and readiness endpoints exist. Shutdown is graceful (drains on SIGTERM). |
| RES-06 | Backups exist, and a restore has been tested at least once. |
| RES-07 | Deployments are reversible: a rollback is tested, and migrations are backward-compatible. |
| RES-08 | Every alert has a runbook and an owner. |

## Property-based testing (`PBT-*`)
**Opt-in question:** "[qa] Use property-based tests? A) Full: all pure business logic  B) Partial: parsers, serialisers, money/time maths  C) No  X) Other"

| Rule | Requirement |
|---|---|
| PBT-01 | Functional Design lists the **testable properties** per rule. Kinds: round-trip, invariant, idempotence, commutativity, oracle/model, metamorphic. |
| PBT-02 | Each listed property has a property test with a custom generator for domain types. |
| PBT-03 | Shrinking is on, and failures print a reproducible seed. |
| PBT-04 | Property tests run in CI with a fixed iteration budget. |
| PBT-05 | Example-based tests still cover the acceptance criteria. Properties add to them; they don't replace them. |
