---
type: "page"
id: "deploying-a-design-with-an-agent"
title: "Deploying a Design with an Agent"
description: "A concrete walkthrough: an agent imports and deploys designs/microservices-demo.yaml through Meshery, then verifies the rollout with kubectl and mesheryctl."
weight: 3
---

## The Scenario

You have an updated `designs/microservices-demo.yaml` in your Git repository. A previous lesson covered how the agent generated and reviewed this design in Kanvas. Now the human reviewer has approved it. The task: have an agent drive the import, deploy, and verification sequence through Meshery.

This lesson is a step-by-step walkthrough. Each shell block is a real command the agent issues, with the expected output and the reasoning behind it.

## Prerequisites

Before the agent begins, confirm the environment is ready:

```bash
mesheryctl system check
```

Expected output includes lines similar to:

```text
✓ mesheryctl version: v0.7.x
✓ Meshery Server: reachable at http://localhost:9081
✓ Kubernetes: context "prod-west" active, server reachable
✓ Meshery Operator: running in namespace meshery
✓ MeshSync: running and syncing
```

If any check fails, stop. A partial environment will produce a partial deploy and leave the cluster in an inconsistent state.

## Step 1 - Import the Design

```bash
mesheryctl design import -f designs/microservices-demo.yaml -s "Kubernetes Manifest"
```

This command uploads the file to Meshery Server, which parses it into a named Meshery design. The `-s "Kubernetes Manifest"` flag tells Meshery which source schema to apply during import. On success you will see:

```text
Design imported successfully.
Design ID: <uuid>
Design Name: microservices-demo
```

Record the Design ID. The agent should store it for subsequent commands in this session.

## Step 2 - Verify the Import in Meshery

After import, open Kanvas or query via CLI to confirm the design topology is correct before deploying. You can list designs with:

```bash
mesheryctl design list
```

Look for `microservices-demo` in the output. If you have the Kanvas UI open, you can visually inspect the topology at this point - components, relationships, and any validation warnings the import surfaced.

This is a lightweight human check. You are not re-reviewing the design in detail; you are confirming the import succeeded and the design is the one you intended.

## Step 3 - Dry-Run

Apply the dry-run technique from the previous lesson:

```bash
kubectl apply -f designs/microservices-demo.yaml --dry-run=server
kubectl diff -f designs/microservices-demo.yaml
```

The agent should surface the diff output and any blast-radius assessment before proceeding. In this walkthrough, assume the diff shows:

```text
-   image: ghcr.io/org/frontend:v1.3
+   image: ghcr.io/org/frontend:v1.4

-   replicas: 2
+   replicas: 3
```

Blast radius: medium - one image update plus a scale-up. The agent reports this and waits for approval.

## Step 4 - Deploy via Meshery

Once approved, the agent deploys the design. In a direct `mesheryctl` workflow this is currently handled by applying the manifest through `kubectl` after the Meshery design is registered:

```bash
kubectl apply -f designs/microservices-demo.yaml
```

Meshery's MeshSync will pick up the resulting cluster state change within its sync interval and update the design's live status in the Meshery dashboard.

## Step 5 - Verify the Rollout

The agent monitors rollout progress:

```bash
kubectl rollout status deployment/frontend -n microservices-demo
kubectl rollout status deployment/api-gateway -n microservices-demo
```

Expected output when rollout completes:

```text
deployment "frontend" successfully rolled out
deployment "api-gateway" successfully rolled out
```

Then confirm all pods are healthy:

```bash
kubectl get pods -n microservices-demo
```

Every pod in the namespace should show `Running` with `READY` equal to the container count. Any pod stuck in `Pending`, `CrashLoopBackOff`, or `ImagePullBackOff` is a signal to investigate before declaring success.

## Step 6 - Confirm via mesheryctl

```bash
mesheryctl system check
```

A clean check after apply confirms that Meshery Server, MeshSync, and the Operator are all still healthy and that the deploy did not destabilize the Meshery control plane.

## What the Agent Records

At the end of this sequence the agent should record:

- The commit hash of `designs/microservices-demo.yaml` that was deployed.
- The Meshery Design ID.
- The timestamp and Kubernetes context used.
- The rollout status for each Deployment.

This information is what makes rollback deterministic. If something goes wrong in the next hour, the agent - or the on-call engineer - can go directly to these values and revert the exact change.

## Common Problems at This Stage

| Problem | Likely cause | Action |
|---|---|---|
| `ImagePullBackOff` | Image tag does not exist in the registry | Fix the image reference in the design, re-import |
| `Pending` pods | Insufficient cluster resources | Scale the cluster or reduce replica count |
| `mesheryctl` import fails | Meshery Server not reachable | Run `mesheryctl system check`, restart if needed |
| `kubectl diff` shows unexpected deletions | Stale resources in namespace not in design | Review namespace contents before apply |
