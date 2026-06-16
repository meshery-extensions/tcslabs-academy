---
type: "lab"
description: "Deploy an inference workload with Meshery, wire up observability, build an MCP tool that exposes cluster state to a coding agent, then run an agent-assisted incident-and-remediation loop with approval gates and governance."
title: "CAINP Capstone - Operate an AI Workload with Agents & Meshery"
---

## Introduction

This is the end-to-end capstone for the **Certified AI-Native Infrastructure Professional (CAINP)**.
You will operate a real inference workload the AI-native way: deploy it with [Meshery](https://meshery.io/),
make it observable, give a coding agent safe, audited access to cluster state through a Model Context
Protocol (MCP) tool, and run an incident-and-remediation loop with a human approving every change.

This is the professional loop: not just shipping infrastructure with AI, but **operating** it with
AI under guardrails.

## Prerequisites

- A Kubernetes cluster with `kubectl` access (a GPU node pool is optional; the stack runs CPU-only).
- [Meshery](https://docs.meshery.io/) running and connected to the cluster.
- A coding agent and access to an LLM.
- CAINA credential and completion of Learning Paths 4-6.

## Step 1 - Deploy the inference + observability stacks

Import and deploy the academy designs:

```bash
mesheryctl design import -f designs/llm-mcp-gateway.yaml -s "Kubernetes Manifest"
mesheryctl design import -f designs/observability-stack.yaml -s "Kubernetes Manifest"
```

Deploy both from Meshery, then confirm the inference gateway and Prometheus/Grafana are healthy:

```bash
kubectl -n tcslabs-ai get deploy,svc
kubectl -n tcslabs-observability get deploy,svc
```

## Step 2 - Establish a performance baseline

Create a Meshery **Performance Profile** against the gateway and record p50/p95 latency and
throughput. Save it so you can compare against it later:

```bash
mesheryctl perf apply ai-baseline \
  --url http://mcp-gateway.tcslabs-ai.svc.cluster.local/healthz \
  --load-generator fortio --concurrent-requests 10 --duration 60s
```

## Step 3 - Build an MCP tool for Meshery

Build a small MCP server that exposes **read-only** cluster/Meshery state to your agent - for
example a `get_workload_status` tool that returns Deployment readiness in a namespace. Start
read-only; this is the safe foundation for everything that follows. Connect it to your coding agent
and confirm the agent can answer "is the inference workload healthy?" using the tool.

## Step 4 - Inject and diagnose an incident

Break the workload deliberately (for example, scale `ollama` to 0, or set an invalid image tag):

```bash
kubectl -n tcslabs-ai set image deploy/ollama ollama=ollama/ollama:does-not-exist
```

Ask your agent to diagnose using the MCP tool and Meshery signals. It should detect the unhealthy
rollout, gather the relevant events, and propose a root cause - **without** making changes yet.

## Step 5 - Remediate with an approval gate

Have the agent propose a remediation as a diff and **wait for your approval** before applying.
Approve it, let it apply, and confirm recovery:

```bash
kubectl -n tcslabs-ai rollout status deploy/ollama
```

Re-run the Performance Profile and compare against your `ai-baseline` to confirm the workload
recovered to its expected performance.

## Step 6 - Govern it

Apply the [`policy-guardrails.yaml`](https://github.com/meshery-extensions/tcslabs-academy/blob/master/designs/policy-guardrails.yaml)
patterns to the workload namespace (quota, limits, default-deny networking). Show that:

- the agent's MCP tool has only the permissions it needs (least privilege),
- every change the agent made is captured in an audit trail (Meshery activity / git history), and
- the workload stays within the ResourceQuota.

## Submission

Submit a single report containing:

1. The deployed stacks (`kubectl get all` for both namespaces) and the baseline Performance Profile.
2. Your MCP tool's source and a transcript showing the agent using it read-only.
3. The incident: what broke, the agent's diagnosis, the proposed diff, your approval, and recovery.
4. The post-remediation Performance Profile compared to baseline.
5. Evidence of governance: least-privilege permissions, the audit trail, and quota compliance.
6. A reflection (10-15 sentences) on where you kept the human in the loop and why.

## What you learned

You operated an AI workload end to end with coding agents and Meshery - observability, a safe MCP
integration, an approval-gated incident-and-remediation loop, and governance. This is the core
competency of an AI-native platform engineer. Take the exam to complete the capstone.
