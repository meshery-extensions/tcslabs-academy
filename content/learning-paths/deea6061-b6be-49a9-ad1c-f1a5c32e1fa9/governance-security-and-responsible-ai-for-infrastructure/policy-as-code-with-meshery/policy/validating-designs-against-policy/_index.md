---
type: "page"
id: "validating-designs-against-policy"
title: "Validating Designs Against Policy"
description: "Run policy validation on Meshery designs - including agent-generated ones - before deployment, surface violations clearly, and enforce fail-closed behavior."
weight: 3
---

## Why Validate Before Deploy

A design that passes visual review can still violate infrastructure policy. A missing `NetworkPolicy`, a container without resource limits, or a `Service` of the wrong type can all slip through manual inspection - especially in large designs produced by a coding agent with many components.

Meshery's validation pipeline evaluates a design against the full policy stack - JSON Schema, relationship rules, and OPA constraints - before the design touches any cluster. The result is a structured violation report: actionable, machine-readable, and surfaced before any `kubectl apply` runs.

## The Validation Pipeline

Meshery runs three evaluation phases in sequence when you validate a design:

```
Design (YAML / Kanvas graph)
        │
        ▼
1. Schema Validation
   └─ Check each component's fields against model-defined JSON Schema
        │
        ▼
2. Relationship Evaluation
   └─ Walk the component graph; apply allow/deny/require relationship rules
        │
        ▼
3. OPA Constraint Evaluation
   └─ Pass component data to policy engine; collect violation messages
        │
        ▼
Violation Report (structured JSON)
```

All three phases must pass for a design to be considered policy-conformant. A failure at any phase stops promotion through environment gates.

## Validating via the CLI

Import a design and trigger validation in one step:

```bash
mesheryctl design import -f designs/policy-guardrails.yaml -s "Kubernetes Manifest"
```

Meshery imports the design and immediately runs schema validation. To view the full violation report after import, use the Meshery UI or query the API endpoint the CLI prints after a successful import.

For a design already saved in Meshery, you can re-validate it from Kanvas by opening the design and selecting **Validate** from the action menu. The results panel lists each violation with:

- The component ID and kind
- The violated rule (schema field, relationship name, or OPA constraint package)
- A severity level (`error` blocks promotion; `warning` does not)
- A human-readable explanation

## Fail-Closed Behavior

Meshery's validation is **fail-closed by default**: if the policy engine cannot reach the OPA backend, validation returns an error rather than a pass. This prevents a connectivity or configuration failure from silently bypassing policy checks.

The fail-closed posture means:

- A network partition between Meshery and OPA does not allow unchecked designs through
- A misconfigured constraint template that fails to compile returns an error, not a vacuous pass
- Unknown component kinds - those not in the registry - are flagged rather than ignored

You can verify that the policy engine is reachable before a critical validation run:

```bash
mesheryctl system check
```

If the policy engine component shows unhealthy, resolve it before proceeding. Do not disable validation to work around a connectivity issue.

## Surfacing Violations to Operators and Agents

Violation output is designed to be readable by both humans and machines.

A human operator reviewing in the Kanvas UI sees violations overlaid on the design graph: components with policy errors are highlighted, and clicking a component shows the specific violation detail.

A coding agent calling the validation API receives a JSON response with a `violations` array:

```json
{
  "violations": [
    {
      "componentId": "deploy-api-7f2c",
      "kind": "Deployment",
      "rule": "meshery.policy.labels/missing-team-label",
      "severity": "error",
      "message": "Deployment 'api' is missing required label 'team'"
    }
  ]
}
```

The agent reads this array, identifies the failing components, updates the design, and re-submits for validation. This loop continues until the violation list is empty - at which point the design is ready for human review and environment promotion.

## Validating Agent-Generated Designs

When an LLM generates infrastructure configuration, the output should never go directly to a cluster. The recommended flow is:

1. The agent generates YAML and calls the Meshery import tool
2. Meshery validates against the full policy stack
3. If violations are returned, the agent revises and re-validates
4. When no violations remain, a human reviews the policy-conformant design
5. The human approves and Meshery promotes through environment gates

Policy validation is not a substitute for human review - it ensures the reviewer sees a design that already meets baseline standards.

**Import the reference design to explore violation types:**

```bash
mesheryctl design import -f designs/policy-guardrails.yaml -s "Kubernetes Manifest"
```

The `policy-guardrails.yaml` design intentionally triggers relationship and OPA violations. Importing it gives you a concrete report to study before applying validation to your own designs. Treat `error` severity as a hard gate and `warning` as a soft signal: block promotion on errors, log warnings for tracking.
