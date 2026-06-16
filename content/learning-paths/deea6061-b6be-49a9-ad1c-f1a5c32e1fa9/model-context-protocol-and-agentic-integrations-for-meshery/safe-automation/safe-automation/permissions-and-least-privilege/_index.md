---
type: "page"
id: "permissions-and-least-privilege"
title: "Permissions and Least Privilege"
description: "Scope an agent's identity to only the namespaces, verbs, and resources it genuinely needs using Kubernetes RBAC and Meshery workspace controls."
weight: 1
---

## Why Least Privilege Matters for Agents

A human operator makes one decision at a time and notices when something looks wrong. An agent executes hundreds of API calls per minute without hesitation. If that agent's identity has `cluster-admin` rights, a single malformed instruction - or a prompt injection in a log file - can cascade into cluster-wide destruction before any human has a chance to intervene. Least privilege is not a theoretical security hygiene rule; it is the primary blast-radius control for automated systems.

The principle is simple: grant only the permissions the agent needs for the specific task it is performing right now, and nothing more.

## Kubernetes RBAC Fundamentals

Kubernetes RBAC has four building blocks:

| Object | Scope | Purpose |
|---|---|---|
| `Role` | Namespace | Grants verbs on resources within one namespace |
| `ClusterRole` | Cluster-wide | Grants verbs on cluster-scoped or cross-namespace resources |
| `RoleBinding` | Namespace | Binds a Role or ClusterRole to a subject within one namespace |
| `ClusterRoleBinding` | Cluster-wide | Binds a ClusterRole to a subject cluster-wide |

For an agent that only needs to read Deployments and Pods in a single namespace, create a narrow `Role` rather than a `ClusterRole`:

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: agent-readonly
  namespace: staging
rules:
  - apiGroups: ["apps"]
    resources: ["deployments", "replicasets"]
    verbs: ["get", "list", "watch"]
  - apiGroups: [""]
    resources: ["pods", "pods/log"]
    verbs: ["get", "list", "watch"]
```

Bind it to the ServiceAccount the agent uses:

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: agent-readonly-binding
  namespace: staging
subjects:
  - kind: ServiceAccount
    name: meshery-agent
    namespace: staging
roleRef:
  kind: Role
  name: agent-readonly
  apiGroup: rbac.authorization.k8s.io
```

If the agent needs to apply a Meshery design, you can extend the Role to include `create`, `update`, and `patch` on exactly the resource types that design touches - no more.

## Verb Scoping

The Kubernetes verbs to consider are: `get`, `list`, `watch`, `create`, `update`, `patch`, `delete`, `deletecollection`. For read-only analysis tasks, grant only `get`, `list`, and `watch`. For reconciliation agents that apply designs, add `create`, `update`, and `patch` on a narrowly defined resource list. Reserve `delete` and `deletecollection` for agents that have explicit garbage-collection responsibilities, and always require a human-approval step before those verbs fire (see the next lesson).

A quick audit to verify what permissions an agent's ServiceAccount actually has:

```bash
kubectl auth can-i --list \
  --as=system:serviceaccount:staging:meshery-agent \
  -n staging
```

Run this check periodically, and after any Role change, to ensure drift has not occurred.

## Meshery Workspace Scoping

Kubernetes RBAC controls what the agent can do at the API level. Meshery workspaces add a second layer of scope that controls what the agent can see and act on within Meshery itself.

A Meshery workspace groups environments (Kubernetes contexts), designs, and team members into an isolated boundary. When you configure an agent to operate through Meshery's MCP server, its token should be tied to a workspace that contains only the environments relevant to its task. An agent managing the `staging` workspace cannot - regardless of its Kubernetes permissions - accidentally apply a design to production environments that belong to a different workspace.

To scope a workspace correctly:

1. In the Meshery UI, create a workspace named after the agent's function (e.g., `ci-agent-staging`).
2. Add only the Kubernetes environment that agent is allowed to touch.
3. Generate a Meshery token scoped to that workspace and use it in the agent's configuration.
4. Import the `designs/policy-guardrails.yaml` design into the workspace to pre-deploy the OPA policies that validate resources before application:

```bash
mesheryctl design import \
  -f designs/policy-guardrails.yaml \
  -s "Kubernetes Manifest"
```

## Combining RBAC and Workspace Scoping

Neither control alone is sufficient. Kubernetes RBAC without Meshery workspace scoping means the agent can see and potentially act on every environment registered in Meshery. Meshery workspace scoping without tight RBAC means that even if the agent is constrained to one workspace, it could still call the Kubernetes API directly with broad permissions.

Apply both controls together:

- RBAC: namespace-scoped `Role` with minimum required verbs.
- Workspace: token bound to a workspace containing only target environments.
- ServiceAccount: one ServiceAccount per agent role, not shared.

When you rotate an agent's Meshery token or Kubernetes ServiceAccount credentials, verify with `kubectl auth can-i --list` that permissions have not expanded inadvertently. Treat every credential rotation as a permission audit opportunity.

## Summary

Least privilege for agents means choosing a `Role` over a `ClusterRole`, specifying exactly the verbs needed, binding the identity to a workspace that excludes production unless that is the explicit scope, and auditing the effective permissions regularly. This is not a one-time setup - it is an ongoing operational discipline.
