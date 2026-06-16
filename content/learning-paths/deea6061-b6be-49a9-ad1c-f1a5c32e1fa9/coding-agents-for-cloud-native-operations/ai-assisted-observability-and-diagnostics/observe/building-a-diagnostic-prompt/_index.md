---
type: "page"
id: "building-a-diagnostic-prompt"
title: "Building a Diagnostic Prompt"
description: "Construct a prompt that turns raw observability signals into a ranked set of likely causes, specifying what context to include and how to ask for evidence."
weight: 3
---

## The Difference Between a Question and a Diagnostic Prompt

Typing "what is wrong?" into an agent is a question. A diagnostic prompt is a structured instruction that tells the agent what role to take, what data it is looking at, what form the output should take, and what constraints apply. The difference in output quality is significant.

A well-constructed diagnostic prompt does four things:

1. Establishes a role and scope
2. Provides bounded, labeled context
3. Specifies the output structure
4. Constrains what the agent should and should not do

Each of these deserves deliberate attention.

## Role and Scope

Start by telling the agent what it is and what it is working on. This is not ceremony - it activates the relevant reasoning patterns the model has learned:

```text
You are a platform engineer diagnosing a production incident in a Kubernetes cluster
managed by Meshery. Your task is to analyze the provided signals and produce a ranked
list of likely root causes. You are NOT to suggest remediation steps at this stage.
```

The role statement bounds the agent's response domain. Without it, the agent may wander into architecture advice, cost optimization, or generic Kubernetes best practices - none of which help you right now.

## Providing Bounded, Labeled Context

Group your signals into clearly labeled sections. Each section should state:

- **What the data is** (event stream, container logs, MeshSync component status)
- **The scope** (namespace, component name, time window)
- **How it was collected** (so downstream readers can reproduce it)

A template structure:

```text
## Signal: MeshSync Component Status
Source: Meshery / MeshSync reconciliation
Scope: namespace=payments, component=checkout-service
Collected: 2024-01-15T14:32:00Z

<component status JSON>

## Signal: Kubernetes Warning Events
Source: kubectl get events -n payments --field-selector type=Warning
Scope: last 30 minutes
Collected: 2024-01-15T14:35:00Z

<events JSON>

## Signal: Container Logs
Source: kubectl logs -n payments checkout-service-7d9f8b-xkj2p --since=30m
Scope: current container only

<log lines>
```

This format is verbose but it pays for itself. When the agent cites evidence, you can trace it back to a specific signal section. When you review the agent's output with a colleague, the provenance is self-documenting.

## Specifying Output Structure

Tell the agent exactly what to produce. Unstructured output from a diagnostic agent is hard to act on and hard to review. A useful output template:

```text
Produce your analysis in the following structure:

### Summary
Two to three sentences describing what the signals show overall.

### Ranked Hypotheses
Number each hypothesis 1 through N, most likely first. For each:
- Hypothesis: one sentence stating the proposed cause
- Evidence: verbatim quote(s) from the input that support this hypothesis
- Confidence: High / Medium / Low with a one-sentence justification

### Gaps
List any information that would materially change the analysis if available.
```

The `Evidence` field is the most important constraint. Requiring verbatim quotes forces the agent to anchor its reasoning to what is actually present in the input rather than constructing plausible-sounding evidence. If a hypothesis has no verbatim evidence, it belongs in the `Gaps` section, not the `Ranked Hypotheses` section.

## Asking for Evidence

Evidence requirements serve two functions: they suppress hallucination, and they make the output verifiable by a human reviewer. Structure the evidence constraint explicitly:

```text
For every hypothesis you state, you MUST include at least one verbatim quote
from the provided signals that supports it. Do not paraphrase. If you cannot
find direct evidence in the signals, state "No direct evidence found" and
lower your confidence to Low.
```

This instruction - paired with input that is small enough to verify - makes the agent's output auditable. You can read the hypothesis, find the quoted line in your event JSON or log file, and confirm or refute the citation yourself.

## What Not to Include

Avoid putting the following in a diagnostic prompt:

| What | Why |
|---|---|
| Remediation steps | Diagnostic and remediation are separate phases; mixing them causes the agent to bias toward conclusions that justify its preferred fix |
| Open-ended history | "Tell me everything that could cause this" produces generic responses; ground the agent in the specific signals you have |
| Multiple unrelated symptoms | One incident per prompt; mixing symptoms muddies the hypothesis ranking |
| Credentials or secrets | Never include kubeconfig, tokens, or passwords in prompt context |

## A Complete Example

Putting it all together for a checkout service incident:

```text
You are a platform engineer diagnosing an incident in a Kubernetes cluster managed
by Meshery. Analyze the signals below and produce a ranked list of likely root causes.
Do not suggest fixes.

For each hypothesis, include verbatim evidence from the signals. State confidence
as High / Medium / Low with a one-sentence justification.

## Signal: MeshSync Component Status
Scope: namespace=payments, component=checkout-service, collected=2024-01-15T14:32Z
{"status":"CrashLoopBackOff","restartCount":7,"lastRestartReason":"OOMKilled"}

## Signal: Kubernetes Warning Events (last 30m, namespace=payments)
[{"reason":"OOMKilling","message":"Memory limit exceeded","count":7},
 {"reason":"BackOff","message":"Back-off restarting failed container","count":12}]

## Signal: Container Logs (last 30m)
2024-01-15T14:28:44Z FATAL: heap allocation failed, requested 512MB
2024-01-15T14:28:44Z signal: killed

Output structure: Summary / Ranked Hypotheses / Gaps
```

This prompt is short, scoped, labeled, and constrained. The agent has enough signal to form a defensible hypothesis and enough constraints to avoid speculating beyond the evidence.
