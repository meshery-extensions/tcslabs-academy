---
type: "page"
id: "combining-mcp-with-mesheryctl"
title: "Combining MCP with mesheryctl"
description: "Use MCP tools for structured reads and mesheryctl for imperative actions, choosing the right surface at each step of an agent workflow."
weight: 3
---

No single Meshery surface does everything well. The MCP server excels at structured reads that feed an agent's context window; `mesheryctl` excels at imperative actions that change state. A well-designed agent workflow uses both, switching surfaces based on what the current step actually needs.

## The Complementary Model

Think of the two surfaces as filling distinct roles in the agentic loop:

| Phase | Surface | Reason |
|---|---|---|
| Gather state | MCP tools | Returns structured JSON the agent can reason over without parsing CLI output |
| Propose a change | Agent reasoning | No Meshery call needed; this is LLM inference |
| Execute a write | `mesheryctl` | CLI is the most reliable path for import, deploy, and test actions |
| Verify the result | MCP tools or REST | Read back updated state to confirm the action succeeded |

This pattern keeps the agent's tool use predictable. MCP tools are idempotent reads; `mesheryctl` calls are writes. Separating them also makes the workflow easier to audit: every state-changing action appears as a shell invocation in logs, while the read calls stay in the MCP trace.

## Using MCP Tools for Reads

The MCP server exposes tools such as `list_designs`, `get_design`, `list_environments`, and `search_registry`. Call these from the agent's tool loop to build context before deciding on an action.

A typical read sequence before a deploy:

1. Call `list_designs` to find the design ID by name.
2. Call `get_design` with that ID to retrieve the full YAML content.
3. Call `list_environments` to confirm the target environment exists and is healthy.

The agent now has enough context to decide whether the deploy should proceed, what to change if it should not, and what to tell the human operator if approval is required.

## Using mesheryctl for Writes

Once the agent has decided to act, `mesheryctl` is the right surface. The two most common write operations in an agent workflow are design import and design deploy.

**Importing a design from a local file:**

```bash
mesheryctl design import -f designs/microservices-demo.yaml -s "Kubernetes Manifest"
```

This registers the design in Meshery's catalog without deploying it. The agent can import a proposed design, let the human operator review it in Kanvas, and deploy only after approval.

**Importing and then deploying:**

```bash
# Import first (registers the design, returns the ID)
mesheryctl design import -f designs/observability-stack.yaml -s "Kubernetes Manifest"

# Deploy by name after the human approves
mesheryctl design deploy -f designs/observability-stack.yaml
```

**Running a performance test against a profile:**

```bash
mesheryctl perf apply <profile-name> --mesh <mesh-name>
```

Each of these commands exits with a non-zero code on failure, which the agent's shell invocation layer should check before proceeding to the next step.

## Switching Surfaces Mid-Workflow

A concrete example that mixes both surfaces:

```text
Step 1 (MCP)       → list_designs → find "observability-stack" design ID
Step 2 (MCP)       → get_design(id) → confirm current version and target namespace
Step 3 (reasoning) → decide to update the replicas field in the design YAML
Step 4 (mesheryctl)→ mesheryctl design import -f updated-observability-stack.yaml -s "Kubernetes Manifest"
Step 5 (HUMAN)     → operator reviews the new design version in Kanvas
Step 6 (mesheryctl)→ mesheryctl design deploy -f updated-observability-stack.yaml
Step 7 (MCP)       → list_designs → confirm the updated design is active
```

Steps 1, 2, and 7 use MCP tools. Steps 4 and 6 use `mesheryctl`. Step 5 is a human gate - the agent pauses and waits for an explicit signal before executing step 6. This is the human-in-the-loop pattern applied to infrastructure automation.

## When MCP Tools Are Unavailable

If the MCP server is not running or does not expose the tool you need, fall back to direct REST API calls using `curl` or the HTTP client available in the agent's environment. The read/write split still applies: use GET calls for reads and `mesheryctl` for writes. Avoid mixing `curl` POST calls with `mesheryctl` commands for the same resource in the same workflow - the two can conflict if they make concurrent requests to the same Meshery resource.

## Choosing the Right Surface - Decision Checklist

Ask these questions before each step in the agent workflow:

1. Am I reading state or changing it? Read - use MCP. Change - use `mesheryctl`.
2. Do I need structured output the agent can parse? Yes - use MCP tools or GraphQL.
3. Is the action a design import, deploy, or performance test? Yes - use `mesheryctl`.
4. Does the MCP server expose this operation? No - fall back to the REST API.

Consistent application of these rules makes the workflow predictable, testable, and easy to extend as the agent takes on more Meshery operations.
