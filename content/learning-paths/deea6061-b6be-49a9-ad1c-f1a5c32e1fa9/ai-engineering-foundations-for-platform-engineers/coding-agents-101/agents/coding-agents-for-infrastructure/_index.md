---
type: "page"
id: "coding-agents-for-infrastructure"
title: "Coding Agents for Infrastructure"
description: "Apply the agentic loop to real infrastructure work with Meshery and Kubernetes, and understand where agents add value and where they need supervision."
weight: 3
---

## Why Infrastructure Is a Good Fit

Infrastructure work is unusually well-suited to agent-based automation. The reasons are structural:

- **State is observable.** Kubernetes and Meshery expose rich, queryable APIs. An agent can read cluster state, Meshery designs, MeshSync data, and component status without scraping logs or guessing.
- **Actions are declarative.** Applying a change means submitting a manifest or running a `mesheryctl` command - discrete, auditable actions with predictable schemas.
- **Feedback is fast.** After applying a change, an agent can immediately query whether the desired state was reached. The reconciliation loop gives the agent a reliable signal.
- **Failures are structured.** Kubernetes events, pod conditions, and Meshery's validation output are machine-readable. An agent can parse them without needing to understand free-form prose.

This combination - observable state, declarative actions, fast feedback, structured failures - maps cleanly onto the plan-act-observe loop.

## Reading Cluster and Meshery State

Before proposing any change, a well-designed agent reads current state. Tools it might use:

```bash
# Check Meshery's connectivity and adapter status
mesheryctl system check

# List current designs registered in Meshery
mesheryctl design list

# Read cluster resources via kubectl
kubectl get deployments -n production -o yaml

# Query events for a specific workload
kubectl get events --field-selector involvedObject.name=my-app -n production
```

An agent given these tools can construct a complete picture of the current state before deciding what to propose. This is the equivalent of a human operator running their pre-change checklist - except the agent does it every time, without skipping steps.

MeshSync, Meshery's cluster synchronization component, continuously reconciles cluster state into Meshery's data model. An agent connected to Meshery via its API or MCP server can query MeshSync-derived state directly, without needing raw `kubectl` access.

## Proposing and Applying Changes

Once the agent understands current state, it can propose a change. The typical flow:

1. Agent reads current state (cluster resources, Meshery design, policy constraints).
2. Agent identifies the gap between current and desired state.
3. Agent generates a candidate manifest or `mesheryctl` command sequence.
4. Agent presents the proposal for human review (see the next lesson for the approval gate).
5. Human approves; agent applies.

For Meshery-managed infrastructure, the apply step often uses a design import:

```bash
mesheryctl design import -f designs/microservices-demo.yaml -s "Kubernetes Manifest"
```

Or a performance test against a defined profile:

```bash
mesheryctl perf apply --profile my-baseline-profile
```

The agent does not need to know the internals of these commands - it needs to know the tool definitions, which describe what parameters are required and what the command does. The framework handles execution.

## What Agents Do Well

| Task | Agent value |
|---|---|
| Summarizing cluster state | High - reads many resources, correlates across namespaces |
| Identifying failing workloads | High - structured event data maps well to pattern matching |
| Generating draft manifests | High - strong prior on Kubernetes YAML schemas |
| Running performance tests | High - deterministic command, structured output |
| Importing and validating designs | High - Meshery's validation output is structured |
| Diagnosing network policy gaps | Medium - requires correlating policy with traffic data |
| Root-cause analysis across logs | Medium - unstructured data, confidence varies |

## Where Agents Need Supervision

Not every infrastructure task is safe for autonomous execution. Watch for these patterns:

**Irreversible actions.** Deleting a namespace, scaling a deployment to zero, removing a Meshery environment - these are hard to undo. Any agent action in this category should require explicit human approval.

**Multi-cluster blast radius.** An agent given access to multiple clusters should have per-cluster permission scopes. A mistake in a staging cluster is recoverable; the same mistake in production may not be.

**Configuration drift.** An agent that makes many small changes without a record can create a configuration that no one fully understands. All agent actions should be logged, and the resulting state should be captured in a Meshery design so it is version-controlled.

**Novel failure modes.** If the agent encounters something it has not seen before - an unusual error, an unexpected API response - it should escalate rather than guess. An agent that confidently applies a fix to an unfamiliar failure mode is more dangerous than one that admits it does not know.

The practical guidance: start with read-only tools. Add write tools one at a time, each behind an approval gate. Expand autonomy as you build confidence in the agent's behavior in your specific environment.

You can practice this workflow by importing `designs/policy-guardrails.yaml` into Meshery and tasking an agent with validating the design against your cluster's current state - a read-only task with high signal value before you enable any write operations.
