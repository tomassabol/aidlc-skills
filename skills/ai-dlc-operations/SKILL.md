---
name: ai-dlc-operations
description: AI-DLC Operations phase. Extends AI-DLC into deployment, observability and incident response. The AI plans, packages and analyses; humans approve each rollout and make the critical calls, with autonomy tiered by incident severity. Use when the user wants to deploy or roll out a built Unit under AI-DLC, plan environments and config, define SLOs and error budgets, set up dashboards, alerts or runbooks, or handle a production incident with AI analysis and human decision, or when aidlc-state.md shows Operations or the Build & Test summary says GO. Do not use for ad-hoc log reading outside an AI-DLC workflow.
---

# AI-DLC Operations: run it

Operations extends AI-DLC beyond development, using the same human-validated approach:
- **The AI** handles repetitive, error-prone work: packaging, configuration, log and metric analysis, pattern detection, drafting remediation.
- **Humans** keep the critical decisions: rollouts, risky remediation, compliance.

The goal is to move from reactive firefighting to proactive, consistent operations.

## Inputs and outputs
| | |
|---|---|
| **Required** | a built system, plus `build-and-test-summary.md` saying GO (or an explicit human acceptance of the risks) |
| **Optional** | NFRs, `infrastructure-design/`, `deployment-architecture.md`, existing pipelines and dashboards, the Success Measures in `requirements.md` |
| **Writes** | `aidlc-docs/operations/**`; pipeline, IaC and observability config in the workspace |
| **Feeds back to** | new Intents (via `ai-dlc` / `ai-dlc-inception`), and `memory.md` |

**Running alone,** e.g. "write runbooks for this service" or "help with this incident": ask for the missing inputs in a short question file. Create the state and audit files lazily, the first time you need them.

## Shared rules
- Docs go in `aidlc-docs/operations/`. IaC, pipeline and config code goes in the workspace. Questions go in files. Plan, then approval, then execute. Log every input verbatim.
- **Nothing reaches staging or production without explicit human approval of that environment's plan.** Approving staging doesn't approve prod.
- **Never put secret values** in plans, logs or chat. Reference them by name only.
- Never run a destructive or production-affecting command on your own initiative. Present it and wait.

## Who does what

| Area | AI may do without asking | Human must approve |
|---|---|---|
| Deploy | package artifacts; render config per environment; run dry-runs, plans and diffs; deploy to dev/ephemeral if the user allowed it | every staging or prod rollout; each traffic shift to 100%; skipping a soak |
| Observe | draft SLOs, dashboards, alerts and log queries; run read-only queries | SLO targets; alert routing and on-call; anything touching retention or PII |
| Incident | read logs, metrics and traces; form hypotheses; draft remediation and post-mortems | every action that changes production, except pre-approved *safe actions* in an approved runbook |
| Improve | propose changes as plans or **draft PRs** | merging, deploying, starting new work |

## Entry check
1. Read `build-and-test-summary.md`.
   - **NO-GO or missing:** stop. Ask whether to return to Construction, or explicitly accept the listed risks. Log the decision as a waiver.
2. **Re-run the operations rows of the risk checklist:** rollback, on-call ownership, cost, compliance, dependencies. It lives in `ai-dlc-inception/references/risk-checklist.md`, if installed.
3. **If SLOs already exist,** read the current error-budget band. Don't propose a non-urgent rollout in the **freeze** band.
4. Run the stages `execution-plan.md` selected. Without a plan, ask which areas are in scope.

---

## 1. Deployment
1. **Questions:**
   - environments and accounts
   - strategy: rolling, blue/green, canary or feature flag. The target must support it; canary needs traffic splitting.
   - migration order and backward compatibility
   - downtime tolerance
   - approvers
   - change windows
2. **Write `operations/plans/deployment-plan.md`.** Per environment:
   - prerequisites
   - a **Secrets required** table: name, environment, where it's configured
   - ordered checkbox steps with the exact commands or pipeline runs
   - **numeric promote and rollback criteria** for each rollout step, for example:

     | Step | Traffic | Soak | Promote if | Auto-rollback if |
     |---|---|---|---|---|
     | canary | 5% | 15 min | error rate ≤ baseline × 1.5, p99 ≤ baseline × 1.3 | error rate > 5× baseline for 2 min, or any PII alert |
     | expand | 50% | 30 min | same | same |
     | full | 100% | — | **human approval** | — |

   - **rollback steps,** tested in a lower environment
   - smoke tests and health checks
   - a rough cost-impact range
   - a post-deploy checklist
3. **Get explicit approval for each environment.** Execute step by step, ticking boxes. Record health checks and smoke results in `operations/deployment-log.md`. Stop for the go-ahead before the next environment.

Gate: 🚀 **Deployment Complete - <env>**: Request Changes / Continue to Next Stage.

## 2. Observability
Build the monitoring system **the AI-DLC way**, with the same plan, clarify, approve, execute loop used to build the app. Consistency matters: the systems that support an application are built the same way as the application.

1. **Questions:**
   - tooling or vendor (and selection criteria if there's none yet)
   - SLIs and SLOs derived from the NFRs
   - key business transactions to trace
   - log fields, retention and PII rules
   - alert routing and on-call
2. **Write `operations/plans/observability-plan.md`:**
   - metrics per unit
   - structured log fields
   - tracing
   - dashboards: one per business transaction, plus a service overview
   - symptom-based alerts, each tied to an SLO, a runbook and an owner
3. **After approval,** generate the config or IaC. Write `operations/observability.md` with:
   - an SLO table
   - an **error-budget policy**:

     | Budget remaining | Band | Deploy policy |
     |---|---|---|
     | > 50% | normal | normal cadence |
     | 25-50% | slow down | 1 deploy per day, extra soak |
     | 10-25% | caution | 1 per week, reliability work first |
     | < 10% or burning out | freeze | security and reliability fixes only |

   - the dashboard list
   - an alert → runbook map
4. **Humans check compliance alignment:** data in logs, retention, access.

Gate: 📈 **Observability Complete**.

## 3. Incident response

### Preparation: runbooks
Write one runbook per alert or scenario at `operations/runbooks/<name>.md`:

```markdown
# Runbook: <name>
- **Matches**: alert <name> / symptom <...>     **Applies to**: SEV2-SEV4
- **Diagnosis queries**: <log/metric/trace queries>
- **Safe actions** (pre-approved, reversible): <e.g. scale out by 1, clear cache key X>
  - **Limits**: max retries 2; cooldown 10 min; blast radius ≤ 3 resources; abort if deploy freeze active
- **Risky actions** (need approval each time): <e.g. restart service, fail over DB>
- Each step has: **command**, **timeout**, **verification**, **rollback** (mandatory)
- **Escalation**: <owner, on-call, vendor>
- **Stop**: human says "stop" → halt immediately, report state
```

### During an incident: severity sets the autonomy

| Severity | Examples | AI does |
|---|---|---|
| **SEV1** | full outage, data loss or leak, PII exposure, ≥30% errors | Page a human immediately and propose a **deploy freeze**. Diagnose only. Draft **no** remediation until a human takes command. |
| **SEV2** | major feature down, SLO burning fast | Diagnose, then draft remediation. **Human approves each action.** |
| **SEV3** | degraded, workaround exists | Diagnose and draft. Run *safe actions* only from an approved runbook. Anything else needs approval. |
| **SEV4** | minor, no user impact | Report and queue for review. |
| unknown | — | Treat as SEV3, and ask a human to confirm the severity. |

**The loop,** followed strictly:
1. **AI analyses.**
   - Build a timeline. Correlate the incident with recent deploys and config changes.
   - Form **3 to 5 hypotheses**, each with a diagnostic query and a prior confidence. Run the queries (in parallel if you can) and update the confidences.
   - Rank suspect changes by: **time proximity 40%, dependency relation 30%, similarity to a past root cause 30%**. Check `operations/rca-patterns.md`.
2. **AI recommends** ranked actions. Each has its evidence, expected effect, risk, blast radius and rollback.
3. **Human decides.** They apply operational judgement and approve, modify or reject.
4. **AI executes only the approved action.** It verifies the effect and reports back.
5. Repeat until resolved.

Log hypotheses, queries, results, recommendations and decisions in `operations/incidents/<date>-<slug>.md` and in `audit.md`.

**If the fix needs code,** hand off to development. Open a new AI-DLC Intent ("Fix: <incident>") using the **bugfix** profile: regression test first, then the fix, then Build & Test, then Deployment. This closes the loop from operations back to development.

**Afterwards,** draft a blameless post-incident review covering the timeline, root cause, detection, what went well and action items. Each action item is proposed as a new Intent. The human approves the review. Append the root cause and its signature to `operations/rca-patterns.md`.

## Feedback loop
Report each of these and propose follow-ups. Don't start work without approval:
- **SLO attainment and error-budget burn rate**
- **cost trend** against budget
- **configuration drift**
- **recurring incidents**
- the **Success Measures** from `requirements.md`, checked on their dates: baseline vs target vs actual

Improvement proposals stop at a plan or a draft PR. Merging and deploying stay human.

## Common failures
- Treating staging approval as prod approval.
- Free-text rollback triggers ("if things look bad") instead of numbers.
- Auto-running remediation on SEV1 or SEV2, or outside an approved runbook's safe actions.
- Secrets pasted into plans or logs.
- Alerts with no runbook or owner.
- Building observability ad hoc instead of through plan → approve → execute.
