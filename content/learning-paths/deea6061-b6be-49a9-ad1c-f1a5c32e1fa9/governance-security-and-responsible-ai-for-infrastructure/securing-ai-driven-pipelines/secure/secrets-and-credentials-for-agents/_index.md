---
type: "page"
id: "secrets-and-credentials-for-agents"
title: "Secrets and Credentials for Agents"
description: "Handle secrets safely in agentic pipelines - keeping credentials out of prompts, designs, and logs while providing agents exactly the access they need."
weight: 1
---

Agentic pipelines blur the boundary between code and conversation. An agent reads context - cluster state, design files, Meshery environment variables - and reasons about it. That makes secret hygiene both more important and more subtle than in a traditional CI/CD pipeline. A credential that leaks into a prompt can be replayed anywhere the LLM's output goes: logs, Kanvas designs, generated manifests, or the MCP message stream.

## Why Secrets in Prompts Are Dangerous

The context window of an LLM is not a secrets vault. Anything passed into the context window can be:

- Echoed in the model's response or explanation
- Logged by the orchestration framework, the MCP server, or the hosting platform
- Cached in a retrieval index if you are using RAG over conversation history
- Inadvertently embedded in a generated YAML manifest that lands in version control

The rule is simple: **never pass a secret as literal text into a prompt or a design**. This applies to API keys, kubeconfig credentials, service account tokens, database connection strings, and TLS private keys.

## Kubernetes Secrets as the Baseline

Kubernetes Secrets give agents a reference-based credential model. The agent receives a reference to a secret - a name and namespace - rather than the secret value itself. The workload the agent deploys then mounts or projects that secret at runtime.

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: meshery-provider-token
  namespace: meshery
type: Opaque
data:
  token: <base64-encoded-value>
```

When generating manifests for Meshery deployments, instruct the agent to output a `secretRef` or `envFrom` block rather than inline values:

```yaml
env:
  - name: PROVIDER_TOKEN
    valueFrom:
      secretKeyRef:
        name: meshery-provider-token
        key: token
```

Import this pattern into Kanvas via `mesheryctl design import -f designs/policy-guardrails.yaml -s "Kubernetes Manifest"` and use the resulting design as a template whenever the agent proposes credential injection.

## External Secret Stores

For production workloads, move credentials out of the Kubernetes API entirely and into a dedicated secret store. The two most common CNCF-ecosystem options are:

| Tool | Mechanism | Sync model |
|------|-----------|------------|
| External Secrets Operator (ESO) | Pulls from Vault, AWS SM, GCP SM, Azure KV | CRD-based; syncs to K8s Secret |
| Secrets Store CSI Driver | Projects secrets as volumes from a provider | Pod-lifecycle mount |

With ESO, your agent generates an `ExternalSecret` manifest rather than a `Secret` manifest. The controller handles the actual credential fetch and rotation. The agent never touches the credential value.

```yaml
apiVersion: external-secrets.io/v1beta1
kind: ExternalSecret
metadata:
  name: meshery-api-key
  namespace: meshery
spec:
  refreshInterval: 1h
  secretStoreRef:
    name: cluster-vault
    kind: ClusterSecretStore
  target:
    name: meshery-api-key
  data:
    - secretKey: token
      remoteRef:
        key: meshery/provider-token
        property: value
```

## Credential Patterns for Meshery Agents

When a coding agent manages Meshery via the MCP server or `mesheryctl`, it authenticates using a provider token. Apply these rules:

1. **Store the token in a Kubernetes Secret or your CI secret manager** - never in the agent's system prompt, a Kanvas design file, or a repository environment variable visible in plain text.
2. **Pass the path or reference, not the value** - for example, `MESHERY_TOKEN_FILE=/run/secrets/meshery-token`. The agent reads the path; the container runtime provides the value.
3. **Scope tokens to the minimum surface** - generate a token for the specific Meshery environment the agent needs. Use Meshery's workspace and environment separation to limit what a compromised token can reach.

## Prompt Injection and Secret Exfiltration

Prompt injection is a real threat when an agent processes cluster state that includes user-supplied annotations, config map values, or Catalog descriptions. An attacker who controls a config map value can attempt to redirect agent behavior. Mitigate this by:

- Validating and sanitizing any cluster data retrieved by an agent before including it in a prompt
- Running agents in a dedicated namespace where only explicitly approved config maps are mounted
- Auditing the MCP message log for unexpected credential-shaped strings (long base64 blobs, token-like patterns)

## Key Takeaways

- The context window is not a vault. Treat it as a log.
- Use `secretKeyRef` and `envFrom` patterns so agents generate references, not values.
- In production, use ESO or the Secrets Store CSI Driver so credential values never reach the Kubernetes API surface accessible to an agent.
- Scope and rotate all agent credentials. A token valid forever is a liability, not a convenience.
