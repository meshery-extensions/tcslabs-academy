---
title: "CAINA Capstone - Exam"
passPercentage: 70
timeLimit: 30
type: "test"
questions:
  - id: "q1"
    text: "What is Meshery, in one phrase?"
    type: "single-answer"
    marks: 2
    explanation: "Meshery is the open-source cloud native manager - a 'manager of managers' for designing and operating Kubernetes and cloud native infrastructure."
    options:
      - id: "a"
        text: "A hosted large language model service"
        isCorrect: false
      - id: "b"
        text: "An open-source cloud native manager for designing and operating infrastructure across clusters"
        isCorrect: true
      - id: "c"
        text: "A container runtime that replaces containerd"
        isCorrect: false
      - id: "d"
        text: "A CI system for building container images"
        isCorrect: false
  - id: "q2"
    text: "Which mesheryctl command imports a Kubernetes manifest as a design?"
    type: "short-answer"
    marks: 2
    correctAnswer: "mesheryctl design import"
    case_sensitive: false
    explanation: "`mesheryctl design import -f <file> -s \"Kubernetes Manifest\"` imports a manifest as a Meshery design."
  - id: "q3"
    text: "When an LLM generates a design, who is accountable for what gets deployed?"
    type: "single-answer"
    marks: 2
    explanation: "AI is an assistant. The engineer reviewing and approving the change remains accountable - human-in-the-loop is the core discipline."
    options:
      - id: "a"
        text: "The model vendor"
        isCorrect: false
      - id: "b"
        text: "No one, because it was automated"
        isCorrect: false
      - id: "c"
        text: "The engineer who reviews and approves the change"
        isCorrect: true
      - id: "d"
        text: "Meshery"
        isCorrect: false
  - id: "q4"
    text: "Select the checks you should make on an AI-generated Deployment before deploying. (Select all that apply.)"
    type: "multiple-answers"
    marks: 3
    explanation: "Resource requests/limits, label/selector correctness, and readiness probes are all part of a basic review. The model's confidence is not a verifiable signal."
    options:
      - id: "a"
        text: "Every container declares resource requests and limits"
        isCorrect: true
      - id: "b"
        text: "Service selectors match the Deployment's pod labels"
        isCorrect: true
      - id: "c"
        text: "Readiness/health probes are present where appropriate"
        isCorrect: true
      - id: "d"
        text: "The model said it was 95% confident"
        isCorrect: false
  - id: "q5"
    text: "In Kanvas, what does relationship and policy validation help you catch?"
    type: "single-answer"
    marks: 2
    explanation: "Validation surfaces misconfigurations - for example a Service whose selector matches no pods, or a missing required relationship - before you deploy."
    options:
      - id: "a"
        text: "Spelling mistakes in lesson content"
        isCorrect: false
      - id: "b"
        text: "Misconfigurations such as a Service selector that matches no pods"
        isCorrect: true
      - id: "c"
        text: "The cost of the model API call"
        isCorrect: false
      - id: "d"
        text: "Git merge conflicts"
        isCorrect: false
  - id: "q6"
    text: "Why is asking an LLM for 'only YAML, no commentary' useful when generating designs?"
    type: "single-answer"
    marks: 2
    explanation: "Constraining the output format yields a clean, directly usable artifact and reduces parsing/transcription errors."
    options:
      - id: "a"
        text: "It makes the model run faster"
        isCorrect: false
      - id: "b"
        text: "It produces a clean, directly usable artifact and avoids parsing errors"
        isCorrect: true
      - id: "c"
        text: "It guarantees the YAML is correct"
        isCorrect: false
      - id: "d"
        text: "It disables hallucinations"
        isCorrect: false
  - id: "q7"
    text: "A coding agent proposes applying changes directly to production. What is the safest next step?"
    type: "single-answer"
    marks: 2
    explanation: "Ask for a dry-run/diff and review it before any apply - preview the blast radius and keep a human in the loop."
    options:
      - id: "a"
        text: "Let it apply immediately to save time"
        isCorrect: false
      - id: "b"
        text: "Ask for a dry-run/diff and review it before applying"
        isCorrect: true
      - id: "c"
        text: "Delete the namespace first"
        isCorrect: false
      - id: "d"
        text: "Disable Meshery validation"
        isCorrect: false
  - id: "q8"
    text: "Which Meshery component provides real-time discovery and state sync of cluster resources?"
    type: "single-answer"
    marks: 2
    explanation: "MeshSync discovers and continuously syncs the state of resources in connected clusters."
    options:
      - id: "a"
        text: "MeshSync"
        isCorrect: true
      - id: "b"
        text: "Grafana"
        isCorrect: false
      - id: "c"
        text: "etcd"
        isCorrect: false
      - id: "d"
        text: "kubelet"
        isCorrect: false
  - id: "q9"
    text: "In a Deployment, how does a container request a GPU on a GPU node pool?"
    type: "short-answer"
    marks: 2
    correctAnswer: "nvidia.com/gpu"
    case_sensitive: false
    explanation: "A container requests a GPU via `resources.limits: nvidia.com/gpu: 1` (the nvidia.com/gpu extended resource)."
  - id: "q10"
    text: "True or false: a default-deny NetworkPolicy plus an allow-same-namespace rule restricts ingress to traffic from pods in the same namespace."
    type: "short-answer"
    marks: 2
    correctAnswer: "true"
    case_sensitive: false
    explanation: "Default-deny blocks all ingress; the companion rule then re-allows only same-namespace pod traffic."
---
