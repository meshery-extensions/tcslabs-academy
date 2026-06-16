---
type: "page"
id: "rollback-and-recovery"
title: "Rollback and Recovery"
description: "When a deploy goes wrong: rolling back via Git revert and Meshery, confirming recovery, and capturing what happened."
weight: 4
---

## When to Roll Back

Not every post-deploy anomaly requires a rollback. A single pod restarting once is not a rollback trigger. A sustained error rate increase, a service that is not reachable, or a deployment stuck in progress for longer than the expected rollout time - those are rollback triggers.

Define the threshold before you deploy, not during the incident. Tell your agent: "If the rollout does not complete within 3 minutes, or if error rate on `/api/orders` rises above 1% within 5 minutes of apply, initiate rollback." Pre-defined thresholds let the agent act without waiting for a human to notice something is wrong.

## The Rollback Strategy

The safest rollback path in a GitOps workflow is a Git revert followed by a re-apply. This approach keeps Git as the source of truth and leaves a complete audit trail - you can see both the broken commit and the revert commit in the log.

Do not use `kubectl rollout undo` as the primary mechanism if your design lives in Git. `kubectl rollout undo` rolls back the Deployment in the cluster but does not update the Git file, creating a gap between Git state and cluster state. Use it only as an emergency stop while you prepare the Git revert.

## Step 1 - Stop the Bleeding (if needed)

If pods are crashing and traffic is being affected, roll back the Kubernetes Deployment immediately:

```bash
kubectl rollout undo deployment/frontend -n microservices-demo
kubectl rollout undo deployment/api-gateway -n microservices-demo
```

This restores the previous ReplicaSet instantly. Confirm recovery:

```bash
kubectl rollout status deployment/frontend -n microservices-demo
kubectl get pods -n microservices-demo
```

This buys time. Git and Meshery still think the new version is deployed - fix that in the next steps.

## Step 2 - Revert in Git

Identify the commit that introduced the broken design:

```bash
git log --oneline designs/microservices-demo.yaml
```

Revert it:

```bash
git revert <commit-hash> --no-edit
git push origin main
```

The revert commit restores `designs/microservices-demo.yaml` to its previous state. The commit message should reference the incident: `revert: rollback microservices-demo - elevated error rate post v1.4 deploy`.

## Step 3 - Re-apply the Reverted Design via Meshery

With the reverted file in Git, re-import and re-apply:

```bash
mesheryctl design import -f designs/microservices-demo.yaml -s "Kubernetes Manifest"
kubectl apply -f designs/microservices-demo.yaml
```

This brings cluster state, Git state, and Meshery design state back into alignment. Run the same verification sequence from the deployment lesson:

```bash
kubectl rollout status deployment/frontend -n microservices-demo
kubectl get pods -n microservices-demo
mesheryctl system check
```

## Step 4 - Confirm Recovery

Recovery is confirmed when:

- All pods show `Running` with full readiness.
- The rollout status reports `successfully rolled out` for each Deployment.
- Application-level health checks pass (endpoint probes, smoke tests, or whatever your team uses).
- `mesheryctl system check` reports all components healthy.

The agent should run all four checks and report results before declaring recovery complete. "Looks good" is not a confirmation. A complete confirmation looks like:

```text
Recovery confirmed:
  - frontend: 3/3 pods Running, rollout complete
  - api-gateway: 2/2 pods Running, rollout complete
  - mesheryctl system check: all components healthy
  - Smoke test /api/orders: HTTP 200, p99 latency 45ms
  Git revert commit: abc1234
```

## Step 5 - Capture What Happened

A rollback without a post-incident record is a missed learning opportunity. Have the agent produce a brief structured summary immediately after recovery:

| Field | Content |
|---|---|
| Broken commit | The SHA that was reverted |
| Revert commit | The SHA that restored the previous state |
| Time to detect | When the problem was first observed |
| Time to recover | When recovery was confirmed |
| Root cause (initial) | What the diff showed that likely caused the problem |
| Follow-up | What needs investigation before the change is re-attempted |

This summary belongs in the pull request that introduced the broken change, as a comment. Future readers - human and agent - can find the context there.

## Re-trying After a Rollback

A rollback is not the end of the deploy. It is the start of a diagnosis cycle. The agent can help: given the diff from the broken change and the error signals, it can reason about the likely cause and propose a revised design.

When you are ready to retry, go back to the dry-run lesson and treat the retry as a new deployment. Do not skip the dry-run because you are in a hurry to restore the feature - the dry-run is exactly what catches the subtle error you introduced in the fix.

## Meshery and MeshSync During Rollback

MeshSync continuously observes cluster state. After a `kubectl rollout undo` and then a `kubectl apply` of the reverted design, MeshSync will update Meshery's view of the cluster within its sync interval (typically seconds). You can watch the Meshery dashboard update in near real time, which is useful for confirming that the cluster state Meshery sees matches what you intend.

If Meshery's design view does not update after a few minutes, run `mesheryctl system check` to confirm MeshSync is still healthy. A crashed MeshSync will not surface the updated cluster state.
