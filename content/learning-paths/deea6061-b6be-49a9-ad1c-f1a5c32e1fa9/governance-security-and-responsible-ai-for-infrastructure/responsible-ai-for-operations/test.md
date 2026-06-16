---
title: "Course Test"
passPercentage: 70
type: "test"
questions:
  - id: "q1"
    text: "Which combination of guardrails is needed to catch both invented Kubernetes fields and admission control failures before applying an AI-generated manifest?"
    type: "single-answer"
    marks: 2
    explanation: "Schema validation catches invented fields and wrong resource kinds. Server-side dry-run runs the full admission control chain including validating webhooks. Both are required because each catches a class of failure the other does not."
    options:
      - id: "a"
        text: "Schema validation only"
        isCorrect: false
      - id: "b"
        text: "Server-side dry-run only"
        isCorrect: false
      - id: "c"
        text: "Schema validation and server-side dry-run"
        isCorrect: true
      - id: "d"
        text: "Human approval gate and constrained output templates"
        isCorrect: false

  - id: "q2"
    text: "What is the primary advantage of constrained output templates over free-form manifest generation when working with a coding agent?"
    type: "single-answer"
    marks: 2
    explanation: "Constrained output templates restrict the agent to filling in variable values within a fixed structure. Hallucinating a field is structurally impossible when the output format is a template rather than a blank canvas, because the agent cannot alter the schema."
    options:
      - id: "a"
        text: "They reduce the number of tokens the agent consumes per request"
        isCorrect: false
      - id: "b"
        text: "They make structural hallucinations impossible by limiting the agent to filling in values within a fixed schema"
        isCorrect: true
      - id: "c"
        text: "They eliminate the need for schema validation"
        isCorrect: false
      - id: "d"
        text: "They allow the agent to operate without human approval gates"
        isCorrect: false

  - id: "q3"
    text: "An AI audit record must be structured so that a future engineer can reconstruct the decision without any additional context. Which fields are essential to achieve this? Select all that apply."
    type: "multiple-answers"
    marks: 2
    explanation: "Reconstructing the decision requires knowing the intent (what problem was being solved), the rationale (why specific choices were made), the validation results (what confirmed safety), and the approver identity (who held accountability). The full prompt text and agent version are useful but not strictly necessary for decision reconstruction."
    options:
      - id: "a"
        text: "The intent - what problem the agent was solving"
        isCorrect: true
      - id: "b"
        text: "The agent's rationale for each structural choice"
        isCorrect: true
      - id: "c"
        text: "The full LLM prompt text sent to the agent"
        isCorrect: false
      - id: "d"
        text: "The identity of the human approver"
        isCorrect: true

  - id: "q4"
    text: "What does the mesheryctl system check command help detect in the context of AI-driven operations?"
    type: "single-answer"
    marks: 2
    explanation: "mesheryctl system check reports on the health and state of Meshery and its connections. Used periodically, a comparison between Meshery's registry and live cluster state surfaces drift - including orphaned resources that a coding agent created and did not clean up."
    options:
      - id: "a"
        text: "LLM token budget exhaustion during an agent session"
        isCorrect: false
      - id: "b"
        text: "Drift between Meshery's registry and live cluster state, surfacing orphaned agent-created resources"
        isCorrect: true
      - id: "c"
        text: "Missing human approval signatures on promoted designs"
        isCorrect: false
      - id: "d"
        text: "Schema validation failures in imported designs"
        isCorrect: false

  - id: "q5"
    text: "Which of the following triggers should cause an AI Operator to escalate rather than approve an agent proposal?"
    type: "multiple-answers"
    marks: 2
    explanation: "Escalation is required when the proposal affects more than one namespace (broad blast radius), when the agent has retried the same task multiple times without success (possible loop or misspecification), and when the proposal touches security-sensitive components such as RBAC or NetworkPolicy. A passing dry-run is a positive signal and is not an escalation trigger."
    options:
      - id: "a"
        text: "The proposal affects more than one namespace"
        isCorrect: true
      - id: "b"
        text: "The agent has retried the same task more than twice without success"
        isCorrect: true
      - id: "c"
        text: "The server-side dry-run passed successfully"
        isCorrect: false
      - id: "d"
        text: "The proposal touches a NetworkPolicy or RBAC resource"
        isCorrect: true

  - id: "q6"
    text: "What is the correct command to import an AI-generated design into Meshery for review and versioning?"
    type: "short-answer"
    marks: 2
    correctAnswer: "mesheryctl design import -f <file> -s \"Kubernetes Manifest\""
    case_sensitive: false
    explanation: "The mesheryctl design import command with the -f flag for the file path and -s flag for the source type imports a design artifact into Meshery, where it is versioned and available for review, validation, and environment promotion."
---
