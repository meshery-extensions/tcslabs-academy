---
type: "page"
id: "the-meshery-graphql-and-rest-apis"
title: "The Meshery GraphQL and REST APIs"
description: "Understand Meshery's REST and GraphQL programmatic surfaces and when to use each for reading state and triggering actions."
weight: 2
---

Meshery exposes two HTTP-based API surfaces: a **REST API** and a **GraphQL API**. Both are served from the same Meshery server process and share the same authentication token. An agent that understands the strengths of each surface can use them selectively rather than defaulting to one for every task.

## The REST API

Meshery's REST API is the older and more broadly documented of the two surfaces. It follows conventional resource-oriented patterns: each Meshery entity (design, environment, workspace, performance profile, pattern) has a corresponding endpoint.

Common REST paths an agent will use:

| Purpose | Method | Path |
|---|---|---|
| List designs | GET | `/api/pattern` |
| Fetch a single design | GET | `/api/pattern/{id}` |
| Import a design | POST | `/api/pattern` |
| List environments | GET | `/api/environments` |
| List workspaces | GET | `/api/workspaces` |
| Fetch registry components | GET | `/api/meshmodels/components` |
| Trigger a performance test | POST | `/api/user/performance/profiles/{id}/run` |

All requests require the `Authorization` header carrying the bearer token from `auth.json`:

```bash
TOKEN=$(jq -r '.token' ~/.meshery/auth.json)
curl -s -H "Authorization: Bearer $TOKEN" \
  http://localhost:9081/api/pattern | jq '.'
```

The REST API is the right choice when:
- You need a stable, well-known endpoint to call from a script or agent tool.
- The data you need maps cleanly to a single resource type.
- You are triggering a write operation (import, delete, deploy trigger via `mesheryctl`).

## The GraphQL API

Meshery's GraphQL API is available at `/api/graphql/query`. It lets you retrieve precisely the fields you need across multiple related entities in a single request - a significant advantage when an agent is building context before making a decision.

A minimal query to fetch design IDs and names:

```text
{
  getPatternsWithPage(selector: { pagesize: 20, page: 0 }) {
    patterns {
      id
      name
      created_at
      updated_at
    }
    total_count
  }
}
```

Send it with a POST request:

```bash
TOKEN=$(jq -r '.token' ~/.meshery/auth.json)
curl -s -X POST \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"query":"{ getPatternsWithPage(selector:{pagesize:20,page:0}){ patterns { id name } total_count } }"}' \
  http://localhost:9081/api/graphql/query | jq '.'
```

GraphQL subscriptions are also available for real-time state updates from MeshSync, though most agent workflows use polling or event-triggered execution rather than persistent subscriptions.

## Choosing REST vs GraphQL

| Criterion | Use REST | Use GraphQL |
|---|---|---|
| Stable, predictable endpoint | Yes | Less so (schema can evolve) |
| Fetch only specific fields | No (returns full object) | Yes |
| Cross-entity joins in one call | No (multiple requests) | Yes |
| Write operations | Yes | Limited |
| Introspection / discovery | No | Yes |

For an agent building a context window before proposing a change, GraphQL is efficient: one query can return designs, their associated environments, and relevant registry components without making three separate REST calls. For import or delete operations, the REST API (or `mesheryctl`, which wraps it) is the practical choice.

## Reading Meshery State Programmatically

The MCP server wraps many of these REST and GraphQL calls into named tools, so the agent does not have to construct raw HTTP requests. But knowing what the MCP tools do underneath is important for two reasons:

1. **Debugging** - If an MCP tool returns unexpected data, you can replicate the call directly to isolate whether the problem is in the tool wrapper or in the Meshery API itself.
2. **Gap filling** - The MCP server does not expose every API endpoint. When you need data or an action that has no MCP tool, you fall back to direct API calls from the agent's shell environment.

Understanding both surfaces makes the agent's integration robust rather than brittle.
