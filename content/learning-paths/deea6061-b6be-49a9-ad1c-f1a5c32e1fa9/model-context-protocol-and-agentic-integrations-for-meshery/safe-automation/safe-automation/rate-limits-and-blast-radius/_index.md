---
type: "page"
id: "rate-limits-and-blast-radius"
title: "Rate Limits and Blast Radius"
description: "Bound how much an agent can change in a single run using rate limits, change caps, and circuit breakers to contain the impact of mistakes."
weight: 4
---

## Understanding Blast Radius

Blast radius is the maximum damage an agent can cause in a single uninterrupted run. If an agent has no constraints on how many resources it can modify, how fast it can issue API calls, or how many changes it can make in one window, the blast radius is effectively unbounded. A single confused instruction or a malformed tool response can trigger a cascade that touches every workload in the cluster before any human notices.

Reducing blast radius does not require reducing an agent's capabilities. It requires bounding how much of those capabilities can be exercised at once.

## Rate Limiting Agent API Calls

The Kubernetes API server enforces rate limits at the client level via the `--max-requests-inflight` and `--max-mutating-requests-inflight` flags on the server side, and via client-side rate limiting in the `rest.Config`. For an agent using a dedicated ServiceAccount, configure the client to stay well below the server's limits:

```go
config.QPS   = 10  // queries per second
config.Burst = 20  // maximum burst
```

For agents that call Meshery's API rather than Kubernetes directly, apply the same discipline on the Meshery client side. Meshery's MCP server respects the token's rate limit configuration.

An agent that calls the API slowly enough for a human to monitor gives operators the window to interrupt it. An agent that issues 500 API calls per second does not.

## Change Caps Per Run

A change cap is a hard limit on the number of resources an agent is allowed to create, update, or delete in a single run. Implement it as an explicit check in the agent's tool logic, before any mutating call:

```text
if changes_this_run >= MAX_CHANGES_PER_RUN:
    raise ChangeCapExceeded(
        f"Reached cap of {MAX_CHANGES_PER_RUN} changes. "
        "Stopping. Review and re-run to continue."
    )
```

What is the right cap? A useful heuristic is to start at 10% of the resource count in the target namespace. If the namespace has 50 Deployments, cap the agent at 5 changes per run. Adjust based on observed behavior over time - but always require a deliberate decision to raise the cap, never have it drift upward automatically.

Apply the same principle to Meshery design applications. If an agent is applying a design that would touch more than N components, require a human review before proceeding:

```bash
# Count components in a design before applying
mesheryctl design import \
  -f designs/microservices-demo.yaml \
  -s "Kubernetes Manifest"
# Review the component count in the output before confirming
```

## Circuit Breakers

A circuit breaker stops an agent when error rates exceed a threshold - the agent is "tripped" and subsequent actions are blocked until a human resets it. This pattern, familiar from distributed systems resilience, applies equally well to agentic automations.

Three states for an agent circuit breaker:

| State | Description |
|---|---|
| **Closed** | Normal operation. Agent runs freely within rate and cap limits. |
| **Open** | Error threshold exceeded. All mutating actions blocked. Alert sent to operator. |
| **Half-Open** | Operator resets the breaker. One trial action is allowed to test whether the problem has resolved. If it succeeds, the breaker closes. If not, it opens again. |

Implement the breaker by tracking error counts in a short window. If more than 3 mutating actions fail in a 5-minute window, trip the breaker:

```text
errors_in_window = count_errors(window=5m)
if errors_in_window > 3:
    trip_circuit_breaker()
    alert_operator("Agent circuit breaker tripped: >3 errors in 5m")
    block_all_mutating_actions()
```

The `designs/policy-guardrails.yaml` design includes OPA policies that can enforce similar circuit-breaker logic at the admission control layer, rejecting API calls from the agent's ServiceAccount when it has been flagged:

```bash
mesheryctl design import \
  -f designs/policy-guardrails.yaml \
  -s "Kubernetes Manifest"
```

## Combining Controls

No single control is sufficient on its own. Use all three in combination:

| Control | What it bounds |
|---|---|
| Rate limit | API call frequency - slows down runaway agents |
| Change cap | Total impact per run - limits scope of a single mistake |
| Circuit breaker | Response to failures - stops agents that are already failing |

When any of these controls trips, the response should be the same: the agent stops, an alert fires, and a human reviews the situation before the agent is allowed to resume. Do not build auto-retry logic that silently resets a tripped circuit breaker - that defeats the purpose.

## Observability for Blast Radius Controls

Controls without observability are invisible until they fail. Instrument each control:

- Expose a metric tracking `agent_api_calls_per_second` and alert if it approaches the rate limit.
- Track `agent_changes_this_run` and log it at the end of every run.
- Record `circuit_breaker_state` as a metric with labels for the agent identity and environment.

The observability stack deployed via `designs/observability-stack.yaml` gives you Prometheus and Grafana out of the box. Add agent-specific dashboards that show these metrics alongside error rates and change counts. An agent running without visible metrics is an agent running without accountability.

## Putting It Together

Blast-radius controls are the last line of defense after permissions, approvals, and sandboxing. They do not substitute for any of those layers - they catch the cases that slip through. An agent with narrow RBAC, human approval gates, sandboxed pre-production runs, and active blast-radius controls is an agent you can trust with production infrastructure. Remove any one of those layers, and the trust is no longer warranted.
