---
type: "page"
id: "postmortems-with-llms"
title: "Postmortems with LLMs"
description: "Use an LLM to draft a blameless postmortem from the incident timeline, understand what humans must verify, and turn findings into durable guardrails."
weight: 4
---

## Why Postmortems Are Hard to Write

Blameless postmortems are one of the highest-leverage reliability practices an engineering team can adopt. They are also consistently skipped, abbreviated, or written days after the incident when memory has faded and the team has moved on to the next fire.

The friction is real: after a stressful incident, the last thing an engineer wants to do is reconstruct a detailed timeline from scattered chat logs, runbook outputs, and memory. An LLM can do the reconstruction, compress the drudgework, and produce a first draft that the team refines rather than writes from scratch.

## What an LLM Can Draft

Given the incident timeline - alert timestamps, agent outputs, approval decisions, recovery confirmation - an LLM can generate:

- A structured timeline of events
- A contributing factor analysis (not blame; structural factors)
- A "five whys" chain leading to the root cause
- A list of action items with owners and due dates
- A summary suitable for stakeholder communication

The quality of the draft depends entirely on the quality of the input. If your agent logged its actions with timestamps - and it should - the LLM has the raw material it needs.

## Preparing the Input

Collect the following before invoking the LLM:

```text
1. Alert payload (timestamp, service, threshold breached)
2. Agent's read-phase outputs (pod state, events, log excerpts)
3. Agent's diagnosis summary and root cause hypothesis
4. Human approval record (who approved, at what time, what action)
5. Fix applied (exact command, timestamp)
6. Recovery confirmation (rollout status, error rate after fix)
7. Incident duration (alert time to resolution time)
```

Structure this as a chronological text block. The more structured your input, the more useful the LLM's draft will be. An unstructured wall of chat logs produces a correspondingly unfocused postmortem.

## A Prompt Template

```text
You are helping write a blameless postmortem for a production incident.
Below is the incident timeline. Draft a postmortem with the following sections:
- Summary (2-3 sentences)
- Timeline (bullet list, chronological)
- Contributing Factors (structural, not blame)
- Root Cause
- Action Items (specific, assignable, time-bounded)
- Stakeholder Summary (non-technical, 1 paragraph)

Be factual. Do not speculate beyond what the timeline shows. Flag any gaps in the
timeline where additional information is needed.

TIMELINE:
[paste structured timeline here]
```

The instruction to flag gaps is critical. An LLM that fills in missing information with plausible-sounding inference produces a postmortem that looks complete but contains fabrications. Gaps must be surfaced, not papered over.

## What Humans Must Verify

A postmortem draft from an LLM is a starting point, not a final document. Before publishing, a human must verify:

**Factual accuracy.** Compare every claim in the draft against the raw timeline. LLMs can misread timestamps, conflate events, or state causation where only correlation exists. Check each one.

**Root cause validity.** The LLM identifies patterns; it does not understand your system's history. The root cause section must be reviewed by someone who knows why the build pipeline was configured the way it was, why the tag naming convention exists, and what previous decisions led to this architecture.

**Action items are actionable.** Generic action items ("improve monitoring", "add more tests") are not useful. Each item must name an owner, a specific deliverable, and a due date. Rewrite any action item that fails this test.

**Blamelessness.** Read the contributing factors and root cause sections looking for language that points at individuals rather than systems and processes. Replace it. Blameless means the document is safe for anyone named in it to read.

**Stakeholder summary accuracy.** The non-technical summary may be read by people who will act on it. Verify it is accurate and does not overstate or understate the impact.

## Turning Findings Into Guardrails

The postmortem's action items are the mechanism by which an incident makes the system more resilient. For an agent-assisted workflow, translate action items into three categories:

**Runbook updates.** If the agent's runbook had a gap - a missing stop condition, an ambiguous step, an approval point that came too late - fix it before the next incident.

**Policy guardrails.** If the root cause involved a configuration that should have been blocked - such as a deployment referencing a non-existent image tag - encode that constraint as a policy. The [`designs/policy-guardrails.yaml`](https://docs.meshery.io) design in this academy includes examples of admission policies you can import and extend:

```bash
mesheryctl design import -f designs/policy-guardrails.yaml -s "Kubernetes Manifest"
```

**Observability gaps.** If the incident was detected late because the right metric or alert did not exist, close the gap. Import the observability stack design and add the missing signal:

```bash
mesheryctl design import -f designs/observability-stack.yaml -s "Kubernetes Manifest"
```

## The Postmortem as Training Data

Over time, postmortems accumulate into a corpus of structured incident knowledge. An agent with access to past postmortems - through retrieval-augmented generation or a searchable incident database - can surface relevant past incidents during the diagnosis phase of a new one.

This is the compounding return on good postmortem practice: every well-written postmortem makes the next incident shorter. An LLM that helps draft postmortems consistently, and a retrieval system that surfaces them at diagnosis time, closes the loop between learning and response.

The discipline required is not technical. It is the consistent commitment to write the postmortem, verify its contents, and follow through on the action items. The LLM removes the drafting friction; the humans must supply the judgment and the follow-through.
