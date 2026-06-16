---
type: "page"
id: "testing-and-debugging-an-mcp-server"
title: "Testing and Debugging an MCP Server"
description: "Verify tool correctness, trace failures through structured logs, and work through common MCP server failure modes before connecting a live agent."
weight: 4
---

## Test Before You Connect an Agent

The fastest way to break an agent integration is to connect a half-working MCP server. The agent will call broken tools repeatedly, misinterpret errors as valid output, and produce unreliable behavior that is hard to trace back to the server.

Test your MCP server in isolation first. Validate tool schemas, verify output shapes, and exercise error paths before an agent ever sees the server.

## Layer 1 - Schema Validation

Before writing any implementation, validate that your tool definitions conform to the MCP specification. The MCP Inspector, available at [modelcontextprotocol.io](https://modelcontextprotocol.io), accepts a server process and enumerates its tools. Run it against your server:

```bash
npx @modelcontextprotocol/inspector your-mcp-server
```

Check each tool in the Inspector UI:

- Name is present and matches your design
- Description is non-empty and accurate
- Input schema has `type: object`
- All required parameters are listed in `required`
- No extra keys appear in the schema that are not part of the spec

Fix schema errors before moving on. A tool with a malformed schema will silently fail or produce unpredictable agent behavior.

## Layer 2 - Direct Tool Invocation

Use the MCP Inspector to call each tool with valid and invalid inputs and inspect the raw response. Build a test matrix:

| Tool | Input | Expected outcome |
|---|---|---|
| `list_designs` | `{}` (no params, all optional) | Returns paginated list, no error |
| `list_designs` | `{"page": 0}` | Returns error or normalized to page 1 |
| `get_workload_status` | valid Deployment name | Returns `ready: true/false` |
| `get_workload_status` | non-existent name | Returns structured `not_found` error |
| `get_workload_status` | missing `kind` param | Schema validation error, not a 500 |

Run every row. A passing test means the tool returns the exact shape you designed in Lesson 1 for every case, including error cases.

## Layer 3 - Structured Logging

Add structured logging to every tool handler. Log the tool name, input parameters (redact sensitive values), upstream API URL, HTTP status, duration, and whether the tool succeeded.

```text
tool=list_designs status=200 duration_ms=43 err=<nil>
tool=get_workload_status status=404 duration_ms=12 err=not_found
```

Structured logs let you grep failures by tool name, correlate latency with specific API endpoints, and distinguish client-side input errors from upstream API failures.

## Common Failure Modes

### Authentication failures

Symptom: every tool returns 401 or an empty response.

Cause: the `MESHERY_TOKEN` environment variable is missing, expired, or malformed.

Fix: run `mesheryctl system check` to verify Meshery is reachable, then re-export the token:

```bash
mesheryctl system check
export MESHERY_TOKEN="$(cat ~/.meshery/auth.json | jq -r '.meshery-token')"
```

### MeshSync lag

Symptom: `get_workload_status` returns `not_found` for a resource you just deployed.

Cause: MeshSync has not yet observed the new resource.

Fix: wait 30 seconds and retry. If the resource never appears, check that Meshery Operator is running in the cluster and MeshSync is reporting healthy in `mesheryctl system check`.

### Schema mismatch

Symptom: the MCP Inspector shows a tool but cannot call it; the agent reports an unknown tool error.

Cause: the tool's input schema contains a field the agent parser cannot handle - typically a `$schema` key, an unrecognized type, or a malformed `enum`.

Fix: remove `$schema` from the schema object, ensure all types are JSON Schema primitives, and re-validate in the Inspector.

### Output too large for context

Symptom: the agent stops mid-task or reports a context limit error after calling `list_designs`.

Cause: the tool is returning all design fields, including large description or YAML content, for every design in the page.

Fix: trim the output. Return only `id`, `name`, and `updatedAt` in list responses. Expose full design content only through `get_design` when the agent explicitly requests it.

## Iterating Safely

Follow this sequence when making changes to a tool: update the definition, restart the server, re-validate in the Inspector, re-run the test matrix, then reconnect the agent session. Never connect an agent mid-edit - an inconsistent tool definition produces misleading behavior that is hard to separate from real failures.

## Smoke Test Before Agent Connection

Before connecting your first agent session, run this checklist:

- `mesheryctl system check` passes with no errors
- `list_designs` returns at least one design (the academy designs you imported earlier)
- `get_workload_status` returns a valid response for a known Deployment
- Every resource URI in your server's list can be fetched without error
- All tools return structured errors for invalid inputs

When all items pass, your MCP server is ready for an agent.
