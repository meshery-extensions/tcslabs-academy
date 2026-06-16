---
title: "Course Test"
passPercentage: 70
type: "test"
questions:
  - id: "q1"
    text: "What does MCP stand for, and what is its primary purpose?"
    type: "short-answer"
    marks: 2
    correctAnswer: "Model Context Protocol"
    case_sensitive: false
    explanation: "MCP stands for Model Context Protocol. Its primary purpose is to provide a common, open standard interface so that agents and LLMs can connect to external tools, data sources, and services without requiring custom integration code for every agent/platform combination."

  - id: "q2"
    text: "Which MCP primitives have side effects (i.e., can change state or trigger operations)?"
    type: "single-answer"
    marks: 2
    explanation: "Only tools have side effects. Resources are read-only data sources, and prompts are reusable templates that return structured message content. Tools are the exclusive mechanism for giving an agent operational authority to change state."
    options:
      - id: "a"
        text: "Resources and prompts"
        isCorrect: false
      - id: "b"
        text: "Tools only"
        isCorrect: true
      - id: "c"
        text: "Tools and resources"
        isCorrect: false
      - id: "d"
        text: "All three primitives"
        isCorrect: false

  - id: "q3"
    text: "Which of the following are valid MCP transport options? Select all that apply."
    type: "multiple-answers"
    marks: 2
    explanation: "MCP defines two standard transports: stdio (the server runs as a child process, messages go over stdin/stdout) and HTTP with Server-Sent Events (the server runs as a standalone HTTP service). WebSocket and gRPC are not defined MCP transports."
    options:
      - id: "a"
        text: "Standard input/output (stdio)"
        isCorrect: true
      - id: "b"
        text: "HTTP with Server-Sent Events (SSE)"
        isCorrect: true
      - id: "c"
        text: "WebSocket"
        isCorrect: false
      - id: "d"
        text: "gRPC"
        isCorrect: false

  - id: "q4"
    text: "A platform team wants to give multiple product team agents access to Meshery's design catalog, with all invocations audited. What is the recommended integration approach?"
    type: "single-answer"
    marks: 2
    explanation: "An MCP server is the right choice when a shared platform capability needs to be exposed to multiple agents with consistent access controls and audit logging. A script per team or per agent is not maintainable at scale and does not provide a central audit point."
    options:
      - id: "a"
        text: "Write a separate shell script for each product team's agent."
        isCorrect: false
      - id: "b"
        text: "Build a single Meshery MCP server with logging middleware, shared by all agents."
        isCorrect: true
      - id: "c"
        text: "Have each agent call Meshery's REST API directly with hardcoded credentials."
        isCorrect: false
      - id: "d"
        text: "Use a plain CLI wrapper per agent since MCP adds unnecessary complexity."
        isCorrect: false

  - id: "q5"
    text: "During the MCP initialization handshake, what does the server return to the client?"
    type: "multiple-answers"
    marks: 2
    explanation: "The server's initialize response includes server info and its advertised capabilities - specifically which of the three primitives (tools, resources, prompts) it supports. The client uses this to determine what it can discover and call. The server does not return credentials or a session token in the initialize response."
    options:
      - id: "a"
        text: "Server info and the set of capabilities the server supports"
        isCorrect: true
      - id: "b"
        text: "Whether the server supports tools, resources, and/or prompts"
        isCorrect: true
      - id: "c"
        text: "A signed session token for subsequent requests"
        isCorrect: false
      - id: "d"
        text: "The protocol version the server implements"
        isCorrect: true

  - id: "q6"
    text: "A coding agent is asked to review a Meshery design, describe its components, and then apply it to the staging environment. Which sequence of MCP primitives does this workflow use, in order?"
    type: "single-answer"
    marks: 2
    explanation: "The workflow reads the design as a resource (read-only context), uses a prompt to structure the review task, then calls a tool (apply_design) to execute the side-effecting operation. This resource-then-prompt-then-tool pattern is the standard separation of concerns in MCP-driven agentic workflows."
    options:
      - id: "a"
        text: "Tool, then prompt, then resource"
        isCorrect: false
      - id: "b"
        text: "Prompt, then resource, then tool"
        isCorrect: false
      - id: "c"
        text: "Resource, then prompt, then tool"
        isCorrect: true
      - id: "d"
        text: "Tool, then resource, then prompt"
        isCorrect: false
---
