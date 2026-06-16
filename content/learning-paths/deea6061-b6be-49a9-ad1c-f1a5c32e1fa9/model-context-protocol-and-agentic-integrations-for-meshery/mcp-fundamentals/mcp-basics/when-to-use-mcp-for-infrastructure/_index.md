---
type: "page"
id: "when-to-use-mcp-for-infrastructure"
title: "When to Use MCP for Infrastructure"
description: "MCP is the right integration layer when multiple agents need consistent, auditable access to infrastructure capabilities - understanding where it fits versus simpler alternatives prevents over-engineering."
weight: 4
---

## Not Every Integration Needs MCP

MCP adds structure and a runtime dependency. Before choosing it, you should be able to answer: what problem does MCP solve here that a simpler alternative does not?

This lesson gives you a framework for making that decision with infrastructure automation in mind.

## When a Plain Script or CLI Is Enough

A script or CLI wrapper is the right choice when:

- **One agent, one task, one-off use.** You are automating a specific task for a specific agent, and there is no expectation that the integration will be reused or shared. The overhead of a protocol layer is not justified.
- **The operation is read-only and the output is simple.** If you just need to pipe `kubectl get pods -o json` into an agent's context, a shell command tool is sufficient.
- **No multiple-agent reuse.** If only one agent will ever use this capability, the abstraction layer MCP provides has no consumer.

Scripts are not wrong. They are the right tool for narrow, temporary, single-consumer integrations.

## When MCP Is the Right Choice

MCP earns its place when one or more of the following are true:

### Multiple Agents Need the Same Capability

If two or more agents - a review agent, a deploy agent, a performance agent - need to query Meshery's design registry, building that integration once as an MCP server means each agent gets it for free. Without MCP, you rebuild the same capability N times in N different tool formats.

### Consistency Across Agent Frameworks Matters

Agent frameworks differ in how they define and call tools. MCP is framework-agnostic. An MCP server written once works with any compliant client, regardless of which LLM or agent runtime is on the other side. If your team uses multiple agent frameworks or expects to change frameworks, MCP protects the integration investment.

### You Need Audit and Access Control at the Integration Layer

Scripts run with whatever permissions the process has. There is no standard place to enforce access controls, log invocations, or rate-limit calls. An MCP server is a single enforcement point for all of these. For infrastructure operations - where applying a design or triggering a performance test has real consequences - this matters.

A well-designed Meshery MCP server logs every `apply_design` call with the caller identity, the design ID, and the target environment. That log exists whether the call came from a local development agent or a production automation pipeline.

### The Integration Should Be Discoverable Without Documentation

MCP's dynamic discovery means any compliant client can query the server and learn what it can do - tool names, argument schemas, descriptions - without reading separate documentation. For a platform team operating a Meshery MCP server used by multiple product teams, this is a significant operational advantage. Teams can self-serve capability discovery.

### You Are Building a Shared Platform Capability

If the MCP server represents a capability that the platform team owns and product teams consume - like access to Meshery's design catalog or MeshSync state - MCP provides a stable, versioned interface. The platform team can evolve the server's internals without breaking consumers, as long as the tool and resource schemas remain compatible.

## Decision Framework

| Situation | Recommended approach |
|---|---|
| One agent, one script, no reuse expected | Shell command or inline REST call |
| One agent, but you want argument validation and structured results | Simple tool definition without MCP |
| Multiple agents need the same backend capability | MCP server |
| You need audit logs for all agent-initiated infrastructure operations | MCP server with logging middleware |
| Your team uses or may use multiple agent frameworks | MCP server (framework-agnostic) |
| A platform team is exposing capabilities to multiple product teams | MCP server with versioned schema |
| Long-running operations with status tracking | MCP server with resource subscriptions |

## Applying This to Meshery

Meshery is a strong fit for MCP because it is a multi-capability platform: designs, environments, performance profiles, the registry, MeshSync state, Kanvas visual sessions. These capabilities are useful across many different agent tasks and agent types - a code review agent checking design correctness, a deployment agent applying changes, a monitoring agent tracking environment drift.

Building a single Meshery MCP server and connecting it to whichever agent is appropriate for the current task is more maintainable than rebuilding Meshery integrations for each agent separately.

The academy's importable design `designs/llm-mcp-gateway.yaml` shows an example gateway architecture for routing agent traffic through a shared MCP layer. You can import it with:

```bash
mesheryctl design import -f designs/llm-mcp-gateway.yaml -s "Kubernetes Manifest"
```

## What MCP Does Not Replace

MCP does not replace:

- **Meshery's REST API** - the MCP server calls this API internally. MCP is a client-facing interface, not a replacement for the backend.
- **Kubernetes RBAC** - MCP access controls operate at the protocol layer. Kubernetes RBAC still governs what the service account running the MCP server can do in the cluster.
- **Human review** - MCP makes it easier for agents to propose and apply changes, but human-in-the-loop review for consequential operations is a design choice, not something MCP enforces or bypasses. Build approval gates into the workflow, not as an afterthought.

## Summary

Use MCP when you need consistency, reuse, auditability, or discoverability across multiple agents or teams. Use simpler tools when the integration is narrow, temporary, or single-consumer. The protocol is not overhead when the problem it solves is real - and for shared infrastructure platforms like Meshery, the problem is very real.
