---
type: "page"
id: "kanvas-the-visual-designer"
title: "Kanvas: the Visual Designer"
description: "Learn to use Kanvas - Meshery's visual designer - to visualize cluster topology, author infrastructure designs, deploy them to clusters, and explore the Catalog."
weight: 5
---

## What Is Kanvas?

Kanvas is the visual interface embedded in Meshery that lets platform engineers interact with infrastructure as diagrams rather than raw YAML. It serves two distinct but complementary purposes: **designing** infrastructure before it reaches a cluster, and **observing** infrastructure that is already running.

These are surfaced as two views within Kanvas: the **Designer** and the **Operator**.

## The Designer View

The Designer is a canvas where you build infrastructure by placing and connecting components. Think of it as a diagram tool that is backed by a real schema: every component you drag onto the canvas is a typed Meshery component from the registry, and every connection you draw between components is a typed relationship.

When you drop a `Deployment` component and a `Service` component onto the canvas and draw an edge between them, Kanvas validates that the relationship is valid (is the Service selector likely to match the Deployment's pod labels?) and flags problems as you work, not after you deploy.

### Building a Design

1. Open Kanvas in the Meshery UI.
2. Select the **Designer** tab.
3. Use the component panel on the left to search for and drag components onto the canvas. Start with a `Namespace`, then add a `Deployment` and a `Service` inside it.
4. Draw connections between components to declare relationships.
5. Edit component properties in the right-hand panel. Set the Deployment's label selectors and the Service's selector to match.
6. Save the design with a name. It is now version-controlled in your Meshery instance.

### Importing an Existing Design

You can also import an existing YAML manifest as a Meshery design:

```bash
mesheryctl design import -f designs/microservices-demo.yaml -s "Kubernetes Manifest"
```

After import, open the design in Kanvas Designer. Meshery parses the YAML, creates the corresponding components, and attempts to infer relationships between them from the registry. The result is a diagram of your manifest with structural validation applied.

Try this with the LLM gateway design as well:

```bash
mesheryctl design import -f designs/llm-mcp-gateway.yaml -s "Kubernetes Manifest"
```

Notice how the inferred relationships draw edges between the gateway components and the backing services - making the architecture immediately readable to anyone who opens the design.

### Deploying a Design

Once a design is ready, deploying it to a connected cluster is a single action:

```bash
mesheryctl design deploy <design-id>
```

Or use the **Deploy** button in the Kanvas UI. Meshery sends the design's components to the target cluster in dependency order, respecting the declared relationships to sequence the deployment correctly.

## The Operator View

The Operator view is read-only topology visualization. It shows you the live state of resources in your connected clusters as discovered by MeshSync. Unlike the Designer, which represents desired state, the Operator view represents current state.

Use the Operator view to:

- Confirm that a deployed design materialized as expected.
- Spot resources that are present in the cluster but absent from any design (undocumented infrastructure, or "shadow" resources).
- Watch topology changes propagate in real time as MeshSync reports them.

Nodes in the Operator view are color-coded by health status. A red node indicates a resource in an error state; a yellow node indicates a pending or degraded state; a green node indicates healthy.

## The Catalog

The **Catalog** is Meshery's shared library of community-contributed designs. It contains reference architectures, integration patterns, and tested configurations that you can import into your own instance with one click and adapt for your environment.

The Catalog is available in the Meshery UI under **Catalog** and at [meshery.io](https://meshery.io). When you publish a design from the Meshery UI, it becomes available to the broader community through the Catalog.

The academy's importable designs (`designs/microservices-demo.yaml`, `designs/observability-stack.yaml`, `designs/llm-mcp-gateway.yaml`, `designs/policy-guardrails.yaml`) are structured the same way as Catalog entries. You can use them as local references without publishing, or publish them to the Catalog to share with the community.

## Kanvas in Agentic Workflows

In later modules, you will see coding agents generate designs and submit them to Meshery for validation. The Kanvas Designer is the human-readable window into that process: you can open a design that an agent produced and inspect it visually before approving deployment. This is one of the key human-in-the-loop checkpoints in AI-assisted infrastructure management.

The visual graph format also makes agent-generated designs much easier to audit than raw YAML. Relationship edges surface intended connections; validation overlays surface problems. A reviewer can understand an agent's design in seconds rather than minutes.

## Summary

| View | Purpose | State type |
|---|---|---|
| Designer | Author, validate, deploy designs | Desired state |
| Operator | Observe live topology and health | Current state |

Kanvas bridges the gap between what you intend and what is running. The Designer enforces intent; the Operator reflects reality. Together they give you a complete picture of your infrastructure at any moment.

## Further Reading

- [Kanvas documentation](https://docs.meshery.io/kanvas)
- [Meshery Catalog](https://meshery.io/catalog)
- [Meshery designs documentation](https://docs.meshery.io/concepts/logical/designs)
