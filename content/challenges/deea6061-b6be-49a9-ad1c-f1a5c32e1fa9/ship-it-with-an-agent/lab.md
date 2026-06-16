---
type: "lab"
description: "Deploy the academy's microservices demo with a coding agent and Meshery: import the design, have the agent deploy it behind a dry-run, and verify the rollout."
title: "Ship It with an Agent"
---

## Introduction

In this challenge you will deploy a small microservices application using a coding agent and
[Meshery](https://meshery.io/). It is the warm-up for the
[CAINA](https://cloud.meshery.io/academy/certifications/deea6061-b6be-49a9-ad1c-f1a5c32e1fa9/certified-ai-native-infrastructure-associate/)
credential: a complete, low-risk run through the design-to-deploy loop.

## Prerequisites

- A Kubernetes cluster (kind, k3d, minikube, or managed) with `kubectl`.
- [Meshery](https://docs.meshery.io/) running (`mesheryctl system start`) and connected.
- A coding agent with shell access.

## Step 1 - Import the design

Use the academy's microservices demo design:

```bash
mesheryctl design import \
  -f https://raw.githubusercontent.com/meshery-extensions/tcslabs-academy/master/designs/microservices-demo.yaml \
  -s "Kubernetes Manifest"
```

Open it in **Kanvas** and confirm the topology: `frontend` -> `api` -> `redis`, all in the
`tcslabs-demo` namespace.

## Step 2 - Brief the agent

Give your coding agent a safe runbook:

```text
1. Show me a dry-run / diff of what deploying this design will change.
2. Wait for my approval.
3. Deploy the "microservices-demo" design via Meshery (or kubectl apply).
4. Wait for all three Deployments to become Available; report status and any events.
```

## Step 3 - Approve and deploy

Review the dry-run. If it looks right, approve. Then verify:

```bash
kubectl -n tcslabs-demo get deploy,svc,pods
kubectl -n tcslabs-demo rollout status deploy/frontend
kubectl -n tcslabs-demo rollout status deploy/api
```

## Step 4 - Prove the request path

Port-forward the frontend and confirm it reaches the API:

```bash
kubectl -n tcslabs-demo port-forward svc/frontend 8080:80
curl -s localhost:8080 | head
```

## Step 5 - Clean up

```bash
kubectl delete namespace tcslabs-demo
```

## What you learned

You ran the full design-to-deploy loop with a coding agent and Meshery, kept a dry-run and approval
gate in the path, and verified the result. Take the exam to complete the challenge.
