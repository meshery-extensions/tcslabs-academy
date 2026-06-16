---
title: "Course Test"
passPercentage: 70
type: "test"
questions:
  - id: "q1"
    text: "Which two properties of an MCP tool definition are most important for the agent to correctly decide when to invoke it?"
    type: "multiple-answers"
    marks: 2
    explanation: "The tool name and description are the only information the agent sees when deciding which tool to call. The name must be unambiguous and the description must clearly state what the tool does and when to use it. Input schema constrains parameters but does not help the agent choose which tool to invoke."
    options:
      - id: "a"
        text: "Tool name"
        isCorrect: true
      - id: "b"
        text: "Tool description"
        isCorrect: true
      - id: "c"
        text: "The HTTP method of the backing API endpoint"
        isCorrect: false
      - id: "d"
        text: "The MIME type of the response"
        isCorrect: false
  - id: "q2"
    text: "Why should read-only MCP tools be implemented before write tools when building a Meshery MCP server?"
    type: "single-answer"
    marks: 2
    explanation: "Read-only tools carry no risk of unintended side effects. They allow end-to-end testing of the agent integration - authentication, API mapping, output shaping - without the risk of mutating cluster or Meshery state during the testing phase."
    options:
      - id: "a"
        text: "Read-only tools have higher performance than write tools"
        isCorrect: false
      - id: "b"
        text: "They allow full agent integration testing without the risk of unintended state mutations"
        isCorrect: true
      - id: "c"
        text: "The MCP specification requires read tools to be registered before write tools"
        isCorrect: false
      - id: "d"
        text: "Meshery's API does not expose write endpoints over MCP"
        isCorrect: false
  - id: "q3"
    text: "What command would you run to verify that a Meshery instance is reachable and healthy before testing MCP tool calls against it?"
    type: "single-answer"
    marks: 2
    explanation: "mesheryctl system check performs a health check of the local Meshery instance, confirming that the server is running, the API is reachable, and connected components like Meshery Operator are healthy."
    options:
      - id: "a"
        text: "mesheryctl system start"
        isCorrect: false
      - id: "b"
        text: "mesheryctl system check"
        isCorrect: true
      - id: "c"
        text: "mesheryctl perf apply"
        isCorrect: false
      - id: "d"
        text: "mesheryctl design import -f designs/observability-stack.yaml -s \"Kubernetes Manifest\""
        isCorrect: false
  - id: "q4"
    text: "Which URI scheme is used to address Meshery MCP resources for cluster state observed by MeshSync?"
    type: "short-answer"
    marks: 2
    explanation: "The recommended URI scheme is meshery://cluster/<context>/<namespace>/<kind>/<name>, for example meshery://cluster/local/prod/Deployment/frontend. This scheme makes the resource's location in the cluster hierarchy explicit and parseable by the MCP server."
    correctAnswer: "meshery://cluster"
    case_sensitive: false
  - id: "q5"
    text: "An agent calls list_designs and receives output containing full YAML content for every design in the page, causing a context window overflow. What is the correct fix?"
    type: "single-answer"
    marks: 2
    explanation: "List responses should return only the minimal identifying fields - id, name, updatedAt - so the agent can select a specific design. Full content should only be returned by a separate get_design tool when the agent explicitly requests it. This keeps list responses small regardless of the number or size of designs."
    options:
      - id: "a"
        text: "Reduce pageSize to 1 so only one design is returned at a time"
        isCorrect: false
      - id: "b"
        text: "Return only minimal fields (id, name, updatedAt) in list responses and expose full content through a separate get_design tool"
        isCorrect: true
      - id: "c"
        text: "Compress the YAML content before returning it"
        isCorrect: false
      - id: "d"
        text: "Switch from the REST API to the GraphQL API for list queries"
        isCorrect: false
  - id: "q6"
    text: "Which of the following actions should be completed before connecting an agent to your MCP server for the first time? Select all that apply."
    type: "multiple-answers"
    marks: 2
    explanation: "Schema validation confirms the tool definitions are spec-compliant; direct tool invocation verifies each tool returns the correct shape for valid and invalid inputs; and the smoke test checklist confirms Meshery is reachable and all tools produce expected output. These three layers of verification prevent an agent from encountering a partially broken server."
    options:
      - id: "a"
        text: "Validate all tool schemas in the MCP Inspector"
        isCorrect: true
      - id: "b"
        text: "Invoke each tool directly and verify output shapes and error handling"
        isCorrect: true
      - id: "c"
        text: "Deploy the MCP server to a production Kubernetes cluster"
        isCorrect: false
      - id: "d"
        text: "Run the smoke test checklist confirming Meshery is healthy and tools return valid responses"
        isCorrect: true
---
