---
type: "page"
id: "performance-profiles-in-meshery"
title: "Performance Profiles in Meshery"
description: "Understand what a Meshery performance profile is and how to create, run, and save one to track service health over time."
weight: 1
---

## What is a Performance Profile?

A Meshery performance profile is a named, reusable test specification that captures everything needed to reproduce a load test: the target endpoint, the load generator to use, the duration, the request rate or concurrency level, and the service-level objectives (SLOs) you want to measure against. Profiles are stored in Meshery and can be triggered on demand or from a CI pipeline.

The separation between the profile definition and the test run is important. The profile is the specification - what to test and under what conditions. Each execution produces a result snapshot that Meshery stores and associates with the profile, giving you a time-ordered history of how the service has performed across releases and config changes.

## Core Metrics

Every profile result surfaces four key signal categories:

| Metric | What it tells you |
|--------|-------------------|
| Latency (p50, p95, p99) | The spread of response times; outliers show up at p99 |
| Throughput (req/s) | Sustained request capacity before the service degrades |
| Error rate (%) | Fraction of requests that returned 4xx or 5xx responses |
| Connection errors | Network-level failures independent of HTTP status codes |

p50 tells you what the median user experiences. p95 and p99 expose tail behavior - the slow requests that skew user perception and often signal resource contention or garbage collection pauses. Track all three; optimizing only p50 while ignoring p99 is a common mistake.

## Creating a Profile with mesheryctl

The `mesheryctl perf apply` command is the primary CLI entry point. At minimum you supply a profile name and a URL:

```bash
mesheryctl perf apply --profile my-api-baseline \
  --url http://my-service.default.svc.cluster.local:8080/api/health \
  --duration 30s \
  --load-generator fortio \
  --concurrent-requests 10
```

Meshery stores the profile under the name `my-api-baseline`. On subsequent runs, omit the flags you do not want to change - Meshery reads the stored profile and applies it:

```bash
mesheryctl perf apply --profile my-api-baseline
```

To run the profile and immediately view the results summary:

```bash
mesheryctl perf apply --profile my-api-baseline --output json
```

The JSON output contains the full latency histogram, throughput, and error rate. Pipe it to your coding agent for interpretation (covered in lesson 3).

## Saving and Comparing Profiles

Each `mesheryctl perf apply` run creates a new result snapshot that Meshery links to the profile. You can list past results from the Meshery UI under **Performance** or retrieve them via the Meshery API.

Best practices for managing profiles:

- **Name profiles after the service and the test scenario**, not the date. Dates belong in the result metadata, not the profile name. Example: `payment-service-checkout-flow` rather than `payment-test-2024-06`.
- **Keep one profile per SLO boundary.** If the checkout endpoint has a different latency budget than the catalog endpoint, define separate profiles. Mixing them produces results that are hard to act on.
- **Anchor profiles to a design.** After importing `designs/microservices-demo.yaml` with `mesheryctl design import -f designs/microservices-demo.yaml -s "Kubernetes Manifest"`, you have a known starting topology. Create profiles against that topology so that when you compare results you know the infrastructure configuration was consistent.

## Interpreting Raw Output

A result summary in JSON form looks like this:

```json
{
  "Profile": "payment-service-checkout-flow",
  "StartTime": "2024-06-10T14:00:00Z",
  "Duration": "30s",
  "RequestedQPS": "100",
  "ActualQPS": 98.6,
  "Percentiles": {
    "p50": 12.3,
    "p75": 18.7,
    "p95": 47.2,
    "p99": 134.8
  },
  "ErrorPercent": 0.02,
  "RetCodes": { "200": 2958, "503": 1 }
}
```

The gap between p50 (12 ms) and p99 (134 ms) is large - more than 10x. That spread is the first thing an LLM or a human reviewer should flag. A narrow p50-to-p99 spread indicates consistent performance; a wide spread points to intermittent resource pressure or cold-path execution.

## Next Steps

With a saved baseline profile you have a reproducible signal. The next lesson examines how to choose the right load generator for each type of workload, because the choice of generator directly affects the accuracy of your results.
