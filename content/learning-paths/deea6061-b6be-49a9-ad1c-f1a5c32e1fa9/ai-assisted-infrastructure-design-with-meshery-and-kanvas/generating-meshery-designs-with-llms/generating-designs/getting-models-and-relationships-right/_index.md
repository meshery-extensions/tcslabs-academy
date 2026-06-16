---
type: "page"
id: "getting-models-and-relationships-right"
title: "Getting Models and Relationships Right"
description: "Align generated designs with the Meshery registry and understand how validation catches common LLM mistakes."
weight: 3
---

Meshery does not treat a design as a bag of YAML documents. It maps every resource in your design to a registered component - a typed, versioned entity in the Meshery registry. If the mapping fails, the resource is marked as unrecognised and cannot be managed, visualised, or deployed through Meshery. This lesson explains the registry model, the most common ways LLM-generated YAML breaks it, and how to use Meshery's validation to close the gap.

## The Meshery Registry

The Meshery registry is a catalogue of models, components, and relationships. Understanding each level helps you understand what can go wrong.

**Models** correspond to integrations - Kubernetes core, Istio, Prometheus, NGINX, and so on. Each model is versioned and describes a set of components that Meshery knows how to manage.

**Components** are the individual resource types within a model. The Kubernetes core model, for example, contains components for Deployment, Service, ConfigMap, Namespace, and many others. Each component is identified by its `kind` and `apiVersion`.

**Relationships** describe how components connect to each other - for example, that a Service's `selector` should match a Deployment's pod template labels, or that a Pod's `serviceAccountName` should reference a ServiceAccount in the same namespace. Relationships are evaluated during validation and visualised in Kanvas as connectors between component nodes.

When you import a design, Meshery resolves every `kind`/`apiVersion` pair against the registry. A pair that is not in the registry produces a warning; a pair that is present but with the wrong version produces a type mismatch error. Both prevent full management of the affected resource.

## Common Mistakes in LLM-Generated Designs

### Wrong apiVersion

This is the most frequent failure. LLMs trained on older data may produce deprecated API groups:

| LLM output | Correct |
|-----------|---------|
| `extensions/v1beta1` for Deployment | `apps/v1` |
| `apps/v1beta1` for StatefulSet | `apps/v1` |
| `networking.k8s.io/v1beta1` for Ingress | `networking.k8s.io/v1` |
| `rbac.authorization.k8s.io/v1beta1` | `rbac.authorization.k8s.io/v1` |

The Kubernetes API server removed these versions in 1.16-1.22. Meshery's registry reflects current, supported API versions. Any deprecated version will either fail the Meshery component lookup or be rejected by the cluster on deployment.

### Selector Mismatch

A Deployment's `spec.selector.matchLabels` must be an exact subset of `spec.template.metadata.labels`. LLMs occasionally produce designs where the selector references a label that is not present on the pod template, or adds a label to the template that is not in the selector.

```yaml
# Broken - selector key does not appear in template labels
spec:
  selector:
    matchLabels:
      app: api
      tier: backend       # not in template
  template:
    metadata:
      labels:
        app: api          # selector key present
        component: api    # different key from selector
```

Meshery flags this as a relationship validation failure. The relationship rule for Deployment-to-Pod requires that `matchLabels` is a subset of template labels.

### Missing Resource Limits

Deployments without resource requests and limits are common in tutorial YAML but problematic in practice. Meshery's validation marks containers without `resources.requests` and `resources.limits` with a warning. Clusters with a `LimitRange` admission controller will reject them outright.

```yaml
# Always include resource constraints
resources:
  requests:
    cpu: "50m"
    memory: "64Mi"
  limits:
    cpu: "200m"
    memory: "128Mi"
```

### Service targetPort Mismatch

A Service's `targetPort` must match a `containerPort` declared in the referenced pod spec. LLMs sometimes invent port numbers or use port names that do not exist in the Deployment.

```yaml
# Broken - targetPort 8080 does not match containerPort 9898
spec:
  ports:
    - port: 80
      targetPort: 8080    # wrong

# Correct - matches containerPort in Deployment
spec:
  ports:
    - port: 9898
      targetPort: 9898
```

Meshery's relationship validation for Service-to-Deployment checks this alignment and flags mismatches.

## How Validation Surfaces These Issues

After import, open the design in Kanvas. The visual canvas shows each component as a node. Components with validation errors are highlighted, and hovering over the error indicator shows the specific issue - wrong apiVersion, selector mismatch, missing field, or relationship failure.

You can also run `mesheryctl system check` to verify that your Meshery instance is healthy and connected to the cluster before attempting deployment. A healthy instance produces accurate validation output; a disconnected one may miss relationship errors that require cluster-side admission.

For designs that fail import entirely, the CLI output from `mesheryctl design import` includes the document index and the specific parsing or identification error. Use this to locate the offending `---` block in your YAML file.

## Registry-Aligned Prompt Additions

Add these lines to any LLM prompt to prevent the most common registry mismatches:

```text
- Use only stable, non-deprecated Kubernetes API versions:
  apps/v1 for Deployments and StatefulSets,
  networking.k8s.io/v1 for Ingress,
  rbac.authorization.k8s.io/v1 for ClusterRole and ClusterRoleBinding,
  v1 for everything else (Namespace, Service, ConfigMap, Secret, ServiceAccount)
- selector.matchLabels on every Deployment must exactly match the pod template labels
- Every container must have resources.requests.cpu, resources.requests.memory,
  resources.limits.cpu, and resources.limits.memory
- Service targetPort values must be numeric and match a containerPort in the corresponding Deployment
```

These four constraints eliminate the four most common registry alignment failures in a single prompt addition.
