---
type: "page"
id: "mcp-clients-and-servers"
title: "MCP Clients and Servers"
description: "MCP uses a client/server model where the agent acts as a client connecting to one or more servers that expose capabilities - understanding this split is fundamental to designing safe, composable integrations."
weight: 3
---

## The Client/Server Split

MCP follows a client/server architecture. The roles are well-defined and intentionally asymmetric:

- The **client** is the entity that drives the conversation. In practice, this is the agent runtime - the component that runs the agentic loop, manages the context window, calls the LLM, and decides which tools to invoke. The client initiates connections and makes requests.
- The **server** is the entity that exposes capabilities. A server knows about one domain - Meshery, a CI system, a secrets manager - and exposes that domain's tools, resources, and prompts over the MCP protocol. The server does not drive the conversation; it responds to requests.

This split matters for security and for operational separation. The server is a narrow, controlled interface to a backend system. It can enforce access controls, validate arguments, rate-limit calls, and audit all actions - independent of whatever agent happens to be on the other side.

## One Client, Many Servers

A single agent session (client) can connect to multiple MCP servers simultaneously. Each server exposes a separate capability namespace. The client's tool list is the union of tools across all connected servers, with server-scoped names to avoid collisions.

For Meshery-based workflows, a typical agent session might connect to:

| Server | What it exposes |
|---|---|
| Meshery MCP server | Designs, environments, performance profiles, MeshSync state |
| Kubernetes MCP server | Direct cluster queries, namespace listing, pod status |
| Observability MCP server | Metrics from Prometheus, dashboards from Grafana |

Each server is independent. Adding a new server extends the agent's capabilities without changing any existing server. Removing a server takes away only those capabilities.

## The Initialization Handshake

When a client connects to an MCP server, the first exchange is a capability negotiation:

```text
Client → Server: initialize (protocol version, client capabilities)
Server → Client: initialize result (server info, capabilities: tools, resources, prompts)
Client → Server: initialized (acknowledgment)
```

After this handshake, the client knows exactly what the server supports. Subsequent calls to `tools/list`, `resources/list`, and `prompts/list` return the full catalog of available primitives with their schemas and descriptions.

This dynamic discovery is what makes MCP composable. A client does not need to be pre-configured with knowledge of a specific server's API. It discovers capabilities at runtime.

## Transports

MCP defines two standard transports. The transport layer is separate from the protocol - the same message schema works over either transport.

### Standard Input/Output (stdio)

The server runs as a child process of the client. Messages are written to stdin and read from stdout. This is the simplest deployment model: no network configuration, no port management. The server lifecycle is tied to the client process.

```bash
# Example: start a Meshery MCP server as a child process
meshery-mcp-server --meshery-endpoint http://localhost:9081
```

stdio is appropriate for local development and for tools that run on the same machine as the agent.

### HTTP with Server-Sent Events (SSE)

The server runs as a standalone HTTP service. The client connects via HTTP POST for requests and receives responses (including streaming updates) via SSE. This model supports remote servers, multi-tenant deployments, and servers shared across multiple agents.

```yaml
# Example client configuration for a remote MCP server
servers:
  - name: meshery
    transport: http
    url: https://mcp.example.internal/meshery
    auth:
      type: bearer
      token_env: MESHERY_MCP_TOKEN
```

HTTP/SSE is appropriate for production environments where the MCP server is a shared, centrally operated service rather than a per-engineer local tool.

## Request/Response Lifecycle

Every tool call follows the same pattern:

1. The agent decides to call a tool based on its reasoning over the current context.
2. The client sends a `tools/call` request with the tool name and arguments.
3. The server validates the arguments against the tool's JSON Schema.
4. The server executes the underlying action (calling Meshery's API, running a command, reading state).
5. The server returns a structured result - content that the client injects back into the agent's context.
6. The agent reasons over the result and continues the loop.

This synchronous call pattern covers most infrastructure operations. For long-running operations (a performance benchmark run, a large design import), servers can return a job ID in the initial response and expose a resource that the client can poll or subscribe to for status.

## Server Isolation and Trust Boundaries

Each MCP server should be treated as a trust boundary. The server - not the client, and not the agent - is responsible for enforcing what the caller is permitted to do. A Meshery MCP server should:

- Authenticate the caller before accepting requests
- Validate that the requested action is within the caller's permitted scope
- Log every tool invocation with the caller identity, arguments, and result
- Reject arguments that would trigger destructive operations unless explicitly authorized

The client and agent are not trusted to self-enforce these constraints. The server is the enforcement point.

## Local vs. Remote Servers

The client/server model accommodates both local and remote deployments. In early development, running a Meshery MCP server locally via stdio is the fastest path to a working integration. As the team grows and more agents need access to the same Meshery instance, the same server code can be deployed as a shared HTTP service behind authentication.

The transition from local to remote does not require changes to the server's tool, resource, or prompt definitions - only to the transport configuration. This makes MCP integrations straightforward to operationalize.
