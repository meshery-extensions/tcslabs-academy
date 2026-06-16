---
type: "page"
id: "anatomy-of-a-meshery-design"
title: "Anatomy of a Meshery Design"
description: "Understand the structure of a Meshery design as valid Kubernetes YAML and what makes it importable."
weight: 1
---

A Meshery design is nothing more than valid Kubernetes YAML - but the specifics of that YAML determine whether Meshery can import it, render it in Kanvas, and deploy it to a cluster. Before you ask an LLM to generate a design, you need to know exactly what a correct design looks like from the inside.

## The Multi-Document Structure

Kubernetes YAML supports multi-document files: multiple resource definitions in a single file, each separated by a `---` delimiter. Meshery imports these files as a single named design, parses each document, and maps each resource to a component in its registry.

A minimal but realistic design contains at least:

- A `Namespace` to scope all other resources
- One or more `Deployment` resources
- Corresponding `Service` resources

The `designs/microservices-demo.yaml` file included in this academy is a three-tier example (frontend, API, cache) that follows this pattern exactly. Import it with:

```bash
mesheryctl design import -f designs/microservices-demo.yaml -s "Kubernetes Manifest"
```

The `-s "Kubernetes Manifest"` flag tells Meshery which design source type to use. If you omit it or pass a wrong value, the import fails before any YAML parsing occurs.

## Document Order and the Namespace

Always place the `Namespace` document first. Kubernetes itself does not enforce document ordering when you `kubectl apply`, but Meshery's import parser uses ordering to resolve intra-design references. Resources that reference a namespace that has not yet been parsed may fail validation.

```yaml
---
apiVersion: v1
kind: Namespace
metadata:
  name: tcslabs-demo
  labels:
    app.kubernetes.io/part-of: tcslabs-academy
```

## Deployments and Label Selectors

Every `Deployment` must have a `selector.matchLabels` block that matches the `template.metadata.labels` on the pod template. This is a Kubernetes requirement, not a Meshery one - but it is one of the most common points where LLM-generated YAML is wrong.

```yaml
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: api
  namespace: tcslabs-demo
spec:
  replicas: 2
  selector:
    matchLabels:
      app: api          # must match pod template labels
  template:
    metadata:
      labels:
        app: api        # must match selector above
    spec:
      containers:
        - name: api
          image: ghcr.io/stefanprodan/podinfo:6.6.2
          ports:
            - containerPort: 9898
          resources:
            requests:
              cpu: "50m"
              memory: "64Mi"
            limits:
              cpu: "200m"
              memory: "128Mi"
```

Note the `resources` block. Meshery's validation will flag deployments that lack resource requests and limits - and a cluster with a `LimitRange` will reject them outright. Always include them.

## Services and Port Mapping

A `Service` must reference pod labels through its `selector`, and the `port`/`targetPort` values must align with the ports declared in the container spec.

```yaml
---
apiVersion: v1
kind: Service
metadata:
  name: api
  namespace: tcslabs-demo
spec:
  selector:
    app: api
  ports:
    - port: 9898
      targetPort: 9898
```

A common LLM mistake is setting `targetPort` to the service port name rather than the numeric port, or referencing a label key that does not exist on the pod template.

## Supporting Resources

Designs may include `ConfigMap`, `Secret` (as opaque placeholders - never real secrets in a design file), `ServiceAccount`, `PersistentVolumeClaim`, and many other resource kinds. Each must specify the correct `apiVersion` for the resource kind - for example, `apps/v1` for Deployments and `v1` for ConfigMaps.

| Kind | apiVersion |
|------|-----------|
| Namespace | v1 |
| Deployment | apps/v1 |
| Service | v1 |
| ConfigMap | v1 |
| StatefulSet | apps/v1 |
| Ingress | networking.k8s.io/v1 |
| ServiceAccount | v1 |

Getting `apiVersion` wrong is the single most frequent LLM error and always causes an import failure.

## What Meshery Checks at Import

When you run `mesheryctl design import -f <file> -s "Kubernetes Manifest"`, Meshery performs three operations in sequence:

1. **Parse** - split the file on `---` delimiters and parse each document as YAML.
2. **Identify** - look up each `kind`/`apiVersion` pair against the Meshery component registry. Unknown combinations are flagged as unrecognised components.
3. **Validate** - check required fields and relationships (for example, that a Deployment's selector matches its pod template labels).

A design that passes all three steps appears in the Meshery Designs panel and can be opened in Kanvas for visual editing and deployment. Failures at any step are reported in the CLI output with enough detail to point you to the offending document.

## Key Takeaways

- A Meshery design is valid Kubernetes YAML with `---` document separators.
- Namespace first, then Deployments, then Services and supporting resources.
- Selectors must match pod template labels exactly.
- Include resource requests and limits on every container.
- Use the correct `apiVersion` for each resource kind.
- The import command is `mesheryctl design import -f <file> -s "Kubernetes Manifest"`.
