# Use-case scoring and readiness check

## 5-point entry gate
A candidate is only scored if it has all five:
1. **Evidence:** at least one Known signal, not just an opinion.
2. **Outcome metric:** a measurable change in the agreed business metric.
3. **Owner:** someone who will decide and champion it.
4. **Build path:** plausible with the team's skills and systems. It needn't be designed yet.
5. **Painkiller:** it solves a real pain, not just a nice-to-have.

A candidate that fails the gate is listed with the reason it failed. It isn't scored.

## Weights (fix these before scoring; don't tune them afterwards)
| Dimension | Default weight | Score 1-5 meaning |
|---|---|---|
| Pain | 25% | how severe and frequent the problem is for the persona |
| Outcome | 25% | expected move in the business metric, in the agreed direction |
| Reach | 15% | how many users or accounts it affects |
| Fit | 10% | alignment with strategy and the product |
| Feasibility | 15% | effort and risk for this team, given current systems |
| Adoption | 10% | how likely users are to change behaviour to use it |

The team may change the weights **before** scoring. Record the final weights in `use-cases.md`.

## Confidence
Base it on the number of **independent** signals: different sources, customers or data sets.
- **High:** 3 or more
- **Medium:** 2
- **Low:** 1

## Decision table
| Weighted score | Confidence | Decision |
|---|---|---|
| ≥ 3.5 | High | **Build first** (only one per team) |
| ≥ 3.5 | Medium or Low | **Prototype / spike to learn** |
| 2.5 – 3.4 | any | **Defer** (revisit with more evidence) |
| < 2.5 | any | **Drop** |

## PR/FAQ readiness check
Rate each question GREEN (clear and evidenced), AMBER (partly) or RED (unknown).
1. Who exactly is the customer?
2. What is their problem or opportunity, in their own words?
3. What is the most important customer benefit?
4. How do we know what customers need (the evidence)?
5. What does the experience look like, end to end?
6. How will we measure success: baseline, target, date?
7. What must be true for this to be viable (cost, legal, operations)?

Any RED means AMBER at best for the whole PR/FAQ. Name the step that would turn it GREEN.
