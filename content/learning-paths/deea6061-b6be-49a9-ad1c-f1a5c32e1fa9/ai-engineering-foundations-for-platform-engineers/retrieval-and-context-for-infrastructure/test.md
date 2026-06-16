---
title: "Course Test"
passPercentage: 70
type: "test"
questions:
  - id: "q1"
    text: "Which of the following best describes the 'lost in the middle' problem with large context windows?"
    type: "single-answer"
    marks: 2
    explanation: "Research shows that LLMs attend poorly to content positioned in the middle of a long context. This means that simply injecting more state into the prompt does not guarantee the model will use all of it correctly."
    options:
      - id: "a"
        text: "Models refuse to process context windows larger than a fixed token limit"
        isCorrect: false
      - id: "b"
        text: "Models attend poorly to content buried deep in the middle of a long context"
        isCorrect: true
      - id: "c"
        text: "Context windows lose tokens from the middle due to compression"
        isCorrect: false
      - id: "d"
        text: "Retrieval systems fail to return the middle chunks from a document"
        isCorrect: false

  - id: "q2"
    text: "An agent needs to know the current number of ready replicas for the payment service in the production namespace. Which approach provides the most accurate answer?"
    type: "single-answer"
    marks: 2
    explanation: "Runtime tool calls to kubectl query the live Kubernetes API at the moment of need, providing the most current data. Pre-fetched context may be seconds or minutes stale, and training data is far more stale."
    options:
      - id: "a"
        text: "Inject a pre-fetched cluster snapshot taken at session start"
        isCorrect: false
      - id: "b"
        text: "Rely on the LLM's training data for typical replica counts"
        isCorrect: false
      - id: "c"
        text: "Execute a runtime tool call to kubectl get deployment"
        isCorrect: true
      - id: "d"
        text: "Query the Meshery Catalog for the service definition"
        isCorrect: false

  - id: "q3"
    text: "When building a retrieval knowledge base from runbooks, which chunking approach is most appropriate?"
    type: "multiple-answers"
    marks: 2
    explanation: "Effective chunking for runbooks uses one procedure per chunk (to keep context coherent), attaches metadata like service tags and modification date (to enable filtered retrieval), and includes a brief header to prevent loss of context at boundaries."
    options:
      - id: "a"
        text: "Split each runbook into one chunk per procedure, with a header naming the procedure and service"
        isCorrect: true
      - id: "b"
        text: "Attach metadata including source file, last-modified date, and relevant service or namespace"
        isCorrect: true
      - id: "c"
        text: "Store each entire runbook as a single chunk to preserve all context"
        isCorrect: false
      - id: "d"
        text: "Split on every paragraph boundary with no metadata"
        isCorrect: false

  - id: "q4"
    text: "What command verifies that Meshery is running correctly before an agent begins any retrieval or design import operations?"
    type: "single-answer"
    marks: 2
    explanation: "mesheryctl system check verifies the health of a running Meshery deployment. It should be run before operations that depend on the Meshery control plane being available."
    options:
      - id: "a"
        text: "mesheryctl system start"
        isCorrect: false
      - id: "b"
        text: "kubectl get pods -n meshery"
        isCorrect: false
      - id: "c"
        text: "mesheryctl system check"
        isCorrect: true
      - id: "d"
        text: "mesheryctl registry list"
        isCorrect: false

  - id: "q5"
    text: "Which of the following are valid safety requirements before an agent executes a write operation on a production cluster?"
    type: "multiple-answers"
    marks: 2
    explanation: "Human approval, dry-run preview, and policy guardrail evaluation are all required before applying real changes. Bounding the blast radius to specific namespaces is also a best practice. Allowing agents to apply changes without approval violates the human-in-the-loop principle."
    options:
      - id: "a"
        text: "Require explicit human approval before any kubectl apply or design import"
        isCorrect: true
      - id: "b"
        text: "Run a dry-run and surface the output for review before executing"
        isCorrect: true
      - id: "c"
        text: "Evaluate the proposed change against OPA or Meshery policy constraints"
        isCorrect: true
      - id: "d"
        text: "Allow the agent to apply changes automatically if tool call accuracy exceeds 80%"
        isCorrect: false

  - id: "q6"
    text: "What is the primary purpose of a 'golden task set' in the context of evaluating an infrastructure agent?"
    type: "short-answer"
    marks: 2
    correctAnswer: "golden tasks"
    case_sensitive: false
    explanation: "A golden task set is a collection of representative, real-world scenarios paired with expected correct answers. It provides a reproducible benchmark for measuring whether the agent produces accurate, safe, and useful behavior across tasks that matter for your environment."
---
