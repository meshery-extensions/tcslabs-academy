---
type: "page"
id: "opa-and-constraints"
title: "OPA and Constraints"
description: "Use Open Policy Agent to express infrastructure governance rules as code and integrate constraint-based policy evaluation into Meshery workflows."
weight: 2
---

## Open Policy Agent in the Infrastructure Stack

[Open Policy Agent](https://openpolicyagent.org/) (OPA) is a general-purpose policy engine that decouples policy logic from application code. Infrastructure teams use OPA to express rules such as "all container images must come from an approved registry" or "no workload may request more than 4 CPU cores without an approval label." OPA evaluates these rules against structured input data and returns a policy decision.

Meshery integrates OPA as a policy backend alongside its native relationship engine. This gives you two complementary layers:

- **Relationships** - structural graph rules about which component types may or must be connected
- **OPA constraints** - field-level and configuration-level rules expressed in Rego, OPA's policy language

Using both layers gives you full coverage: structural correctness from relationships and configuration correctness from OPA.

## Rego Fundamentals

OPA policies are written in **Rego**, a declarative language designed for querying structured data. A Rego rule is a set of conditions that must all be true for the rule to produce a result.

A simple rule asserting that every container must have resource limits:

```rego
package meshery.policy.resources

violation[msg] {
  container := input.spec.containers[_]
  not container.resources.limits
  msg := sprintf("container '%v' has no resource limits", [container.name])
}
```

Key Rego concepts:

| Concept | Description |
|---------|-------------|
| `package` | Namespace for the policy module |
| `input` | The data being evaluated (design component fields) |
| `violation[msg]` | A rule that collects policy violation messages |
| `_` | Wildcard iteration over array elements |
| `not` | Negation-as-failure |

## Constraint Frameworks

Rather than writing raw Rego for every rule, most teams adopt a **constraint framework** - a pattern in which policy authors write a constraint template (the Rego logic) and operators create constraint instances (the configuration parameters).

This separation matters in practice:

```
ConstraintTemplate  ←  defines the Rego logic once
      │
      └──► Constraint  ←  instantiated with parameters per environment
```

A template that enforces image registry allowlists can be instantiated multiple times: once for dev (lenient registry list), once for production (strict registry list). The Rego logic is maintained in one place.

## Integrating OPA with Meshery

Meshery evaluates OPA policies during design validation. The integration works through Meshery's policy engine, which passes component data as structured JSON to OPA and collects any `violation` messages returned.

To enable OPA-backed constraint evaluation, the Meshery Operator must be running in your cluster:

```bash
mesheryctl system check
```

Confirm that the policy engine component shows a healthy status. If it does not, restart the Meshery system:

```bash
mesheryctl system start
```

## Writing Constraints as Code

A full constraint for enforcing that all `Deployment` components carry a `team` label looks like this in Rego:

```rego
package meshery.policy.labels

violation[msg] {
  component := input.components[_]
  component.kind == "Deployment"
  not component.metadata.labels.team
  msg := sprintf(
    "Deployment '%v' is missing required label 'team'",
    [component.metadata.name]
  )
}
```

The `input.components` field is the array of components Meshery passes from the active design. Each component carries its `kind`, `metadata`, and `spec` as they appear in the design graph.

## Policy-as-Code Principles Applied

Treating OPA policies as code means applying the same practices used for application code:

- **Version control** - commit every Rego file alongside the infrastructure code it governs
- **Testing** - use `opa test` to run unit tests against your Rego modules before publishing them
- **Review** - policy changes go through pull request review, not informal approval
- **Distribution** - Meshery's Catalog lets teams publish constraint sets for organisation-wide use

An example test for the label constraint:

```rego
package meshery.policy.labels_test

test_missing_team_label {
  violation[_] with input as {
    "components": [{
      "kind": "Deployment",
      "metadata": {"name": "api", "labels": {}}
    }]
  }
}

test_present_team_label {
  count(violation) == 0 with input as {
    "components": [{
      "kind": "Deployment",
      "metadata": {"name": "api", "labels": {"team": "platform"}}
    }]
  }
}
```

## OPA Constraints and Coding Agents

When a coding agent submits a generated design for validation, OPA constraint evaluation runs as part of the same pipeline. Violations are returned in the tool response as structured JSON - the agent reads the `violations` array, identifies which components failed which constraints, and can revise the design before surfacing it for human review. This makes OPA constraints a reliable policy guardrail in agentic workflows where a human may not inspect every generated component individually.
