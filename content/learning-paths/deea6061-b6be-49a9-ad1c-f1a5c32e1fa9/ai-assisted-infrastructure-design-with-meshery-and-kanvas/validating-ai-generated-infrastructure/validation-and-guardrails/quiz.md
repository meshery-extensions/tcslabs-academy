---
title: "Module Quiz"
passPercentage: 70
type: "test"
questions:
  - id: "q1"
    text: "A Meshery design contains a Service whose selector does not match any Pod labels in the design. Which validation mechanism catches this error?"
    type: "single-answer"
    marks: 2
    explanation: "Meshery's registry resolves component relationships at import time. A Service-to-Pod network relationship that resolves to zero matching components is reported as a relationship error - not a schema error, since the YAML itself is structurally valid."
    options:
      - id: "a"
        text: "YAML schema validation"
        isCorrect: false
      - id: "b"
        text: "Meshery registry relationship evaluation"
        isCorrect: true
      - id: "c"
        text: "LimitRange admission control"
        isCorrect: false
      - id: "d"
        text: "ResourceQuota enforcement"
        isCorrect: false
  - id: "q2"
    text: "Which Kubernetes primitive sets a default CPU limit for any container in a namespace that omits one?"
    type: "single-answer"
    marks: 2
    explanation: "A LimitRange can specify default limits and default requests at the container level. When a container is admitted without explicit limits, the admission controller injects the LimitRange defaults automatically."
    options:
      - id: "a"
        text: "ResourceQuota"
        isCorrect: false
      - id: "b"
        text: "NetworkPolicy"
        isCorrect: false
      - id: "c"
        text: "LimitRange"
        isCorrect: true
      - id: "d"
        text: "PodDisruptionBudget"
        isCorrect: false
  - id: "q3"
    text: "Which of the following are common misconfiguration patterns produced by LLMs that Meshery's pre-deploy checks catch? Select all that apply."
    type: "multiple-answers"
    marks: 2
    explanation: "LLMs frequently omit resource limits (because much training data lacks them), produce selector/label mismatches between Services and Deployments, and assign resources to the wrong namespace. All three are caught by Meshery's relationship validation and policy engine before deployment."
    options:
      - id: "a"
        text: "Missing container resource limits"
        isCorrect: true
      - id: "b"
        text: "Service selector not matching Deployment labels"
        isCorrect: true
      - id: "c"
        text: "Incorrect Hugo front matter"
        isCorrect: false
      - id: "d"
        text: "Resources assigned to the wrong namespace"
        isCorrect: true
  - id: "q4"
    text: "What is the primary purpose of applying a default-deny NetworkPolicy to a namespace before deploying AI-generated workloads?"
    type: "single-answer"
    marks: 2
    explanation: "LLMs rarely generate NetworkPolicies. Without a default-deny baseline, all Pods in the namespace can communicate freely. A default-deny policy forces generated designs to explicitly declare the network access they need, surfacing gaps immediately in testing rather than silently in production."
    options:
      - id: "a"
        text: "To limit aggregate CPU and memory consumption across the namespace"
        isCorrect: false
      - id: "b"
        text: "To prevent node drains from terminating all replicas simultaneously"
        isCorrect: false
      - id: "c"
        text: "To force generated designs to explicitly declare required network access"
        isCorrect: true
      - id: "d"
        text: "To set default resource requests on containers that omit them"
        isCorrect: false
---
