---
type: "page"
id: "the-meshery-catalog"
title: "The Meshery Catalog"
description: "Save designs to the Meshery Catalog, use curated templates, and share reusable infrastructure patterns with your team."
weight: 2
---

## What is the Meshery Catalog?

The [Meshery Catalog](https://meshery.io/catalog) is a curated library of designs, filters, and patterns that the Meshery community and your organization can publish, discover, and deploy. It operates like a package registry for infrastructure intent: you publish a design once, and any team member - or any coding agent with access to Meshery - can import and deploy it on demand.

The Catalog solves a specific problem: raw YAML checked into a repository is opaque to anyone who did not write it. A Catalog entry wraps that YAML in a named, versioned, documented artifact with a description, tags, compatibility information, and a visual preview rendered by Kanvas. The artifact is searchable, filterable, and deployable without requiring the recipient to understand the underlying manifests.

## Saving a Design to the Catalog

After you have imported and validated a design (as you did in the previous lesson), you can publish it to the Catalog directly from Kanvas.

1. Open the design in Kanvas.
2. Click the **Publish** button in the top toolbar.
3. In the publish dialog, fill in the required metadata:
   - **Name** - a short, descriptive label (e.g. `microservices-demo`)
   - **Description** - one or two sentences about what the design deploys and why
   - **Tags** - keywords that make the design discoverable (`kubernetes`, `microservices`, `demo`)
   - **Compatibility** - the Kubernetes version range the design targets
4. Click **Publish to Catalog**.

Meshery sends the design YAML and metadata to the Catalog backend. After a brief review period for community submissions, the design appears in the Catalog UI and is discoverable via `mesheryctl`:

```bash
mesheryctl catalog list
mesheryctl catalog search --name microservices-demo
```

For private organizational Catalogs (available in Meshery Cloud), published designs are immediately visible to members of your organization without a review step.

## Using Catalog Entries as Templates

A Catalog entry is not just an artifact you deploy as-is - it is a template you can clone, modify, and re-publish. This is the recommended starting point for new designs: find the closest matching Catalog entry, clone it, adapt the components to your environment, and publish the variant under a new name.

To clone a Catalog entry from the CLI:

```bash
mesheryctl catalog clone --id <catalog-entry-id> --name my-custom-design
```

This pulls the design into your local Meshery instance as a new draft with the name you specified. Open it in Kanvas, make your changes, and follow the publish flow above when ready.

Templates are especially valuable when a coding agent is generating infrastructure. An agent can use a Catalog entry as a base context - passing the YAML to its context window - and then apply targeted mutations to produce a variant that matches a specific requirement. The agent does not need to produce valid Kubernetes YAML from scratch; it only needs to make correct, scoped changes to a known-good template.

## Discovering Community Designs

The public Meshery Catalog at [meshery.io/catalog](https://meshery.io/catalog) contains designs contributed by the community. Categories include:

| Category | Example entries |
|---|---|
| Observability | Prometheus + Grafana stacks, distributed tracing topologies |
| Networking | Istio service mesh configurations, Ingress patterns |
| Security | OPA policy bundles, NetworkPolicy templates |
| Platform | Multi-tenant namespace scaffolding, RBAC role sets |

Browse the Catalog in the UI or filter by tag:

```bash
mesheryctl catalog list --tag observability
```

To import a community design directly into your Meshery instance by its Catalog ID:

```bash
mesheryctl design import -f https://catalog.meshery.io/<catalog-entry-id>.yaml -s "Kubernetes Manifest"
```

The academy's `designs/observability-stack.yaml` file is modeled on the kind of entry you would find in the Observability category - a complete Prometheus and Grafana deployment ready to scrape a running cluster. Import it with the same command you used for the microservices demo:

```bash
mesheryctl design import -f designs/observability-stack.yaml -s "Kubernetes Manifest"
```

Open it in Kanvas to see how a multi-component observability stack is represented as a design topology, then consider how you would publish a variant of it to your organization's private Catalog.

The next lesson extends the Catalog concept into version control: backing your designs with GitHub so that every change is auditable and pull requests carry an infrastructure preview.
