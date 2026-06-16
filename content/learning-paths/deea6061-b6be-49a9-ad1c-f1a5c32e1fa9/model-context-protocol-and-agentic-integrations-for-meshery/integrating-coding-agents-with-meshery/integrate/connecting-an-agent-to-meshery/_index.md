---
type: "page"
id: "connecting-an-agent-to-meshery"
title: "Connecting an Agent to Meshery"
description: "Wire a coding agent to Meshery via an MCP server and mesheryctl, covering authentication and the connection model."
weight: 1
---

Meshery exposes two primary entry points that a coding agent can use: an **MCP server** for tool-based, structured interactions, and `mesheryctl` for CLI-driven imperative actions. Both share the same underlying REST and GraphQL APIs, but they present different interfaces that suit different agent architectures. Understanding the connection model - how credentials flow, how sessions are established, and which surface to reach for first - is the prerequisite for every agentic workflow that follows.

## Authentication Fundamentals

Meshery uses a token-based authentication model. When you log in interactively with `mesheryctl system login`, the CLI stores a credential token in `~/.meshery/auth.json`. Any subsequent `mesheryctl` command reads from this file, so the agent's host environment needs that file present and current before any CLI calls are made.

```bash
# Verify the current login state before the agent runs
mesheryctl system check
```

If the token is stale, re-authenticate before the workflow starts. Automating this in CI/CD typically means injecting a service-account token into `auth.json` as a secret rather than using interactive login.

The MCP server authenticates requests using the same token. When you start the Meshery MCP server, it inherits credentials from the environment. The agent connects to the MCP server over a local or remote socket - the exact transport (stdio or SSE) is configured in the MCP host settings on the agent's side.

## The Connection Model

```
+-------------------+        MCP protocol         +------------------+
|   Coding Agent    | <-------------------------> |  Meshery MCP     |
|  (agentic loop)   |                             |  Server          |
+-------------------+       REST / GraphQL        +------------------+
        |                                                  |
        | mesheryctl CLI                                   |
        v                                                  v
+-------------------+                            +------------------+
|  mesheryctl binary|                            |  Meshery Server  |
|  (shell invoke)   | <-- HTTP API calls ------> |  (API backend)   |
+-------------------+                            +------------------+
```

The coding agent sits at the top of this stack. It can reach Meshery in two independent ways:

1. **Via the MCP server** - The agent calls MCP tools (functions exposed by the MCP server) and receives structured JSON responses. This path is best for reads: listing designs, querying component state, fetching performance profiles, or searching the registry.

2. **Via shell invocations of `mesheryctl`** - The agent runs shell commands and parses exit codes and stdout. This path is best for writes: deploying a design, running a performance test, or importing a new design file.

Neither path is exclusive. In a well-designed workflow, the agent uses MCP tools to gather context, reasons about what action to take, then calls `mesheryctl` to execute.

## Verifying the MCP Connection

Once the MCP server is running, a quick test from the agent side is to call the `list_designs` tool (or the equivalent in your MCP server implementation) and confirm you receive a valid JSON array. If the response is an authentication error, check that the MCP server process has access to the same `auth.json` that `mesheryctl` uses.

```bash
# Confirm Meshery is reachable and the token is valid
mesheryctl system check
```

A healthy output shows all system components - Meshery server, Meshery Operator, and MeshSync - as running. If any component reports an error, resolve it before the agent workflow begins. An agent operating against a degraded Meshery instance will produce unreliable results because MeshSync may be reporting stale state.

## Scoping Agent Permissions

Not every agent action should run with full administrative privileges. Meshery's environments and workspaces let you scope what a service-account token can see and modify. Create a dedicated environment for agent-driven operations, and bind the agent's token to that environment. This limits the blast radius if the agent makes an unexpected change and gives human operators a clear view of which changes originated from automated workflows.

```bash
# Example: check which environment the CLI is targeting
mesheryctl system check
```

With authentication confirmed, the MCP connection verified, and permissions scoped, the agent has a stable foundation to start using Meshery's richer programmatic surfaces - covered in the next lesson.
