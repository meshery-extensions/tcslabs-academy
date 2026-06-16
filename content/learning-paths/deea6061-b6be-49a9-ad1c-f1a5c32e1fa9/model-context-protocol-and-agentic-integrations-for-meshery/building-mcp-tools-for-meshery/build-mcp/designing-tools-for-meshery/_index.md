---
type: "page"
id: "designing-tools-for-meshery"
title: "Designing Tools for Meshery"
description: "Apply single-responsibility and read-first principles to design MCP tools with clear names, typed inputs, and predictable outputs for Meshery operations."
weight: 1
---

## What Makes a Good MCP Tool

An MCP tool is a named, typed function that an agent can invoke through the protocol. The agent sees the tool's name, its description, and its input schema - nothing else. Every design decision you make in the tool definition shapes how the agent reasons about when and how to call it. A poorly named or overly broad tool leads to agent confusion, incorrect invocations, and unreliable behavior at runtime.

Three principles govern good Meshery tool design:

- **Single responsibility** - each tool does exactly one thing. An agent should never have to guess whether a tool will also mutate state when all it wants is a status check.
- **Read-only first** - start by exposing read operations before write ones. Read tools carry no risk of unintended side effects and are far easier to test and reason about.
- **Typed and constrained inputs** - use JSON Schema to constrain every parameter. An agent that passes a namespace name where a design ID is expected should get a schema validation error, not a confusing API failure.

## Naming Conventions

Tool names are identifiers in the agent's reasoning process. Follow a `verb_noun` pattern that maps to a clear action and target.

| Tool name | What it does |
|---|---|
| `get_workload_status` | Returns the rollout and health status of a named workload in a given namespace |
| `list_designs` | Returns a paginated list of Meshery designs visible to the current user |
| `get_design` | Returns the full content of a single design by ID |
| `list_components` | Returns registered components from the Meshery registry for a given model |
| `get_environment` | Returns the metadata and connection targets for a named Meshery environment |

Avoid generic names like `query`, `fetch`, or `run`. An agent picking between twenty tools needs unambiguous names to route correctly.

## Defining Inputs with JSON Schema

Every parameter must have a `type` and a `description`. For enumerations, supply an `enum` array. For optional fields, exclude them from `required`. Below is a minimal schema for `get_workload_status`:

```yaml
name: get_workload_status
description: >
  Returns the current rollout and health status of a Kubernetes workload
  managed by Meshery. Use this to check whether a Deployment, DaemonSet,
  or StatefulSet is healthy before applying a design.
inputSchema:
  type: object
  properties:
    namespace:
      type: string
      description: Kubernetes namespace containing the workload.
    name:
      type: string
      description: Name of the workload resource.
    kind:
      type: string
      enum: ["Deployment", "DaemonSet", "StatefulSet"]
      description: Kubernetes resource kind.
  required: ["namespace", "name", "kind"]
```

And for `list_designs`:

```yaml
name: list_designs
description: >
  Returns a paginated list of Meshery designs accessible to the current user.
  Use this to discover available designs before importing or deploying one.
inputSchema:
  type: object
  properties:
    page:
      type: integer
      description: Page number, starting at 1.
      default: 1
    pageSize:
      type: integer
      description: Number of results per page (max 100).
      default: 25
    search:
      type: string
      description: Optional substring filter applied to design names.
  required: []
```

## Shaping Outputs for Agent Consumption

The agent receives your tool's output as text or structured content. Return only what the agent needs to make its next decision. Avoid embedding raw API responses - strip internal fields, normalize status strings, and present a flat structure.

For `get_workload_status`, a good output shape is:

```text
{
  "namespace": "prod",
  "name": "frontend",
  "kind": "Deployment",
  "ready": true,
  "readyReplicas": 3,
  "desiredReplicas": 3,
  "conditions": [
    {"type": "Available", "status": "True"},
    {"type": "Progressing", "status": "True"}
  ]
}
```

The agent can parse `ready: true` directly without understanding Kubernetes condition semantics.

## Design Hygiene Checklist

Before implementing any tool, answer these questions:

1. Can the agent describe in one sentence what this tool does? If not, split it.
2. Does calling this tool change any state? If yes, is that intentional and documented?
3. Are all required parameters constrained by type and description?
4. Does the output contain only fields the agent will actually use?
5. Is the tool name unique and unambiguous within your server?

Start with the read-only tools (`get_workload_status`, `list_designs`, `get_design`, `get_environment`) before adding any that mutate state. A working read-only set lets you test the agent integration end-to-end without risk, and reveals gaps in your output shapes before you wire up writes.

You can test your tool definitions against the MCP specification at [modelcontextprotocol.io](https://modelcontextprotocol.io) before writing a single line of implementation code.
