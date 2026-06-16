---
type: "page"
id: "co-designing-in-kanvas"
title: "Co-Designing in Kanvas"
description: "Understand the human+AI design loop in Kanvas, where an LLM proposes components and you arrange, validate, and approve them visually."
weight: 2
---

## Kanvas as the Shared Canvas

Kanvas is Meshery's visual infrastructure designer. It renders your infrastructure as a canvas of components - Deployments, Services, ConfigMaps, Ingresses, NetworkPolicies, and every other resource in the Meshery registry - that you can arrange, connect, annotate, and export as a Meshery design.

When you work with an LLM on an infrastructure design task, Kanvas serves as the single shared artifact. The LLM outputs a set of component definitions; Kanvas makes those definitions visual and interactive. You inspect them, reposition them for clarity, add relationships the LLM missed, and remove or modify anything that does not match your requirements. Neither side of this loop is optional: the LLM brings breadth and speed, and you bring domain judgment and accountability.

## The Agentic Loop in Practice

A coding agent driving infrastructure design typically follows this sequence:

1. **Receive the brief** - The agent reads your infrastructure brief (see lesson 3 for how to write one) and identifies the required components from the Meshery registry.
2. **Propose a design** - The agent emits component definitions - YAML or Meshery design format - covering workloads, services, networking, and storage.
3. **Load into Kanvas** - The design is imported into Meshery, either by the agent via the Meshery API or by you via `mesheryctl design import`.
4. **Human checkpoint** - You open Kanvas, inspect the canvas, and either accept, modify, or reject the proposal.
5. **Iterate** - If you reject or modify, you communicate the change back to the agent, which produces a revised proposal. The loop repeats until the design is approved.

This loop is what "human-in-the-loop" means in practice: not a passive review at the end, but an active checkpoint after every agent proposal. Kanvas makes that checkpoint concrete because you can see the full topology - not just a list of YAML files - and spot missing connections, over-privileged pods, or absent NetworkPolicies at a glance.

## What You Do in Each Iteration

When you open a proposed design in Kanvas, your job is structured, not open-ended. Work through these actions in order:

### 1. Check component presence

Scan the canvas for components your brief required. Open the component panel on the left and verify that every workload, service, and storage resource you specified is present. Missing components are the most common LLM omission.

### 2. Validate relationships

Kanvas renders relationships between components - Service-to-Deployment selectors, Ingress-to-Service backends, PVC-to-StatefulSet bindings. A broken or missing relationship shows as a disconnected component or a warning in the relationship panel. Fix these before moving on.

### 3. Arrange for readability

Drag components into a layout that reflects your mental model of the system: frontend components at the top, data layer at the bottom, namespace boundaries visible. This is not cosmetic - a readable layout surfaces architectural problems that a flat list of YAML files hides.

### 4. Annotate for your team

Add annotations to components that need explanation - why a particular resource limit was chosen, which team owns a service, which NetworkPolicy applies to which namespace. Annotations persist in the design and travel with it into the Meshery Catalog if you publish there.

### 5. Export or approve

When the design passes your review, export it as a Kubernetes manifest or save it as a Meshery design for reuse. The `designs/observability-stack.yaml` in the academy repository is an example of a Kanvas-exported design you can study and import:

```bash
mesheryctl design import -f designs/observability-stack.yaml -s "Kubernetes Manifest"
```

## The Human-in-the-Loop Checkpoint

The Kanvas checkpoint is not a formality. It is the moment when infrastructure intent (your brief), LLM capability (the proposal), and operational reality (your cluster's constraints) are reconciled. An LLM cannot know your organization's NetworkPolicy conventions, your team's naming standards, or the resource quotas on your namespace. You do. The checkpoint is where that knowledge enters the design.

Skipping or rushing the checkpoint is where AI-assisted infrastructure work fails. A design that looks complete in YAML can have subtle problems - a selector mismatch, a missing resource limit, a port collision - that are visible in Kanvas's relationship view but invisible in a text diff. Use the visual layer for what it is good at.

## Persisting the Loop with Meshery

Meshery's design system persists each iteration. Every version of a design you save is stored, and you can return to an earlier version if an iteration makes things worse. Use environments and workspaces to organize designs by team or cluster target, so the co-design loop for one project does not pollute another.

When the loop is complete and the design is approved, Meshery's MeshSync will reconcile the design's intended state with your cluster's actual state, and Meshery Operator will maintain that reconciliation over time.

## Summary

Co-designing in Kanvas means running a structured iteration loop: the LLM proposes, you inspect visually, you correct and iterate. The human checkpoint after each proposal is where domain judgment overrides LLM assumption. Kanvas makes that checkpoint fast and concrete by rendering the full topology rather than a wall of YAML.
