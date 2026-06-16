---
title: "Build a Meshery MCP Tool - Exam"
passPercentage: 70
timeLimit: 20
type: "test"
questions:
  - id: "q1"
    text: "Why build the first MCP tool as read-only?"
    type: "single-answer"
    marks: 2
    explanation: "Read-only is the safe foundation: the agent can observe and answer questions with minimal blast radius before any write capability is added."
    options:
      - id: "a"
        text: "Read-only tools cannot be logged"
        isCorrect: false
      - id: "b"
        text: "It is the safe foundation - observe before you allow changes"
        isCorrect: true
      - id: "c"
        text: "MCP does not support writes"
        isCorrect: false
      - id: "d"
        text: "It avoids needing a schema"
        isCorrect: false
  - id: "q2"
    text: "What makes a good MCP tool definition? (Select all that apply.)"
    type: "multiple-answers"
    marks: 3
    explanation: "A clear name, typed inputs, a shaped (not raw-dump) output, and structured errors all make a good tool. A single do-everything tool with write access is an anti-pattern."
    options:
      - id: "a"
        text: "A clear, single-responsibility name"
        isCorrect: true
      - id: "b"
        text: "Typed inputs and a shaped output"
        isCorrect: true
      - id: "c"
        text: "Structured errors instead of crashing"
        isCorrect: true
      - id: "d"
        text: "One tool that does everything with write access"
        isCorrect: false
  - id: "q3"
    text: "What typically backs a Meshery MCP tool?"
    type: "single-answer"
    marks: 2
    explanation: "The tool calls Meshery's REST/GraphQL API (or kubectl to start) and shapes the response for the agent."
    options:
      - id: "a"
        text: "Meshery's REST/GraphQL API (or kubectl)"
        isCorrect: true
      - id: "b"
        text: "A spreadsheet"
        isCorrect: false
      - id: "c"
        text: "The model's training data"
        isCorrect: false
      - id: "d"
        text: "A container registry"
        isCorrect: false
  - id: "q4"
    text: "In MCP, what is a 'resource' (as opposed to a tool)?"
    type: "single-answer"
    marks: 2
    explanation: "A resource is read-only data the agent can fetch on demand; a tool is an action the agent invokes."
    options:
      - id: "a"
        text: "Read-only data the agent can fetch on demand"
        isCorrect: true
      - id: "b"
        text: "A mutating action"
        isCorrect: false
      - id: "c"
        text: "A Kubernetes CRD"
        isCorrect: false
      - id: "d"
        text: "A load generator"
        isCorrect: false
  - id: "q5"
    text: "What should you do before connecting the MCP server to an agent?"
    type: "single-answer"
    marks: 2
    explanation: "Test the tool in isolation (valid input, error input, check logs) so you trust its output before an agent depends on it."
    options:
      - id: "a"
        text: "Test it in isolation and check its logs"
        isCorrect: true
      - id: "b"
        text: "Give it write access to production"
        isCorrect: false
      - id: "c"
        text: "Remove its error handling"
        isCorrect: false
      - id: "d"
        text: "Skip testing to save time"
        isCorrect: false
  - id: "q6"
    text: "Which Meshery component would a resource exposing live cluster state read from, and why note its lag?"
    type: "short-answer"
    marks: 2
    correctAnswer: "MeshSync"
    case_sensitive: false
    explanation: "MeshSync syncs cluster state; noting its lag tells the agent how fresh the data is."
---
