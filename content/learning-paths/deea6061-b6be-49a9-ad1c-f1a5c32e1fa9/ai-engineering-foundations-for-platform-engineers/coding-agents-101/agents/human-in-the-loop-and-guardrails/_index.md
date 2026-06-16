---
type: "page"
id: "human-in-the-loop-and-guardrails"
title: "Human-in-the-Loop and Guardrails"
description: "Design approval gates, dry-run patterns, and permission boundaries that keep agents safe in production infrastructure environments."
weight: 4
---

## Why Human-in-the-Loop Is Not Optional

The agentic loop is powerful because it can act. It is also risky for the same reason. An agent that can run `kubectl delete` or `mesheryctl system stop` in a production environment is a sharp tool - valuable when used correctly, dangerous when used without guardrails.

Human-in-the-loop (HITL) is not a failure mode or a concession that the agent is not good enough. It is an architectural decision: some actions have a blast radius large enough that a human should be the final authorization step, regardless of how confident the agent is. The goal is not to second-guess every action - it is to ensure that irreversible or high-impact actions always have a human sign-off.

The practical benefit is also organizational. An agent that always asks before making production changes builds trust. An agent that surprises the on-call engineer with an unexpected deployment at 2 AM destroys it.

## Approval Gates

An approval gate is a point in the agentic loop where the agent pauses and presents its proposed action - with full context - to a human for a yes/no decision.

A well-designed approval gate provides:

- **What the agent intends to do** - the specific command or API call, with all parameters visible.
- **Why** - the agent's reasoning, summarized in plain language.
- **What it cannot undo** - an explicit statement of the blast radius.
- **The diff, if applicable** - for manifest changes, a structured diff between current state and proposed state.

```text
Agent: I propose to apply the following change to the production namespace:

  - Scale deployment/api-gateway from 2 replicas to 4
  - Reason: p99 latency exceeded threshold in the last 15 minutes (observed: 620ms, threshold: 400ms)
  - This action is reversible (scale back down to 2)

Approve? [y/n]
```

The human's job at an approval gate is not to re-do the agent's analysis - it is to sanity-check the proposed action against their own knowledge of the environment. Did anything change in the last hour that the agent would not know about? Does this action conflict with a pending maintenance window? Is the reasoning sound?

## Dry-Run Patterns

Before committing a change, agents should use dry-run modes wherever available. Kubernetes supports server-side dry runs:

```bash
kubectl apply -f updated-deployment.yaml --dry-run=server
```

This validates the manifest against the API server - checking schema correctness, admission webhook results, and resource constraints - without persisting anything. An agent that always dry-runs before applying will catch a large class of errors before they affect running workloads.

Meshery's design validation serves a similar role at the Meshery layer. Importing a design and running validation before deployment checks component relationships, policy constraints, and environment compatibility without making changes to the cluster.

```bash
mesheryctl design import -f designs/observability-stack.yaml -s "Kubernetes Manifest"
# Then validate in the Meshery UI or via API before deploying
```

The dry-run result should be part of the approval gate context. Present the validation output alongside the proposed action so the human can see exactly what the API server and Meshery's policy engine think of the change.

## Scope and Permission Limits

The most reliable guardrail is a narrow permission scope. An agent that cannot do something cannot do it by accident.

Design permission boundaries around:

- **Namespace scope** - limit the agent to specific namespaces. An agent fixing a staging issue has no reason to touch the production namespace.
- **Resource type** - an agent tasked with reading logs and describing pods does not need `delete` or `patch` permissions on any resource.
- **Cluster scope** - if the agent manages multiple clusters, each cluster's credentials should be separate, with separate authorization decisions.
- **Meshery environment** - Meshery's environments and workspaces let you group resources with distinct access controls. Use them to constrain an agent to its intended operating scope.

Document the minimum permissions the agent needs and grant exactly those - not a broader role because it is convenient. The principle of least privilege applies as much to agents as to human operators.

## Blast-Radius Thinking

Before granting an agent access to any tool, ask: what is the worst thing it could do with this tool in a single action?

| Tool | Worst case | Mitigation |
|---|---|---|
| `kubectl apply` | Apply a broken manifest to all namespaces | Require dry-run first; limit to specific namespaces |
| `kubectl delete` | Delete a production namespace | Require approval; block delete on production namespaces |
| `mesheryctl design import` | Import a design that conflicts with live policy | Validate before applying; use staging environment first |
| `mesheryctl perf apply` | Run a load test against production | Scope to performance test environments only |

Blast-radius thinking is not about being pessimistic - it is about being precise. The goal is to match the permission scope to the actual need, so that even a buggy or confused agent cannot cause more damage than the task requires.

The reference design `designs/policy-guardrails.yaml` provides a worked example of policy constraints that can be imported into Meshery and used to validate agent-proposed changes before they are applied. Importing it is a useful starting exercise before enabling any write tools in your agent configuration.

## Building Trust Incrementally

The path to a useful, trusted agent is incremental:

1. Read-only tools only. Verify the agent's reasoning is sound before it can touch anything.
2. Write tools in non-production environments, behind approval gates.
3. Write tools in production, behind approval gates and with dry-run required.
4. Expand autonomy for specific, well-understood, reversible actions where the approval overhead exceeds the risk.

Each expansion should be deliberate and documented. The goal is an agent that earns broader autonomy through demonstrated reliability - not one that starts with broad access and hopes for the best.
