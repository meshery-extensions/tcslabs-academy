---
type: "page"
id: "dry-runs-and-diffs"
title: "Dry-Runs and Diffs"
description: "Always preview before applying: how to run a dry-run, read the diff, assess blast radius, and have the agent wait for explicit approval."
weight: 2
---

## The Cost of Skipping Preview

An agent that deploys without preview is indistinguishable from a runaway script. The dry-run step is where human judgment re-enters the loop. It is not optional, it is not a courtesy - it is the control mechanism that separates an agentic workflow from an autonomous one.

This lesson gives you the mechanics and the reading skills to use dry-runs effectively.

## What a Dry-Run Does

A dry-run submits the intended change to the Kubernetes API server with `--dry-run=client` or `--dry-run=server` without persisting anything. The server validates the manifest against the current schema and admission webhooks and returns either a success response or a structured error. No pods are created, no services are updated.

The diff step goes further: it compares the current cluster state against the incoming manifest and reports exactly which fields will change. This is where you see blast radius.

## Running a Dry-Run

For a raw Kubernetes manifest, your agent can invoke:

```bash
kubectl apply -f designs/microservices-demo.yaml --dry-run=server
```

Server-side dry-run passes through admission webhooks and gives a more accurate result than client-side. If you are running a policy layer such as OPA/Gatekeeper, server-side dry-run is the only mode that exercises those policies.

For Meshery designs, import the file and use Meshery's validation layer:

```bash
mesheryctl design import -f designs/microservices-demo.yaml -s "Kubernetes Manifest"
```

After import, use `mesheryctl system check` to confirm connectivity before proceeding.

## Reading the Diff

`kubectl diff` is the canonical tool for showing what will change:

```bash
kubectl diff -f designs/microservices-demo.yaml
```

The output uses standard unified-diff format. Lines beginning with `-` are what exists today; lines beginning with `+` are what will exist after apply.

Key things to look for in the diff:

| Signal | What it means |
|---|---|
| Image tag changes | A rollout will be triggered for every affected Deployment |
| Resource limit changes | Pods will be evicted if new limits are lower than current usage |
| Label selector changes | The old ReplicaSet is orphaned - manual cleanup required |
| New Namespace | A new namespace will be created; RBAC may not be ready |
| Deleted resources | Anything removed from the manifest will be deleted from the cluster |

## Assessing Blast Radius

Blast radius is the scope of potential impact if the change has an unexpected side effect. A useful heuristic:

- **Low blast radius**: changes isolated to a single Deployment's environment variables or config map data, no selector changes, same replica count.
- **Medium blast radius**: image tag rollout across multiple Deployments, new Service or Ingress resources.
- **High blast radius**: changes to label selectors, Namespace deletions, or PersistentVolumeClaim modifications.

Train your agent to categorize blast radius explicitly and surface the category in its approval request. An agent that just says "ready to apply" is not useful. An agent that says "medium blast radius - rolling update of 3 Deployments across the `payments` namespace, no selector changes, estimated rollout time 90 seconds" gives you the information you need to approve or pause.

## The Approval Checkpoint

The agent must not proceed from diff to apply without a discrete signal from a human or a policy gate. Implement this as a function call with a boolean result:

```text
[Agent]: Dry-run passed. Diff summary:
  - frontend: image updated ghcr.io/org/frontend:v1.3 -> v1.4
  - api-gateway: replicas 2 -> 3
  Blast radius: medium. Estimated rollout: 60s.
  Approve apply? [yes/no]

[Human]: yes

[Agent]: Calling mesheryctl design import ...
```

If the agent is running unattended in a CI pipeline, the policy gate can be an OPA policy evaluated against the diff JSON. See [openpolicyagent.org](https://openpolicyagent.org) for policy authoring guidance.

## Handling Dry-Run Failures

When `kubectl apply --dry-run=server` returns a non-zero exit code, the agent should:

1. Parse the error message - most API server errors include the field path and the constraint violated.
2. Attempt to fix the manifest if the error is structural (missing required field, invalid value).
3. Re-run the dry-run after the fix.
4. If the error is policy-driven (admission webhook rejection), surface the policy name and escalate to a human - do not attempt to work around policy.

A dry-run failure is not a deployment failure. Nothing in the cluster changed. It is a signal to revise the design before proceeding.
