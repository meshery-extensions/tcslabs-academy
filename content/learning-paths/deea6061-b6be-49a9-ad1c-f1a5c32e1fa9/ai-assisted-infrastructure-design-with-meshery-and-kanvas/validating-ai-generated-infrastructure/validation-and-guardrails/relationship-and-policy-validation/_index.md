---
type: "page"
id: "relationship-and-policy-validation"
title: "Relationship and Policy Validation"
description: "Understand how Meshery validates designs through model relationships and policy rules, catching semantic errors a plain schema check cannot detect."
weight: 1
---

## Beyond Schema Validation

A YAML linter tells you whether a manifest is structurally well-formed. It does not tell you whether a Deployment's label selector actually matches the labels on its Pods, whether a Service points to Pods that exist in the design, or whether a container is missing the resource requests that a cluster policy requires. These are semantic errors - and they are exactly the category of mistake an LLM is most likely to introduce.

Meshery addresses this through two layered mechanisms: the **registry** (models, components, and relationships) and the **policy engine**.

## The Registry: Models, Components, and Relationships

Every Kubernetes resource type - and resources from hundreds of other cloud native tools - is represented in the Meshery registry as a **component** belonging to a **model**. A component captures the schema for a resource; a **relationship** captures how two components interact.

Relationships encode real operational semantics:

| Relationship type | Example |
|---|---|
| Hierarchical | A Deployment owns ReplicaSets; a StatefulSet owns PersistentVolumeClaims |
| Network | A Service selects Pods via `spec.selector` |
| Permission | A ServiceAccount binds to a Role through a RoleBinding |
| Volume | A Pod mounts a PersistentVolumeClaim |

When you import a design - whether you authored it by hand or an LLM generated it - Meshery resolves each component against the registry and evaluates declared relationships. If a Service's selector does not match any Pod label set in the design, Meshery surfaces a relationship error. The error is semantic: the YAML was valid, but the wiring was wrong.

## The Policy Engine

On top of registry-level relationship checks, Meshery applies an **OPA-based policy engine** ([openpolicyagent.org](https://www.openpolicyagent.org)) that evaluates designs against Rego rules. Policies are attached to environments or workspaces and run automatically when a design is imported or saved.

Policy rules can enforce constraints that no schema can express:

- Every container must declare `resources.limits.cpu` and `resources.limits.memory`.
- No Deployment may run containers as `root` (`securityContext.runAsNonRoot: true` must be present).
- Images must reference a digest or a pinned tag - not `latest`.
- Every workload must carry a `team` label from an approved set.

When Meshery evaluates a design against these rules, it returns a structured report: which components violated which rules, with the path inside the component where the violation occurred. This is what a plain schema check cannot give you.

## Importing and Validating a Design

To see this in practice, import an AI-generated manifest using `mesheryctl`:

```bash
mesheryctl design import -f my-generated-design.yaml -s "Kubernetes Manifest"
```

Meshery processes the import, resolves components against the registry, evaluates relationships, and runs policy rules. Any errors appear in the Meshery UI under the design's **Validation** tab, and they are also printed to the CLI output.

You can run a quick system check before importing to confirm your Meshery instance is healthy:

```bash
mesheryctl system check
```

## What Semantic Errors Look Like

Here are concrete examples of errors that relationship and policy validation catch - and that a schema check would pass:

```text
[RELATIONSHIP ERROR] Service "api-svc": selector {app: api} matches 0 components in design.
  Hint: Deployment "api" uses label {app: api-server}. Selector mismatch.

[POLICY VIOLATION] Deployment "worker": container "processor" missing resources.limits.
  Rule: all-containers-must-declare-limits (env: production)

[POLICY VIOLATION] Deployment "frontend": container "nginx" image tag is "latest".
  Rule: no-mutable-image-tags (env: production)
```

Each error identifies the component, the field path, and the rule that triggered it. This output is actionable: you know exactly what to fix and where.

## Why This Matters for AI-Generated Infrastructure

An LLM producing infrastructure from a natural-language prompt has no runtime awareness of your cluster's policies, your team's label conventions, or the relationship topology Meshery has modeled. It works from training data and context - which means it will produce plausible but subtly wrong wiring more often than a human expert would.

Meshery's relationship and policy validation is the first automated gate in the human-in-the-loop workflow. It narrows the gap between "the LLM produced something" and "the design is safe to deploy." Treat its output as mandatory, not advisory: do not move a design forward until the validation report is clean.
