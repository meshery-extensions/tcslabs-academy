---
title: "Module Quiz"
passPercentage: 70
type: "test"
questions:
  - id: "q1"
    text: "Which Meshery component runs inside each managed Kubernetes cluster and publishes resource-change events to the Broker?"
    type: "single-answer"
    marks: 2
    explanation: "MeshSync runs as a pod inside each managed cluster. It watches the Kubernetes API server and publishes structured discovery events to the NATS Broker, which the Meshery Server subscribes to."
    options:
      - id: "a"
        text: "Meshery Server"
        isCorrect: false
      - id: "b"
        text: "MeshSync"
        isCorrect: true
      - id: "c"
        text: "Kanvas"
        isCorrect: false
      - id: "d"
        text: "mesheryctl"
        isCorrect: false

  - id: "q2"
    text: "What command verifies that Meshery Server, the Operator, and MeshSync are all healthy after installation?"
    type: "single-answer"
    marks: 2
    explanation: "`mesheryctl system check` runs a pre-flight inspection that confirms Meshery Server is reachable, and that the Operator and MeshSync are running in each connected cluster."
    options:
      - id: "a"
        text: "mesheryctl system start"
        isCorrect: false
      - id: "b"
        text: "mesheryctl system status"
        isCorrect: false
      - id: "c"
        text: "mesheryctl system check"
        isCorrect: true
      - id: "d"
        text: "mesheryctl registry list"
        isCorrect: false

  - id: "q3"
    text: "In the Meshery registry, which concept represents a declared, typed connection between two components - such as a Service selecting Pods via a label selector?"
    type: "single-answer"
    marks: 2
    explanation: "Relationships are declared, typed connections between components in the Meshery registry. They power design-time validation by checking that connections between components are semantically correct, not just syntactically valid."
    options:
      - id: "a"
        text: "Model"
        isCorrect: false
      - id: "b"
        text: "Component"
        isCorrect: false
      - id: "c"
        text: "Relationship"
        isCorrect: true
      - id: "d"
        text: "Adapter"
        isCorrect: false

  - id: "q4"
    text: "Which two Kanvas views exist, and what does each represent?"
    type: "multiple-answers"
    marks: 2
    explanation: "The Designer view represents desired state - it is where you author and validate designs before deploying them. The Operator view represents current state - it shows the live topology of resources as discovered by MeshSync."
    options:
      - id: "a"
        text: "Designer - represents desired state for authoring and validating designs"
        isCorrect: true
      - id: "b"
        text: "Operator - represents current state, showing live topology from MeshSync"
        isCorrect: true
      - id: "c"
        text: "Auditor - represents historical state for compliance reporting"
        isCorrect: false
      - id: "d"
        text: "Monitor - represents metrics state from Prometheus"
        isCorrect: false
---
