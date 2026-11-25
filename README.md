# AI-DLC Skills

Agent skills for the **AI-Driven Development Lifecycle (AI-DLC)**. In AI-DLC the AI plans, asks and proposes at every stage, and a human approves each critical decision.

The skills are plain markdown, with no engine. They work with Claude Code, Cursor, Codex, Copilot, Kiro and any other agent supported by the [`skills`](https://www.npmjs.com/package/skills) CLI.

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
npx skills add tomassabol/aidlc-skills --skill ai-dlc-review
```

Add `-g` to install globally. Run `npx skills add tomassabol/aidlc-skills --list` to see what's available.

## Skills

| Skill | What it does |
|---|---|
| [`ai-dlc`](skills/ai-dlc/SKILL.md) | **Start here.** The orchestrator. It detects the workspace and picks a profile: trivial, bugfix, security-patch, feature, full, refactor or infra. It keeps the state, audit and project-memory files, runs the approval gates, reviews before each gate, and handles resume, status and repair. Its references cover question files, conflict rules, extensions, collaboration and best practices. |
| [`ai-dlc-discovery`](skills/ai-dlc-discovery/SKILL.md) | *Optional, before Inception.* **Should we build it?** Turns signals into evidence-labelled problems, scores them with weights fixed in advance, writes a PR/FAQ and a pre-mortem, and ends in commit, pivot or park. Its output is a brief that Inception reads. |
| [`ai-dlc-inception`](skills/ai-dlc-inception/SKILL.md) | **WHAT and WHY.** Runs Mob Elaboration: reverse engineering for existing code, requirements (with a corner-case sweep), user stories, the execution plan, application design and Units of Work. Also has a risk checklist. |
| [`ai-dlc-construction`](skills/ai-dlc-construction/SKILL.md) | **HOW.** Builds each unit in Bolts (simple, ddd or spike), starting with a walking skeleton. Covers domain, NFR and infra design, code from an approved plan with tests built in, and Build & Test with a target verification matrix and a GO/NO-GO report. |
| [`ai-dlc-operations`](skills/ai-dlc-operations/SKILL.md) | **RUN IT.** Deployments with numeric promote and rollback criteria, SLOs with error-budget policies, runbooks with blast-radius limits, and incident response whose autonomy depends on severity (AI analyses, human decides, AI executes). |
| [`ai-dlc-review`](skills/ai-dlc-review/SKILL.md) | An independent code review, or a cross-unit design review, with severities and fixes. Works standalone. |
| [`ai-dlc-spike`](skills/ai-dlc-spike/SKILL.md) | A time-boxed throwaway prototype that tests the riskiest assumption. It produces findings, never shipped code. |
| [`ai-dlc-adoption`](skills/ai-dlc-adoption/SKILL.md) | For team leads: a readiness check, choosing a mechanism (prompts, skills, hooks or an engine), running a pilot, and lifecycle and conformance metrics. |

## Usage

Start a request with "Using AI-DLC". For example:

> Using AI-DLC, add an idea-submission and approval flow for employees.

The agent will then:
1. Detect the workspace, propose a profile, and create `aidlc-docs/`.
2. Write the questions to a file. Each question has 2 to 4 options, an "Other" choice, and a recommendation. You answer by:
   - filling in the file
   - saying "guide me" (clickable questions in Claude Code)
   - answering in chat

   For easily reversible decisions, "accept recommendations" answers them all at once.
3. Propose an **execution plan** saying which stages run and why.
4. Work through the stages. Each one ends at a **hard-stop gate**, after an independent review.

You can say **"status"** at any point. If the state gets lost, say **"repair"**. A new session resumes from `aidlc-state.md`.

### Layout the skills create

```
aidlc-docs/
  aidlc-state.md     # progress, profile, depth, test strategy, extensions
  audit.md           # append-only, verbatim log of every input and approval
  memory.md          # project rules learned from your corrections (ALWAYS / NEVER / DECIDED)
  standards/         # tech stack (pinned versions), coding standards, decisions index
  discovery/  inception/  construction/  operations/
  verification/      # phase checks and risk checks
```

Application code stays in your normal source tree, never in `aidlc-docs/`. Spike code goes in `spikes/` and is never shipped.

## Key concepts

- **Intent:** the business goal, in business language, with no premature technology choices.
- **Unit of Work:** a cohesive cluster of 3 to 8 stories that one team can build and deploy on its own.
- **Bolt:** a build cycle of hours to days that replaces the sprint. Types: simple, ddd, spike.
- **Mob Elaboration / Mob Construction / Mob Testing:** cross-functional sessions where the AI proposes and humans validate.
- **One-way vs two-way doors:** deliberate carefully over hard-to-reverse decisions, and default quickly on easy ones.
- **Core loop:** Task → Plan → Clarify → Refine → Approve → Execute → Review → Verify.

## Developing

```bash
./scripts/validate.sh
```

The validator checks frontmatter and relative links. After changing any rule, run the behavioural scenarios in [`evals/`](evals/README.md).

## Sources and credits

The skills were written from:
- the AWS Skill Builder learning plan *AI Driven Development Lifecycle Foundations*
- AWS's public AI-DLC material:
  - the DevOps blog post
  - the AI-DLC Method Definition paper
  - [awslabs/aidlc-workflows](https://github.com/awslabs/aidlc-workflows) (MIT-0)

They also use ideas from:
- [aws-samples/sample-aidlc-decisions-driven-skill](https://github.com/aws-samples/sample-aidlc-decisions-driven-skill), [sample-aidlc-discovery](https://github.com/aws-samples/sample-aidlc-discovery) and [sample-oh-my-aidlcops](https://github.com/aws-samples/sample-oh-my-aidlcops) (MIT-0)
- [fabriqaai/specs.md](https://github.com/fabriqaai/specs.md), [qtalen/aidlc-skills](https://github.com/qtalen/aidlc-skills) and [ijin/aidlc-cc-plugin](https://github.com/ijin/aidlc-cc-plugin)

All content is paraphrased and condensed. This is an independent community project, not an official AWS product.

## License

MIT. See [LICENSE](LICENSE).
