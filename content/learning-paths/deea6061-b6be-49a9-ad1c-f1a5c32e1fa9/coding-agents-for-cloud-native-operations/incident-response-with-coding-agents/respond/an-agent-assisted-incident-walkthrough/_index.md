---
type: "page"
id: "an-agent-assisted-incident-walkthrough"
title: "An Agent-Assisted Incident Walkthrough"
description: "A concrete walkthrough of a crashlooping workload: the agent gathers state, proposes a fix, a human approves, and recovery is confirmed."
weight: 3
---

## The Scenario

It is 02:17. An alert fires: `payments` deployment in the `production` namespace is crashlooping. Pod restarts have exceeded the threshold. Error rate on the `/checkout` path has climbed to 8%. No deployments have been made in the last four hours - this is not an obvious rollout regression.

A coding agent, already subscribed to the alerting pipeline, begins the incident runbook automatically. The on-call engineer receives a summary in the incident channel within 90 seconds of the alert.

## Step 1: Agent Gathers State (Read Phase)

The agent executes the read-only steps of the crashloop runbook in parallel:

```bash
kubectl get pods -n production -l app=payments
```

```text
NAME                        READY   STATUS             RESTARTS   AGE
payments-7d9f8b4c6-xk2p9   0/1     CrashLoopBackOff   14         47m
payments-7d9f8b4c6-mn7r3   0/1     CrashLoopBackOff   12         47m
payments-7d9f8b4c6-qw5t1   0/1     CrashLoopBackOff   13         47m
```

```bash
kubectl describe pod payments-7d9f8b4c6-xk2p9 -n production
```

The agent extracts the relevant portion of the describe output and logs it to the incident channel. The key finding: `Back-off restarting failed container`. The agent also pulls recent events:

```bash
kubectl get events -n production --sort-by='.metadata.creationTimestamp' | grep payments | tail -10
```

```text
47m   Warning   BackOff   pod/payments-7d9f8b4c6-xk2p9   Back-off restarting failed container
47m   Warning   Failed    pod/payments-7d9f8b4c6-xk2p9   Error: ImagePullBackOff
```

`ImagePullBackOff` - the container image cannot be pulled. The agent checks the image reference:

```bash
kubectl get deployment payments -n production -o jsonpath='{.spec.template.spec.containers[0].image}'
```

```text
registry.internal/payments:v2.4.1-rc3
```

The agent queries the registry. The tag `v2.4.1-rc3` does not exist. It was pushed with an incorrect tag during a pre-release build pipeline run earlier that night and then deleted when the error was noticed - but the deployment was never reverted.

**Agent summary to incident channel:**
```text
Root cause hypothesis: payments deployment references image tag v2.4.1-rc3,
which does not exist in the registry. This is consistent with ImagePullBackOff
across all 3 replicas. No other services appear affected. Blast radius: payments
pods only. Recommended action: roll back to last known-good tag (v2.4.0).
Awaiting human approval before proceeding.
```

## Step 2: Human Reviews and Approves

The on-call engineer reads the agent's summary. The analysis is consistent with what the engineer sees in the incident channel logs. The engineer checks the registry directly to confirm `v2.4.0` exists and is healthy:

```bash
# Human verification - not delegated to the agent
crane ls registry.internal/payments | grep v2.4.0
```

Tag confirmed. The engineer types `APPROVE` in the incident channel interface.

## Step 3: Agent Executes the Fix

With explicit approval, the agent executes the rollback:

```bash
kubectl set image deployment/payments payments=registry.internal/payments:v2.4.0 -n production
```

```text
deployment.apps/payments image updated
```

The agent then imports the corrected manifest as a Meshery design for audit trail purposes:

```bash
mesheryctl design import -f designs/microservices-demo.yaml -s "Kubernetes Manifest"
```

This records the intended state in Meshery, making the corrected configuration visible in Kanvas and queryable via the Meshery API.

## Step 4: Agent Monitors Recovery

The agent polls pod status every 30 seconds:

```bash
kubectl rollout status deployment/payments -n production
```

```text
Waiting for deployment "payments" rollout to finish: 0 of 3 updated replicas are available...
Waiting for deployment "payments" rollout to finish: 1 of 3 updated replicas are available...
Waiting for deployment "payments" rollout to finish: 2 of 3 updated replicas are available...
deployment "payments" successfully rolled out
```

After confirming the rollout, the agent checks error rates via the observability stack:

```bash
mesheryctl system check
```

All components report healthy. The agent posts to the incident channel:

```text
Recovery confirmed. payments deployment rolled out successfully with image v2.4.0.
All 3 replicas Running. Pod restart count: 0. Error rate on /checkout: 0.1% (baseline).
Incident duration: 54 minutes. Human approval was obtained at step 3 before any
write operations were executed.
```

## Step 5: Human Declares Resolved

The engineer reviews the agent's recovery report, spot-checks the metrics in Grafana, and declares the incident resolved. The incident channel is closed.

## What This Walkthrough Demonstrates

| Property | How it was maintained |
|---|---|
| Read-only until approved | Agent ran only `kubectl get`, `kubectl describe`, `kubectl logs` before approval |
| Single approval point | One explicit APPROVE before any write operation |
| Auditable fix | Design imported to Meshery; rollback recorded in deployment history |
| Human retains authority | Engineer independently verified the registry before approving |
| Recovery confirmed | Agent monitored until steady-state; human validated before close |

The entire read and diagnosis phase took under 90 seconds. The engineer's active time - reading the summary, verifying the tag, typing APPROVE - was under three minutes. Without the agent, that 90 seconds of parallel data gathering would have been 15-20 minutes of manual investigation at 2 AM.
