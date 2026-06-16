---
type: "page"
id: "kubernetes-essentials"
title: "Kubernetes Essentials"
description: "Understand Kubernetes core objects - Pods, Deployments, Services, and Namespaces - the reconciliation control loop, and why declarative APIs are the right interface for automated cluster management."
weight: 3
---

## What Kubernetes Does

Kubernetes is a container orchestrator. Its job is to accept a description of the workloads you want to run - expressed as YAML manifests - and make the cluster match that description. When the cluster drifts from the description (a node fails, a pod crashes, demand spikes), Kubernetes corrects the drift automatically.

This is the **control loop** at its simplest: observe current state, compare to desired state, act to close the gap, repeat.

## Core Objects

Every Kubernetes workload is built from a small set of primitives. You need to recognize these on sight.

### Pod

A **Pod** is the smallest deployable unit. It wraps one or more containers that share a network namespace (they can reach each other on `localhost`) and, optionally, shared storage volumes.

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: demo-app
  namespace: default
spec:
  containers:
    - name: app
      image: registry.example.com/demo-app:v1.2.0
      ports:
        - containerPort: 8080
```

You rarely create pods directly. Pods are ephemeral - if a node fails, the pod is gone. Higher-level objects manage pod lifecycle.

### Deployment

A **Deployment** declares that you want N replicas of a pod template running at all times. If a pod is deleted or crashes, the Deployment controller creates a replacement. If you update the pod template (e.g. a new image), the Deployment rolls out the change in a controlled fashion.

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: demo-app
  namespace: default
spec:
  replicas: 3
  selector:
    matchLabels:
      app: demo-app
  template:
    metadata:
      labels:
        app: demo-app
    spec:
      containers:
        - name: app
          image: registry.example.com/demo-app:v1.2.0
          ports:
            - containerPort: 8080
```

### Service

A **Service** provides a stable network endpoint for a set of pods selected by label. Pods come and go; the Service IP and DNS name stay constant.

```yaml
apiVersion: v1
kind: Service
metadata:
  name: demo-app
  namespace: default
spec:
  selector:
    app: demo-app
  ports:
    - port: 80
      targetPort: 8080
```

### Namespace

A **Namespace** is a logical partition inside a cluster. Resources in different namespaces are isolated by default. Platform teams use namespaces to separate workloads by team, environment, or trust boundary.

```bash
kubectl get namespaces
kubectl get pods -n kube-system
```

## The Reconciliation Control Loop

Every Kubernetes controller follows the same pattern:

1. **Watch** - subscribe to events from the API server for resources of a given type
2. **Observe** - read the current state of those resources
3. **Diff** - compare current state to desired state in the spec
4. **Act** - issue API calls to close the gap (create, update, or delete resources)
5. **Repeat**

This loop runs continuously. It is not a one-shot deployment script. If you manually delete a pod managed by a Deployment, the Deployment controller creates a new one within seconds. The cluster self-heals.

This property is what makes declarative infrastructure safe to automate. A coding agent can apply a manifest and then observe the reconciliation loop to verify that the cluster converged to the desired state, without needing to manually track every intermediate step.

## Essential kubectl Commands

```bash
# View cluster health
kubectl get nodes

# List pods in a namespace
kubectl get pods -n <namespace>

# Describe a resource (events, conditions, spec)
kubectl describe deployment demo-app -n default

# Apply a manifest (create or update)
kubectl apply -f manifest.yaml

# Watch rollout status
kubectl rollout status deployment/demo-app -n default

# View logs from a pod
kubectl logs -f <pod-name> -n <namespace>
```

Meshery builds on top of these primitives. When you import a design with `mesheryctl design import -f designs/microservices-demo.yaml -s "Kubernetes Manifest"`, Meshery parses the Deployment, Service, and Namespace objects, models their relationships, and renders them in Kanvas - the visual designer. The same objects you manage with `kubectl` are the objects Meshery understands.

## Why Declarative APIs Matter

Kubernetes uses a declarative API: you tell the system what you want, not how to get there. You do not write a script that says "if there are fewer than 3 pods, start another one." You declare `replicas: 3` and Kubernetes figures out how to maintain that.

This distinction is critical for automated operations. An LLM or coding agent can:

- Read a manifest and reason about intent
- Propose changes as diffs against existing manifests
- Apply manifests and observe convergence
- Detect drift by comparing live cluster state to the manifest on disk

None of this is tractable with imperative scripts, whose current-state model exists only in the operator's head. The declarative API is the interface that makes agentic infrastructure management possible.

For further reading on Kubernetes concepts, see the official documentation at [kubernetes.io/docs](https://kubernetes.io/docs/concepts/).
