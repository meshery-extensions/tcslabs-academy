---
title: "Learning Path Exam"
passPercentage: 70
timeLimit: 35
type: "test"
questions:
  - id: "q1"
    text: "When turning intent into a topology, what should a good infrastructure brief to an LLM include? (Select all that apply.)"
    type: "multiple-answers"
    marks: 3
    explanation: "Functional needs, constraints, and non-functional requirements (scale, security) all shape a correct design. The model's internal weights are not something you specify."
    options:
      - id: "a"
        text: "Functional requirements (what it must do)"
        isCorrect: true
      - id: "b"
        text: "Constraints (namespaces, images, limits)"
        isCorrect: true
      - id: "c"
        text: "Non-functional requirements (scale, security)"
        isCorrect: true
      - id: "d"
        text: "The model's training weights"
        isCorrect: false
  - id: "q2"
    text: "What role does Kanvas play when co-designing with an AI?"
    type: "single-answer"
    marks: 2
    explanation: "Kanvas is the shared visual canvas and a human-in-the-loop checkpoint: the AI proposes components, you arrange and validate them before deploying."
    options:
      - id: "a"
        text: "It trains the LLM on your cluster"
        isCorrect: false
      - id: "b"
        text: "It is the shared canvas and human-in-the-loop checkpoint for proposed designs"
        isCorrect: true
      - id: "c"
        text: "It replaces the need to review designs"
        isCorrect: false
      - id: "d"
        text: "It is a load generator"
        isCorrect: false
  - id: "q3"
    text: "A Meshery design (Kubernetes Manifest source) is fundamentally what?"
    type: "single-answer"
    marks: 2
    explanation: "It is valid Kubernetes YAML (often multi-document) that Meshery can import, visualize, validate, and deploy."
    options:
      - id: "a"
        text: "A proprietary binary format"
        isCorrect: false
      - id: "b"
        text: "Valid Kubernetes YAML that Meshery can import and deploy"
        isCorrect: true
      - id: "c"
        text: "A Grafana dashboard"
        isCorrect: false
      - id: "d"
        text: "A container image manifest"
        isCorrect: false
  - id: "q4"
    text: "Which prompt instruction most improves the chance of importable design YAML?"
    type: "single-answer"
    marks: 2
    explanation: "Telling the model to output only valid YAML (no commentary) and to use specific, current resource kinds yields a clean, importable artifact."
    options:
      - id: "a"
        text: "'Be as verbose as possible'"
        isCorrect: false
      - id: "b"
        text: "'Output only valid YAML using these resource kinds; no commentary'"
        isCorrect: true
      - id: "c"
        text: "'Invent any apiVersion you like'"
        isCorrect: false
      - id: "d"
        text: "'Skip resource limits'"
        isCorrect: false
  - id: "q5"
    text: "Which are common mistakes in LLM-generated Kubernetes designs? (Select all that apply.)"
    type: "multiple-answers"
    marks: 3
    explanation: "Outdated apiVersions, selector/label mismatches, and missing resource limits are all common; using a Namespace is correct practice, not a mistake."
    options:
      - id: "a"
        text: "Deprecated or wrong apiVersion"
        isCorrect: true
      - id: "b"
        text: "Service selector not matching pod labels"
        isCorrect: true
      - id: "c"
        text: "Missing resource requests/limits"
        isCorrect: true
      - id: "d"
        text: "Placing resources in a Namespace"
        isCorrect: false
  - id: "q6"
    text: "In the agent deploy loop, what should happen before any change is applied to a cluster?"
    type: "single-answer"
    marks: 2
    explanation: "Preview the change with a dry-run/diff and have a human approve it - bounding blast radius before applying."
    options:
      - id: "a"
        text: "Apply first, review later"
        isCorrect: false
      - id: "b"
        text: "Preview with a dry-run/diff and get human approval"
        isCorrect: true
      - id: "c"
        text: "Delete the namespace"
        isCorrect: false
      - id: "d"
        text: "Disable validation"
        isCorrect: false
  - id: "q7"
    text: "What is the correct way to roll back a bad design change that is tracked in Git?"
    type: "single-answer"
    marks: 2
    explanation: "Revert the change in Git and re-deploy the previous known-good design (optionally using kubectl rollout undo as an immediate stopgap)."
    options:
      - id: "a"
        text: "Edit production by hand and hope it sticks"
        isCorrect: false
      - id: "b"
        text: "git revert the change and re-deploy the previous known-good design"
        isCorrect: true
      - id: "c"
        text: "Delete the Git history"
        isCorrect: false
      - id: "d"
        text: "Turn off MeshSync"
        isCorrect: false
  - id: "q8"
    text: "What kind of error does Meshery's relationship validation catch that plain schema validation does not?"
    type: "single-answer"
    marks: 2
    explanation: "Relationship validation catches semantic errors - how components must relate - not just whether each object's fields are individually well-formed."
    options:
      - id: "a"
        text: "Spelling errors in comments"
        isCorrect: false
      - id: "b"
        text: "Semantic errors in how components relate to each other"
        isCorrect: true
      - id: "c"
        text: "Slow container image pulls"
        isCorrect: false
      - id: "d"
        text: "Git merge conflicts"
        isCorrect: false
  - id: "q9"
    text: "Which Kubernetes objects make good standing guardrails for AI-generated workloads?"
    type: "multiple-answers"
    marks: 3
    explanation: "ResourceQuota, LimitRange, and NetworkPolicy all bound what generated infra can do. A ConfigMap stores configuration; it is not a guardrail."
    options:
      - id: "a"
        text: "ResourceQuota"
        isCorrect: true
      - id: "b"
        text: "LimitRange"
        isCorrect: true
      - id: "c"
        text: "NetworkPolicy"
        isCorrect: true
      - id: "d"
        text: "ConfigMap"
        isCorrect: false
  - id: "q10"
    text: "Before merging AI-generated infrastructure, your review checklist should confirm correctness, security, resources, policy, and what else?"
    type: "short-answer"
    marks: 2
    correctAnswer: "rollback"
    case_sensitive: false
    explanation: "Rollback readiness (can you safely revert?) is the fifth pillar of a sound review checklist for AI-generated infrastructure."
---
