---
title: "Learning Path Exam"
passPercentage: 70
timeLimit: 35
type: "test"
questions:
  - id: "q1"
    text: "Which signals does Meshery surface that are useful for AI-assisted diagnostics? (Select all that apply.)"
    type: "multiple-answers"
    marks: 3
    explanation: "MeshSync-derived state, workload/component status, events, and metrics (via the Prometheus/Grafana integration) are all surfaced. Model training data is not a cluster signal."
    options:
      - id: "a"
        text: "MeshSync-derived cluster state"
        isCorrect: true
      - id: "b"
        text: "Workload and component status"
        isCorrect: true
      - id: "c"
        text: "Events and metrics (Prometheus/Grafana)"
        isCorrect: true
      - id: "d"
        text: "The LLM's training data"
        isCorrect: false
  - id: "q2"
    text: "When feeding logs to an LLM for analysis, what reduces hallucinated conclusions?"
    type: "single-answer"
    marks: 2
    explanation: "Scoping the input, pre-processing (dedupe/sort), and requiring the model to quote evidence verbatim keep its conclusions grounded."
    options:
      - id: "a"
        text: "Asking it to be creative"
        isCorrect: false
      - id: "b"
        text: "Scoping input and requiring verbatim evidence for claims"
        isCorrect: true
      - id: "c"
        text: "Sending the entire cluster's logs at once"
        isCorrect: false
      - id: "d"
        text: "Hiding the timestamps"
        isCorrect: false
  - id: "q3"
    text: "In symptom-to-hypothesis diagnosis, which hypothesis should you test first?"
    type: "single-answer"
    marks: 2
    explanation: "Test the cheapest, fastest-to-check hypothesis first to narrow the space quickly."
    options:
      - id: "a"
        text: "The most expensive one to verify"
        isCorrect: false
      - id: "b"
        text: "The cheapest/fastest one to verify"
        isCorrect: true
      - id: "c"
        text: "A random one"
        isCorrect: false
      - id: "d"
        text: "Always restart everything first"
        isCorrect: false
  - id: "q4"
    text: "What makes a runbook safe for a coding agent to follow?"
    type: "multiple-answers"
    marks: 3
    explanation: "Explicit steps, read-only-by-default actions, approval points, and stop conditions all make a runbook safe to delegate. 'No verification' is the opposite of safe."
    options:
      - id: "a"
        text: "Explicit, ordered steps"
        isCorrect: true
      - id: "b"
        text: "Read-only by default"
        isCorrect: true
      - id: "c"
        text: "Approval points and stop conditions"
        isCorrect: true
      - id: "d"
        text: "No verification of results"
        isCorrect: false
  - id: "q5"
    text: "During an incident, what is the right division of labor with an agent?"
    type: "single-answer"
    marks: 2
    explanation: "The agent accelerates gathering state and proposing fixes; a human leads decisions and approves changes - especially under pressure."
    options:
      - id: "a"
        text: "The agent makes all decisions to be fast"
        isCorrect: false
      - id: "b"
        text: "The agent gathers state and proposes; a human decides and approves"
        isCorrect: true
      - id: "c"
        text: "The human stops watching once the agent starts"
        isCorrect: false
      - id: "d"
        text: "Nobody reviews the changes"
        isCorrect: false
  - id: "q6"
    text: "Which mesheryctl command creates/runs a performance profile against an endpoint?"
    type: "short-answer"
    marks: 2
    correctAnswer: "mesheryctl perf apply"
    case_sensitive: false
    explanation: "`mesheryctl perf apply <name> --url ... --load-generator ...` runs a performance profile."
  - id: "q7"
    text: "Name one load generator Meshery supports for performance testing."
    type: "short-answer"
    marks: 2
    correctAnswer: "fortio"
    case_sensitive: false
    explanation: "Meshery supports fortio, wrk2, and nighthawk."
  - id: "q8"
    text: "How do you turn performance testing into a regression gate?"
    type: "single-answer"
    marks: 2
    explanation: "Save a baseline profile and compare new runs against it, failing when latency/throughput regress beyond a budget."
    options:
      - id: "a"
        text: "Run one test once and never again"
        isCorrect: false
      - id: "b"
        text: "Save a baseline and compare each run against it within a budget"
        isCorrect: true
      - id: "c"
        text: "Only test in production at peak"
        isCorrect: false
      - id: "d"
        text: "Delete old results"
        isCorrect: false
  - id: "q9"
    text: "What are the phases of a closed-loop remediation pattern?"
    type: "single-answer"
    marks: 2
    explanation: "Detect, decide, act, verify - a loop that confirms the fix actually worked."
    options:
      - id: "a"
        text: "Detect, decide, act, verify"
        isCorrect: true
      - id: "b"
        text: "Guess, apply, hope"
        isCorrect: false
      - id: "c"
        text: "Log, ignore, repeat"
        isCorrect: false
      - id: "d"
        text: "Scale, delete, restart"
        isCorrect: false
  - id: "q10"
    text: "Before granting an agent more remediation autonomy, what should justify it?"
    type: "single-answer"
    marks: 2
    explanation: "Grow autonomy only as measured evidence (success rate, low false positives, fast recovery, low rollback rate) justifies it."
    options:
      - id: "a"
        text: "A gut feeling that it is probably fine"
        isCorrect: false
      - id: "b"
        text: "Measured safety metrics over time"
        isCorrect: true
      - id: "c"
        text: "The vendor's marketing claims"
        isCorrect: false
      - id: "d"
        text: "Removing all approval gates immediately"
        isCorrect: false
---
