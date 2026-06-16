---
title: "Module Quiz"
passPercentage: 70
type: "test"
questions:
  - id: "q1"
    text: "What command do you use to run a saved Meshery performance profile from the CLI?"
    type: "single-answer"
    marks: 2
    explanation: "mesheryctl perf apply is the CLI command for running performance profiles. The --profile flag specifies which saved profile to execute."
    options:
      - id: "a"
        text: "mesheryctl system check --profile <name>"
        isCorrect: false
      - id: "b"
        text: "mesheryctl perf apply --profile <name>"
        isCorrect: true
      - id: "c"
        text: "mesheryctl perf run --name <name>"
        isCorrect: false
      - id: "d"
        text: "mesheryctl design apply --perf <name>"
        isCorrect: false
  - id: "q2"
    text: "Which load generator is best suited for testing a gRPC service running behind an Istio service mesh?"
    type: "single-answer"
    marks: 2
    explanation: "nighthawk is an Envoy-native load generator that supports gRPC and is designed to measure services running behind Envoy-based proxies such as Istio. It provides accurate per-stream latency using HDR histograms."
    options:
      - id: "a"
        text: "wrk2"
        isCorrect: false
      - id: "b"
        text: "fortio"
        isCorrect: false
      - id: "c"
        text: "nighthawk"
        isCorrect: true
      - id: "d"
        text: "ab (Apache Bench)"
        isCorrect: false
  - id: "q3"
    text: "When feeding a performance profile result to a coding agent for analysis, which of the following inputs improve the quality of the agent's diagnosis? Select all that apply."
    type: "multiple-answers"
    marks: 2
    explanation: "The agent needs the full profile result JSON for latency and error data, resource utilization metrics to correlate load with CPU/memory pressure, and the deployment manifest to check resource limits and replica count. The agent cannot access the cluster directly, so completeness of the provided context is critical."
    options:
      - id: "a"
        text: "The full profile result JSON from mesheryctl perf apply --output json"
        isCorrect: true
      - id: "b"
        text: "CPU and memory utilization metrics from the test window"
        isCorrect: true
      - id: "c"
        text: "The current deployment manifest including resource limits and replica count"
        isCorrect: true
      - id: "d"
        text: "The names of the engineers who wrote the service"
        isCorrect: false
  - id: "q4"
    text: "A performance profile result shows p50 latency of 15 ms and p99 latency of 220 ms. What does the large gap between p50 and p99 most likely indicate?"
    type: "single-answer"
    marks: 2
    explanation: "A large p50-to-p99 gap (here more than 14x) indicates that most requests are fast but a small fraction experience very high latency. Common causes are GC pauses, connection pool limits, or slow database queries on cache miss - intermittent resource pressure rather than overall saturation."
    options:
      - id: "a"
        text: "The service is uniformly slow and needs more replicas"
        isCorrect: false
      - id: "b"
        text: "The load generator is misconfigured"
        isCorrect: false
      - id: "c"
        text: "Most requests are fast but tail requests experience intermittent resource pressure"
        isCorrect: true
      - id: "d"
        text: "The p99 metric is not meaningful and can be ignored"
        isCorrect: false
---
