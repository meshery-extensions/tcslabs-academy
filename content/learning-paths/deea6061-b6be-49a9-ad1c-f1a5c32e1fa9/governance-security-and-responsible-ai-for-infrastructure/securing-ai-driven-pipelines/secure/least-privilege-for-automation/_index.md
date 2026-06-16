---
type: "page"
id: "least-privilege-for-automation"
title: "Least Privilege for Automation"
description: "Design minimal, auditable RBAC permissions for automated pipelines, separate read from write identities, and rotate credentials continuously."
weight: 4
---

Least privilege is the principle that an identity - human or automated - should hold exactly the permissions required to perform its current task, and nothing more. In practice this is harder for automated pipelines than for human users, because automation often runs continuously, crosses multiple resource types, and is designed by engineers under deadline pressure who default to `cluster-admin` because it works.

AI-driven pipelines make this worse. An agent that can read any resource to build context is useful. An agent that can write any resource because it was given broad permissions is a significant risk. Separating read from write, and scoping both tightly, is the structural fix.

## The Read/Write Identity Split

The most impactful single change you can make to an agentic pipeline's permission model is to give it two identities: one that can read, and one that can write. They are different service accounts, with different credentials, and they are used at different points in the agentic loop.

```
Read identity  ->  gather context (cluster state, MeshSync data, ConfigMaps)
Write identity ->  apply approved manifests (after human or policy gate)
```

The read identity is long-lived and broadly scoped to the namespaces and resource types the agent needs to observe. The write identity is short-lived, narrowly scoped, and activated only when an approved action is ready to execute.

## Designing Minimal RBAC

Start from zero and add permissions only when the agent's behavior requires them. Do not start from `cluster-admin` and remove things. The audit trail of what you removed is invisible; the audit trail of what you added is legible.

For a Meshery agent that imports and applies designs in a target namespace, a minimal write role looks like:

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: meshery-agent-writer
  namespace: app-production
rules:
  - apiGroups: ["apps"]
    resources: ["deployments", "statefulsets"]
    verbs: ["get", "list", "create", "update", "patch"]
  - apiGroups: [""]
    resources: ["services", "configmaps"]
    verbs: ["get", "list", "create", "update", "patch"]
  - apiGroups: ["networking.k8s.io"]
    resources: ["networkpolicies"]
    verbs: ["get", "list", "create", "update", "patch"]
```

Notice what is absent: `delete`, `secrets`, `clusterroles`, `clusterrolebindings`. The agent cannot delete resources, cannot read secrets directly, and cannot escalate its own permissions. Each of these omissions eliminates a class of attack.

## Separate Service Accounts per Pipeline Stage

Map each distinct agent responsibility to its own `ServiceAccount`:

| Service Account | Permissions | Lifetime |
|----------------|-------------|---------|
| `meshery-context-reader` | `get`, `list`, `watch` on target namespaces | Long-lived |
| `meshery-design-applier` | `create`, `update`, `patch` on specific resource types | Short-lived token via TokenRequest API |
| `meshery-audit-logger` | `get`, `list` on events, audit logs | Long-lived, read-only |

Use the Kubernetes `TokenRequest` API to issue time-bounded tokens for the write identity. These tokens expire automatically and do not require explicit rotation:

```bash
kubectl create token meshery-design-applier \
  --namespace meshery-agents \
  --duration 15m
```

The agent pipeline requests a fresh token immediately before each apply step and discards it afterward. A leaked token is valid for at most 15 minutes.

## Credential Rotation

For credentials that cannot use short-lived tokens (external API keys, Meshery provider tokens, registry credentials), implement automated rotation:

1. Store the credential in an external secret store (see the Secrets lesson)
2. Configure the store's rotation policy - typically every 24 hours for pipeline tokens
3. Use the External Secrets Operator to sync the rotated value into the cluster
4. Configure your agent's workload to reload credentials from the mounted secret without a pod restart (use a file watcher or a short refresh interval)

Check the current Meshery system status after credential rotation to confirm connectivity is restored:

```bash
mesheryctl system check
```

## Auditing Automated Actions

Least privilege is only meaningful if you can verify it is being enforced and detect when it is being exceeded. Enable Kubernetes audit logging on the API server and configure it to capture all writes from agent service accounts:

```yaml
# audit-policy.yaml
rules:
  - level: RequestResponse
    users: ["system:serviceaccount:meshery-agents:meshery-design-applier"]
    verbs: ["create", "update", "patch", "delete"]
```

Route audit logs to your observability stack (import `designs/observability-stack.yaml` with `mesheryctl design import -f designs/observability-stack.yaml -s "Kubernetes Manifest"` to get a pre-wired logging pipeline). Alert on any verb or resource type the agent is not expected to use. An agent that attempts to read Secrets, create ClusterRoleBindings, or modify resources outside its designated namespaces should trigger an immediate investigation.

## Key Takeaways

- Split every pipeline into a read identity and a write identity with separate service accounts and credentials.
- Define RBAC from zero, adding only the verbs and resource types actually needed. Never start from `cluster-admin`.
- Use the `TokenRequest` API to issue short-lived (15-minute) tokens for write operations.
- Automate credential rotation for long-lived tokens via an external secret store and the External Secrets Operator.
- Enable Kubernetes audit logging scoped to agent service accounts and alert on unexpected verbs or resource access.
