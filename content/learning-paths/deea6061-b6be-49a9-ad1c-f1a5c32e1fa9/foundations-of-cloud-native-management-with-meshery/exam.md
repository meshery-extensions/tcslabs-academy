---
title: "Learning Path Exam"
passPercentage: 70
timeLimit: 30
type: "test"
questions:
  - id: "q1"
    text: "Which statement best describes 'cloud native'?"
    type: "single-answer"
    marks: 2
    explanation: "Cloud native is an approach to building and running scalable applications using containers, orchestration, and dynamic management - not a single product."
    options:
      - id: "a"
        text: "A specific product you buy from one vendor"
        isCorrect: false
      - id: "b"
        text: "Building and running scalable apps with containers, orchestration, and dynamic management"
        isCorrect: true
      - id: "c"
        text: "Running virtual machines in a public cloud"
        isCorrect: false
      - id: "d"
        text: "A programming language for the cloud"
        isCorrect: false
  - id: "q2"
    text: "What makes a container image well-suited to reliable, repeatable deployments?"
    type: "single-answer"
    marks: 2
    explanation: "Images are immutable and self-contained, so the same artifact runs the same way across environments."
    options:
      - id: "a"
        text: "It is mutable and changes at runtime"
        isCorrect: false
      - id: "b"
        text: "It is immutable and self-contained"
        isCorrect: true
      - id: "c"
        text: "It always runs as root"
        isCorrect: false
      - id: "d"
        text: "It requires a hypervisor"
        isCorrect: false
  - id: "q3"
    text: "Which are core Kubernetes objects? (Select all that apply.)"
    type: "multiple-answers"
    marks: 3
    explanation: "Pods, Deployments, Services, and Namespaces are core objects. A 'Dockerfile' is not a Kubernetes object."
    options:
      - id: "a"
        text: "Pod"
        isCorrect: true
      - id: "b"
        text: "Deployment"
        isCorrect: true
      - id: "c"
        text: "Service"
        isCorrect: true
      - id: "d"
        text: "Dockerfile"
        isCorrect: false
  - id: "q4"
    text: "Why does a declarative, version-controlled model suit LLM/agent automation?"
    type: "single-answer"
    marks: 2
    explanation: "Declared desired state can be diffed, reviewed, and reverted - giving agents a reviewable artifact and a safe rollback path."
    options:
      - id: "a"
        text: "It hides changes from reviewers"
        isCorrect: false
      - id: "b"
        text: "Desired state can be diffed, reviewed, and reverted"
        isCorrect: true
      - id: "c"
        text: "It removes the need for any human review"
        isCorrect: false
      - id: "d"
        text: "It only works without Git"
        isCorrect: false
  - id: "q5"
    text: "In one phrase, what is Meshery?"
    type: "single-answer"
    marks: 2
    explanation: "Meshery is the open-source cloud native manager for designing and operating infrastructure across clusters."
    options:
      - id: "a"
        text: "A hosted LLM API"
        isCorrect: false
      - id: "b"
        text: "The open-source cloud native manager"
        isCorrect: true
      - id: "c"
        text: "A container registry"
        isCorrect: false
      - id: "d"
        text: "A Linux distribution"
        isCorrect: false
  - id: "q6"
    text: "Which Meshery component provides real-time discovery and state sync of cluster resources?"
    type: "short-answer"
    marks: 2
    correctAnswer: "MeshSync"
    case_sensitive: false
    explanation: "MeshSync discovers and continuously syncs the state of resources in connected clusters."
  - id: "q7"
    text: "Which command imports a Kubernetes manifest as a Meshery design?"
    type: "single-answer"
    marks: 2
    explanation: "mesheryctl design import -f <file> -s \"Kubernetes Manifest\" imports a manifest as a design."
    options:
      - id: "a"
        text: "mesheryctl design import -f <file> -s \"Kubernetes Manifest\""
        isCorrect: true
      - id: "b"
        text: "kubectl meshery apply <file>"
        isCorrect: false
      - id: "c"
        text: "mesheryctl apply design <file>"
        isCorrect: false
      - id: "d"
        text: "helm install meshery <file>"
        isCorrect: false
  - id: "q8"
    text: "What does the Meshery registry's relationships layer enable?"
    type: "single-answer"
    marks: 2
    explanation: "Relationships capture how components relate, enabling validation that catches semantic misconfigurations a plain schema check would miss."
    options:
      - id: "a"
        text: "Faster container image builds"
        isCorrect: false
      - id: "b"
        text: "Validation of how components relate, catching misconfigurations"
        isCorrect: true
      - id: "c"
        text: "Automatic GPU scheduling"
        isCorrect: false
      - id: "d"
        text: "Encryption of secrets at rest"
        isCorrect: false
  - id: "q9"
    text: "Why store Meshery designs in Git (designs as code)?"
    type: "multiple-answers"
    marks: 3
    explanation: "Versioning, review via pull requests, and easy rollback are all benefits. Git does not make designs deploy without a target cluster."
    options:
      - id: "a"
        text: "Version history and auditability"
        isCorrect: true
      - id: "b"
        text: "Review changes via pull requests"
        isCorrect: true
      - id: "c"
        text: "Roll back to a previous version"
        isCorrect: true
      - id: "d"
        text: "It deploys designs without any cluster"
        isCorrect: false
  - id: "q10"
    text: "What is the Meshery Catalog used for?"
    type: "single-answer"
    marks: 2
    explanation: "The Catalog stores and shares reusable designs as templates."
    options:
      - id: "a"
        text: "Storing and sharing reusable designs as templates"
        isCorrect: true
      - id: "b"
        text: "Hosting container images"
        isCorrect: false
      - id: "c"
        text: "Running CI pipelines"
        isCorrect: false
      - id: "d"
        text: "Managing DNS records"
        isCorrect: false
---
