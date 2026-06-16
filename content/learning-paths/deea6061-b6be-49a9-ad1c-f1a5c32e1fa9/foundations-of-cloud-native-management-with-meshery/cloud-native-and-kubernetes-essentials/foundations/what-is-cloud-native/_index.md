---
type: "page"
id: "what-is-cloud-native"
title: "What Is Cloud Native?"
description: "Define cloud native computing, understand its core pillars - containers, orchestration, and dynamic management - and explore why the CNCF ecosystem is the operating environment for AI-driven infrastructure."
weight: 1
---

## Defining Cloud Native

"Cloud native" is one of those terms the industry has stretched in many directions. A precise definition matters before you build on top of it.

The Cloud Native Computing Foundation (CNCF) defines cloud native technologies as those that "empower organizations to build and run scalable applications in modern, dynamic environments such as public, private, and hybrid clouds." The operational emphasis is on **scalable**, **dynamic**, and **automated** - not on where the hardware lives.

Three pillars hold that definition up:

1. **Containers** - the unit of packaging and deployment. A container bundles an application and every dependency it needs into an immutable, portable artifact. It runs identically on a developer laptop and a production cluster.
2. **Orchestration** - the system that decides where containers run, restarts them when they fail, scales them up under load, and routes traffic to healthy instances. Kubernetes is the orchestration layer the industry has standardized on.
3. **Dynamic management** - the infrastructure responds to declared intent rather than manual intervention. When the desired state diverges from the actual state, a control loop corrects the divergence automatically.

These three pillars are not independent. Containers make orchestration possible at scale. Orchestration makes dynamic management practical. Dynamic management is what allows coding agents and LLMs to safely operate on your infrastructure - they issue declarations, and the system reconciles.

## The CNCF Landscape

The CNCF hosts over 150 graduated, incubating, and sandbox projects spanning every layer of the cloud native stack: container runtimes, orchestrators, service meshes, observability tools, policy engines, CI/CD systems, and more. You can browse the full map at [landscape.cncf.io](https://landscape.cncf.io).

The breadth of that landscape is both an asset and a challenge. The asset: every problem in distributed systems management has at least one open-source solution. The challenge: integrating those solutions, keeping them current, and reasoning about their collective state is operationally expensive.

Meshery addresses that challenge directly. It models the CNCF landscape as a **registry** of components, models, and relationships. When you import a design into Meshery, it understands not just the raw Kubernetes YAML, but the semantic relationships between the objects - which service depends on which deployment, which ingress routes to which service, which policy applies to which workload. That semantic layer is what makes agentic operations tractable.

## Why This Matters for AI-Driven Operations

A coding agent managing infrastructure needs to:

- Read the current state of the cluster
- Understand what the desired state should be
- Issue the correct API calls to move from current to desired
- Verify that reconciliation succeeded

Every step in that loop is easier when the infrastructure is cloud native. Container images are immutable artifacts with known contents. Kubernetes exposes a consistent, declarative API surface. The control loop provides a feedback signal the agent can observe. The CNCF ecosystem provides standardized interfaces - metrics, traces, logs, policy - that the agent can query.

Contrast this with imperative, script-driven infrastructure, where the agent must reconstruct current state by running commands and parsing their output, issue imperative commands whose effects are not guaranteed, and have no systematic way to verify success. The cloud native model is not just operationally superior - it is the prerequisite for safe agentic automation.

## What Comes Next

The following lessons build each pillar in detail:

- **Containers and Images** - what a container is at the kernel level, and why immutability matters
- **Kubernetes Essentials** - the objects, the control loop, and the declarative API
- **Declarative Infrastructure and GitOps** - how to manage desired state in version control, and why that is the right substrate for LLM-assisted operations

Each lesson is self-contained but assumes the vocabulary introduced here. Take a moment to revisit the three pillars - containers, orchestration, dynamic management - before moving on.

For a deeper orientation to the CNCF ecosystem, see the CNCF's own overview at [cncf.io](https://www.cncf.io) and the [landscape](https://landscape.cncf.io).
