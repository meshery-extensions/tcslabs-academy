---
type: "course"
id: "mcp-fundamentals"
title: "1. MCP Fundamentals"
description: "Understand the Model Context Protocol (MCP) as an open standard for connecting agents and LLMs to external systems. Learn the core primitives, the client/server model, and when MCP is the right integration choice for infrastructure automation."
weight: 1
tags: ["ai","mcp"]
categories: "AI"
level: "advanced"
---

The Model Context Protocol (MCP) defines a common interface that lets agents and large language models connect to tools, data sources, and services without bespoke glue code for every combination. For infrastructure engineers, MCP shifts the integration problem from "how do I wire this agent to my platform" to "how do I expose the right capabilities safely and consistently."

This course covers the foundational concepts you need before building MCP integrations for Meshery. You will learn what MCP is and why it exists, what the three core primitives are, how the client/server transport model works, and how to decide when MCP is the right architectural choice versus a plain script or CLI wrapper.

These concepts apply directly to the rest of this learning path, where you will build MCP servers that expose Meshery's design, performance, and cluster state APIs to a coding agent.
