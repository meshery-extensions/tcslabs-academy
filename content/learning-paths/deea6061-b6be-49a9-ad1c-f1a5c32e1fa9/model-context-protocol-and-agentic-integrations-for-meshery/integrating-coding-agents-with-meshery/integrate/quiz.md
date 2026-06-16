---
title: "Module Quiz"
passPercentage: 70
type: "test"
questions:
  - id: "q1"
    text: "Where does mesheryctl store the authentication token it uses for all API calls?"
    type: "single-answer"
    marks: 2
    explanation: "mesheryctl reads and writes credentials to ~/.meshery/auth.json. This file must be present and current before any agent-driven CLI invocation."
    options:
      - id: "a"
        text: "~/.kube/config"
        isCorrect: false
      - id: "b"
        text: "~/.meshery/auth.json"
        isCorrect: true
      - id: "c"
        text: "/etc/meshery/token"
        isCorrect: false
      - id: "d"
        text: "A JWT passed as an environment variable at runtime"
        isCorrect: false
  - id: "q2"
    text: "Which Meshery API surface is best suited for fetching only specific fields from multiple related entities in a single request?"
    type: "single-answer"
    marks: 2
    explanation: "GraphQL lets the caller specify exactly which fields to return and can join across related entities in one query, avoiding multiple round-trips that the REST API would require."
    options:
      - id: "a"
        text: "The REST API using GET /api/pattern"
        isCorrect: false
      - id: "b"
        text: "The GraphQL API at /api/graphql/query"
        isCorrect: true
      - id: "c"
        text: "The mesheryctl CLI with the --output flag"
        isCorrect: false
      - id: "d"
        text: "The Meshery MCP server's subscribe tool"
        isCorrect: false
  - id: "q3"
    text: "In the recommended agent workflow, which surfaces should be used for each phase? (Select all that apply)"
    type: "multiple-answers"
    marks: 2
    explanation: "MCP tools are used for structured reads (gathering state) because they return JSON the agent can reason over. mesheryctl is used for writes (import, deploy) because it provides reliable exit codes and is the sanctioned CLI path for state-changing actions."
    options:
      - id: "a"
        text: "MCP tools for reading current design and environment state"
        isCorrect: true
      - id: "b"
        text: "mesheryctl for importing and deploying designs"
        isCorrect: true
      - id: "c"
        text: "MCP tools for all write operations including deploy"
        isCorrect: false
      - id: "d"
        text: "mesheryctl for verifying live component state after deploy"
        isCorrect: false
  - id: "q4"
    text: "What is the purpose of importing a proposed design with 'mesheryctl design import' before deploying it in the end-to-end workflow?"
    type: "single-answer"
    marks: 2
    explanation: "Importing the design registers it in Meshery and makes it visible in Kanvas so the human operator can review the change visually before the agent proceeds to deploy. This is the human-in-the-loop approval gate."
    options:
      - id: "a"
        text: "It automatically deploys the design to the target namespace"
        isCorrect: false
      - id: "b"
        text: "It compresses the YAML before sending it to the Meshery server"
        isCorrect: false
      - id: "c"
        text: "It registers the design so the operator can review it in Kanvas before approving deployment"
        isCorrect: true
      - id: "d"
        text: "It validates the design against the Kubernetes schema only, without touching Meshery"
        isCorrect: false
---
