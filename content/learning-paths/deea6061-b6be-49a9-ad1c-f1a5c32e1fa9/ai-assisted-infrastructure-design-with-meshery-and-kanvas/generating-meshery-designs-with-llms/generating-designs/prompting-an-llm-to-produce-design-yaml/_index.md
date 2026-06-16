---
type: "page"
id: "prompting-an-llm-to-produce-design-yaml"
title: "Prompting an LLM to Produce Design YAML"
description: "Craft prompts that reliably produce correct, importable Kubernetes YAML from an LLM."
weight: 2
---

Asking an LLM to "write Kubernetes YAML for my app" produces wildly variable results - sometimes correct, often not. The gap between a vague request and a reliable output is almost entirely in how you prompt. This lesson covers the techniques that consistently get importable designs on the first attempt.

## The Core Problem with Open-Ended Prompts

LLMs are trained on enormous amounts of Kubernetes YAML, but that corpus contains old API versions, deprecated fields, inconsistent resource limits, and patterns from dozens of different toolchains. An open-ended prompt lets the model sample from all of that equally. The result is output that looks plausible but fails import because of a wrong `apiVersion`, a missing `selector`, or an ambiguous `targetPort`.

The fix is constraint: give the model enough specifics that it has no room to guess.

## Technique 1 - Specify Every Resource Kind

Name the exact Kubernetes resource kinds you want. Do not ask for "a deployment and some services" - list them explicitly.

```text
Generate valid Kubernetes YAML for a three-tier application.
Include exactly these resources in this order:
1. Namespace named "demo" with label app.kubernetes.io/part-of: demo
2. Deployment named "frontend" in namespace "demo", image nginx:1.27-alpine, 2 replicas
3. Service named "frontend" in namespace "demo", ClusterIP, port 80 targeting containerPort 80
4. Deployment named "api" in namespace "demo", image ghcr.io/stefanprodan/podinfo:6.6.2, 1 replica
5. Service named "api" in namespace "demo", ClusterIP, port 9898 targeting containerPort 9898

Requirements:
- Use apiVersion apps/v1 for Deployments, v1 for Namespace and Service
- Each Deployment must have selector.matchLabels that exactly matches template.metadata.labels
- Every container must have resources.requests and resources.limits
- Separate each document with ---
- Output only the YAML, no explanation
```

The "output only the YAML" instruction is important. Without it, the model wraps the output in prose, which breaks the import parser if any text appears before the first `---`.

## Technique 2 - Ground the Prompt in Real Component Kinds

The Meshery registry recognises components by their `kind` and `apiVersion` combination. Grounding your prompt in real, current kinds prevents the model from inventing deprecated or fictional types.

Good prompt additions:

```text
Use only these resource kinds:
- v1/Namespace
- apps/v1/Deployment
- v1/Service
- v1/ConfigMap
- v1/ServiceAccount
- networking.k8s.io/v1/Ingress

Do not use any custom resource definitions or beta API versions.
```

This constraint eliminates two common failure modes: the model using `extensions/v1beta1/Deployment` (long deprecated) and the model hallucinating a custom resource kind it saw in training data.

## Technique 3 - State Constraints Explicitly

Constraints are anything the model cannot infer from the resource list alone:

- Namespace scope: "all resources except the Namespace itself must set `namespace: demo`"
- Label consistency: "the label key `app` must appear on pods and be referenced in Service selectors"
- Resource limits: "every container must declare cpu and memory requests and limits; use conservative values appropriate for a development environment"
- Port alignment: "containerPort values in Deployments must match targetPort values in Services"

A prompt with explicit constraints reads longer, but it eliminates the most common validation failures before the model even outputs a character.

## Technique 4 - Provide a Reference Example

If you have a working design - such as `designs/microservices-demo.yaml` - paste a representative excerpt into the prompt as a reference pattern:

```text
Use the following as a structural template. Match its label scheme,
document ordering, and resource field conventions:

---
apiVersion: v1
kind: Namespace
metadata:
  name: tcslabs-demo
  labels:
    app.kubernetes.io/part-of: tcslabs-academy
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: frontend
  namespace: tcslabs-demo
...

Now generate a similar design for the following specification: [your spec here]
```

Providing a concrete example is more reliable than describing the pattern in prose. The model matches the structure of what it sees rather than interpreting abstract instructions.

## Technique 5 - One Shot vs. Iterative Generation

For simple designs (two or three services), a single well-constrained prompt usually produces something importable. For complex designs - multiple tiers, custom RBAC, Ingress routing, PersistentVolumeClaims - use iterative generation:

1. Generate the core resources (Namespace, Deployments, Services) in one prompt.
2. In a follow-up prompt, add the ConfigMaps and ServiceAccounts.
3. In another follow-up, add the Ingress and RBAC resources.

Each round is smaller and easier to verify. You can import the partial design after each step and catch problems early rather than debugging a 200-line file that fails somewhere in the middle.

## A Complete Prompt Template

```text
You are generating a Kubernetes manifest for import into Meshery.

Application: [your app name]
Namespace: [name]

Resources required (in this order):
1. Namespace
2. [list each resource with name, image, replicas, ports]

Constraints:
- apiVersion: apps/v1 for Deployments and StatefulSets; v1 for Namespace, Service, ConfigMap
- selector.matchLabels must exactly match template.metadata.labels on every Deployment
- All resources except Namespace must set namespace: [name]
- Every container must include resources.requests and resources.limits
- Service targetPort values must match containerPort values in the corresponding Deployment
- Separate each resource with ---
- Output only YAML, no prose before or after
```

Copy this template, fill in your specifics, and you have a prompt that will produce an importable design the majority of the time. The next lesson covers what to do when the output is close but not quite right.
