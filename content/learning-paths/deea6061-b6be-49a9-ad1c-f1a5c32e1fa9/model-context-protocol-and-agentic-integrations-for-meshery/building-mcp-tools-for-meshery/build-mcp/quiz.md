---
title: "Module Quiz"
passPercentage: 70
type: "test"
questions:
  - id: "q1"
    text: "Which naming pattern is recommended for MCP tool names that expose Meshery operations?"
    type: "single-answer"
    marks: 2
    explanation: "The verb_noun pattern (e.g., get_workload_status, list_designs) gives the agent a clear, unambiguous signal about both the action and the target, reducing incorrect invocations."
    options:
      - id: "a"
        text: "A generic name like 'query' or 'fetch' that covers multiple operations"
        isCorrect: false
      - id: "b"
        text: "A verb_noun pattern such as get_workload_status or list_designs"
        isCorrect: true
      - id: "c"
        text: "A fully qualified path matching the REST API endpoint, e.g., /api/v1/designs"
        isCorrect: false
      - id: "d"
        text: "A camelCase method name matching the Meshery SDK client method"
        isCorrect: false
  - id: "q2"
    text: "What is the primary difference between an MCP tool and an MCP resource?"
    type: "single-answer"
    marks: 2
    explanation: "Tools are callable functions that accept arguments and return a response. Resources are addressable by URI and represent read-only state that the agent fetches on demand - such as cluster state from MeshSync."
    options:
      - id: "a"
        text: "Tools are read-only; resources can mutate state"
        isCorrect: false
      - id: "b"
        text: "Tools are callable functions invoked with arguments; resources are URI-addressable read-only content the agent fetches"
        isCorrect: true
      - id: "c"
        text: "Tools require authentication; resources are publicly accessible"
        isCorrect: false
      - id: "d"
        text: "There is no functional difference; both are invoked by the agent with parameters"
        isCorrect: false
  - id: "q3"
    text: "Which Meshery component continuously syncs Kubernetes cluster resource metadata into Meshery's data store, making it available to MCP resource handlers?"
    type: "single-answer"
    marks: 2
    explanation: "MeshSync is the Meshery Operator component that observes cluster state and syncs it into Meshery. MCP resource handlers query Meshery's /api/v1/meshsync/resources endpoint to retrieve this data."
    options:
      - id: "a"
        text: "Meshery Adapter"
        isCorrect: false
      - id: "b"
        text: "Kanvas"
        isCorrect: false
      - id: "c"
        text: "MeshSync"
        isCorrect: true
      - id: "d"
        text: "Meshery Catalog"
        isCorrect: false
  - id: "q4"
    text: "When a tool's backing API returns HTTP 404, what should the MCP server return to the agent?"
    type: "single-answer"
    marks: 2
    explanation: "Returning a structured error with a machine-readable error code and a human-readable message lets the agent decide whether to retry, escalate to the user, or take an alternative action - rather than treating the raw HTTP error as valid output."
    options:
      - id: "a"
        text: "An empty JSON object {}"
        isCorrect: false
      - id: "b"
        text: "The raw HTTP 404 response body from Meshery"
        isCorrect: false
      - id: "c"
        text: "A structured error with an error code and a descriptive message"
        isCorrect: true
      - id: "d"
        text: "Null, so the agent knows there is no result"
        isCorrect: false
---
