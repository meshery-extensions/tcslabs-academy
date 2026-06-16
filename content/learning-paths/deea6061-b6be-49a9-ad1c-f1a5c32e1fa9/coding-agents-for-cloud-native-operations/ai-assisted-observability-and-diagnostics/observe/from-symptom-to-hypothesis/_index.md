---
type: "page"
id: "from-symptom-to-hypothesis"
title: "From Symptom to Hypothesis"
description: "A disciplined method for moving from an observed symptom through state gathering and hypothesis formation to the cheapest possible test - with an agent assisting at each step."
weight: 4
---

## Why Discipline Matters in AI-Assisted Diagnosis

A coding agent is fast. That speed is a liability as much as an asset during incident diagnosis. An agent offered a symptom will often jump toward an explanation and then toward a fix - skipping the state-gathering and hypothesis-ranking steps that separate systematic diagnosis from guesswork. The engineer's job is to enforce the workflow; the agent's job is to accelerate it.

The method described here has four phases. Each phase has a defined output. The agent participates in phases two and three; the engineer owns phases one and four.

## Phase 1: Observe the Symptom (Engineer)

A symptom is a specific, observable deviation from expected behavior. It is not a hypothesis. "The service is slow" is not a symptom. "P99 latency for the checkout service crossed 2000ms at 14:28 UTC, up from a 200ms baseline, and the error rate crossed 5%" is a symptom.

Before involving the agent, write down:

- **What changed** - the observable metric, status, or behavior that is wrong
- **When it started** - as precisely as possible
- **What changed around that time** - deployments, configuration changes, external events
- **What is not wrong** - which related services or components are behaving normally

This scoping protects the agent from receiving ambiguous input. An agent given "something is wrong with checkout" will form hypotheses about everything. An agent given the precise symptom above can focus.

## Phase 2: Gather State (Engineer + Agent)

With the symptom defined, gather the signals that could illuminate it. This is the step where Meshery's structured output pays off.

The agent's role here is assistance, not leadership. Use it to:

- Format and deduplicate events collected via `kubectl`
- Extract the relevant component status from Meshery's model
- Summarize log sections that are too long to read manually

The engineer decides what to gather. The agent helps process it. A useful prompt for this phase:

```text
I have gathered the following signals related to a latency spike in the checkout
service starting at 14:28 UTC. Summarize each signal section in two sentences,
note any entries that are time-correlated with 14:28, and flag any gaps in coverage.

## Signal: ...
```

The output of this phase is a structured state snapshot - a document you could hand to a colleague and they would understand the situation without further explanation.

## Phase 3: Form Hypotheses (Agent-Assisted, Engineer-Reviewed)

With state gathered, ask the agent to produce a ranked list of hypotheses. This is the diagnostic prompt you constructed in the previous lesson. The rules apply:

- Require verbatim evidence for every hypothesis
- Ask for confidence levels with justifications
- Ask for gaps - information that would change the ranking
- Do not ask for fixes

Review the output critically. An agent's hypothesis ranking is an input to your thinking, not a conclusion. Ask: does the top hypothesis actually follow from the cited evidence, or is the agent pattern-matching to a common scenario that happens to fit loosely?

When a hypothesis lacks strong evidence, demote it. When the evidence for a hypothesis is unambiguous (as in the OOMKilled example from the previous lesson), prioritize testing it first.

## Phase 4: Test the Cheapest Hypothesis First (Engineer)

Hypotheses are not solutions. Testing one hypothesis costs time, and testing the wrong hypothesis first costs the most time. Order your tests by cost:

| Cost tier | Example test |
|---|---|
| Zero-cost read | Check resource limits in the component spec via Meshery or `kubectl describe` |
| Low-cost read | Pull current metrics from Grafana for the suspect component |
| Medium-cost action | Restart the component; observe if the symptom resolves |
| High-cost action | Roll back a deployment; restore a configuration change |

Work through the tiers in order. If the zero-cost check answers the question, you are done. If the symptom is a memory limit violation - as the OOMKilled signals suggest - then checking the resource limit spec costs nothing and either confirms or eliminates the hypothesis before you touch the cluster.

When a hypothesis is tested and falsified, return to phase three. Give the agent the test result and ask it to re-rank:

```text
We tested hypothesis 1 (OOM due to misconfigured memory limit).
Finding: memory limit is set correctly at 256Mi and the application's
historical usage never exceeded 180Mi. This hypothesis is false.

Given this new information, re-rank the remaining hypotheses and update
your evidence citations.
```

This loop - observe, gather, hypothesize, test, return - is the agentic diagnostic cycle. The agent makes it faster; the engineer makes it rigorous.

## Keeping the Agent in the Loop Without Letting It Lead

The most common failure mode in AI-assisted diagnosis is the engineer abdicating judgment. The agent proposes a fix, the engineer applies it, the symptom resolves, and no one actually knows what the root cause was. The next incident is harder to diagnose because the previous one was not understood.

Structural safeguards:

- **Never act on an agent recommendation without tracing its evidence.** If the evidence is in your signals, you can verify it. If it is not, the recommendation is speculation.
- **Keep the human-in-the-loop at every state-changing step.** Gathering data is safe to delegate. Restarting components or applying changes is not.
- **Document the outcome.** After resolution, record the symptom, the correct hypothesis, the falsified hypotheses, and the fix. This becomes training data for better prompts next time.

Meshery's design and environment model supports this discipline. Because all your infrastructure state flows through Meshery and MeshSync, you have a consistent, auditable record of what the cluster looked like during the incident - not just what you happened to capture in a terminal session.
