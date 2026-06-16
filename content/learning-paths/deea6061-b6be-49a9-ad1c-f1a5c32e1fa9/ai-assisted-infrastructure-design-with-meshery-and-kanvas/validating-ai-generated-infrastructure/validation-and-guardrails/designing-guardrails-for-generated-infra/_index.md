---
type: "page"
id: "designing-guardrails-for-generated-infra"
title: "Designing Guardrails for Generated Infrastructure"
description: "Use Kubernetes admission controls and Meshery policy to set hard boundaries on what AI-generated infrastructure can consume and do."
weight: 3
---

## Guardrails vs. Validation

Validation catches errors in a specific design. Guardrails are standing controls that constrain every design deployed to an environment - regardless of whether a human or an LLM authored it.

The distinction matters because you cannot review every detail of every AI-generated manifest by hand as volume scales. Guardrails provide a safety net that operates independently of reviewer attention: even if something slips through code review, the cluster refuses to run it.

This lesson covers four Kubernetes primitives that together form a practical guardrail suite for AI-generated workloads: ResourceQuota, LimitRange, NetworkPolicy, and PodDisruptionBudget.

## ResourceQuota: Cap Namespace Resource Consumption

A `ResourceQuota` sets hard ceilings on aggregate resource consumption within a namespace. An LLM that generates a fleet of services without resource limits can still be stopped from consuming unbounded memory or CPU if a quota is in place.

```yaml
apiVersion: v1
kind: ResourceQuota
metadata:
  name: generated-infra-quota
  namespace: production
spec:
  hard:
    requests.cpu: "20"
    requests.memory: "40Gi"
    limits.cpu: "40"
    limits.memory: "80Gi"
    pods: "50"
    services: "20"
    persistentvolumeclaims: "10"
```

When a deploy would breach any quota, Kubernetes rejects it at admission. The quota does not care that the manifest came from an LLM.

## LimitRange: Set Per-Container Defaults and Bounds

A `LimitRange` operates at the container level. It sets default requests and limits for any container that omits them, and it enforces minimum and maximum bounds.

```yaml
apiVersion: v1
kind: LimitRange
metadata:
  name: container-defaults
  namespace: production
spec:
  limits:
    - type: Container
      default:
        cpu: "500m"
        memory: "256Mi"
      defaultRequest:
        cpu: "100m"
        memory: "128Mi"
      max:
        cpu: "4"
        memory: "4Gi"
      min:
        cpu: "50m"
        memory: "64Mi"
```

LimitRange handles the common LLM failure of omitting `resources.limits` entirely: the admission controller injects defaults before the container starts, keeping the node safe even when the manifest was incomplete.

## NetworkPolicy: Default-Deny with Explicit Allow

An LLM generating microservice topologies rarely adds NetworkPolicies. The default Kubernetes network model allows all Pod-to-Pod traffic, so generated workloads often land in a flat, unrestricted network - even in production.

Apply a namespace-level default-deny policy first:

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: default-deny-all
  namespace: production
spec:
  podSelector: {}
  policyTypes:
    - Ingress
    - Egress
```

Then require generated designs to explicitly declare the ingress and egress rules their workloads need. If a generated design lacks NetworkPolicies, nothing communicates - which surfaces the gap immediately in testing, rather than silently in production.

## PodDisruptionBudget: Prevent Accidental Full Outage

An LLM generating Deployments rarely co-generates PodDisruptionBudgets. Without a PDB, a node drain or cluster upgrade can terminate all replicas of a service simultaneously.

```yaml
apiVersion: policy/v1
kind: PodDisruptionBudget
metadata:
  name: api-pdb
  namespace: production
spec:
  minAvailable: 1
  selector:
    matchLabels:
      app: api
```

A Meshery policy rule can enforce the presence of a PDB for any Deployment with `replicas > 1`. This rule runs at design import time and blocks promotion of designs that are missing disruption protection.

## The `policy-guardrails.yaml` Design

The academy ships a reference design that encodes the patterns above as importable Meshery components:

```bash
mesheryctl design import -f designs/policy-guardrails.yaml -s "Kubernetes Manifest"
```

After import, open the design in Kanvas. You will see:

- A `ResourceQuota` component for the production namespace
- A `LimitRange` component with sensible defaults for container workloads
- A `NetworkPolicy` component implementing default-deny
- Three `PodDisruptionBudget` components covering example service tiers

Use this design as a template. Clone it in Kanvas, adjust the values for your environment, and deploy it to your target namespace before any AI-generated workloads land there. The guardrails will be active before the first generated manifest arrives.

## Layering Guardrails with Meshery Environments

Meshery environments let you associate a set of connections and configurations with a named target. When you attach policy rules to an environment, every design imported against that environment is evaluated against those rules.

Configure your production environment to include:
- A rule requiring `ResourceQuota` presence in the namespace
- A rule verifying `LimitRange` is in place
- A rule blocking any Deployment missing a PDB if `replicas > 1`
- A rule rejecting default-deny-absent NetworkPolicy configurations

These rules run automatically. Engineers importing AI-generated designs get immediate feedback on what is missing, without waiting for a human reviewer to notice.
