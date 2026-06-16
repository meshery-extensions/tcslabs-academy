---
title: "Course Test"
passPercentage: 70
type: "test"
questions:
  - id: "q1"
    text: "Meshery is best described as which of the following?"
    type: "single-answer"
    marks: 2
    explanation: "Meshery is the open-source cloud native manager - sometimes called a 'manager of managers' - that provides visibility, lifecycle management, configuration, performance benchmarking, and governance across multiple clusters and service meshes from a single control plane."
    options:
      - id: "a"
        text: "A replacement for kubectl that manages a single cluster"
        isCorrect: false
      - id: "b"
        text: "An open-source cloud native manager that operates across multiple clusters and service meshes"
        isCorrect: true
      - id: "c"
        text: "A service mesh that handles traffic routing between microservices"
        isCorrect: false
      - id: "d"
        text: "A CI/CD pipeline tool for Kubernetes deployments"
        isCorrect: false

  - id: "q2"
    text: "Which components run inside each managed cluster as part of the Meshery architecture? Select all that apply."
    type: "multiple-answers"
    marks: 2
    explanation: "The Meshery Operator, MeshSync, and the NATS Broker all run inside each managed cluster. The Meshery Server runs in the control plane, not in the managed clusters."
    options:
      - id: "a"
        text: "Meshery Operator"
        isCorrect: true
      - id: "b"
        text: "MeshSync"
        isCorrect: true
      - id: "c"
        text: "Broker (NATS)"
        isCorrect: true
      - id: "d"
        text: "Meshery Server"
        isCorrect: false

  - id: "q3"
    text: "What is the correct command to start Meshery on your local machine using the default Docker-based deployment?"
    type: "single-answer"
    marks: 2
    explanation: "`mesheryctl system start` bootstraps the Meshery Server using Docker Compose by default. Adding `--platform kubernetes` deploys it into the current kubeconfig context instead."
    options:
      - id: "a"
        text: "mesheryctl start"
        isCorrect: false
      - id: "b"
        text: "mesheryctl system start"
        isCorrect: true
      - id: "c"
        text: "mesheryctl deploy --local"
        isCorrect: false
      - id: "d"
        text: "mesheryctl server up"
        isCorrect: false

  - id: "q4"
    text: "What command would you use to import the academy's microservices demo design into Meshery?"
    type: "single-answer"
    marks: 2
    explanation: "`mesheryctl design import -f <file> -s \"Kubernetes Manifest\"` imports a YAML manifest as a Meshery design. The `-s` flag specifies the source type."
    options:
      - id: "a"
        text: "mesheryctl design load designs/microservices-demo.yaml"
        isCorrect: false
      - id: "b"
        text: "mesheryctl apply -f designs/microservices-demo.yaml"
        isCorrect: false
      - id: "c"
        text: "mesheryctl design import -f designs/microservices-demo.yaml -s \"Kubernetes Manifest\""
        isCorrect: true
      - id: "d"
        text: "kubectl apply -f designs/microservices-demo.yaml"
        isCorrect: false

  - id: "q5"
    text: "In the Meshery registry, what is the role of a Model?"
    type: "single-answer"
    marks: 2
    explanation: "A Model is the top-level grouping in the Meshery registry. It represents a technology domain - such as Kubernetes core, Istio, or Prometheus - and packages together all of the components and relationships that belong to that technology."
    options:
      - id: "a"
        text: "A single manageable resource, equivalent to a Kubernetes resource kind"
        isCorrect: false
      - id: "b"
        text: "A declared, typed connection between two components"
        isCorrect: false
      - id: "c"
        text: "A top-level grouping for a technology domain, containing its components and relationships"
        isCorrect: true
      - id: "d"
        text: "A versioned snapshot of a deployed cluster state"
        isCorrect: false

  - id: "q6"
    text: "How does the Kanvas Operator view differ from the Kanvas Designer view?"
    type: "single-answer"
    marks: 2
    explanation: "The Operator view shows the live current state of resources in connected clusters as discovered by MeshSync. The Designer view shows desired state - it is where you author, validate, and prepare designs for deployment."
    options:
      - id: "a"
        text: "The Operator view is for authoring designs; the Designer view is for reading live cluster state"
        isCorrect: false
      - id: "b"
        text: "The Operator view shows live current state from MeshSync; the Designer view represents desired state for authoring designs"
        isCorrect: true
      - id: "c"
        text: "They are identical views with different color themes"
        isCorrect: false
      - id: "d"
        text: "The Operator view requires cluster-admin access; the Designer view does not"
        isCorrect: false
---
