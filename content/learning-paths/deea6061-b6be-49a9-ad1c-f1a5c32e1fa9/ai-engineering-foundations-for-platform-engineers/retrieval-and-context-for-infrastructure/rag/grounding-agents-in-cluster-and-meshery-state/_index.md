---
type: "page"
id: "grounding-agents-in-cluster-and-meshery-state"
title: "Grounding Agents in Cluster and Meshery State"
description: "Identify the authoritative sources of infrastructure state and learn how to surface them to an agent at query time."
weight: 2
---

## Sources of Truth in a Meshery Environment

An agent making decisions about your cluster needs authoritative data, not cached assumptions. In a Meshery-managed environment, there are four primary sources of truth, each with different freshness characteristics and different strengths.

### `kubectl` - Direct Kubernetes API

The Kubernetes API server is the authoritative record of cluster state. `kubectl` queries it synchronously and returns current data.

```bash
# List all deployments across all namespaces
kubectl get deployments --all-namespaces -o json

# Get pod status with conditions
kubectl get pods -n production -o yaml

# Describe a failing pod to retrieve events
kubectl describe pod <pod-name> -n production
```

An agent can invoke `kubectl` as a tool call and receive structured JSON or YAML output. This output can be parsed, filtered, and injected into the context window. The key discipline is filtering before injection: a `kubectl get pods --all-namespaces -o json` output for a large cluster may be tens of thousands of tokens. Pass only the fields the agent needs.

### `mesheryctl` - Meshery Control Plane

`mesheryctl` gives you access to the Meshery control plane state: registered models, active connections, designs, performance profiles, and environments.

```bash
# Check system health
mesheryctl system check

# List available designs
mesheryctl design list

# Import a design from a local file
mesheryctl design import -f designs/microservices-demo.yaml -s "Kubernetes Manifest"

# List registered models in the registry
mesheryctl registry list
```

For grounding an agent in your declared infrastructure, designs are especially valuable. A design encodes the intended state of your services and their relationships - precisely the context an agent needs when evaluating whether a proposed change is safe.

### MeshSync - Continuous Cluster Discovery

MeshSync is the Meshery Operator component that continuously observes cluster state and synchronizes it into Meshery's database. It runs inside the cluster and watches resources without requiring repeated `kubectl` calls from outside. From an agent's perspective, MeshSync data answers "what does Meshery currently believe about the cluster?" and includes topology, resource configurations, relationship mappings, and policy compliance status.

### Designs as Context

A Meshery design captures the intended configuration of one or more infrastructure components. Designs sit at the intersection of what you intended and what MeshSync reports as actual. Surfacing a relevant design to an agent before asking it to modify infrastructure gives it declared intent to compare against observed state. Store designs - including `designs/llm-mcp-gateway.yaml` and `designs/policy-guardrails.yaml` - in version control so retrieval pipelines can query them.

## How to Surface State to an Agent

There are two patterns for getting state into an agent's context window.

### Pattern 1 - Tool Calls at Runtime

The agent has access to tools that call `kubectl` or the Meshery API. When it needs to know the current replica count of a deployment, it calls the tool, receives the answer, and proceeds. This is the most accurate approach because the data is retrieved at the moment of need.

The tradeoff is latency: each tool call adds a round trip. For highly volatile state (pod status, event logs), runtime tool calls are worth it. For stable state (registered models, environment configs), pre-fetching is cheaper.

### Pattern 2 - Pre-fetched Context Injection

Before the agent begins reasoning, a harness script fetches a snapshot of relevant state and injects it into the system prompt or first user message. This is appropriate for state that changes slowly and for reducing the number of tool calls needed during a task.

```bash
# Example harness script fragment
NAMESPACE=production
DEPLOYMENTS=$(kubectl get deployments -n $NAMESPACE -o json | jq '[.items[] | {name:.metadata.name, replicas:.spec.replicas, ready:.status.readyReplicas}]')
echo "Current deployments in $NAMESPACE: $DEPLOYMENTS"
```

The fetched JSON is compact, structured, and directly usable by the agent.

## A Note on MCP

The Model Context Protocol (MCP) is a standard for connecting agents to tools and data sources in a structured, server-backed way. Rather than scripting tool calls ad hoc, MCP defines a contract that allows a Meshery server to expose resources - including MeshSync data, designs, and registry contents - to any compliant agent. MCP is covered fully in a later course in this learning path. For now, understand that the patterns described above (runtime tool calls, pre-fetched context) are what MCP formalizes and automates.
