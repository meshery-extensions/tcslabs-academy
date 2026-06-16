---
type: "page"
id: "an-end-to-end-agent-to-meshery-workflow"
title: "An End-to-End Agent-to-Meshery Workflow"
description: "A complete walkthrough in which an agent reads state via MCP, proposes a design change, deploys via mesheryctl behind an approval gate, and verifies the outcome."
weight: 4
---

This lesson assembles everything from the module into one concrete workflow. The scenario: an agent is responsible for keeping the observability stack in a target namespace up to date. It reads current state, detects a drift, proposes a corrected design, requests human approval, deploys, and verifies. Every step maps to a specific Meshery surface call.

## Scenario Setup

The agent has:
- A valid token in `~/.meshery/auth.json`
- The Meshery MCP server running locally
- `mesheryctl` installed and pointing at the same Meshery server
- The academy design file `designs/observability-stack.yaml` available locally

Before running, confirm the environment is healthy:

```bash
mesheryctl system check
```

All components should report as running. If MeshSync is not running, the state the agent reads will be stale and the workflow should not proceed.

## Step 1 - Read Current State (MCP)

The agent calls the `list_designs` MCP tool to discover what is currently registered:

```text
Tool call: list_designs()
Response: [
  { "id": "abc-123", "name": "observability-stack", "updated_at": "2025-11-01T10:00:00Z" },
  { "id": "def-456", "name": "microservices-demo",  "updated_at": "2025-10-28T08:30:00Z" }
]
```

The agent then calls `get_design` with the ID `abc-123` to retrieve the full design YAML and inspects the current replica count for the Prometheus deployment. It finds the count is set to 1, but the target environment's resource policy (stored in `designs/policy-guardrails.yaml`) requires at least 2 replicas for production observability components.

## Step 2 - Detect Drift and Propose a Change (Reasoning)

The agent's reasoning step compares the current design state against the policy and determines:

- Current state: `replicas: 1` in the Prometheus deployment spec
- Required state: `replicas: 2` per the policy guardrails design
- Proposed action: update the observability-stack design to set `replicas: 2`, then re-import and deploy

The agent writes the corrected YAML to a local file `updated-observability-stack.yaml`. It does not import or deploy yet - it first requests human approval.

## Step 3 - Request Human Approval (Human-in-the-Loop Gate)

The agent surfaces its proposal to the operator:

```text
Proposed change:
  Design: observability-stack
  Field:  spec.components[Prometheus].replicas
  From:   1
  To:     2
  Reason: policy-guardrails.yaml requires >= 2 replicas for production observability

Import the updated design into Kanvas for review, then confirm to deploy.
```

The agent imports the proposed design so the operator can inspect it in Kanvas before approving:

```bash
mesheryctl design import -f updated-observability-stack.yaml -s "Kubernetes Manifest"
```

This registers the updated design without deploying it. The operator opens Kanvas, reviews the change visually, and signals approval - either through a chat message, a webhook, or a simple prompt confirmation depending on how the agent is deployed.

## Step 4 - Deploy After Approval (mesheryctl)

Once approval is received, the agent deploys the updated design:

```bash
mesheryctl design deploy -f updated-observability-stack.yaml
```

The command exits 0 on success. If it exits non-zero, the agent logs the failure, does not proceed to verification, and alerts the operator with the stderr output. Never suppress exit codes in agent shell invocations - they are the primary signal that an action failed.

## Step 5 - Verify the Outcome (MCP + REST)

The agent waits for MeshSync to reconcile the new state - typically 15-30 seconds - then calls `get_design` again to confirm the updated design is now the active version:

```text
Tool call: get_design("abc-123")
Response: { "name": "observability-stack", "updated_at": "2025-11-15T14:22:00Z", ... }
```

The `updated_at` timestamp advancing confirms the import landed. The agent also queries the Meshery REST API to check that the Prometheus deployment in the target namespace reports the expected replica count via MeshSync:

```bash
TOKEN=$(jq -r '.token' ~/.meshery/auth.json)
curl -s -H "Authorization: Bearer $TOKEN" \
  "http://localhost:9081/api/meshmodels/components?type=Deployment&name=prometheus" | jq '.components[0].configuration.replicas'
```

If the response returns `2`, the workflow is complete. The agent logs the result and closes the loop.

## Workflow Summary

| Step | Surface | Action |
|---|---|---|
| 1 | MCP `list_designs` | Discover registered designs |
| 1 | MCP `get_design` | Read current design state |
| 2 | Agent reasoning | Detect drift, write corrected YAML |
| 3 | `mesheryctl design import` | Import updated design for human review in Kanvas |
| 3 | Human operator | Review in Kanvas, approve |
| 4 | `mesheryctl design deploy` | Deploy approved design |
| 5 | MCP `get_design` | Confirm updated design is active |
| 5 | REST GET | Confirm live component state via MeshSync |

This pattern - read via MCP, reason, import for review, gate on human approval, deploy via `mesheryctl`, verify - is the core template for any agent-driven Meshery workflow. Extend it by adding performance validation with `mesheryctl perf apply` after deploy, or by feeding MeshSync state back into the agent's next planning cycle.
