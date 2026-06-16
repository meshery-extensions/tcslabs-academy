---
title: "Learning Path Exam"
passPercentage: 70
timeLimit: 35
type: "test"
questions:
  - id: "q1"
    text: "What problem does the Model Context Protocol (MCP) primarily solve?"
    type: "single-answer"
    marks: 2
    explanation: "MCP gives agents/LLMs a common, standard interface to external tools and data, replacing many bespoke integrations."
    options:
      - id: "a"
        text: "It trains models faster"
        isCorrect: false
      - id: "b"
        text: "It gives agents a common, standard interface to external tools and data"
        isCorrect: true
      - id: "c"
        text: "It replaces Kubernetes"
        isCorrect: false
      - id: "d"
        text: "It encrypts container images"
        isCorrect: false
  - id: "q2"
    text: "Match the MCP primitives: which are real MCP concepts? (Select all that apply.)"
    type: "multiple-answers"
    marks: 3
    explanation: "Tools (actions), resources (readable data), and prompts (reusable templates) are the MCP primitives. A 'Deployment' is a Kubernetes object, not an MCP primitive."
    options:
      - id: "a"
        text: "Tools"
        isCorrect: true
      - id: "b"
        text: "Resources"
        isCorrect: true
      - id: "c"
        text: "Prompts"
        isCorrect: true
      - id: "d"
        text: "Deployments"
        isCorrect: false
  - id: "q3"
    text: "In the MCP client/server model, what is the agent?"
    type: "single-answer"
    marks: 2
    explanation: "The agent is the client; it connects to MCP servers that expose tools and resources."
    options:
      - id: "a"
        text: "The server"
        isCorrect: false
      - id: "b"
        text: "The client that connects to MCP servers"
        isCorrect: true
      - id: "c"
        text: "A Kubernetes node"
        isCorrect: false
      - id: "d"
        text: "A load generator"
        isCorrect: false
  - id: "q4"
    text: "When designing an MCP tool for Meshery, what is a good first principle?"
    type: "single-answer"
    marks: 2
    explanation: "Start read-only and single-responsibility, with a clear name and typed inputs/outputs - add mutating capabilities deliberately later."
    options:
      - id: "a"
        text: "Make one tool that does everything with write access"
        isCorrect: false
      - id: "b"
        text: "Start read-only, single-responsibility, with typed inputs/outputs"
        isCorrect: true
      - id: "c"
        text: "Avoid input validation to keep it simple"
        isCorrect: false
      - id: "d"
        text: "Return raw, unshaped API dumps"
        isCorrect: false
  - id: "q5"
    text: "An MCP tool for Meshery is typically backed by what?"
    type: "single-answer"
    marks: 2
    explanation: "It wraps Meshery's REST/GraphQL API, mapping a tool call to an API request and shaping the response for the agent."
    options:
      - id: "a"
        text: "Meshery's REST/GraphQL API"
        isCorrect: true
      - id: "b"
        text: "A random number generator"
        isCorrect: false
      - id: "c"
        text: "The container runtime"
        isCorrect: false
      - id: "d"
        text: "A Grafana panel"
        isCorrect: false
  - id: "q6"
    text: "For reads vs writes, how should MCP and mesheryctl typically divide work in an integration?"
    type: "single-answer"
    marks: 2
    explanation: "Use MCP tools/resources for structured reads and mesheryctl for actions like design import/deploy - choosing the right surface per step."
    options:
      - id: "a"
        text: "Use MCP for everything including destructive actions, unsupervised"
        isCorrect: false
      - id: "b"
        text: "Use MCP for structured reads and mesheryctl for actions, with approval"
        isCorrect: true
      - id: "c"
        text: "Never use mesheryctl"
        isCorrect: false
      - id: "d"
        text: "Use kubectl edit by hand for all changes"
        isCorrect: false
  - id: "q7"
    text: "Which command would an agent use to import a design as part of a deploy step?"
    type: "short-answer"
    marks: 2
    correctAnswer: "mesheryctl design import"
    case_sensitive: false
    explanation: "mesheryctl design import -f <file> -s \"Kubernetes Manifest\" imports a design; deploy then applies it."
  - id: "q8"
    text: "Why scope an automation identity to least privilege?"
    type: "single-answer"
    marks: 2
    explanation: "Granting only the permissions required limits the damage from a mistake or a compromised agent."
    options:
      - id: "a"
        text: "To make setup harder"
        isCorrect: false
      - id: "b"
        text: "To limit the damage from a mistake or compromise"
        isCorrect: true
      - id: "c"
        text: "Because Meshery requires cluster-admin"
        isCorrect: false
      - id: "d"
        text: "To speed up inference"
        isCorrect: false
  - id: "q9"
    text: "Which controls help bound an agent's blast radius? (Select all that apply.)"
    type: "multiple-answers"
    marks: 3
    explanation: "Rate limits, per-run change caps, and circuit breakers all contain mistakes. Granting cluster-admin does the opposite."
    options:
      - id: "a"
        text: "API rate limits"
        isCorrect: true
      - id: "b"
        text: "Per-run change caps"
        isCorrect: true
      - id: "c"
        text: "Circuit breakers"
        isCorrect: true
      - id: "d"
        text: "Granting cluster-admin"
        isCorrect: false
  - id: "q10"
    text: "Before connecting an MCP server to a real agent, what should you do?"
    type: "single-answer"
    marks: 2
    explanation: "Test and debug the server (verify each tool returns correct, well-shaped data; check logs) before wiring it to an agent."
    options:
      - id: "a"
        text: "Deploy it straight to production"
        isCorrect: false
      - id: "b"
        text: "Test each tool's output and behavior, and check logs"
        isCorrect: true
      - id: "c"
        text: "Grant it write access to production first"
        isCorrect: false
      - id: "d"
        text: "Remove all logging"
        isCorrect: false
---
