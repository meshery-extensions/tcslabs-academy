---
title: "Course Test"
passPercentage: 70
type: "test"
questions:
  - id: "q1"
    text: "Which command verifies that all Meshery system components - including Meshery Operator and MeshSync - are running before an agent workflow begins?"
    type: "single-answer"
    marks: 2
    explanation: "mesheryctl system check reports the health of all Meshery system components. Running it before an agent workflow ensures MeshSync is active and state reads will reflect live cluster data."
    options:
      - id: "a"
        text: "mesheryctl system start"
        isCorrect: false
      - id: "b"
        text: "mesheryctl system check"
        isCorrect: true
      - id: "c"
        text: "mesheryctl design list"
        isCorrect: false
      - id: "d"
        text: "kubectl get pods -n meshery"
        isCorrect: false
  - id: "q2"
    text: "An agent needs to retrieve design IDs, their associated environments, and relevant registry components in a single network call. Which Meshery API should it use?"
    type: "single-answer"
    marks: 2
    explanation: "GraphQL allows the caller to join data across related entities and select only the fields needed in one request. The REST API would require multiple separate calls for the same data."
    options:
      - id: "a"
        text: "REST GET /api/pattern followed by GET /api/environments"
        isCorrect: false
      - id: "b"
        text: "GraphQL POST /api/graphql/query with a multi-entity query"
        isCorrect: true
      - id: "c"
        text: "mesheryctl design list --all"
        isCorrect: false
      - id: "d"
        text: "MCP tool list_designs called three times in parallel"
        isCorrect: false
  - id: "q3"
    text: "What flag specifies the source type when importing a design with mesheryctl?"
    type: "short-answer"
    marks: 2
    correctAnswer: "-s"
    case_sensitive: false
    explanation: "The -s flag specifies the source type for the imported design file. For Kubernetes manifests the value is 'Kubernetes Manifest', as in: mesheryctl design import -f <file> -s \"Kubernetes Manifest\"."
  - id: "q4"
    text: "In the agent connection model, which of the following statements are true? (Select all that apply)"
    type: "multiple-answers"
    marks: 2
    explanation: "The MCP server and mesheryctl both communicate with the same Meshery server backend and share the same authentication token from auth.json. MCP is best for structured reads; mesheryctl is best for writes. Neither is exclusive - well-designed workflows use both."
    options:
      - id: "a"
        text: "The MCP server and mesheryctl share the same Meshery server backend"
        isCorrect: true
      - id: "b"
        text: "Authentication tokens are read from ~/.meshery/auth.json by both surfaces"
        isCorrect: true
      - id: "c"
        text: "The MCP server is the only way to trigger a design deploy"
        isCorrect: false
      - id: "d"
        text: "mesheryctl cannot be used alongside the MCP server in the same workflow"
        isCorrect: false
  - id: "q5"
    text: "An agent has proposed a change to the observability-stack design and the human operator has approved it in Kanvas. What is the correct next mesheryctl command to execute the deploy?"
    type: "single-answer"
    marks: 2
    explanation: "mesheryctl design deploy -f <file> deploys a previously imported design to the target environment. The import step (mesheryctl design import) was already done before the operator review; deploy is the next state-changing action."
    options:
      - id: "a"
        text: "mesheryctl design import -f updated-observability-stack.yaml -s \"Kubernetes Manifest\""
        isCorrect: false
      - id: "b"
        text: "mesheryctl design apply -f updated-observability-stack.yaml"
        isCorrect: false
      - id: "c"
        text: "mesheryctl design deploy -f updated-observability-stack.yaml"
        isCorrect: true
      - id: "d"
        text: "mesheryctl system deploy --design updated-observability-stack.yaml"
        isCorrect: false
  - id: "q6"
    text: "Which of the following best describes the role of MeshSync in an agent-driven Meshery workflow?"
    type: "single-answer"
    marks: 2
    explanation: "MeshSync continuously reconciles and reports the live state of Kubernetes resources into Meshery. If MeshSync is not running, the state an agent reads via MCP tools or the REST API will be stale, leading to incorrect decisions. This is why mesheryctl system check must confirm MeshSync is healthy before any agent workflow begins."
    options:
      - id: "a"
        text: "MeshSync provides the MCP server's tool definitions to the agent"
        isCorrect: false
      - id: "b"
        text: "MeshSync continuously reports live Kubernetes resource state into Meshery, making it accurate for agent reads"
        isCorrect: true
      - id: "c"
        text: "MeshSync authenticates the agent's token against the Meshery API"
        isCorrect: false
      - id: "d"
        text: "MeshSync deploys designs to Kubernetes on behalf of mesheryctl"
        isCorrect: false
---
