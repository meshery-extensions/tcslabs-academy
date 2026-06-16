---
type: "page"
id: "tools-resources-and-prompts"
title: "Tools, Resources, and Prompts"
description: "MCP defines three primitives - tools, resources, and prompts - that together cover the full range of what an agent needs to interact with an external system."
weight: 2
---

## The Three MCP Primitives

Every capability an MCP server exposes falls into one of three categories: a tool, a resource, or a prompt. Understanding the distinction is essential for designing MCP servers that are safe, ergonomic, and easy for agents to use correctly.

## Tools

A **tool** is an action the agent can invoke. Tools have side effects - they change state, trigger operations, or produce computed results that are not simply a read of existing data. The agent calls a tool by name, passing a structured argument object. The server executes the action and returns a structured result.

Tools are the primary mechanism for giving an agent real operational authority. In an infrastructure context, tools are what allow an agent to apply a design, run a benchmark, or query cluster state.

### Tools in a Meshery Context

| Tool name | What it does |
|---|---|
| `apply_design` | Applies a Meshery design to a target cluster |
| `run_performance_test` | Triggers a `mesheryctl perf apply` run against a performance profile |
| `get_component_status` | Queries MeshSync for the current state of a named component |
| `import_design` | Imports a design file from a path using `mesheryctl design import` |

A tool definition includes a name, a description that the agent uses to decide when to call it, and a JSON Schema for the input arguments. Clear, specific descriptions reduce the chance that an agent will call the wrong tool or pass malformed arguments.

### Safety Consideration

Because tools have side effects, they are where access controls matter most. An MCP server implementing Meshery tools should enforce that the calling agent's session has permission to perform the underlying action before proxying the request.

## Resources

A **resource** is data the agent can read. Resources are identified by a URI and are intended for consumption, not mutation. They are conceptually similar to files or API endpoints that return data.

Resources are appropriate when the agent needs context - the current state of a design, the contents of a manifest, the list of registered models - but should not have the ability to change anything through that access path.

### Resources in a Meshery Context

```text
meshery://designs/list               - all designs in the current environment
meshery://designs/{id}               - a specific design by ID
meshery://catalog/components         - components available in the Meshery registry
meshery://environments/{name}/state  - current state of a named environment
meshery://performance/profiles       - configured performance profiles
```

Resources support two access patterns: direct URI fetch (the client requests a specific resource) and subscription (the client receives updates when a resource changes). For infrastructure use cases, subscriptions are useful for tracking environment drift between agent actions.

### Resources and the Context Window

Resources are a primary mechanism for injecting infrastructure context into an agent's context window without requiring the agent to call a tool and wait for a response. When the agent starts a task, the client can pre-load relevant resources - the current design, the environment manifest - so the agent has accurate state from the start.

## Prompts

A **prompt** is a reusable template that a server exposes to help the agent construct well-formed requests. Prompts can accept arguments and return a structured message - or a sequence of messages - ready to be injected into the agent's conversation.

Prompts are not instructions to the agent in the system prompt sense. They are server-defined templates that encode domain knowledge about how to phrase a request to get the right outcome.

### Prompts in an Infrastructure Context

A Meshery MCP server might expose prompts such as:

- `summarize_design` - given a design ID, return a prompt that asks the agent to describe the design's components and their relationships
- `diagnose_drift` - given an environment name, return a prompt that frames a drift investigation task
- `benchmark_comparison` - given two performance profile names, structure a comparison request

Prompts reduce the engineering burden on the agent side. Instead of every agent needing to know how to correctly frame a Meshery-specific question, the server encodes that knowledge once.

## How the Primitives Complement Each Other

A typical agentic workflow in Meshery uses all three:

1. The client pre-loads `meshery://designs/{id}` as a **resource** so the agent has the current design in context.
2. The agent calls the `summarize_design` **prompt** to generate a structured review task.
3. Based on the review, the agent calls the `apply_design` **tool** to update the cluster.

This separation - read-only context via resources, templated framing via prompts, side-effecting operations via tools - makes it straightforward to apply least-privilege controls. You can grant an agent access to all resources while restricting which tools it can call.

## Registering Primitives on a Server

When an MCP server starts, it advertises its primitives during the initialization handshake. The client can then call `tools/list`, `resources/list`, and `prompts/list` to discover what is available without any prior knowledge of the server's capabilities. This dynamic discovery is what makes MCP servers composable: a client can connect to a new server and immediately understand what it can do.
