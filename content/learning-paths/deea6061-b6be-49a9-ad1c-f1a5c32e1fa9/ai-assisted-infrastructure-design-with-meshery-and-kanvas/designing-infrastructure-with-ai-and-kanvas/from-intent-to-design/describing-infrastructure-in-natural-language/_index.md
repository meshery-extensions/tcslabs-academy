---
type: "page"
id: "describing-infrastructure-in-natural-language"
title: "Describing Infrastructure in Natural Language"
description: "Write an infrastructure brief that gives an LLM the functional needs, constraints, and non-functionals required to produce a reviewable design proposal."
weight: 3
---

## Why the Brief Is the Critical Artifact

The infrastructure brief is the document you hand to an LLM before asking it to design anything. It is not a vague starting point you refine later - it is the primary determinant of output quality. A weak brief produces a plausible-looking but incorrect design. A strong brief produces a reviewable proposal with a short correction list.

Writing a good brief is an engineering skill, not a writing skill. It requires the same thinking as writing a technical spec: define the system boundary, state the functional requirements, constrain the non-functionals, and explicitly exclude what is out of scope.

## Structure of an Infrastructure Brief

A brief that produces reliable LLM output has four sections. Each section answers a specific question that the LLM cannot answer from context alone.

### Section 1: Functional Requirements

What does this infrastructure need to do? Name every service, its role, and its external dependencies.

```text
## Functional Requirements

- API server: receives HTTP requests from external clients, routes to downstream services
- Worker: consumes jobs from a queue, writes results to the database, no direct client traffic
- Queue: message broker (one topic, "jobs"), written to by API server, read by worker
- Database: relational, written and read by worker only
- Cache: key-value, read by API server to reduce downstream calls
```

Write one line per component. The LLM reads this as a component list. If you do not name it here, the LLM will not include it.

### Section 2: Constraints

What must be true about how these components are deployed? Constraints bound the design space.

```text
## Constraints

- All components in a single namespace: "payments"
- No component may be exposed outside the cluster except the API server (Ingress on port 443)
- Services must not share a database instance
- Worker must not be reachable from outside the namespace
- TLS termination at Ingress only; internal traffic plain HTTP/2
```

Constraints are the most valuable part of the brief because they prevent the LLM from generating correct-looking but policy-violating designs. Write them as negative requirements ("must not") as well as positive ones ("must").

### Section 3: Non-Functional Requirements

Scale, availability, security posture, observability, and resource limits. These are the properties that distinguish a production design from a prototype.

```text
## Non-Functional Requirements

Scale:
  - API server: 2-10 replicas (HPA on CPU 60%)
  - Worker: 1-3 replicas (HPA on queue depth)
  - Database: 1 replica (StatefulSet), no scaling

Availability:
  - API server: PodDisruptionBudget, minAvailable: 1
  - Worker: no PDB required

Security:
  - Pod security standard: restricted on all pods
  - No privileged containers or hostPath mounts
  - Non-root user for all containers
  - Read-only root filesystem where possible

Observability:
  - Prometheus scrape annotations on all Deployments
  - Structured JSON logging to stdout
  - No sidecar injection required at this stage

Resource limits:
  - Set CPU request/limit and memory request/limit on all containers
  - Suggest reasonable defaults based on service role
```

An LLM that receives this section will produce a design with HPAs, PDBs, security contexts, and resource requests. An LLM that does not receive this section will omit most of them.

### Section 4: Exclusions

What is explicitly out of scope? This prevents the LLM from making decisions you have not authorized.

```text
## Exclusions

- No service mesh (Istio, Linkerd) at this stage
- No cert-manager or externally managed TLS certificates
- No persistent volume snapshots or backup configuration
- No CI/CD pipeline resources (no Tekton, no Argo Workflows)
```

Exclusions are cheap to write and expensive to omit. Without them, the LLM may add a service mesh because your brief mentions "TLS" and the model associates the two. An explicit exclusion removes that ambiguity.

## What to Leave Out

The brief is not a design. Do not specify:

- Container image tags or registries (the LLM can use a placeholder; you will update before deployment)
- Exact label selectors (the LLM should follow convention; you will review in Kanvas)
- Boilerplate annotations (let the LLM fill these from its training)
- The implementation language or framework of any service (irrelevant to the infrastructure topology)

These details belong in your review checklist (lesson 4), not in the brief.

## Practical Example

The academy's `designs/llm-mcp-gateway.yaml` represents a complete design produced from a brief that specified: a gateway service exposing an MCP endpoint, a model-routing backend, and an internal policy enforcement layer. You can import it and read the resulting topology in Kanvas to see how a well-specified brief translates to a concrete design:

```bash
mesheryctl design import -f designs/llm-mcp-gateway.yaml -s "Kubernetes Manifest"
```

Compare what you see in Kanvas to the four brief sections above. Every component, constraint, and non-functional requirement in the brief should have a corresponding artifact in the design.

## Summary

A useful infrastructure brief has four sections: functional requirements (what to build), constraints (what must be true), non-functionals (scale, security, observability), and exclusions (what to omit). Writing it is the engineering work that determines the quality of everything the LLM produces. The brief is not a first draft - it is the specification. Treat it with that rigor.
