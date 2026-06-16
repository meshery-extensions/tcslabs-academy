---
type: "page"
id: "meshery-architecture"
title: "Meshery Architecture"
description: "Understand the components that make up a Meshery deployment - Server, Operator, MeshSync, adapters, the Broker, and Kanvas - and how discovery and state sync work across managed clusters."
weight: 2
---

## The Two Planes

Meshery's architecture divides cleanly into two planes: the **control plane** that runs Meshery itself, and the **managed clusters** that Meshery observes and operates on. Understanding this separation is essential before you install anything, because it determines where each component lives and what it is allowed to do.

## Meshery Server

The Meshery Server is the central brain. It exposes a REST and GraphQL API that the browser UI, `mesheryctl`, adapters, and - critically - coding agents all talk to. It maintains state in a local database (SQLite by default, PostgreSQL for production), owns the design registry, and orchestrates all lifecycle operations.

The Server runs wherever you choose to host it: your laptop, a dedicated VM, or inside a Kubernetes cluster. When you run `mesheryctl system start`, the CLI bootstraps the Server (typically as a Docker container or a Kubernetes deployment) and leaves it running.

## Meshery Operator

The Meshery Operator is a Kubernetes operator that runs **inside each managed cluster**. It is the local agent that bridges the managed cluster back to the Meshery Server. The Operator does two things:

1. It deploys and manages **MeshSync** in the cluster.
2. It manages the **Broker** (NATS) messaging component.

When you connect a cluster to Meshery, the Server pushes the Operator into that cluster via the cluster's kubeconfig.

## MeshSync

MeshSync is a discovery and state-sync engine. It runs as a pod inside the managed cluster and continuously watches the Kubernetes API server for changes to every resource type it knows about - Deployments, Services, ConfigMaps, CRDs from service meshes, and more. When it detects a change, it publishes a structured event to the Broker.

This is how Meshery achieves real-time topology awareness without polling or scraping. MeshSync pushes; the Server subscribes.

## The Broker (NATS)

The Broker is a NATS messaging server that the Operator deploys alongside MeshSync. It is the communication backbone between a managed cluster and the Meshery Server. MeshSync publishes discovery events to NATS topics; the Meshery Server subscribes and updates its internal state accordingly.

The NATS architecture decouples discovery from storage. If the Meshery Server restarts, it simply re-subscribes and receives the current cluster state from MeshSync's replay. This makes the system resilient to Server restarts without losing visibility.

## Adapters

Adapters are optional service-mesh-specific components that Meshery can connect to. Each supported service mesh - Istio, Linkerd, Consul Connect, and others - has a corresponding adapter that speaks the mesh's native API and translates operations into Meshery's unified model.

Adapters are not required if you are only managing plain Kubernetes workloads. They become relevant when you need mesh-specific operations: installing a mesh, configuring traffic policies, or running mesh-specific performance tests.

## Kanvas

Kanvas is Meshery's visual designer and topology viewer, integrated directly into the Meshery UI. It deserves its own section in this course (Lesson 5), but architecturally it is a front-end component that reads from the Meshery Server's registry and renders designs and live topology as interactive graphs. Kanvas is where platform engineers author infrastructure visually and where operators watch live cluster state.

## How Discovery and State Sync Work End-to-End

The flow, from cluster resource to Meshery UI, goes like this:

```text
Kubernetes API server
  └─► MeshSync (watches resources in the managed cluster)
        └─► Broker / NATS (event bus in the managed cluster)
              └─► Meshery Server (subscribes, stores in registry)
                    └─► Kanvas / UI / API / mesheryctl
```

1. A resource changes in the managed cluster (new Deployment, updated ConfigMap, etc.).
2. MeshSync detects the change via its watches.
3. MeshSync publishes a structured event to the NATS Broker.
4. The Meshery Server's subscriber receives the event and updates the internal state database.
5. The UI (Kanvas) and API consumers reflect the updated state immediately.

## Control Plane vs Managed Clusters

| Location | Components |
|---|---|
| Control plane (where Meshery Server runs) | Meshery Server, Provider connections, Kanvas UI |
| Each managed cluster | Meshery Operator, MeshSync, Broker (NATS), optional Adapters |

A single Meshery Server can manage many clusters simultaneously. Each cluster runs its own Operator, MeshSync, and Broker. The Server aggregates all of their feeds into a unified view.

## Further Reading

- [Meshery architecture overview](https://docs.meshery.io/architecture)
- [MeshSync documentation](https://docs.meshery.io/concepts/architecture/meshsync)
- [Meshery Operator documentation](https://docs.meshery.io/concepts/architecture/operator)
