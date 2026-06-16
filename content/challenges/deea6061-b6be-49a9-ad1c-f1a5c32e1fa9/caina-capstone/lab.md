---
type: "lab"
description: "Use an LLM to generate a Meshery design from a plain-language brief, deploy it to a cluster with a coding agent and mesheryctl, and validate the result in Meshery and Kanvas."
title: "CAINA Capstone - Generate, Deploy & Validate a Design with an Agent"
---

## Introduction

This is the hands-on capstone for the **Certified AI-Native Infrastructure Associate (CAINA)**. You
will take an application from a plain-language brief to a deployed, validated
[Meshery](https://meshery.io/) design - using an LLM to generate the design, a coding agent to drive
the deployment, and Meshery to validate it. This mirrors the everyday loop of an AI-native platform
engineer: describe intent, let AI draft the infrastructure, then verify before it ships.

## Prerequisites

- A Kubernetes cluster (kind, k3d, minikube, or a managed cluster) with `kubectl` access.
- [Meshery](https://docs.meshery.io/) running (`mesheryctl system start`) and connected to the cluster.
- A coding agent (any CLI coding agent) and access to an LLM.
- Completion of Learning Paths 1-3.

## The brief

> "We need a small web application for a demo: a public web frontend that calls an internal API,
> with a Redis cache behind the API. Everything in its own namespace. Keep resource requests small."

## Step 1 - Generate the design with an LLM

Prompt your LLM to produce a Meshery-importable Kubernetes manifest from the brief. Ground it with
the constraints you care about. A good prompt is specific about output format:

```text
You are helping author a Meshery design (plain Kubernetes YAML).
Produce a single multi-document YAML for the brief below. Requirements:
- One Namespace: capstone-app
- A "frontend" Deployment (nginx) exposed by a Service on port 80
- An "api" Deployment exposed by a Service; the frontend proxies to it
- A "redis" Deployment + Service used by the api as a cache
- Small CPU/memory requests and limits on every container
- readiness probes on frontend and api
Output only YAML, no commentary.

Brief: <paste the brief>
```

Save the output as `capstone-design.yaml`. Read it critically - **you** are accountable for what you
deploy. Check that every container has resource requests/limits, that Services select the right pods,
and that names are consistent. If something is off, ask the agent to fix the specific issue rather
than regenerating from scratch.

## Step 2 - Import and validate in Meshery

Import the generated design and open it in **Kanvas**:

```bash
mesheryctl design import -f capstone-design.yaml -s "Kubernetes Manifest"
```

In Kanvas, run **relationship and policy validation**. Confirm the topology matches the brief:
frontend → api → redis, all in the `capstone-app` namespace. Fix any issues the validator flags
(for example, a Service whose selector does not match its Deployment's pod labels).

## Step 3 - Deploy with a coding agent

Have your coding agent deploy the validated design and confirm the rollout. A safe agent runbook:

```text
1. Show me a diff / dry-run of what will be applied.
2. Deploy the design "capstone-app" via Meshery (or `mesheryctl design`/`kubectl apply`).
3. Wait for all Deployments to become Available.
4. Report pod status and any events; stop and ask me if anything is not Ready.
```

Verify:

```bash
kubectl -n capstone-app get deploy,svc,pods
kubectl -n capstone-app rollout status deploy/frontend
```

## Step 4 - Prove it works

Port-forward the frontend and confirm the request path reaches the API:

```bash
kubectl -n capstone-app port-forward svc/frontend 8080:80
curl -s localhost:8080 | head
```

## Step 5 - Validate against guardrails

Apply the academy guardrails design to a copy of the namespace, or compare your design against the
[`policy-guardrails.yaml`](https://github.com/meshery-extensions/tcslabs-academy/blob/master/designs/policy-guardrails.yaml)
reference. Confirm your manifests would satisfy a default-deny NetworkPolicy and a LimitRange (i.e.,
every container declares requests/limits).

## Submission

Submit:

1. Your `capstone-design.yaml` and the prompt(s) you used to generate it.
2. A screenshot of the design validated in Kanvas.
3. `kubectl -n capstone-app get all` output showing a healthy deployment.
4. A short note (5-10 sentences) on one thing the LLM got wrong or risky and how you caught it.

## What you learned

You drove the full associate-level loop: intent → AI-generated design → validation → agent-driven
deployment → verification. Crucially, you stayed accountable for the AI's output. Take the exam to
complete the capstone.
