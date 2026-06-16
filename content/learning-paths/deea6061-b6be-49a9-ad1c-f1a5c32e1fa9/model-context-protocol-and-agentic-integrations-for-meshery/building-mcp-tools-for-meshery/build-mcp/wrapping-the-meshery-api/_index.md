---
type: "page"
id: "wrapping-the-meshery-api"
title: "Wrapping the Meshery API"
description: "Back an MCP tool with Meshery's REST and GraphQL APIs, mapping tool call parameters to API requests and shaping raw responses into clean agent-readable output."
weight: 2
---

## Meshery's API Surface

Meshery exposes two API interfaces you can use as MCP tool backends:

- **REST API** - available at `http://localhost:9081/api/v1` by default. Suitable for CRUD operations on designs, environments, workspaces, and performance profiles.
- **GraphQL API** - available at `http://localhost:9081/api/graphql/query`. Better for querying cluster state, component data from the registry, and relationship graphs.

For most tool implementations you will use the REST API. Reserve GraphQL for queries where you need to traverse relationships or filter deeply nested data in a single round trip.

## Authentication

Meshery uses session tokens issued after login. When running your MCP server locally alongside Meshery, pass the token in the `Cookie` header:

```bash
curl -s -H "Cookie: meshery-token=<your-token>" \
  http://localhost:9081/api/v1/designs?page=1&pageSize=25
```

In your server code, load the token from an environment variable - never hard-code it:

```bash
export MESHERY_TOKEN="$(cat ~/.meshery/auth.json | jq -r '.meshery-token')"
```

The `~/.meshery/auth.json` file is written by `mesheryctl system start` after a successful login.

## Mapping a Tool Call to a REST Request

For the `list_designs` tool, the mapping is direct: take the `page`, `pageSize`, and optional `search` parameters from the tool input and forward them as query parameters.

```text
Tool input:
  { "page": 1, "pageSize": 10, "search": "observability" }

REST request:
  GET /api/v1/designs?page=1&pageSize=10&search=observability
```

For `get_workload_status`, there is no single REST endpoint that returns workload health directly. Instead, query the MeshSync-backed resource list:

```text
GET /api/v1/meshsync/resources
  ?kind=Deployment
  &namespace=prod
  &name=frontend
```

MeshSync stores a snapshot of cluster state. The response will contain the resource's metadata and last-known status. Parse the `status.conditions` array to derive the `ready` field your tool returns.

## Shaping the Response

Raw API responses contain fields the agent does not need - internal IDs, timestamps, pagination metadata, and Kubernetes noise. Strip them before returning.

Below is a Go-style pseudocode example showing the transformation for `list_designs`:

```text
apiResp = GET /api/v1/designs?page=1&pageSize=10

toolResp = {
  "total": apiResp.total_count,
  "page":  apiResp.page,
  "designs": [
    for each d in apiResp.designs:
      {
        "id":          d.id,
        "name":        d.name,
        "description": d.description,
        "updatedAt":   d.updated_at
      }
  ]
}
```

The agent receives a clean list it can iterate without understanding Meshery's internal design object shape.

## Using GraphQL for Registry Queries

When you need component data - for example, to check whether a specific model is registered before suggesting it to the user - use the GraphQL API:

```bash
curl -s -X POST http://localhost:9081/api/graphql/query \
  -H "Content-Type: application/json" \
  -H "Cookie: meshery-token=$MESHERY_TOKEN" \
  -d '{
    "query": "{ registrantsByModel(model: \"kubernetes\") { name version } }"
  }'
```

Wrap this call behind a `list_registered_models` tool that accepts a `model` string and returns name and version pairs. The agent can then verify compatibility before proceeding.

## Error Handling

Every tool must return a structured error when the backing API call fails. Do not let raw HTTP errors propagate to the agent unhandled.

| API status | Tool behavior |
|---|---|
| 401 Unauthorized | Return `{"error": "authentication_required", "message": "Meshery token is missing or expired."}` |
| 404 Not Found | Return `{"error": "not_found", "message": "Resource <name> not found in namespace <ns>."}` |
| 503 Service Unavailable | Return `{"error": "meshery_unavailable", "message": "Meshery did not respond. Check mesheryctl system check."}` |

A well-structured error lets the agent decide whether to retry, escalate, or report the failure to the user - rather than hallucinating a fallback.

## Importing and Testing Designs via the REST API

To verify that your tool can reference real designs, import the academy's sample designs first:

```bash
mesheryctl design import -f designs/llm-mcp-gateway.yaml -s "Kubernetes Manifest"
mesheryctl design import -f designs/observability-stack.yaml -s "Kubernetes Manifest"
```

After import, call `list_designs` through your MCP server and confirm both designs appear in the tool's output. This end-to-end check validates authentication, API mapping, and response shaping together.
