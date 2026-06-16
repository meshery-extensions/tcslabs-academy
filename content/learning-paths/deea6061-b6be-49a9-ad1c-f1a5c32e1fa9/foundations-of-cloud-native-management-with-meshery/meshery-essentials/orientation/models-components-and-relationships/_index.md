---
type: "page"
id: "models-components-and-relationships"
title: "Models, Components, and Relationships"
description: "Understand the Meshery registry - models, components, and relationships - and how relationships enable design validation and safe AI-generated infrastructure."
weight: 4
---

## The Registry: Meshery's Schema Layer

Every infrastructure tool invents its own terminology for the same underlying concepts: resources, kinds, entities. Meshery resolves this fragmentation through a unified **registry** - a catalog of structured definitions that describes everything Meshery knows how to manage.

The registry has three tiers: **Models**, **Components**, and **Relationships**.

## Models

A **Model** is the top-level grouping. It represents a technology domain - Kubernetes core, Istio, Prometheus, Cert-Manager, and so on. Each model is versioned and packages together all of the components and relationships that belong to that technology.

When you connect a cluster and Meshery discovers an Istio installation, it loads the Istio model. The model tells Meshery what Istio resources exist, what their fields mean, and how they relate to each other and to Kubernetes resources.

You can inspect loaded models from the UI under **Registry** > **Models** or from the CLI:

```bash
mesheryctl registry list
```

Models are community-maintained and distributed through the Meshery project. If a tool you care about does not have a model yet, contributing one is a direct way to extend Meshery's management capabilities.

## Components

A **Component** is a typed definition of a single manageable resource within a model. It maps roughly to a Kubernetes resource kind - but the concept generalizes beyond Kubernetes. Every component definition includes:

- A **schema** describing its valid fields and their types.
- A **display name** and **category** for UI presentation.
- **Metadata** about which API group and version it belongs to.

For example, the Kubernetes model contains components for `Deployment`, `Service`, `ConfigMap`, `Ingress`, and every other core API object. The Istio model contains components for `VirtualService`, `DestinationRule`, `Gateway`, and so on.

When you drag a component onto the Kanvas canvas or import a design, Meshery validates the component's fields against its schema. This is the first layer of validation - structural correctness.

## Relationships

**Relationships** are where the registry becomes genuinely powerful. A relationship is a declared, typed connection between two components. Relationships model things like:

- A `Deployment` selects `Pods` via a label selector.
- An `Ingress` routes traffic to a `Service`.
- A `VirtualService` applies to a `Deployment` in the same namespace.
- A `ServiceAccount` is bound to a `ClusterRole` via a `ClusterRoleBinding`.

Relationships are directional and typed. They are not inferred heuristically at runtime - they are declared in the registry by people who understand how the technologies work.

### Why Relationships Enable Validation

Structural schema validation (are the field names and types correct?) catches a class of errors, but not the most dangerous ones. The dangerous errors are semantic: a label selector that does not match any pod, a service port that does not align with the container port it should reach, an Istio VirtualService that references a host that has no corresponding service.

These errors pass schema validation because the fields themselves are syntactically valid. They fail at runtime - often silently, often in production.

Relationships enable Meshery to catch them at design time. When you build or import a design, Meshery evaluates declared relationships and flags mismatches: "this Ingress backend references a Service named `api` but no such Service exists in this design."

### Relationships and AI-Generated Designs

This validation layer is what makes Meshery a safe substrate for AI-generated infrastructure configurations. A coding agent constructing a Kubernetes deployment from a natural language prompt can produce syntactically valid YAML that is semantically broken - wrong selectors, missing services, port mismatches. Without a validation step, that configuration reaches the cluster and fails in opaque ways.

When the agent submits the design to Meshery, relationship validation runs before deployment. Structural and semantic errors surface as structured feedback that the agent can interpret and correct - closing the loop without human intervention for the common cases.

You can import the academy's observability stack design to see the registry in action:

```bash
mesheryctl design import -f designs/observability-stack.yaml -s "Kubernetes Manifest"
```

Inspect it in the Kanvas UI. Notice that relationships between components are drawn as edges in the graph - they are not decorative. Each edge represents a declared relationship from the registry, and each one is actively validated.

## The Registry as a Living Catalog

The registry is not static. When you connect a new cluster that has custom CRDs installed, Meshery discovers those CRDs and synthesizes component definitions for them automatically. This means the registry grows with your infrastructure: if your team installs a custom operator, its CRDs become first-class Meshery components.

This extensibility is what allows Meshery to remain vendor-neutral while still providing deep, validated management for any Kubernetes-based technology.

## Further Reading

- [Meshery registry documentation](https://docs.meshery.io/concepts/logical/models)
- [Meshery components](https://docs.meshery.io/concepts/logical/components)
- [Meshery relationships](https://docs.meshery.io/concepts/logical/relationships)
