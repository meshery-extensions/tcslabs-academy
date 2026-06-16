---
title: "Module Quiz"
passPercentage: 70
type: "test"
questions:
  - id: "q1"
    text: "Why is an LLM's training data insufficient for answering questions about your Kubernetes cluster without retrieval?"
    type: "multiple-answers"
    marks: 2
    explanation: "LLM training data has a cutoff date and reflects generic public knowledge, not your specific cluster configuration, naming conventions, or internal runbooks. Both staleness and specificity are structural problems that retrieval addresses."
    options:
      - id: "a"
        text: "Training data has a cutoff date and does not reflect current cluster state"
        isCorrect: true
      - id: "b"
        text: "Training data is generic and does not include organization-specific configurations"
        isCorrect: true
      - id: "c"
        text: "LLMs cannot process YAML or JSON output from kubectl"
        isCorrect: false
      - id: "d"
        text: "Larger context windows eliminate the need for retrieval entirely"
        isCorrect: false

  - id: "q2"
    text: "Which MeshSync component continuously observes cluster state and synchronizes it into Meshery's database?"
    type: "single-answer"
    marks: 2
    explanation: "MeshSync is the Meshery Operator component that watches Kubernetes resources and keeps Meshery's view of the cluster current. It runs inside the cluster and updates continuously."
    options:
      - id: "a"
        text: "mesheryctl"
        isCorrect: false
      - id: "b"
        text: "Kanvas"
        isCorrect: false
      - id: "c"
        text: "MeshSync"
        isCorrect: true
      - id: "d"
        text: "The Meshery registry"
        isCorrect: false

  - id: "q3"
    text: "What is the correct command to import the observability stack design into Meshery?"
    type: "single-answer"
    marks: 2
    explanation: "mesheryctl design import requires the -f flag for the file path and the -s flag for the source type. 'Kubernetes Manifest' is the correct source type for YAML design files."
    options:
      - id: "a"
        text: "mesheryctl design apply -f designs/observability-stack.yaml"
        isCorrect: false
      - id: "b"
        text: "mesheryctl design import -f designs/observability-stack.yaml -s \"Kubernetes Manifest\""
        isCorrect: true
      - id: "c"
        text: "kubectl apply -f designs/observability-stack.yaml"
        isCorrect: false
      - id: "d"
        text: "mesheryctl system import designs/observability-stack.yaml"
        isCorrect: false

  - id: "q4"
    text: "In the context of a RAG knowledge base for operations, what metadata field is most important for preventing an agent from acting on an outdated runbook?"
    type: "short-answer"
    marks: 2
    correctAnswer: "last_indexed"
    case_sensitive: false
    explanation: "Attaching a last_indexed timestamp to each chunk allows the agent to surface the age of retrieved content. An agent that sees the timestamp can flag stale content rather than acting on it blindly."
---
