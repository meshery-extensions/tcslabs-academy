---
type: "page"
id: "hallucination-guardrails-for-infrastructure"
title: "Hallucination Guardrails for Infrastructure"
description: "Concrete validation layers - schema checks, dry-runs, policy gates, and constrained output formats - that stop AI-generated infrastructure mistakes before they reach production."
weight: 1
---

## Why Infrastructure Hallucinations Are Dangerous

An LLM generating application prose can hallucinate a fact and a reader corrects it. An LLM generating a Kubernetes manifest can hallucinate a field name, a resource kind, or a capacity value - and the cluster will either reject the resource silently or accept it with unexpected behavior. Automated guardrails are the answer because they do not get tired.

Hallucinations take several forms: invented fields (`spec.replicas.strategy` instead of `spec.strategy`), wrong resource kinds (a nonexistent CRD), plausible but invalid values (a memory limit of `512` with no unit suffix), and missing required fields (a `Service` with no `selector`). Each can slip past a rushed human review.

## Layer 1: Schema Validation Before Import

The first guardrail is strict schema validation applied to the agent's output before it enters Meshery. Kubernetes resource schemas are published and machine-readable. Before any AI-generated manifest is imported, run it through a schema validator.

```bash
# Validate against the Kubernetes schema before importing
kubeval agent-output.yaml

# Then import only if validation passes
mesheryctl design import -f agent-output.yaml -s "Kubernetes Manifest"
```

Meshery itself validates designs against the registry of known components and relationships during import. If the agent has invented a field or misnamed a resource kind, the import will surface a validation error rather than silently accepting a broken design.

## Layer 2: Dry-Run Before Apply

Schema validity does not guarantee runtime correctness. A manifest can be schema-valid and still fail to apply due to namespace conflicts, RBAC restrictions, or resource quota violations. The second guardrail is a server-side dry-run against the actual target cluster before any change is promoted.

```bash
kubectl apply --dry-run=server -f agent-output.yaml
```

Server-side dry-run runs the full admission control chain - including validating webhooks - without persisting any state. Integrate this as a required tool call: the agent must not proceed to apply without a successful dry-run response.

## Layer 3: Constrained Output Formats

The most reliable way to prevent hallucinations is to reduce the space of valid outputs. Instead of asking the agent to generate a free-form manifest, provide a template with only the variable fields left open.

```yaml
# Template: agent fills in image, replicas, and resource limits only
apiVersion: apps/v1
kind: Deployment
metadata:
  name: "{{name}}"
  namespace: "{{namespace}}"
spec:
  replicas: "{{replicas}}"
  selector:
    matchLabels:
      app: "{{name}}"
  template:
    spec:
      containers:
        - name: app
          image: "{{image}}"
          resources:
            limits:
              cpu: "{{cpu_limit}}"
              memory: "{{memory_limit}}"
```

The agent fills in values; the structure is not under its control. Hallucinating a field is structurally impossible when the output format is a constrained template rather than a blank canvas.

Meshery designs serve this purpose in a visual workflow. Using Kanvas, you can lock component configurations and expose only specific properties to the agent. The agent's scope of influence is bounded by the design canvas.

## Layer 4: Approval Gates Between Stages

Even with validation and dry-run passing, a human approval gate is the final safety net. The agent generates a design and records its rationale; schema validation and dry-run execute automatically; the diff is surfaced to a named approver; and the approver signs off before Meshery environment promotion runs.

In Meshery, environment promotion gates enforce this structure. A design validated in staging does not reach production until a reviewer explicitly promotes it - a deliberate circuit breaker that keeps human judgment in the critical path.

## Combining the Layers

| Guardrail | What it catches | Where it runs |
|---|---|---|
| Schema validation | Invented fields, wrong kinds | Before import |
| Meshery import validation | Registry mismatches, relationship errors | On import |
| Server-side dry-run | Admission failures, quota violations | Before promote |
| Constrained output templates | Structural hallucinations | At generation time |
| Human approval gate | Judgment calls, context the agent lacks | Before production apply |

No single layer is sufficient. Each catches a class of failure the others do not. Running all five in sequence makes AI-generated infrastructure changes as safe to deploy as human-authored ones.
