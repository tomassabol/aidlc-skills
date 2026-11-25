---
name: ai-dlc-operations
description: AI-DLC Operations phase. Extends AI-DLC into deployment, observability and incident response, with the AI planning and analysing while humans approve rollouts and make the critical calls. Use when the user wants to deploy or roll out a built Unit under AI-DLC, plan environments and configuration, set up monitoring, dashboards, alerts or SLOs, write runbooks, or handle a production incident with AI analysis and human decision, or when aidlc-state.md shows Operations or the Build & Test summary says GO.
---

# AI-DLC Operations: run it

Operations is a natural extension of AI-DLC. The same human-validated approach used to build the system now runs it:
- **AI** handles the repetitive, error-prone operational work: packaging, configuration, log analysis, pattern detection.
- **Humans** keep control of the critical decisions: rollouts, risky remediations, compliance.

The goal is to move from reactive firefighting to proactive, consistent operations.

## Shared rules (from the `ai-dlc` orchestrator)
- Docs go in `aidlc-docs/operations/`. IaC, pipeline and config code goes in the workspace, never in `aidlc-docs/`.
- Questions go in files with `[Answer]:` tags. Plan, then get approval, then execute step by step. Log every input verbatim in `audit.md`.
- **Nothing reaches staging or production without explicit human approval of the plan.** Treat every production change as a one-way door unless a tested rollback exists.
- Never run destructive or production-affecting commands on your own initiative. Present the command and wait for approval.

## Entry check
Read `construction/build-and-test/build-and-test-summary.md`.
- If it says **NO-GO**, or doesn't exist, stop and ask whether to return to Construction or to accept the listed risks explicitly. Log that decision.
- Then run the stages that `execution-plan.md` selected. Without a plan, ask which of the three areas below are in scope.

---

## 1. AI-driven deployment
**AI's job:**
1. Package the Units into **independently deployable components** (Deployment Units).
2. Manage cross-environment configuration: dev, staging and prod values, plus secrets references. Never put secret values in plans.
3. Propose a deployment strategy: rolling, blue/green, canary or feature flag.
4. Write the rollout plan.

**Human's job:** approve the deployment plan **before any rollout**, for each environment.

Steps:
1. Questions file (`operations/deployment-questions.md`):
   - target environments and accounts
   - deployment strategy
   - migration ordering
   - downtime tolerance
   - approval owners
   - change windows
2. Write `operations/plans/deployment-plan.md`. Per environment:
   - prerequisites
   - ordered checkbox steps
   - the exact commands or pipeline runs
   - health checks and smoke tests
   - **rollback steps and triggers**
3. Gate: get explicit approval of the plan **for each environment**. Approving staging does not approve prod.
4. Execute step by step and tick each step. After each environment, record the results in `operations/deployment-log.md` (health checks, smoke tests) and stop for the go-ahead before the next environment.

Gate: 🚀 **Deployment Complete - <env>**, with Request Changes / Continue to Next Stage.

## 2. AI-driven observability
Build the monitoring system **the AI-DLC way**: the same plan, clarify, approve, execute loop used to build the application.

1. Questions:
   - existing tooling or vendor (selection criteria if none)
   - SLIs and SLOs derived from the NFRs
   - key business transactions to trace
   - log retention and compliance
   - alert routing and on-call
2. Write `operations/plans/observability-plan.md`. It covers:
   - metrics collection, per Unit
   - structured logging fields
   - tracing
   - dashboards: one per business transaction, plus a service overview
   - alerts: symptom-based, each tied to an SLO and a runbook
3. After approval, generate the config or IaC in the workspace. Write `operations/observability.md` with an SLO table, a dashboard list, and an alert → runbook map.
4. Humans check that the result matches compliance requirements: data in logs, retention, access.

Gate: 📈 **Observability Complete**.

## 3. Incident response
**Preparation:** write `operations/runbooks/<alert-or-scenario>.md`, one per alert. Each runbook has:
- symptoms
- diagnosis queries
- safe actions (low-risk, reversible)
- risky actions (need approval)
- escalation path

**During an incident**, follow this loop strictly:
1. **AI analyses** logs, metrics and traces. It finds patterns, correlates them with recent deploys and changes, and estimates impact.
2. **AI recommends** ranked actions, each with its evidence, expected effect, risk and rollback. Example: "restart service X: evidence ..., risk: drops in-flight requests ...".
3. **Human decides.** They review the recommendation, apply operational judgement, and approve, modify or reject it.
4. **AI executes** only the approved action, verifies the effect, and reports back.
5. Repeat until the incident is resolved.

Log every recommendation and decision in `operations/incidents/<date>-<slug>.md`, and in `audit.md`.

**If the fix needs code**, hand off to development. Open a new AI-DLC Intent, for example "Fix: <incident>", which normally runs the bugfix profile: Requirements (minimal) → Code Generation → Build & Test → Deployment. This closes the loop from operations back into development.

**After the incident**, draft a blameless post-incident review covering:
- timeline
- root cause
- what detected it
- action items, each proposed as a new Intent or backlog item

The human approves it.

## Feedback loop
Use operational data to inform the next Intents:
- SLO reports
- cost
- drift
- recurring incidents

Propose these as candidates. Don't start new work without approval.
