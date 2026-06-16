---
type: "page"
id: "exposing-cluster-state-as-resources"
title: "Exposing Cluster State as Resources"
description: "Model read-only Kubernetes and Meshery state from MeshSync as MCP resources that an agent can fetch by URI on demand."
weight: 3
---

## Tools vs Resources in MCP

MCP distinguishes between two primitives an agent can access:

- **Tools** - callable functions. The agent invokes them with arguments and receives a response. Tools are stateless from the server's perspective.
- **Resources** - addressable content identified by a URI. The agent requests them by URI when it needs the current state of something. Resources are read-only and are typically fetched rather than invoked.

Cluster state is a natural fit for resources. An agent that needs to know what Deployments are running in `prod` should not need to call a function - it should be able to fetch a URI and get back a snapshot. This separation also makes the agent's context window more predictable: tools produce responses inline, while resources can be loaded selectively as the agent decides what context it needs.

## What MeshSync Provides

MeshSync is the Meshery component responsible for observing Kubernetes cluster state. It runs as part of the Meshery Operator and continuously syncs resource metadata into Meshery's data store. Through MeshSync you have access to:

- Nodes, namespaces, and their labels/annotations
- Workload resources: Deployments, DaemonSets, StatefulSets, ReplicaSets
- Network resources: Services, Ingresses, NetworkPolicies
- Configuration resources: ConfigMaps, Secrets (names only, not values)
- Custom resources registered in the cluster

This is all accessible via Meshery's REST API at `/api/v1/meshsync/resources`. You do not need direct cluster access in your MCP server - MeshSync is the intermediary.

## Defining MCP Resources for Cluster State

Each resource you expose needs a URI scheme, a MIME type, and a description. A practical scheme for Meshery-backed resources:

```text
meshery://cluster/<context>/<namespace>/<kind>/<name>
```

Examples:

| URI | What it returns |
|---|---|
| `meshery://cluster/local/prod/Deployment/frontend` | Status snapshot of the frontend Deployment in prod |
| `meshery://cluster/local/kube-system/DaemonSet/kube-proxy` | Status snapshot of kube-proxy |
| `meshery://cluster/local/-/Node/worker-1` | Node metadata (namespace not applicable, use `-`) |

In your MCP server's resource list handler, enumerate the resources currently known to MeshSync:

```text
GET /api/v1/meshsync/resources?kind=Deployment,DaemonSet,StatefulSet

for each r in response.resources:
  yield Resource {
    uri:         "meshery://cluster/" + r.cluster_name + "/" + r.namespace + "/" + r.kind + "/" + r.name,
    name:        r.name,
    description: r.kind + " in " + r.namespace,
    mimeType:    "application/json"
  }
```

The list is dynamic - as MeshSync observes new resources, they appear in subsequent list responses.

## Fetching a Resource by URI

When the agent fetches a resource URI, your server parses the URI, maps it back to a MeshSync query, and returns the content:

```text
URI received: meshery://cluster/local/prod/Deployment/frontend

Parse:
  context   = "local"
  namespace = "prod"
  kind      = "Deployment"
  name      = "frontend"

Query:
  GET /api/v1/meshsync/resources
    ?cluster=local&namespace=prod&kind=Deployment&name=frontend

Return content:
  {
    "kind": "Deployment",
    "name": "frontend",
    "namespace": "prod",
    "readyReplicas": 3,
    "desiredReplicas": 3,
    "conditions": [...]
  }
```

## Meshery Environment State as Resources

Beyond cluster state, you can expose Meshery-level state as resources:

| URI | Backing API |
|---|---|
| `meshery://environments` | `GET /api/v1/environments` |
| `meshery://workspaces` | `GET /api/v1/workspaces` |
| `meshery://designs` | `GET /api/v1/designs` |
| `meshery://registry/models` | GraphQL registry query |

These give the agent a read-only picture of the Meshery management layer - what environments exist, what designs are available, what models are registered - without requiring it to call a tool first.

## Keeping Resources Consistent with MeshSync

MeshSync data has a propagation delay. When a Deployment is updated in the cluster, MeshSync may take a few seconds to reflect the change. Document this in your resource descriptions:

```text
description: >
  Last-known state of the Deployment as observed by MeshSync.
  May lag cluster reality by up to 30 seconds.
```

This lets the agent calibrate how much to trust the resource snapshot and when it should re-fetch or escalate to a human before acting on potentially stale data. For time-sensitive decisions, the agent should call a tool (which triggers a live API query) rather than relying on a cached resource.

## Validating Resource Coverage

After implementing resource listing and fetching, import the academy's sample designs and verify the resources they create appear in your server's list:

```bash
mesheryctl design import -f designs/observability-stack.yaml -s "Kubernetes Manifest"
mesheryctl design import -f designs/llm-mcp-gateway.yaml -s "Kubernetes Manifest"
```

Deploy one to a local cluster and confirm that MeshSync picks up the resulting workloads. A resource URI for each pod controller should appear in your server's list within 30 seconds of deployment.
