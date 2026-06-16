---
title: "Module Quiz"
passPercentage: 70
type: "test"
questions:
  - id: "q1"
    text: "Which of the following best describes what the Model Context Protocol (MCP) solves?"
    type: "single-answer"
    marks: 2
    explanation: "MCP solves the N-times-M integration problem by defining a single protocol that any compliant agent can use to connect to any compliant server, eliminating the need to rebuild integrations for every agent/platform combination."
    options:
      - id: "a"
        text: "It replaces Kubernetes RBAC with a simpler permission model for agents."
        isCorrect: false
      - id: "b"
        text: "It provides a common interface so agents can connect to any compliant server without bespoke glue code per agent/platform pair."
        isCorrect: true
      - id: "c"
        text: "It is a training protocol for fine-tuning LLMs on infrastructure data."
        isCorrect: false
      - id: "d"
        text: "It standardizes how Kubernetes manifests are authored by coding agents."
        isCorrect: false

  - id: "q2"
    text: "An MCP server exposes three primitives. Which of the following correctly identifies all three?"
    type: "single-answer"
    marks: 2
    explanation: "The three MCP primitives are tools (side-effecting actions the agent can invoke), resources (read-only data the agent can access), and prompts (reusable server-defined templates). Configurations and schemas are not MCP primitives."
    options:
      - id: "a"
        text: "Tools, resources, and configurations"
        isCorrect: false
      - id: "b"
        text: "Actions, schemas, and templates"
        isCorrect: false
      - id: "c"
        text: "Tools, resources, and prompts"
        isCorrect: true
      - id: "d"
        text: "Hooks, handlers, and middleware"
        isCorrect: false

  - id: "q3"
    text: "In the MCP client/server model, which entity is responsible for enforcing access controls on infrastructure operations?"
    type: "single-answer"
    marks: 2
    explanation: "The MCP server is the enforcement point. It should authenticate callers, validate that requested actions are within the caller's permitted scope, and log all invocations. The client and agent are not trusted to self-enforce these constraints."
    options:
      - id: "a"
        text: "The LLM, because it reasons about what actions are safe."
        isCorrect: false
      - id: "b"
        text: "The MCP client, because it initiates all requests."
        isCorrect: false
      - id: "c"
        text: "The MCP server, which is the enforcement point independent of which agent is on the other side."
        isCorrect: true
      - id: "d"
        text: "The initialization handshake, which negotiates permissions for the session."
        isCorrect: false

  - id: "q4"
    text: "When is a plain script or CLI wrapper a better choice than building an MCP server?"
    type: "single-answer"
    marks: 2
    explanation: "MCP earns its place when multiple agents need the same capability, when consistency across frameworks matters, or when audit and access controls are required. For a one-off, single-agent, single-task integration with no expectation of reuse, the overhead of a protocol layer is not justified - a script is the right tool."
    options:
      - id: "a"
        text: "When multiple teams and agents all need access to the same backend platform."
        isCorrect: false
      - id: "b"
        text: "When you need all agent-initiated operations to produce an audit log."
        isCorrect: false
      - id: "c"
        text: "When you are automating a one-off task for a single agent with no expectation of reuse."
        isCorrect: true
      - id: "d"
        text: "When the integration must work across multiple agent frameworks."
        isCorrect: false
---
