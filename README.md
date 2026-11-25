# AI-DLC Skills

Agent skills for the **AI-Driven Development Lifecycle (AI-DLC)**. In AI-DLC the AI plans, asks and proposes at every stage, and a human approves each critical decision.

The skills work with Claude Code, Cursor, Codex, Copilot, Kiro and any other agent supported by the [`skills`](https://www.npmjs.com/package/skills) CLI.

## Install

```bash
npx skills add tomassabol/aidlc-skills
```

Install everything, for all detected agents, without prompts:

```bash
npx skills add tomassabol/aidlc-skills --all
```

Install a single skill:

```bash
npx skills add tomassabol/aidlc-skills --skill ai-dlc-inception
```

Add `-g` to install globally instead of into the current project. Run `npx skills add tomassabol/aidlc-skills --list` to see what's available.

## Skills

| Skill | What it does |
|---|---|
| [`ai-dlc`](skills/ai-dlc/SKILL.md) | **Start here.** The orchestrator: workspace detection, state and audit files, workflow profile, approval gates, resume, and mid-workflow changes. Its references cover question format, decision-making (one-way vs two-way doors, the five decision points), and the seven best practices. |
| [`ai-dlc-inception`](skills/ai-dlc-inception/SKILL.md) | **WHAT and WHY.** Turns an Intent into requirements, User Stories and Units of Work through Mob Elaboration. Includes brownfield reverse engineering and the execution plan. |
| [`ai-dlc-construction`](skills/ai-dlc-construction/SKILL.md) | **HOW.** Bolts per Unit: Functional Design → NFR Requirements → NFR Design → Infrastructure Design → Code Generation (plan approved first) → Build & Test → go/no-go Summary Report. |
| [`ai-dlc-operations`](skills/ai-dlc-operations/SKILL.md) | **RUN IT.** Deployment plans approved per environment, observability built the AI-DLC way, and incident response (AI analyses → human decides → AI executes). |
| [`ai-dlc-adoption`](skills/ai-dlc-adoption/SKILL.md) | For team leads: readiness assessment, choosing a mechanism (prompts vs rules vs MCP), the pilot Mob Elaboration, and lifecycle metrics. |

## Usage

Start a request with "Using AI-DLC". For example:

> Using AI-DLC, add an idea-submission and approval flow for employees.

The agent will then:
1. Detect the workspace and create `aidlc-docs/aidlc-state.md` and `aidlc-docs/audit.md`.
2. Write the requirements questions to a file. You answer by filling in letters after `[Answer]:`, or say "guide me".
3. Propose an **execution plan** saying which stages run and which are skipped, and why. You approve it or change it.
4. Work through the stages. Each one ends at a **hard-stop gate** where you Request Changes or Approve & Continue.

If you open a new session later, the agent resumes from `aidlc-state.md`.

### Layout the skills create

```
aidlc-docs/
  aidlc-state.md     # progress, checkboxes, current stage
  audit.md           # verbatim, append-only log of every input and approval
  inception/         # requirements, stories, units, execution-plan.md
  construction/      # per-unit designs, code-gen plans, build-and-test summary
  operations/        # deployment plans, observability, runbooks, incidents
```

Application code stays in your normal source tree. It never goes in `aidlc-docs/`.

## Key concepts

- **Intent:** the business goal, written in business language with no premature technology choices.
- **Unit of Work:** a cohesive, loosely coupled cluster of stories that one team can build and deploy independently.
- **Bolt:** a build cycle measured in hours or days. It replaces the sprint.
- **Mob Elaboration / Mob Construction / Mob Testing:** cross-functional sessions where the AI proposes and humans validate in real time.
- **Core loop:** Task → Plan → Clarify → Refine → Approve → Execute → Verify.

## Sources

The skills were written from:
- the AWS Skill Builder learning plan *AI Driven Development Lifecycle Foundations*
- AWS's public material on AI-DLC:
  - the DevOps blog post *AI-Driven Development Life Cycle: Reimagining Software Engineering*
  - the AI-DLC Method Definition paper
  - the open-source [awslabs/aidlc-workflows](https://github.com/awslabs/aidlc-workflows) rules (MIT-0)

All content is paraphrased. This is an independent community project, not an official AWS product.

## License

MIT. See [LICENSE](LICENSE).
