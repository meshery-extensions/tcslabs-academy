---
type: "page"
id: "system-and-user-instructions"
title: "System and User Instructions"
description: "Understand the role split between system and user instructions and learn to write prompts that give an LLM clear task scope, firm constraints, and an unambiguous output contract."
weight: 1
---

Every LLM conversation has at least two instruction channels: the **system prompt** and the **user turn**. Getting this split right is the single most impactful thing you can do before optimizing any other aspect of your prompts for cloud native operations.

## The Two Roles

### System Instructions

The system prompt runs before any user message and is not visible to end users in most deployments. Think of it as the operator's brief to the LLM - it sets identity, scope, and non-negotiable constraints.

For infrastructure operations, system instructions should cover:

- **Identity and scope** - what the agent is and what it is authorized to do. Example: "You are an infrastructure assistant for a Kubernetes platform team. You may suggest configuration changes, but you must never suggest deleting a namespace unless the user explicitly provides the namespace name and confirms deletion."
- **Output contract** - what format every response must follow. Example: "All responses that include Kubernetes configuration must be valid YAML fenced in a ```yaml block. Do not include explanatory prose inside the YAML block."
- **Grounding rules** - what the agent should refuse to do without real data. Example: "Do not make assumptions about running workloads. If the user has not provided `kubectl get` output or MeshSync state, ask for it before proceeding."
- **Persona constraints** - tone, verbosity, and what the agent should decline. Terse, tool-oriented responses are more useful to an operator than conversational ones.

### User Instructions

The user turn is where specific tasks arrive - either from a human or from an orchestrating agent. User instructions should be specific, bounded, and include the relevant state. A vague user turn like "fix my deployment" forces the LLM to guess, and guesses produce unreliable output.

A well-formed user turn has three parts:

| Part | Purpose | Example |
|---|---|---|
| Task | What to produce | "Generate a HorizontalPodAutoscaler manifest" |
| Constraints | Limits on the output | "Target CPU utilization: 60%. Min replicas: 2. Max replicas: 10." |
| State context | Real data to reason over | *(paste of `kubectl get deploy -n production -o yaml`)* |

## Designing Clear Instructions

### Be Specific About the Task

Vague: "Help me scale my app."

Specific: "Write a Kubernetes HorizontalPodAutoscaler for the `api-gateway` deployment in the `production` namespace. Target CPU utilization is 60%. Minimum replicas: 2. Maximum replicas: 10."

The specific version leaves no room for interpretation. The LLM does not need to ask a clarifying question - it has everything required to produce a correct manifest.

### Encode Constraints Explicitly

Constraints you leave out of the prompt become constraints the LLM invents - or ignores. Common constraints for infrastructure prompts:

- Resource limits and requests
- Namespaces in scope (and namespaces that are out of scope)
- Labels and annotations that must be preserved
- Fields that must not be changed
- The Kubernetes API version to target

### Define the Output Format in the System Prompt

If your coding agent will parse the response programmatically, the output format must be non-negotiable and defined in the system prompt - not asked for in the user turn. A user turn instruction like "please output YAML" can be overridden by a long conversation; a system prompt instruction cannot.

```text
System:
You are an infrastructure configuration assistant.
Every response that contains Kubernetes configuration MUST be enclosed in a ```yaml code block.
Do not include any text inside that block except valid YAML.
If you cannot produce valid YAML for the requested task, say so in plain text outside any code block.
```

## Splitting Responsibility Between Prompts

A useful mental model: the system prompt owns **what the agent is**, and the user turn owns **what the agent should do right now**. If a constraint applies to every interaction - authorization scope, output format, grounding rules - it belongs in the system prompt. If a constraint applies only to this request - the specific namespace, the specific resource count - it belongs in the user turn.

Mixing these produces fragile prompts. When authorization scope is in the user turn, a future user turn can accidentally override it. When task-specific constraints are in the system prompt, they create noise and can conflict with legitimate future requests.

## Practical Checklist

Before sending a prompt that will drive a real infrastructure change through Meshery, verify:

- [ ] System prompt defines the agent's authorization scope
- [ ] System prompt specifies the output format
- [ ] System prompt includes grounding rules (no assumptions without real state)
- [ ] User turn names the specific resource, namespace, and cluster
- [ ] User turn includes or references actual cluster state
- [ ] User turn states constraints explicitly (limits, labels, versions)
- [ ] There is no ambiguity about what "done" looks like

Clear instructions are not just a best practice - they are a safety mechanism. An LLM that has been given precise scope and format requirements is significantly less likely to produce output that causes an unintended change to your cluster.
