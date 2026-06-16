---
type: "page"
id: "authoring-your-first-design"
title: "Authoring Your First Design"
description: "Understand what a Meshery design is, import a real design from file, inspect it in Kanvas, and deploy it to a cluster."
weight: 1
---

## What is a Meshery Design?

A Meshery design is a YAML document that expresses infrastructure intent. It combines Kubernetes resource manifests with Meshery-specific metadata: component annotations, relationship declarations, visual layout hints for Kanvas, and optional policy references. Think of it as a blueprint that can be opened, validated, versioned, and deployed - the single artifact that moves from a developer's laptop to a production cluster.

Designs are distinct from raw Kubernetes manifests in one important way: they carry _relationships_. A design can declare that a Deployment depends on a ConfigMap, that a Service should route to specific Pod labels, or that two microservices communicate over a particular network path. Meshery's registry uses those relationships to validate the design before deployment and to render a meaningful topology in Kanvas.

The canonical format for a design file uses the `.yaml` extension and is importable from any source Meshery understands - local files, URLs, GitHub repositories, or the Catalog.

## Importing the Academy Design

The academy ships a sample design at `designs/microservices-demo.yaml`. This file contains a realistic microservices topology - several Deployments, Services, and a Gateway resource - sized to run on a small local cluster.

Import it with `mesheryctl`:

```bash
mesheryctl design import -f designs/microservices-demo.yaml -s "Kubernetes Manifest"
```

The `-f` flag accepts a relative or absolute file path. The `-s` flag tells Meshery which source schema to apply when parsing the file. `"Kubernetes Manifest"` is the correct schema for standard Kubernetes YAML; Meshery will parse each document in the file, resolve its kind, and map it to a registered component in the registry.

A successful import returns the design ID and a confirmation line:

```text
Design imported successfully.
Design ID: <uuid>
```

If the import fails, verify that Meshery is running (`mesheryctl system check`) and that the file path is correct relative to your working directory.

## Opening the Design in Kanvas

After import, open the Meshery UI and navigate to **Designs** in the left sidebar. You will see `microservices-demo` listed. Click it to open the design in Kanvas, Meshery's visual infrastructure designer.

Kanvas renders each component as a node and draws edges between components that share a declared relationship. For the microservices demo you will see:

| Node type | What it represents |
|---|---|
| Deployment | A workload that Kubernetes manages as a replica set |
| Service | A stable network endpoint that routes to Pod labels |
| ConfigMap | Configuration data mounted into Pods |
| Gateway | An ingress resource routing external traffic |

Use the canvas controls to zoom, pan, and select individual nodes. Clicking a node opens its component panel on the right - a structured form backed by the JSON Schema for that component kind. You can edit fields directly in the panel and Kanvas will update the underlying YAML in real time.

Take a few minutes to explore the topology. Notice how Kanvas draws an arrow from each Service to its target Deployment - this relationship was inferred from the `selector` fields in the manifest, not hand-drawn. That inference is the registry's work.

## Deploying the Design

When you are satisfied with the design, deploy it to the connected cluster from the Kanvas toolbar. Click the **Deploy** button (the upward-pointing arrow icon) and confirm the target environment in the dialog that appears.

Meshery sends each component to the Kubernetes API server in dependency order: ConfigMaps and Secrets first, then Deployments, then Services. Progress is shown in the **Notifications** panel. When all components reach a ready state, the nodes in Kanvas update with a green status indicator.

You can also deploy from the CLI:

```bash
mesheryctl design deploy --id <design-id>
```

Replace `<design-id>` with the UUID returned during import, or retrieve it with `mesheryctl design list`.

To confirm the workloads are running on the cluster:

```bash
kubectl get pods -n default
kubectl get svc -n default
```

You have now completed the full import-inspect-deploy cycle for a Meshery design. The next lesson covers the Catalog - the mechanism for saving designs so your team can discover and reuse them.
