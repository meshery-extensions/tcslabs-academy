---
type: "page"
id: "from-intent-to-topology"
title: "From Intent to Topology"
description: "Translate a plain-language infrastructure requirement into a concrete cloud native topology covering workloads, services, data, and networking."
weight: 1
---

## What is a Topology?

A cloud native topology is the explicit, structured representation of everything that needs to exist in your cluster - or across clusters - to satisfy a requirement. It names each workload (Deployments, StatefulSets, Jobs), the Services that expose them, the data stores they depend on, the networking rules that connect or isolate them, and the relationships between all of those components.

When you start with a plain-language requirement - "run a checkout service that persists orders to a database and exposes an API to the frontend" - you have an intent, not a topology. The gap between intent and topology is where most design errors live. Closing that gap deliberately, rather than by intuition, is what this lesson is about.

## What an LLM Needs to Produce a Useful Design

An LLM working on infrastructure design is solving a constraint-satisfaction problem. The more constraints you supply, the fewer gaps it has to fill with assumptions, and the fewer corrections you need to make afterward.

At minimum, give an LLM the following four categories of information:

| Category | What to specify | Example |
|---|---|---|
| **Workloads** | Services and their roles | "A stateless API server, a background worker, and a cache" |
| **Data** | Persistence and access patterns | "PostgreSQL for orders; Redis for session state; no cross-service DB sharing" |
| **Networking** | Exposure and isolation | "API server exposed via Ingress; worker and DB internal only; TLS required" |
| **Non-functionals** | Scale, availability, security | "API server scales from 2-10 replicas; worker is single-instance; pod security standards: restricted" |

If any of these four are absent, the LLM will make a choice. Sometimes it will make the right one. You cannot count on that in production.

## Walking Through an Example

Suppose your requirement is:

> "Deploy a microservices demo with a frontend, a cart service, a product catalog, and a checkout service. The checkout service writes to a database. Everything should be observable."

That sentence contains: workload names (frontend, cart, catalog, checkout), a data dependency (checkout writes to DB), and a non-functional intent (observable). It does not contain: replica counts, which database engine, how services communicate (HTTP, gRPC), whether there is an Ingress, what "observable" means in concrete terms (metrics? traces? logs?).

Before passing this to an LLM, fill the gaps:

```text
Workloads:
  - frontend: stateless, 2 replicas, Ingress on port 80/443
  - cart: stateless, 2 replicas, internal ClusterIP
  - catalog: stateless, 2 replicas, internal ClusterIP
  - checkout: stateless, 2 replicas, internal ClusterIP

Data:
  - PostgreSQL (StatefulSet, 1 replica) for checkout only
  - No direct DB access from frontend, cart, or catalog

Networking:
  - All inter-service communication over HTTP/2 (gRPC)
  - frontend exposed via Ingress; all others ClusterIP only

Non-functionals:
  - Pod security standard: baseline
  - Resource requests/limits required on all containers
  - Prometheus scrape annotations on all Deployments
  - No privileged containers
```

This brief is the input to the next lesson. The academy's `designs/microservices-demo.yaml` is an importable reference for this exact topology - you can load it with:

```bash
mesheryctl design import -f designs/microservices-demo.yaml -s "Kubernetes Manifest"
```

## Identifying the Topology Primitives

Once you have a complete brief, map it to Kubernetes and Meshery primitives before the LLM does. This gives you a checklist to verify the output against:

- **Workloads** - Deployment, StatefulSet, DaemonSet, or Job per service
- **Services** - ClusterIP, NodePort, or LoadBalancer; one per workload minimum
- **ConfigMaps and Secrets** - per environment variable surface
- **Ingress or Gateway API** - one per external entry point
- **NetworkPolicy** - one per namespace or isolation boundary
- **PersistentVolumeClaim** - one per stateful workload
- **ServiceAccount** - one per workload that calls the Kubernetes API or needs IRSA/Workload Identity

If the topology you receive back from the LLM is missing any of these that your brief implied, that is a gap to fix before the design reaches your cluster.

## What to Leave Unspecified

Not everything needs to be in the brief. Container image tags, exact label selectors, and annotation formats are details the LLM can fill in from convention - and that you will review visually in Kanvas. Over-specifying at this stage creates noise that can distract the LLM from the structural decisions that actually matter.

Leave out: specific image versions, exact CPU/memory values (specify "set reasonable defaults"), and boilerplate labels. Your review step - covered in lesson 4 - is the right place to inspect and correct those.

## Summary

The jump from intent to topology requires you to specify workloads, data, networking, and non-functionals before asking an LLM to design anything. Gaps you leave become assumptions the LLM makes. Make the gaps intentional and small, and your AI-assisted design session will produce something reviewable rather than something that needs to be rebuilt from scratch.
