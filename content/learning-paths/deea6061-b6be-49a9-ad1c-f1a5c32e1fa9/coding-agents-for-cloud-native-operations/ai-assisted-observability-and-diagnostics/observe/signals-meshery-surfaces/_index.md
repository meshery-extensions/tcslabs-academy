---
type: "page"
id: "signals-meshery-surfaces"
title: "Signals Meshery Surfaces"
description: "Understand the four categories of observability data Meshery exposes and how to make them available for agent-driven analysis."
weight: 1
---

## What Meshery Makes Observable

Meshery is not just a deployment tool - it is a continuous reconciliation engine. Every second it is running, it gathers state from your cluster and surfaces it through a consistent data model. That consistency is what makes Meshery's output well-suited to LLM analysis: the agent receives structured, labeled data rather than raw, heterogeneous noise.

There are four primary signal categories to understand.

### 1. MeshSync State

MeshSync is the Meshery Operator component responsible for continuously watching your Kubernetes cluster and syncing the discovered state into Meshery's data layer. It tracks every object the cluster reports - Deployments, Services, ConfigMaps, Pods, and the mesh-specific resources added by your service mesh.

What this means for diagnostics: when something drifts or disappears, MeshSync surfaces the delta almost immediately. An agent querying Meshery's state after an incident sees a snapshot that is authoritative and timestamped, not a reconstruction from `kubectl` output.

### 2. Component and Workload Status

Meshery models infrastructure as components - each with a lifecycle status that maps to the underlying Kubernetes object's conditions. A component's status rolls up from the cluster through MeshSync into Meshery's registry representation.

For an agent, this is the first layer of triage. A component stuck in `Pending` or cycling through `CrashLoopBackOff` is a direct signal. Because the status lives in Meshery's structured model (not raw YAML), an agent can be given a precise JSON object rather than a blob of `kubectl describe` text.

### 3. Events

Kubernetes events are ephemeral - they expire after roughly an hour by default. Meshery captures and surfaces them as part of its observability stream, giving you a durable record of `Warning` and `Normal` events tied to specific components.

Events are high-value context for LLM analysis. A `FailedScheduling` or `BackOff` event, paired with the component's current status, gives the agent enough signal to reason about whether the problem is resource-related, configuration-related, or network-related - without access to every log line.

### 4. Metrics via the Prometheus and Grafana Integration

Meshery integrates with [Prometheus](https://prometheus.io) and [Grafana](https://grafana.com) to pull performance metrics into its performance profiles. The `mesheryctl perf apply` command runs a performance test and stores results that include latency percentiles, error rates, and throughput.

For observability-driven diagnostics, this integration matters because it provides a quantitative baseline. When an agent is reasoning about whether behavior has changed, having a historical performance snapshot to compare against is far more useful than log text alone.

## Deploying the Observability Stack

The academy ships an importable design that wires Prometheus and Grafana alongside a sample application. Import it with:

```bash
mesheryctl design import -f designs/observability-stack.yaml -s "Kubernetes Manifest"
```

This design provisions:

| Component | Role |
|---|---|
| Prometheus | Scrapes mesh data-plane metrics |
| Grafana | Visualizes metrics and surfaces dashboards |
| Meshery Operator | Runs MeshSync; keeps Meshery in sync with cluster state |

After import, verify the stack is healthy:

```bash
mesheryctl system check
```

You should see Meshery Operator and MeshSync listed as running. If either is absent, the reconciliation loop is not active and the state data the agent will see is stale.

## Why Signal Structure Matters for LLM Analysis

A raw dump of `kubectl get events -A -o json` is several thousand tokens. An LLM's ability to reason over it degrades with length because salient facts compete with noise. Meshery's structured output solves this in two ways:

- **Filtering by relevance** - you can query Meshery for events or status tied to a specific component or namespace, dramatically reducing token count.
- **Consistent schema** - because MeshSync uses Meshery's component model, the JSON shape is predictable. An agent that knows the schema can extract fields by name rather than parsing free-form text.

When you build the diagnostic prompts in later lessons, this structure is what lets you pass precise, bounded context to the LLM rather than hoping it finds the signal in a wall of text.

## Checking Your Signal Pipeline

Before writing a single diagnostic prompt, confirm each layer is producing data:

```bash
# Confirm Meshery is running and operator is active
mesheryctl system check

# List designs to verify MeshSync has reconciled cluster resources
mesheryctl design list
```

If `mesheryctl system check` reports issues with MeshSync or the Operator, resolve them before proceeding. An agent reasoning over stale or missing state will produce confident-sounding but incorrect diagnoses.
