---
title: "Course Test"
passPercentage: 70
type: "test"
questions:
  - id: "q1"
    text: "What is the primary purpose of a Meshery performance profile?"
    type: "single-answer"
    marks: 2
    explanation: "A Meshery performance profile is a named, reusable test specification that captures the target endpoint, load generator, duration, request rate, and SLOs. Its primary purpose is to enable repeatable, reproducible load tests that produce a time-ordered history of results."
    options:
      - id: "a"
        text: "To define Kubernetes resource quotas for a namespace"
        isCorrect: false
      - id: "b"
        text: "To store a reusable, reproducible load test specification that generates comparable result history over time"
        isCorrect: true
      - id: "c"
        text: "To configure Meshery Operator reconciliation intervals"
        isCorrect: false
      - id: "d"
        text: "To export Prometheus metrics to Grafana"
        isCorrect: false
  - id: "q2"
    text: "Which flag must you add to mesheryctl perf apply to capture the full latency histogram as structured data for programmatic processing?"
    type: "short-answer"
    marks: 2
    correctAnswer: "--output json"
    case_sensitive: false
    explanation: "The --output json flag instructs mesheryctl perf apply to emit the full result including percentile histograms, throughput, and error rates as JSON, which can be piped to a script or a coding agent for analysis."
  - id: "q3"
    text: "fortio is the recommended default load generator for most API performance profiles because:"
    type: "single-answer"
    marks: 2
    explanation: "fortio runs at a fixed QPS and applies coordinated omission correction by default, which produces accurate latency histograms. It also supports HTTP/1.1, HTTP/2, and gRPC and emits clean JSON output, making it the most versatile starting point for general API testing."
    options:
      - id: "a"
        text: "It is the only generator that supports HTTP/2"
        isCorrect: false
      - id: "b"
        text: "It runs at fixed QPS with coordinated omission correction, produces clean JSON output, and supports multiple protocols"
        isCorrect: true
      - id: "c"
        text: "It is the fastest generator available and can sustain the highest request rates"
        isCorrect: false
      - id: "d"
        text: "It is required by Meshery Operator for all performance scans"
        isCorrect: false
  - id: "q4"
    text: "When should you update the stored performance baseline? Select all that apply."
    type: "multiple-answers"
    marks: 2
    explanation: "The baseline should be updated when a deliberate optimization is verified to produce real improvements, when the SLO or traffic pattern changes intentionally, or when the infrastructure changes in a way that makes the old baseline irrelevant. The baseline should never be updated just to pass a failing gate - that defeats the purpose of regression detection."
    options:
      - id: "a"
        text: "After a verified optimization that measurably improves the profiled metrics"
        isCorrect: true
      - id: "b"
        text: "When an SLO or traffic pattern is intentionally changed"
        isCorrect: true
      - id: "c"
        text: "Whenever the gate fails, to prevent the pipeline from blocking"
        isCorrect: false
      - id: "d"
        text: "When the infrastructure changes in a way that makes the old baseline irrelevant"
        isCorrect: true
  - id: "q5"
    text: "A coding agent analyzing a performance profile observes: p50 = 18 ms, p99 = 22 ms, error rate = 4.3%, CPU utilization = 35%. What is the most likely root cause?"
    type: "single-answer"
    marks: 2
    explanation: "When latency is low and consistent (narrow p50-to-p99 spread) but error rate is elevated, the service is not under CPU or memory pressure. The error rate with normal latency is the pattern associated with a circuit breaker tripping or upstream dependency failures - not resource saturation."
    options:
      - id: "a"
        text: "CPU saturation causing high tail latency"
        isCorrect: false
      - id: "b"
        text: "Connection pool exhaustion causing timeouts"
        isCorrect: false
      - id: "c"
        text: "A circuit breaker tripping or upstream dependency failures"
        isCorrect: true
      - id: "d"
        text: "The load generator is producing too many concurrent connections"
        isCorrect: false
  - id: "q6"
    text: "Which practices reduce false positive regression failures caused by normal performance variance? Select all that apply."
    type: "multiple-answers"
    marks: 2
    explanation: "Using statistical thresholds (requiring a metric to exceed budget by more than a small margin), averaging across multiple runs, and including a warm-up period all reduce noise-driven false positives. Running with a single connection does not help with variance and may actually introduce its own artifacts."
    options:
      - id: "a"
        text: "Require a metric to exceed the budget by more than 15% before failing the gate"
        isCorrect: true
      - id: "b"
        text: "Run the profile three times and use the median result for comparison"
        isCorrect: true
      - id: "c"
        text: "Always run with a single concurrent connection to eliminate variance"
        isCorrect: false
      - id: "d"
        text: "Include a warm-up phase before the measurement window to avoid cold-start latency"
        isCorrect: true
---
