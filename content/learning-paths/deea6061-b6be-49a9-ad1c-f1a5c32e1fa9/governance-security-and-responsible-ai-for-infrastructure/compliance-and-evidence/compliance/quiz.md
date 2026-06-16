---
title: "Module Quiz"
passPercentage: 70
type: "test"
questions:
  - id: "q1"
    text: "Which Meshery component continuously observes cluster state and reports it back to the Meshery control plane for drift detection?"
    type: "single-answer"
    marks: 2
    explanation: "MeshSync is the in-cluster Kubernetes operator that watches all resources and reports observed state to Meshery, enabling drift detection between intended and actual state."
    options:
      - id: "a"
        text: "Meshery Operator"
        isCorrect: false
      - id: "b"
        text: "MeshSync"
        isCorrect: true
      - id: "c"
        text: "Kanvas"
        isCorrect: false
      - id: "d"
        text: "The Meshery registry"
        isCorrect: false

  - id: "q2"
    text: "When a coding agent applies an infrastructure change through the Meshery MCP server, which of the following statements is true?"
    type: "single-answer"
    marks: 2
    explanation: "The Meshery MCP server routes every agent action through the same policy evaluation and logging pipeline that applies to human operators. The platform - not the agent - is the trust boundary."
    options:
      - id: "a"
        text: "The agent bypasses OPA policy evaluation because it operates programmatically"
        isCorrect: false
      - id: "b"
        text: "The change is applied directly to the cluster without a deploy record"
        isCorrect: false
      - id: "c"
        text: "The agent's action goes through the same policy evaluation and logging as a human operator"
        isCorrect: true
      - id: "d"
        text: "MeshSync is disabled for agent-initiated changes to reduce latency"
        isCorrect: false

  - id: "q3"
    text: "Which of the following are valid sources of compliance evidence in a Meshery-based IDP? Select all that apply."
    type: "multiple-answers"
    marks: 2
    explanation: "Git commit history provides the authorization chain, Meshery validation results record that each design passed policy, and MeshSync observation snapshots confirm the post-deploy cluster state. Together they form an unbroken evidence chain."
    options:
      - id: "a"
        text: "Git commit history with pull request approvals"
        isCorrect: true
      - id: "b"
        text: "Meshery design validation results"
        isCorrect: true
      - id: "c"
        text: "MeshSync observation snapshots"
        isCorrect: true
      - id: "d"
        text: "Agent reasoning traces stored only in the agent's context window"
        isCorrect: false

  - id: "q4"
    text: "What does an 'unmanaged resource' finding from MeshSync indicate?"
    type: "single-answer"
    marks: 2
    explanation: "An unmanaged resource is a cluster resource that exists in the cluster but is not part of any Meshery design. It indicates a change was made outside the Meshery-managed change path - bypassing policy evaluation and leaving no evidence chain."
    options:
      - id: "a"
        text: "A Meshery design that failed policy validation"
        isCorrect: false
      - id: "b"
        text: "A resource whose configuration differs from the applied design"
        isCorrect: false
      - id: "c"
        text: "A cluster resource that exists but is not part of any Meshery design, indicating an out-of-band change"
        isCorrect: true
      - id: "d"
        text: "A design imported in the wrong format"
        isCorrect: false
---
