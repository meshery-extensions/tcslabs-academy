---
type: "page"
id: "llm-assisted-performance-tuning"
title: "LLM-Assisted Performance Tuning"
description: "Feed Meshery profile results to a coding agent to interpret latency percentiles, identify bottlenecks, and generate verified tuning recommendations."
weight: 3
---

## Why Involve an LLM in Performance Analysis?

Raw performance data from a load test is not a diagnosis. A p99 latency of 250 ms tells you something is slow at the tail, but it does not tell you whether the cause is CPU saturation, memory pressure, connection pool exhaustion, or a downstream dependency. Connecting the numbers to a root cause requires correlating them against resource metrics, deployment configuration, and knowledge of the application's architecture.

A coding agent with access to the right context can do this correlation faster than a manual review. The agent does not replace your judgment - it accelerates the first pass: scanning the histogram, surfacing anomalies, and proposing specific tuning actions that you then verify with a follow-up run.

## Preparing the Context

Before invoking an LLM, collect three artifacts:

1. **The profile result JSON** - the full output of `mesheryctl perf apply --output json`.
2. **Resource metrics at test time** - CPU and memory utilization from the Kubernetes namespace during the test window (from Prometheus or the observability stack in `designs/observability-stack.yaml`).
3. **The current deployment manifest** - specifically the `resources`, `replicas`, and relevant environment variables from the container spec.

Feeding all three to the agent gives it the inputs it needs to reason about the relationship between load, resource consumption, and latency.

## Structuring the Prompt

A well-structured prompt produces actionable output. Use a consistent template so that results are comparable across runs:

```text
You are a cloud native performance engineer. Analyze the following Meshery
performance profile result and Kubernetes deployment configuration.

## Profile Result
<paste JSON output here>

## Deployment Configuration
<paste relevant sections of the deployment manifest here>

## Resource Utilization During Test
CPU: 78% average, 94% peak
Memory: 1.1 GiB / 1.5 GiB limit

## Task
1. Interpret p50, p95, and p99 latency values.
2. Identify the most likely bottleneck based on the data provided.
3. Propose three specific, verifiable tuning actions.
4. For each action, state what metric you expect to improve and by how much.
```

The final two instructions - "verifiable" and "state the expected improvement" - are important. They force the agent to produce falsifiable recommendations rather than generic advice.

## Interpreting Percentile Patterns

An LLM working through performance data should recognize these common patterns:

| Pattern | Likely cause |
|---------|-------------|
| p50 low, p99 very high (10x+ gap) | GC pauses, connection pool limits, or slow DB queries on cache miss |
| p50 and p99 both high | CPU saturation or insufficient replicas |
| High error rate with normal latency | Circuit breaker tripping or upstream dependency failures |
| Latency climbs linearly with concurrency | Missing connection pooling or single-threaded bottleneck |

The agent should map the numbers to one of these patterns and then verify the hypothesis against the resource utilization data before proposing a fix.

## Acting on Recommendations

A typical agent output for a p50/p99 gap might look like this:

```text
Observation: p50 is 14 ms and p99 is 210 ms - a 15x gap. CPU utilization
peaked at 94%, which suggests the service is compute-bound during tail
requests rather than blocked on I/O.

Proposed actions:
1. Increase CPU limit from 500m to 1000m and re-run the profile.
   Expected: p99 drops below 80 ms; p50 unchanged.
2. Increase replica count from 2 to 3.
   Expected: p99 drops further; throughput ceiling rises.
3. Profile the /checkout handler with pprof to confirm CPU-bound path.
```

Do not apply all recommendations simultaneously. Apply one change at a time and re-run the profile with `mesheryctl perf apply --profile payment-service-checkout-flow`. Compare the new result against the baseline to confirm the change produced the expected improvement before making the next change.

## Verifying with a Follow-Up Run

After applying a tuning change, trigger the same profile:

```bash
mesheryctl perf apply --profile payment-service-checkout-flow --output json \
  > post-tuning-result.json
```

Feed `post-tuning-result.json` and the original baseline result to the agent with the prompt: "Compare these two results. Did the change produce the expected improvement? What residual issues remain?"

This two-pass pattern - propose, verify, re-propose - keeps the agent inside a tight feedback loop and prevents compounding changes that make attribution impossible.

## Limits of LLM Analysis

An LLM does not have direct access to your cluster unless you provide it through tools (MCP, RAG, or explicit context injection). It can only reason about what you give it. If the profile result does not include connection-level error counts, the agent cannot diagnose connection pool exhaustion. Completeness of the input context directly determines the quality of the output.

Always treat agent-generated tuning advice as a hypothesis to test, not a directive to execute. Run the profile again, verify the numbers moved in the expected direction, and only then commit the configuration change to your deployment.
