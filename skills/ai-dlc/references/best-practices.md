# Seven practices that keep AI-DLC on track

Common failure modes:
- solving a complex problem in one shot
- losing control of solution quality
- drowning the AI in irrelevant context
- accepting over-engineered proposals
- applying design patterns the AI can't implement reliably
- modernizing code nobody understands yet

Each practice below counters one or more of these.

## 1. Never single-shot a multi-step problem
Break the work into tasks, write a plan for each, get approval, and execute step by step. "Build an e-commerce platform" is an Intent, not a prompt. It becomes Units, each Unit becomes Bolts, and each Bolt gets a plan.
**Agent check:** if a request needs more than about 3 distinct steps or touches more than one component, write a plan file before you write any code.

## 2. Maximize semantics per token
Give the AI meaningful, relevant information and filter out noise. Prefer the domain glossary, acceptance criteria, interface contracts and the 3 relevant files over the whole repo.
**Agent check:** before loading context, ask "does this file change what I'll do?" If not, don't load it. Summarise long documents into the artifact instead of re-reading them.

## 3. Refresh context strategically
Write decisions down in files (`aidlc-docs/`) so they don't depend on chat memory. Start each stage by loading only that stage's inputs, and start a fresh session when context gets cluttered.
**Agent check:** every decision made in chat gets written into the relevant artifact before the gate.

## 4. Rein in the AI's approach
AI tends to overreach: extra features, extra abstraction layers, speculative configurability. Set clear boundaries and question any feature nobody asked for.
**Agent check:** every element of a plan must trace to a requirement, story or approved NFR. List anything else under "Proposed extras (not approved)" and ask.

## 5. Handle design with care
Check that the AI can actually implement a pattern well before committing to it. Pivot to a simpler design when generated code keeps fighting the pattern. Good design gives the AI context, but over-elaborate patterns produce brittle code.
**Agent check:** for each non-trivial pattern (CQRS, event sourcing, hexagonal, and so on), write one line on why it's needed and a simpler fallback. Prefer the simpler one unless an NFR requires the complex one.

## 6. Contextualize legacy systems before modernizing
Before changing a legacy system, build a semantic model of it:
- **Static model:** components, responsibilities, relationships.
- **Dynamic model:** how components interact for the key use cases.

Humans validate both before any redesign.
**Agent check:** in brownfield work, Reverse Engineering artifacts must be current before Requirements Analysis.

## 7. Refactor with surgical precision
Business logic hides in legacy code. Refactor in small steps, and validate each one by **A/B comparison** (old vs new behaviour on the same inputs) with cross-functional review, because product and QA know which quirks are really business rules.
**Agent check:** for each refactor step, record the inputs used for comparison and the observed equivalence (tests, snapshots, recorded traffic). Flag every behaviour difference for a human decision.
