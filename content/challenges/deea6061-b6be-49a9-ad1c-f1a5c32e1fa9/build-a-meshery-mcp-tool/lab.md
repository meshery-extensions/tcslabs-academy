---
type: "lab"
description: "Build a read-only Model Context Protocol tool that exposes Meshery and cluster state, back it with the Meshery API, and connect it to a coding agent to answer questions about your infrastructure."
title: "Build a Meshery MCP Tool"
---

## Introduction

In this challenge you will build a small [Model Context Protocol](https://modelcontextprotocol.io/)
(MCP) tool that gives a coding agent a safe, structured view of your [Meshery](https://meshery.io/)
and cluster state. You will start **read-only** - the safe foundation for any agent integration -
and prove the agent can answer real questions about your infrastructure through your tool.

## Prerequisites

- A Kubernetes cluster with [Meshery](https://docs.meshery.io/) running and connected.
- A coding agent that supports MCP servers.
- A language you are comfortable in (any language with an MCP server library works).

## Step 1 - Define one read-only tool

Design a single, well-scoped tool. Good first choice: `get_workload_status`.

```text
name: get_workload_status
description: Return the readiness of Deployments in a namespace.
input:
  namespace: string (required)
output:
  list of { name, desiredReplicas, readyReplicas, ready (bool) }
```

Keep it single-responsibility, with typed inputs and a small, shaped output - not a raw API dump.

## Step 2 - Back it with the Meshery API (or kubectl)

Implement the tool by calling Meshery's REST/GraphQL API (authenticated with your Meshery token) or,
to start, by shelling out to `kubectl`. Map the tool call to a request and shape the response:

```text
get_workload_status(namespace="tcslabs-demo")
  -> GET deployments in namespace
  -> return [{name: "api", desiredReplicas: 2, readyReplicas: 2, ready: true}, ...]
```

Return structured errors (for example, "namespace not found") rather than crashing.

## Step 3 - Run and test the server directly

Before connecting an agent, test the tool in isolation:

- Call it with a valid namespace - confirm the shape and values are correct.
- Call it with a missing namespace - confirm a clean error.
- Check your server logs show each call.

## Step 4 - Connect it to your agent

Register the MCP server with your coding agent. Then ask the agent a question that requires the tool,
for example: *"Is everything in the tcslabs-demo namespace healthy?"* Confirm the agent calls
`get_workload_status` and answers from the tool's output, not from guesswork.

## Step 5 - (Stretch) Add a resource

Expose live cluster state as an MCP **resource** (read-only data the agent can fetch on demand), such
as `meshery://cluster/<context>/<namespace>/deployments`. Note any MeshSync lag in the resource
description so the agent knows how fresh the data is.

## Submission

Submit:

1. Your tool's source and its input/output schema.
2. A transcript of the agent answering an infrastructure question using your tool.
3. Evidence the tool is read-only (no mutating calls) and returns structured errors.

## What you learned

You built the safe foundation of an agent integration: a read-only MCP tool backed by the Meshery
API that grounds an agent in real state. This is the starting point for the CAINP capstone. Take the
exam to complete the challenge.
