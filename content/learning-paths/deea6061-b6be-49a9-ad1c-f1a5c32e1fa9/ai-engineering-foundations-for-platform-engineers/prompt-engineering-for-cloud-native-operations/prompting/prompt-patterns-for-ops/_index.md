---
type: "page"
id: "prompt-patterns-for-ops"
title: "Prompt Patterns for Operations"
description: "Apply proven prompt patterns - few-shot, checklist, step-by-step decomposition, and role prompting - to recurring cloud native operations tasks."
weight: 4
---

Prompt patterns are reusable structures that reliably produce a certain class of output. Rather than writing every prompt from scratch, you build a library of patterns suited to your operations domain and instantiate them for each specific task. This lesson covers the four patterns most useful for cloud native operations and shows how each maps to real Meshery and Kubernetes workflows.

## Pattern 1: Few-Shot Prompting

Few-shot prompting provides the model with two or three complete examples of input-output pairs before presenting the actual task. The examples calibrate the model's output structure, tone, and precision without requiring an explicit schema.

### When to Use It

Use few-shot prompting when:
- Your output format is complex or organization-specific (custom annotation schemes, non-standard label sets)
- You want the model to match an existing pattern in your codebase or design catalog
- Zero-shot prompting is producing structurally inconsistent results

### Example: Generating HPA Manifests from Specs

```text
Example 1:
Input: service=checkout, namespace=payments, min=2, max=8, cpu_target=65
Output:
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: checkout-hpa
  namespace: payments
  labels:
    team: payments
    managed-by: meshery
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: checkout
  minReplicas: 2
  maxReplicas: 8
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 65

Example 2:
Input: service=catalog, namespace=commerce, min=1, max=5, cpu_target=70
Output:
[... second example ...]

Now produce for:
Input: service=inventory, namespace=commerce, min=3, max=12, cpu_target=60
```

The model learns from the examples that it should include the `team` and `managed-by` labels - conventions that would require verbose instructions to describe explicitly.

## Pattern 2: Checklist Prompting

Checklist prompting asks the model to verify a list of conditions before producing output, or to produce output that satisfies a specific checklist. It is the prompt equivalent of a pre-flight check.

### When to Use It

Use checklist prompting for:
- Pre-deploy validation (does this manifest satisfy our baseline standards?)
- Security reviews (does this service account request minimal permissions?)
- Drift detection (does observed state match declared state on these specific fields?)

### Example: Manifest Security Review

```text
Review the following Kubernetes Deployment manifest against this security checklist.
For each item, output a line with the item text, then PASS or FAIL, then a one-line reason.

Checklist:
1. Container does not run as root (runAsNonRoot: true or runAsUser > 0)
2. Container image is not tagged :latest
3. readOnlyRootFilesystem is set to true
4. No hostPid, hostNetwork, or hostIPC is set to true
5. Resource requests and limits are both set for CPU and memory

Manifest:
<paste manifest>
```

This pattern produces output that is easy to parse and easy to audit. It also makes the model's reasoning transparent - you can see exactly which checks failed and why.

## Pattern 3: Step-by-Step Decomposition

Complex operations tasks are too large to accomplish in a single LLM turn. Step-by-step decomposition breaks a high-level goal into an ordered sequence of concrete steps, where each step is small enough for the model to handle accurately.

### When to Use It

Use decomposition when:
- The task involves multiple resources or multiple namespaces
- The task has ordering constraints (create ConfigMap before Deployment)
- You want a human review point between steps
- The task involves both reading state and writing new configuration

### Example: Migrating a Workload to a New Namespace

```text
I need to migrate the `api-gateway` workload from the `staging` namespace to the `production` namespace.

Break this into an ordered list of steps. For each step, provide:
- Step number and name
- The exact kubectl or mesheryctl command to run
- What to verify after running it before proceeding to the next step

Constraints:
- Do not delete the staging namespace resources until production is confirmed healthy
- Preserve all existing labels and annotations
- The Meshery design for this workload is in designs/microservices-demo.yaml
```

The decomposed output becomes a runnable procedure. A coding agent can execute each step, capture the verification output, and gate on it before proceeding - providing natural human-in-the-loop checkpoints.

## Pattern 4: Role Prompting

Role prompting assigns the model a specific expert persona that shapes how it reasons and what it emphasizes. For infrastructure operations, roles like "senior SRE", "security reviewer", or "cost optimization analyst" produce noticeably different outputs from the same input.

### When to Use It

Use role prompting when:
- You want a specific analytical lens applied to the same input (security vs. reliability vs. cost)
- You want the model to reason in a domain with established conventions (SRE, FinOps)
- You want the model to challenge a configuration rather than just describe it

### Example: Reliability Review

```text
System:
You are a senior site reliability engineer reviewing Kubernetes configurations for
production readiness. You are skeptical of any configuration that lacks explicit
resource limits, missing liveness/readiness probes, or single-replica deployments.
You output findings in order of severity: Critical, High, Medium, Low.

User:
Review this deployment for production readiness:
<paste deployment YAML>
```

The role shapes the model's focus. Without the SRE persona, the same prompt might produce a neutral description of the manifest. With it, you get an opinionated, prioritized findings list that is actionable.

## Combining Patterns

These patterns compose. A production-readiness pipeline might use:

1. **Role prompting** in the system prompt (senior SRE)
2. **Grounding** in the user turn (live kubectl output + designs/observability-stack.yaml)
3. **Checklist prompting** to structure the review
4. **Step-by-step decomposition** to produce a remediation plan

```text
System:
You are a senior SRE. Review configurations for reliability, not for style.

User:
Checklist for this deployment review:
1. Single points of failure (replicas < 2)
2. Missing resource limits
3. Missing health probes
4. No PodDisruptionBudget
5. No NetworkPolicy

Current state:
<kubectl output>

After the checklist, produce a step-by-step remediation plan with the exact manifests
to apply for any FAIL items.
```

Combining patterns does not add complexity - it reduces ambiguity. Each pattern constrains a different dimension of the model's output, and together they narrow the space of acceptable responses to exactly what your agentic pipeline needs.
