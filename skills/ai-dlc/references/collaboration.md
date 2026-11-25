# Collaboration at AI speed

When AI can produce a feature in hours, **human decision-making becomes the bottleneck**. AI-DLC replaces slow ceremonies (weekly standups, multi-day review chains) with short, focused human decisions at well-defined points.

## Why a new methodology
- Waterfall suited an era when changes were expensive. Agile emerged when faster hardware, the internet and automation made iteration cheap. AI is the next inflection point.
- **Retrofitting AI into Scrum creates a mismatch.** The AI waits days for ceremonies that were sized for human-speed work.
- The two common AI approaches both fall short:
  - **AI-assisted:** AI handles narrow tasks such as autocomplete, while slow rituals still cap velocity.
  - **AI-managed:** AI builds the whole thing in one shot with little human input, and the result usually needs heavy rework.
- AI-DLC sits in between. AI does the heavy lifting across every stage, and humans stay in control of the critical decisions.

## The nine principles (course framing)
1. Reimagine workflows for the AI era. Don't retrofit AI into old ones.
2. Reverse the conversation: AI orchestrates and proposes, humans validate and decide.
3. Design techniques such as DDD are core, not optional, because they give the AI richer context.
4. Align with what AI can really do. It is not reliable fully autonomous, so humans keep responsibility.
5. Keep the practices that help humans and AI collaborate, such as user stories as the shared contract.
6. Streamline roles to cut handoffs, while keeping the oversight that's needed.
7. Use three phases (Inception, Construction, Operations) with strategic validation points.
8. Prefer flexible, AI-recommended workflows over rigid templates.
9. Build on familiar concepts: Sprint becomes **Bolt** (hours or days), Epic becomes **Unit of Work**.

## High-velocity decision making
- **Break problems apart** so each decision is small and quick.
- **Share responsibility.** The person closest to the knowledge decides.
- **Disagree and commit** once a decision is made.
- **Decide with about 70% of the information** for reversible choices. A good decision made fast usually beats a perfect one made late.

### One-way vs two-way doors
| | One-way door | Two-way door |
|---|---|---|
| Reversibility | hard or expensive to undo | easy to undo |
| Examples | data model, public API contract, service boundaries, auth model, cloud or vendor choice, data retention | config file format, naming and casing, comment style, folder layout, library for a leaf utility |
| AI behaviour | ask, with options and trade-offs; wait for a human decision | propose a sensible default, note it in the artifact, let the human override |

### The five critical decision points
1. **Clarification questions:** the human answers what the AI can't know.
2. **Plan approval:** nothing executes before a human approves the plan.
3. **Execution intervention:** the human, or the AI itself, stops execution when reality diverges from the plan.
4. **Artifact quality:** the human reviews each stage's output at the gate.
5. **Iterate or complete:** the human decides whether the output is good enough to move on.

## Mob rituals
- **Mob Elaboration** (Inception): the product owner, developers, QA and other stakeholders share one screen with a facilitator. The AI proposes the breakdown of the Intent into stories, acceptance criteria and Units, and the mob gives a real-time reality check. It turns days of requirements meetings into hours.
- **Mob Construction** (Construction): the team works together on a shared screen. The AI proposes designs and code plans, and humans validate. Teams working on different Units exchange integration contracts early.
- **Mob Testing:** the team analyses test failures together, so the root cause is found once.

When working with a single user, play the mob for them: tag questions by role (`[product]`, `[dev]`, `[qa]`, `[ops]`, `[security]`) so they can bring the right people in.

## Roles
The Product Owner and the Developer stay the core roles. Developers work across frontend, backend, infra and security, with AI support, which cuts handoffs. QA, security and ops join the mob rituals rather than reviewing afterwards.
