---
type: "page"
id: "load-generators-fortio-wrk2-nighthawk"
title: "Load Generators: fortio, wrk2, and nighthawk"
description: "Compare the load generators Meshery supports and learn how to choose the right one for each test scenario."
weight: 2
---

## Why the Choice of Load Generator Matters

The load generator is not a neutral tool. Each one makes different assumptions about how to drive traffic, how to measure latency, and what statistical model to use for result aggregation. Choosing the wrong generator for your workload can produce results that look good in a report but do not reflect real user experience - or results that are so noisy they are impossible to compare across runs.

Meshery supports three load generators out of the box: **fortio**, **wrk2**, and **nighthawk**. You specify the generator in a performance profile via the `--load-generator` flag.

## fortio

Fortio (pronounced "for-tee-oh") is the default Meshery load generator and a CNCF project. It was built by the Istio team and is designed for correctness and reproducibility.

**Key characteristics:**

- Runs at a fixed QPS (queries per second), not a fixed concurrency level. This means it measures how the service performs under a specific offered load rather than how it behaves with N simultaneous connections.
- Uses coordinated omission correction by default - it accounts for slow responses in the latency histogram rather than hiding them behind a backlog of requests.
- Supports HTTP/1.1, HTTP/2, and gRPC.
- Produces clean JSON output that is easy to parse programmatically.

**When to use fortio:**

- API services with an expected QPS budget (e.g., "this endpoint must handle 500 req/s at p99 < 50 ms").
- Baseline measurement and regression detection where reproducibility matters most.
- Scenarios where you want coordinated-omission-correct latency numbers.

```bash
mesheryctl perf apply --profile api-baseline \
  --url http://my-api.default.svc.cluster.local/v1/status \
  --load-generator fortio \
  --duration 60s \
  --qps 200
```

## wrk2

wrk2 is a fork of wrk that adds constant-throughput mode and corrects for coordinated omission. It is a C-based tool that can push very high request rates with low CPU overhead.

**Key characteristics:**

- Constant-throughput scheduling means it maintains the target rate even when some responses are slow, which produces accurate latency histograms under high load.
- Multi-threaded with a fixed number of connections per thread; good for simulating many concurrent users.
- Does not natively support HTTP/2 or gRPC.
- Less scriptable than fortio for complex request patterns.

**When to use wrk2:**

- HTTP/1.1 services that need to sustain very high request rates (tens of thousands of req/s).
- Scenarios where you want to compare against existing wrk2 benchmarks from the community.
- Workloads where connection count is the primary variable rather than QPS.

```bash
mesheryctl perf apply --profile high-volume \
  --url http://my-service.default.svc.cluster.local/ \
  --load-generator wrk2 \
  --duration 30s \
  --concurrent-requests 50
```

## nighthawk

Nighthawk is an Envoy-native load testing tool built by the Envoy proxy team. It is purpose-built for measuring Envoy-proxied services and service mesh environments.

**Key characteristics:**

- Supports both HTTP/1.1 and HTTP/2, as well as gRPC with detailed per-stream latency metrics.
- Produces extremely detailed latency histograms using HDR histograms, which capture outliers accurately.
- Can drive traffic through the Envoy data plane directly, measuring the overhead contributed by the proxy itself.
- Supports request sequencing and per-request header injection, which is useful for testing auth flows or A/B canaries.

**When to use nighthawk:**

- Services running behind Istio or Envoy where proxy overhead is part of what you are measuring.
- gRPC workloads where per-stream latency matters.
- Advanced scenarios where you need per-request customization (custom headers, body templates).
- When HDR histogram precision at the p99.9 and p99.99 levels is required.

```bash
mesheryctl perf apply --profile grpc-checkout \
  --url grpc://my-checkout.default.svc.cluster.local:9090 \
  --load-generator nighthawk \
  --duration 60s \
  --concurrent-requests 20
```

## Comparison Summary

| Dimension | fortio | wrk2 | nighthawk |
|-----------|--------|------|-----------|
| Protocol support | HTTP/1.1, HTTP/2, gRPC | HTTP/1.1 | HTTP/1.1, HTTP/2, gRPC |
| Coordinated omission | Corrected | Corrected | Corrected (HDR) |
| Throughput ceiling | Medium-high | Very high | High |
| Proxy-aware | No | No | Yes (Envoy) |
| Best for | General API testing | High-volume HTTP | Envoy / service mesh |

## Choosing a Generator for Your Test

Start with fortio for most API performance profiles. Switch to nighthawk when your service runs behind Istio or when you need gRPC-level precision. Reserve wrk2 for pure HTTP/1.1 throughput benchmarks where you are comparing against existing community results.

The load generator you choose belongs in the profile definition so that every comparison run uses the same generator. Switching generators mid-series invalidates your historical trend data.
