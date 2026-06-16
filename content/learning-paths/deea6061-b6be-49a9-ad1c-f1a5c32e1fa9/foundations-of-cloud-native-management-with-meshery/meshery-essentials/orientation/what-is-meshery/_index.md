---
type: "page"
id: "what-is-meshery"
title: "What Is Meshery?"
description: "Learn what Meshery is, the problems it solves across multi-cluster environments, and where it fits relative to kubectl and other Kubernetes tools."
weight: 1
---

## The Manager of Managers

Kubernetes solved container orchestration within a single cluster. The industry then discovered that one cluster is never enough. Real production systems span multiple clusters across clouds and on-premises data centers, each running dozens of services owned by different teams, each with its own mesh, gateway, observability stack, and policy engine. Managing all of that with `kubectl` alone is like administering a city by hand-editing `/etc/hosts`.

Meshery describes itself as the open-source **cloud native manager** - and specifically as a "manager of managers." It does not replace Kubernetes. It sits above it and aggregates control across every cluster, every service mesh, every cloud native tool in your estate. If you have used a cloud provider's unified management console, you have the right mental picture - except Meshery is vendor-neutral and community-governed under the [Cloud Native Computing Foundation](https://cncf.io).

## What Problems Does Meshery Solve?

### Visibility

In a fleet of clusters, answering "what is running where?" should take seconds, not hours. Meshery continuously discovers every resource across connected clusters through its MeshSync component and surfaces them in a single UI. You can see workloads, services, configurations, and their relationships without writing a single `kubectl get` command.

### Lifecycle Management

Deploying an application to multiple clusters, rolling it back when something breaks, and knowing the authoritative state of a deployment at any given moment are lifecycle problems. Meshery manages Kubernetes resources as **designs** - versioned, importable, and deployable - so lifecycle operations become repeatable and auditable.

### Configuration

Keeping configuration consistent across clusters is one of the hardest problems in platform engineering. Drift between environments causes outages that are painful to debug. Meshery's registry of models, components, and relationships lets you validate configuration before it is applied, catching structural errors early.

### Performance

Knowing whether your cluster is saturated or has headroom requires continuous benchmarking. Meshery includes a performance management system, built around [Service Mesh Performance (SMP)](https://layer5.io), that runs load tests with `mesheryctl perf apply` and stores results against named profiles for trend comparison over time.

### Governance

Who is allowed to deploy what, and to which environments? Policy enforcement in distributed systems is notoriously fragile when it is applied ad-hoc. Meshery integrates with policy engines such as [Open Policy Agent](https://openpolicyagent.org) and enforces governance rules at design validation time, before workloads ever reach a cluster.

## Where Meshery Sits Relative to kubectl

`kubectl` is a single-cluster imperative tool. It is excellent for what it does: sending API requests to one Kubernetes control plane at a time. Meshery is a multi-cluster, declarative management layer that sits above the control planes.

| Capability | kubectl | Meshery |
|---|---|---|
| Scope | Single cluster | Multi-cluster, multi-mesh |
| Interaction model | Imperative commands | Declarative designs |
| Topology visibility | Limited | Full, with relationships |
| Performance benchmarking | No | Yes, via SMP |
| Policy governance | No | Yes, with OPA integration |
| Service mesh management | No | Yes, adapter per mesh |

Importantly, Meshery does not discard `kubectl`. You still use `kubectl` for targeted, low-level operations. Meshery is the plane above it - the place where you reason about your whole infrastructure, author designs that are valid before they are applied, and let coding agents operate on real cluster state through structured APIs.

## Meshery and Agentic Workflows

One reason Meshery matters to this academy is that it provides the structured interface that coding agents need to act on infrastructure reliably. A language model given raw `kubectl` access and an untyped YAML file faces enormous ambiguity. Meshery's registry - with typed components and declared relationships - gives an agent a schema to reason against, a validation step to catch hallucinated configurations, and a set of discrete operations (deploy, undeploy, validate, benchmark) that map naturally to tool calls.

You will explore this connection in depth later in the curriculum. For now, understand that Meshery's design as a structured manager is also what makes it a safe, auditable substrate for AI-assisted operations.

## Further Reading

- [Meshery project overview](https://meshery.io)
- [Meshery documentation](https://docs.meshery.io)
- [CNCF landscape entry](https://landscape.cncf.io)
