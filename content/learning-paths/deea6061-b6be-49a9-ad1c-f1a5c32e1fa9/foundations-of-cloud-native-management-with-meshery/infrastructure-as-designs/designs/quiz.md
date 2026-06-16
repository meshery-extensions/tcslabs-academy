---
title: "Module Quiz"
passPercentage: 70
type: "test"
questions:
  - id: "q1"
    text: "Which command imports a local Kubernetes manifest file into Meshery as a design?"
    type: "single-answer"
    marks: 2
    explanation: "The correct command is `mesheryctl design import -f <file> -s \"Kubernetes Manifest\"`. The `-f` flag specifies the file path and `-s` specifies the source schema to use when parsing the file."
    options:
      - id: "a"
        text: "mesheryctl design load -f designs/microservices-demo.yaml"
        isCorrect: false
      - id: "b"
        text: "mesheryctl design import -f designs/microservices-demo.yaml -s \"Kubernetes Manifest\""
        isCorrect: true
      - id: "c"
        text: "mesheryctl design apply -f designs/microservices-demo.yaml"
        isCorrect: false
      - id: "d"
        text: "mesheryctl design push designs/microservices-demo.yaml"
        isCorrect: false

  - id: "q2"
    text: "What does the Meshery Catalog provide that a raw YAML file in a Git repository does not?"
    type: "multiple-answers"
    marks: 2
    explanation: "The Catalog wraps designs in named, versioned, documented artifacts with tags, compatibility metadata, and a visual Kanvas preview. Raw YAML files have none of those discovery and documentation features built in."
    options:
      - id: "a"
        text: "A visual topology preview rendered by Kanvas"
        isCorrect: true
      - id: "b"
        text: "Searchable metadata including tags and compatibility information"
        isCorrect: true
      - id: "c"
        text: "The ability to version infrastructure changes over time"
        isCorrect: false
      - id: "d"
        text: "A named, documented artifact that can be cloned as a template"
        isCorrect: true

  - id: "q3"
    text: "In the Meshery organizational model, what is a workspace?"
    type: "single-answer"
    marks: 2
    explanation: "A workspace is a collaborative container that groups environments, designs, and team members and is the unit of access control in Meshery. Environments are deployment targets; clusters are infrastructure; namespaces are a Kubernetes concept."
    options:
      - id: "a"
        text: "A named group of Kubernetes namespaces"
        isCorrect: false
      - id: "b"
        text: "A collaborative container that groups environments, designs, and team members and is the unit of access control"
        isCorrect: true
      - id: "c"
        text: "A deployment target backed by one or more cluster connections"
        isCorrect: false
      - id: "d"
        text: "A cluster-level resource created by the Meshery Operator"
        isCorrect: false

  - id: "q4"
    text: "Why does backing Meshery designs with a GitHub repository matter specifically for agent-generated infrastructure changes?"
    type: "short-answer"
    marks: 2
    correctAnswer: "version control"
    case_sensitive: false
    explanation: "Version control provides the three essential guardrails for agent-generated changes: auditability (every change is a commit), reviewability (pull requests expose changes for human approval), and reversibility (git history makes rollback deterministic). Without version control, agent changes are invisible and irreversible."
---
