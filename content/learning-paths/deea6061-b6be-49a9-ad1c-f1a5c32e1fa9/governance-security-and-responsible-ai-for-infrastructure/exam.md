---
title: "Learning Path Exam"
passPercentage: 70
timeLimit: 35
type: "test"
questions:
  - id: "q1"
    text: "How do Meshery relationships function as policy?"
    type: "single-answer"
    marks: 2
    explanation: "Relationships encode allowed/required configurations; validation enforces them, catching designs that violate the rules."
    options:
      - id: "a"
        text: "They are documentation only"
        isCorrect: false
      - id: "b"
        text: "They encode allowed/required configurations that validation enforces"
        isCorrect: true
      - id: "c"
        text: "They store container images"
        isCorrect: false
      - id: "d"
        text: "They are GPU scheduling hints"
        isCorrect: false
  - id: "q2"
    text: "What is OPA used for in policy as code?"
    type: "single-answer"
    marks: 2
    explanation: "Open Policy Agent evaluates policy expressed as code (constraints) against inputs - e.g., checking a design against rules."
    options:
      - id: "a"
        text: "Open Policy Agent evaluates policy-as-code rules against inputs"
        isCorrect: true
      - id: "b"
        text: "It builds container images"
        isCorrect: false
      - id: "c"
        text: "It is a load generator"
        isCorrect: false
      - id: "d"
        text: "It is a logging backend"
        isCorrect: false
  - id: "q3"
    text: "What should happen when an AI-generated design fails policy validation?"
    type: "single-answer"
    marks: 2
    explanation: "Fail closed: block the deploy and surface the violation for correction; do not silently proceed."
    options:
      - id: "a"
        text: "Deploy anyway and note it later"
        isCorrect: false
      - id: "b"
        text: "Fail closed - block the deploy and surface the violation"
        isCorrect: true
      - id: "c"
        text: "Disable policy and retry"
        isCorrect: false
      - id: "d"
        text: "Delete the namespace"
        isCorrect: false
  - id: "q4"
    text: "Where should secrets used by agents live?"
    type: "single-answer"
    marks: 2
    explanation: "In Kubernetes Secrets or an external secret store - never embedded in prompts, designs, or source."
    options:
      - id: "a"
        text: "Pasted into the prompt for convenience"
        isCorrect: false
      - id: "b"
        text: "In Kubernetes Secrets or an external secret store"
        isCorrect: true
      - id: "c"
        text: "Hard-coded in the design YAML"
        isCorrect: false
      - id: "d"
        text: "In a public Git repo"
        isCorrect: false
  - id: "q5"
    text: "Which practices strengthen the supply chain for AI-generated infrastructure? (Select all that apply.)"
    type: "multiple-answers"
    marks: 3
    explanation: "Pinning image digests, scanning manifests/images, and human review of generated output all strengthen the supply chain. Trusting output blindly does not."
    options:
      - id: "a"
        text: "Pin image digests/versions"
        isCorrect: true
      - id: "b"
        text: "Scan manifests and images"
        isCorrect: true
      - id: "c"
        text: "Human review before trust"
        isCorrect: true
      - id: "d"
        text: "Trust generated output blindly"
        isCorrect: false
  - id: "q6"
    text: "Name one concrete guardrail that keeps an AI hallucination from reaching production."
    type: "short-answer"
    marks: 2
    correctAnswer: "dry-run"
    case_sensitive: false
    explanation: "A server-side dry-run (also: validation, approval gates, constrained output) stops bad AI output before it is applied."
  - id: "q7"
    text: "Why label AI-created resources (for example, managed-by: ai-agent)?"
    type: "single-answer"
    marks: 2
    explanation: "Labeling makes AI-created resources discoverable for audit, cost attribution, and cleanup."
    options:
      - id: "a"
        text: "It improves model accuracy"
        isCorrect: false
      - id: "b"
        text: "It makes them discoverable for audit, cost, and cleanup"
        isCorrect: true
      - id: "c"
        text: "It is required by YAML"
        isCorrect: false
      - id: "d"
        text: "It speeds up scheduling"
        isCorrect: false
  - id: "q8"
    text: "Who is accountable for an AI-driven infrastructure change?"
    type: "single-answer"
    marks: 2
    explanation: "A human owner remains accountable; AI is an assistant, not an accountable party."
    options:
      - id: "a"
        text: "The model vendor"
        isCorrect: false
      - id: "b"
        text: "A human owner who reviews and approves"
        isCorrect: true
      - id: "c"
        text: "No one"
        isCorrect: false
      - id: "d"
        text: "The CI runner"
        isCorrect: false
  - id: "q9"
    text: "Which Meshery capability detects drift between desired and actual cluster state?"
    type: "short-answer"
    marks: 2
    correctAnswer: "MeshSync"
    case_sensitive: false
    explanation: "MeshSync continuously syncs actual state, enabling drift detection against the declared design."
  - id: "q10"
    text: "What makes good compliance evidence for AI-driven changes? (Select all that apply.)"
    type: "multiple-answers"
    marks: 3
    explanation: "Git history (who approved what), validation/policy results, and deploy records are all evidence. A verbal 'it's fine' is not."
    options:
      - id: "a"
        text: "Git history of authored/approved changes"
        isCorrect: true
      - id: "b"
        text: "Validation and policy-check results"
        isCorrect: true
      - id: "c"
        text: "Deploy records and MeshSync observations"
        isCorrect: true
      - id: "d"
        text: "A verbal assurance that it is fine"
        isCorrect: false
---
