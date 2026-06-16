---
title: "Module Quiz"
passPercentage: 70
type: "test"
questions:
  - id: "q1"
    text: "Which guardrail catches hallucinated Kubernetes field names before a manifest is imported into Meshery?"
    type: "single-answer"
    marks: 2
    explanation: "Schema validation checks the manifest against the published Kubernetes resource schemas and catches invented or misspelled field names before the file is imported into Meshery."
    options:
      - id: "a"
        text: "Server-side dry-run against the target cluster"
        isCorrect: false
      - id: "b"
        text: "Schema validation applied to the agent output"
        isCorrect: true
      - id: "c"
        text: "Human approval gate at the promotion stage"
        isCorrect: false
      - id: "d"
        text: "Meshery environment promotion policy"
        isCorrect: false

  - id: "q2"
    text: "What information must a complete AI audit record include beyond the manifest itself? Select all that apply."
    type: "multiple-answers"
    marks: 2
    explanation: "A complete audit record includes the agent's rationale for structural choices, the validation results (schema, dry-run, policy), and the identity and timestamp of the human approver. The manifest alone is insufficient for post-incident investigation."
    options:
      - id: "a"
        text: "The agent's rationale for each structural choice in the proposal"
        isCorrect: true
      - id: "b"
        text: "Validation results including schema check and dry-run output"
        isCorrect: true
      - id: "c"
        text: "The full LLM context window from the agent session"
        isCorrect: false
      - id: "d"
        text: "The identity and timestamp of the human approver"
        isCorrect: true

  - id: "q3"
    text: "Which label practice makes it possible to query cloud cost tooling for all resources created by AI agents?"
    type: "single-answer"
    marks: 2
    explanation: "Tagging every AI-created resource with a label such as managed-by: ai-agent allows cost management tools to filter and aggregate spend from agent-driven provisioning separately from human-authored changes."
    options:
      - id: "a"
        text: "Adding a TTL annotation to every resource"
        isCorrect: false
      - id: "b"
        text: "Storing token usage in a Prometheus metric"
        isCorrect: false
      - id: "c"
        text: "Labeling every agent-created resource with a managed-by: ai-agent label"
        isCorrect: true
      - id: "d"
        text: "Running mesheryctl system check after every agent session"
        isCorrect: false

  - id: "q4"
    text: "In the three-role accountability model, who holds final authority to approve or reject an agent's proposal?"
    type: "single-answer"
    marks: 2
    explanation: "The AI Operator configures the agent, sets the task scope, reviews proposals, and holds final authority to approve or reject. The Domain Reviewer provides specialist input, and the Escalation Owner handles situations the Operator cannot resolve."
    options:
      - id: "a"
        text: "Domain Reviewer"
        isCorrect: false
      - id: "b"
        text: "Escalation Owner"
        isCorrect: false
      - id: "c"
        text: "AI Operator"
        isCorrect: true
      - id: "d"
        text: "The coding agent itself, based on its validation results"
        isCorrect: false
---
