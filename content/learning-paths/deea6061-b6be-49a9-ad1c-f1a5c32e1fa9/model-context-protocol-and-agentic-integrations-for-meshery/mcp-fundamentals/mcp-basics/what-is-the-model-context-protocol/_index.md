---
type: "page"
id: "what-is-the-model-context-protocol"
title: "What Is the Model Context Protocol?"
description: "MCP is an open standard that gives agents and LLMs a uniform interface to tools and data, eliminating the fragmented glue code that has made agentic integrations hard to build and maintain."
weight: 1
---

## The Problem MCP Solves

Before MCP, connecting a coding agent to an external system - a Kubernetes cluster, a metrics store, a design tool - meant writing bespoke integration code for every combination of agent and platform. Each agent framework had its own concept of a "tool." Each platform had its own API shape. Swapping out one agent for another meant rewriting the integration layer from scratch.

The result was a proliferation of fragile, one-off adapters. Capabilities were not reusable across agents. Security controls were scattered. There was no standard way for an agent to discover what an integration could do.

MCP addresses this directly. It defines a single protocol that any compliant agent (client) can use to talk to any compliant integration (server), regardless of which platform or language is on either side.

## What MCP Is

The [Model Context Protocol](https://modelcontextprotocol.io/) is an open standard that specifies:

- A message format for describing capabilities (tools, resources, and prompts)
- A request/response contract for invoking those capabilities
- A set of transport bindings (stdio, HTTP with Server-Sent Events) for connecting clients to servers

An agent that speaks MCP can connect to any MCP server and immediately discover what that server exposes. It does not need to be pre-trained on the integration or have special knowledge of the server's internal API shape.

## Why "Context Protocol"

The name reflects MCP's role in the agentic loop. An agent reasons over context - the text, data, and state it has been given. MCP is the protocol by which that context is populated and extended at runtime. When an agent calls an MCP tool, it receives structured context back: the result of an action, the contents of a resource, or the text of a rendered prompt template.

The protocol is not about training or fine-tuning. It is about what the agent can see and do at inference time.

## MCP in an Infrastructure Context

For infrastructure engineers, MCP is significant because it lets you expose cluster state, design artifacts, performance data, and operational actions to any compliant agent - once, in one place - without rebuilding the integration for every tool.

Consider Meshery. It manages cluster designs, tracks component relationships via MeshSync, runs performance benchmarks, and holds a registry of infrastructure models. All of that information is useful to a coding agent working on infrastructure tasks. Without MCP, you would need to write a different tool layer for every agent you might use. With MCP, you write one MCP server that exposes Meshery's capabilities, and any compliant agent can use it.

## How MCP Relates to Existing Standards

MCP does not replace Kubernetes APIs, REST, or gRPC. It sits on top of them. An MCP server that exposes Meshery capabilities still calls Meshery's REST API internally. The protocol defines the agent-facing interface; the implementation details of how that server talks to the backend are not constrained.

This matters for adoption. You can wrap existing APIs with an MCP server without changing those APIs. The investment is in the thin adapter layer, not in the systems being exposed.

## Specification and Versioning

MCP is developed as an open specification. The canonical reference is [modelcontextprotocol.io](https://modelcontextprotocol.io/). The specification is versioned, and servers advertise the protocol version they support during the initialization handshake. Clients can negotiate compatibility at connection time.

Server and client implementations exist across multiple languages - TypeScript, Python, Go, and others. The specification is language-agnostic; any implementation that conforms to the message schema and transport contract is a valid participant.

## Key Takeaway

MCP solves the N-times-M integration problem in agentic systems. Instead of N agents each needing M custom integrations, you build M MCP servers once and any of the N agents can use all of them. For infrastructure teams managing multiple platforms and evaluating multiple agent tools, this is a substantial operational advantage.
