---
type: "page"
id: "sandboxing-and-isolation"
title: "Sandboxing and Isolation"
description: "Contain the blast radius of a compromised or misbehaving agent by isolating agent execution and the workloads it manages using namespaces, network policy, and environment separation."
weight: 3
---

An agent that can do anything is an agent that can break everything. Even a well-designed agentic pipeline can behave unexpectedly when its model hallucinates a kubectl command, misinterprets cluster state from MeshSync, or processes a prompt-injected instruction. Isolation limits what happens when things go wrong. It is not a substitute for correctness - it is the safety net that makes correctness recoverable.

## The Principle of Blast Radius Containment

Blast radius is the scope of damage possible from a single failure. For an AI-driven pipeline, the blast radius is determined by:

- Which clusters the agent can reach
- Which namespaces within those clusters the agent can modify
- Which resources (Deployments, Secrets, ClusterRoles) are in scope
- Whether the agent's service account can escalate privileges

The goal is to minimize all four dimensions simultaneously, so that a compromised or misbehaving agent can at most affect a bounded, recoverable surface.

## Namespace Isolation as the First Layer

Run agent workloads - the MCP server, the Meshery Operator, pipeline job pods - in a dedicated namespace separate from the workloads they manage. Apply a default-deny network policy to that namespace immediately:

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: default-deny-all
  namespace: meshery-agents
spec:
  podSelector: {}
  policyTypes:
    - Ingress
    - Egress
```

Then add explicit allow rules only for the connections the agent actually needs: egress to the Kubernetes API server, egress to the Meshery server endpoint, and nothing else. This prevents a compromised agent pod from scanning the internal network or exfiltrating data to an unexpected destination.

## Network Policy for Managed Workloads

Workloads deployed by the agent should themselves receive network policies generated as part of the agent's output. When instructing an agent to deploy a service, include a requirement in your prompt template or system instruction:

> Every Deployment manifest must be accompanied by a NetworkPolicy that restricts ingress to labeled sources and denies all egress by default unless explicitly required.

The `designs/observability-stack.yaml` design (importable with `mesheryctl design import -f designs/observability-stack.yaml -s "Kubernetes Manifest"`) shows how to pair service manifests with NetworkPolicy resources. Use it as a reference pattern.

## Separate Clusters for Agent Execution

For production-grade pipelines, run the agent's execution environment on a dedicated cluster that is separate from the clusters it manages. The agent cluster holds:

- The MCP server and its dependencies
- The Meshery Operator and MeshSync
- Pipeline orchestration tooling

The target clusters hold the actual workloads. The agent authenticates to target clusters via short-lived kubeconfig credentials scoped to specific namespaces. It never runs workloads on the clusters it manages.

This separation means that compromising the agent's execution environment does not automatically grant access to production workloads. An attacker must additionally compromise the credential chain between the agent cluster and each target cluster.

## Staging Environments as Mandatory Pre-Flight

Every agent-generated change must pass through a staging environment before reaching production. Configure Meshery to separate environments explicitly using the Environments feature. A typical topology:

| Environment | Purpose | Agent access |
|-------------|---------|--------------|
| `dev` | Agent drafts and iterates designs | Full read/write |
| `staging` | Automated and human validation | Read/write with PR gate |
| `production` | Live workloads | Read-only for agent; apply via GitOps only |

The agent may write to `dev` and `staging` freely, but production applies are handled by a GitOps controller (Flux or Argo CD) that reads from a signed, reviewed Git branch. The agent never holds a credential that grants write access to production.

## Pod-Level Isolation Controls

For agent pods themselves, enforce security context constraints that prevent privilege escalation:

```yaml
securityContext:
  runAsNonRoot: true
  runAsUser: 65534
  allowPrivilegeEscalation: false
  readOnlyRootFilesystem: true
  capabilities:
    drop:
      - ALL
```

Combine this with a restrictive `PodSecurityAdmission` label on the agent namespace:

```bash
kubectl label namespace meshery-agents \
  pod-security.kubernetes.io/enforce=restricted \
  pod-security.kubernetes.io/audit=restricted
```

## Key Takeaways

- Run agent workloads in a dedicated namespace with a default-deny network policy.
- Keep agent execution clusters separate from the clusters agents manage.
- Use Meshery Environments to enforce a dev - staging - production promotion path; give agents write access only to non-production tiers.
- Enforce `restricted` pod security on agent namespaces and generate network policies alongside every workload manifest.
- Isolation does not replace correct agent behavior - it makes failures recoverable rather than catastrophic.
