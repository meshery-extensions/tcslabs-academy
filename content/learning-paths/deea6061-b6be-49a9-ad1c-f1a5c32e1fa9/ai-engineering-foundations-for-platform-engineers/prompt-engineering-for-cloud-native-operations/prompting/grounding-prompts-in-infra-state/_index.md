---
type: "page"
id: "grounding-prompts-in-infra-state"
title: "Grounding Prompts in Infrastructure State"
description: "Learn to feed real kubectl and MeshSync output into prompts so your LLM reasons from actual cluster state rather than stale assumptions."
weight: 2
---

An LLM has no direct connection to your cluster. It cannot `kubectl get pods` on its own. Everything it knows about your infrastructure during a prompt session comes from what you put in the context window. If you put nothing in, it reasons from training data - which may be months old, tuned on different cluster configurations, and completely wrong about your specific environment.

Grounding means feeding real, current state into the prompt before asking the model to reason or act. It is the difference between a useful answer and a confident hallucination.

## Why Stale Assumptions Are Dangerous

Consider asking an LLM to "optimize my resource requests for the `api-gateway` deployment." Without real state, the model will:

1. Invent plausible-looking CPU and memory values
2. Assume a resource version or API group that may not match your cluster
3. Reference labels and selectors it cannot know
4. Produce a manifest that looks correct but will fail on apply

With real state, the model has the actual `.spec`, the actual resource requests currently set, the actual label selectors, and the actual API version. The diff between its output and your current state is small and reviewable.

## Sources of Real Infrastructure State

### kubectl Output

`kubectl` is the most direct source of live cluster state. Pipe its output into your prompt:

```bash
kubectl get deployment api-gateway -n production -o yaml
```

```bash
kubectl get pods -n production -l app=api-gateway \
  --output=jsonpath='{range .items[*]}{.metadata.name}{"\t"}{.status.phase}{"\n"}{end}'
```

```bash
kubectl top pods -n production --sort-by=memory
```

Paste the output directly into the user turn of your prompt, clearly labeled:

```text
Current deployment state (kubectl get deployment api-gateway -n production -o yaml):
<paste output here>

Task: Adjust resource requests so that CPU request is 50% of the current limit.
Output only the modified deployment YAML.
```

### mesheryctl and MeshSync

Meshery's MeshSync component continuously reconciles cluster state and stores it in Meshery's graph. You can query that state with `mesheryctl`:

```bash
mesheryctl system check
```

For designs, the Meshery Catalog and imported designs give you a versioned snapshot of intended state:

```bash
mesheryctl design import -f designs/microservices-demo.yaml -s "Kubernetes Manifest"
```

When you have imported a design, you can reference its components by name in your prompts. The LLM can then reason over the declared design alongside the observed state from MeshSync, and identify drift.

### Combining Observed and Declared State

The most powerful grounding pattern is to provide both what your cluster declares (the design) and what it actually runs (live kubectl output), then ask the LLM to identify and reconcile differences:

```text
System:
You are an infrastructure drift analyzer. Given declared design state and observed live state,
identify discrepancies and output a minimal YAML patch to bring live state into alignment
with declared state. Output only valid YAML in a ```yaml block.

User:
Declared design (Meshery design import output):
<paste design YAML>

Observed state (kubectl get deployment -n staging -o yaml):
<paste kubectl output>

Task: Identify fields that differ between declared and observed. Output a strategic merge patch
that, when applied with `kubectl patch`, would align observed state with declared state.
```

## Retrieval Over Recall

The principle here is simple: **always retrieve before you reason**. Do not ask the model to recall what your cluster looks like. Retrieve the actual state with a tool call or shell command, and inject it into the prompt.

This is the same principle behind Retrieval-Augmented Generation (RAG): instead of relying on what the model learned during training, you fetch the current, authoritative source at inference time and give it directly to the model.

For infrastructure operations, the retrieval step should be automated wherever possible. A coding agent that operates on your cluster should:

1. Run `kubectl get <resource> -o yaml` before every modify operation
2. Pass the result into the next LLM turn as context
3. Never proceed with a modify prompt unless the current state was fetched in the same session

## Sizing Context Inputs

Context windows have limits. A full `kubectl get all -A -o yaml` for a large cluster can easily exceed what a model can reason over effectively. Be precise:

| Instead of | Use |
|---|---|
| `kubectl get all -A -o yaml` | `kubectl get deployment api-gateway -n production -o yaml` |
| Full node describe output | `kubectl describe node <name> | grep -A5 "Allocatable"` |
| All pod logs | `kubectl logs <pod> --tail=50` |

Narrow inputs produce better outputs. Give the model exactly the state it needs to answer the question, and nothing more.

## Grounding Checklist

Before sending any infrastructure-change prompt:

- [ ] Have you fetched current state from the cluster in this session?
- [ ] Is the fetched state included in the user turn, clearly labeled?
- [ ] Have you scoped the kubectl query to the specific resource and namespace?
- [ ] If comparing design to live state, are both provided?
- [ ] Does your system prompt instruct the model to refuse ungrounded requests?

Grounding is not optional when the LLM's output will be applied to real infrastructure. Make it a non-negotiable step in every agentic workflow you build.
