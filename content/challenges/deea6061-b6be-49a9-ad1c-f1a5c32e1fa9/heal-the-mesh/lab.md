---
type: "lab"
description: "Inject a fault into a running deployment, use a coding agent and Meshery signals to diagnose the root cause, propose a fix behind an approval gate, and verify recovery."
title: "Heal the Mesh"
---

## Introduction

Real operations is mostly day-2: things break, and you fix them. In this challenge you will
deliberately break a workload, then use a coding agent grounded in [Meshery](https://meshery.io/) and
Kubernetes signals to diagnose and remediate it - safely, with you approving the fix.

## Prerequisites

- A Kubernetes cluster with `kubectl` and [Meshery](https://docs.meshery.io/) connected.
- The academy microservices demo deployed (see the *Ship It with an Agent* challenge), or any
  workload you can safely break.
- A coding agent with shell access.

## Step 1 - Deploy a target

```bash
mesheryctl design import \
  -f https://raw.githubusercontent.com/meshery-extensions/tcslabs-academy/master/designs/microservices-demo.yaml \
  -s "Kubernetes Manifest"
# deploy via Meshery, then confirm it is healthy:
kubectl -n tcslabs-demo rollout status deploy/api
```

## Step 2 - Break it

Pick one fault (do not tell the agent which):

```bash
# A) bad image tag -> ImagePullBackOff
kubectl -n tcslabs-demo set image deploy/api podinfo=ghcr.io/stefanprodan/podinfo:does-not-exist
# B) wrong cache address -> api degraded
kubectl -n tcslabs-demo set env deploy/api PODINFO_CACHE_SERVER=tcp://redis-typo:6379
# C) scale the cache to zero
kubectl -n tcslabs-demo scale deploy/redis --replicas=0
```

## Step 3 - Diagnose with the agent (read-only)

Brief the agent: *"The api workload in namespace tcslabs-demo is unhealthy. Diagnose the root cause
using read-only commands only. Do not change anything. Report the cause with the evidence you used."*

The agent should gather signals such as:

```bash
kubectl -n tcslabs-demo get pods
kubectl -n tcslabs-demo describe deploy/api
kubectl -n tcslabs-demo get events --sort-by=.lastTimestamp | tail -20
kubectl -n tcslabs-demo logs deploy/api --tail=50
```

If Meshery's MeshSync and metrics are wired up (see `designs/observability-stack.yaml`), the agent
can also read workload status and events through Meshery.

## Step 4 - Propose and approve a fix

Ask the agent to propose a remediation **as a command or diff, and wait for approval**. Review it -
does it match the evidence? Approve only if it does. Example fixes:

```bash
# A) roll back the image
kubectl -n tcslabs-demo set image deploy/api podinfo=ghcr.io/stefanprodan/podinfo:6.7.0
# B) restore the cache address
kubectl -n tcslabs-demo set env deploy/api PODINFO_CACHE_SERVER=tcp://redis:6379
# C) scale the cache back up
kubectl -n tcslabs-demo scale deploy/redis --replicas=1
```

## Step 5 - Confirm recovery

```bash
kubectl -n tcslabs-demo rollout status deploy/api
kubectl -n tcslabs-demo get pods
```

## Step 6 - Write the postmortem

Have the agent draft a short blameless postmortem (symptom, root cause, fix, prevention). Verify the
facts yourself, then note one guardrail that would have caught this earlier.

## What you learned

You ran an AI-assisted diagnose-remediate loop grounded in real signals, kept the agent read-only
until you approved a fix, and confirmed recovery. Take the exam to complete the challenge.
