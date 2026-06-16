---
title: "Module Quiz"
passPercentage: 70
type: "test"
questions:
  - id: "q1"
    text: "Which four categories of information should you always provide in an infrastructure brief before asking an LLM to design a topology?"
    type: "multiple-answers"
    marks: 2
    explanation: "A brief needs workloads, data, networking, and non-functionals. Without all four, the LLM fills gaps with assumptions that often do not match production requirements."
    options:
      - id: "a"
        text: "Workloads and their roles"
        isCorrect: true
      - id: "b"
        text: "Container image tags and registries"
        isCorrect: false
      - id: "c"
        text: "Data and persistence requirements"
        isCorrect: true
      - id: "d"
        text: "Networking exposure and isolation rules"
        isCorrect: true
      - id: "e"
        text: "Non-functional requirements (scale, security, observability)"
        isCorrect: true

  - id: "q2"
    text: "In the human+AI co-design loop, what is the primary purpose of the Kanvas visual checkpoint?"
    type: "single-answer"
    marks: 2
    explanation: "Kanvas renders the full topology visually, making missing components, broken relationships, and structural problems visible in a way that a text diff of YAML files does not."
    options:
      - id: "a"
        text: "To automatically apply the design to the cluster without further review"
        isCorrect: false
      - id: "b"
        text: "To render the full topology so a human can inspect, correct, and approve before the design proceeds"
        isCorrect: true
      - id: "c"
        text: "To replace the infrastructure brief with a visual equivalent"
        isCorrect: false
      - id: "d"
        text: "To generate YAML from a diagram drawn by the user"
        isCorrect: false

  - id: "q3"
    text: "What command imports an existing design file into Meshery using the Kubernetes Manifest source?"
    type: "short-answer"
    marks: 2
    correctAnswer: "mesheryctl design import -f <file> -s \"Kubernetes Manifest\""
    case_sensitive: false
    explanation: "The mesheryctl design import command with the -f flag for the file path and -s flag for the source type is the correct way to load a design into Meshery."

  - id: "q4"
    text: "When reviewing an AI-proposed design, which of the following are security red flags you should check explicitly?"
    type: "multiple-answers"
    marks: 2
    explanation: "Security review must check for root containers, privileged settings, hostPath mounts, and hardcoded secrets. These are the most common permissive defaults in AI-generated designs."
    options:
      - id: "a"
        text: "Containers running as root or with allowPrivilegeEscalation"
        isCorrect: true
      - id: "b"
        text: "HPA min and max replica counts"
        isCorrect: false
      - id: "c"
        text: "Container images using the latest tag"
        isCorrect: true
      - id: "d"
        text: "Secrets hardcoded in ConfigMaps rather than referenced from Secret objects"
        isCorrect: true
      - id: "e"
        text: "Service selector label values"
        isCorrect: false
---
