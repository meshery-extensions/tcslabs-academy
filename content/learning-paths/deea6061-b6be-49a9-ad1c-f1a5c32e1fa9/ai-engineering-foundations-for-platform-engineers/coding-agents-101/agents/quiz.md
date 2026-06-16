---
title: "Module Quiz"
passPercentage: 70
type: "test"
questions:
  - id: "q1"
    text: "What is the key difference between using an LLM in chat mode versus running a coding agent?"
    type: "single-answer"
    marks: 2
    explanation: "A coding agent can call tools - reading files, running commands, and observing results - and loop over multiple steps to complete a task. Chat mode is a single-turn interaction with no tool access."
    options:
      - id: "a"
        text: "A coding agent uses a larger language model."
        isCorrect: false
      - id: "b"
        text: "A coding agent can invoke tools and iterate over multiple steps to complete a task."
        isCorrect: true
      - id: "c"
        text: "A coding agent responds faster than chat mode."
        isCorrect: false
      - id: "d"
        text: "A coding agent requires no prompts from the user."
        isCorrect: false

  - id: "q2"
    text: "In the plan-act-observe loop, what happens immediately after the agent calls a tool?"
    type: "single-answer"
    marks: 2
    explanation: "After the agent calls a tool, the framework executes it and appends the result (the observation) to the agent's context. The agent then returns to the plan step with updated context."
    options:
      - id: "a"
        text: "The agent produces a final answer."
        isCorrect: false
      - id: "b"
        text: "The loop terminates and waits for user input."
        isCorrect: false
      - id: "c"
        text: "The tool result is appended to the context and the agent plans its next step."
        isCorrect: true
      - id: "d"
        text: "The agent calls the next tool immediately without evaluating the result."
        isCorrect: false

  - id: "q3"
    text: "Which of the following conditions should trigger a human approval gate before an agent proceeds?"
    type: "multiple-answers"
    marks: 2
    explanation: "Deleting resources and scaling production deployments are irreversible or high-impact actions that warrant human approval. Reading pod logs and listing namespaces are read-only and low-risk."
    options:
      - id: "a"
        text: "Reading pod logs in a development namespace."
        isCorrect: false
      - id: "b"
        text: "Deleting a Kubernetes namespace."
        isCorrect: true
      - id: "c"
        text: "Scaling a production deployment based on observed latency."
        isCorrect: true
      - id: "d"
        text: "Listing namespaces across the cluster."
        isCorrect: false

  - id: "q4"
    text: "What Meshery CLI command would you use to import and validate a design file before applying it to the cluster?"
    type: "short-answer"
    marks: 2
    correctAnswer: "mesheryctl design import"
    case_sensitive: false
    explanation: "The command `mesheryctl design import -f <file> -s \"Kubernetes Manifest\"` imports and validates a design in Meshery before it is deployed to the cluster."
---
