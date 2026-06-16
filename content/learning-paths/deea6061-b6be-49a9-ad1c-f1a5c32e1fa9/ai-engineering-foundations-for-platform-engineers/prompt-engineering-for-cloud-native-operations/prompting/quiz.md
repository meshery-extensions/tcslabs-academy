---
title: "Module Quiz"
passPercentage: 70
type: "test"
questions:
  - id: "q1"
    text: "Which location is most appropriate for defining an agent's authorization scope and output format requirements?"
    type: "single-answer"
    marks: 2
    explanation: "Authorization scope and output format apply to every interaction the agent has. These constraints belong in the system prompt, which runs before any user turn and cannot be overridden by a user message. Placing them in the user turn means a future user turn can accidentally override them."
    options:
      - id: "a"
        text: "The user turn, so the operator can adjust them per request"
        isCorrect: false
      - id: "b"
        text: "The system prompt, so they apply to every interaction"
        isCorrect: true
      - id: "c"
        text: "A separate configuration file read by the agent at runtime"
        isCorrect: false
      - id: "d"
        text: "A comment at the top of the YAML manifest the agent produces"
        isCorrect: false

  - id: "q2"
    text: "What is the primary reason to pass kubectl output into a prompt before asking the LLM to modify a Kubernetes resource?"
    type: "single-answer"
    marks: 2
    explanation: "An LLM has no live connection to a cluster. Without real state passed in the context window, the model reasons from training data that may be months old and specific to different cluster configurations. Grounding with real kubectl output ensures the model reasons from actual current state rather than stale or fabricated assumptions."
    options:
      - id: "a"
        text: "To reduce the number of tokens used in the prompt"
        isCorrect: false
      - id: "b"
        text: "To ensure the model reasons from actual current cluster state rather than stale training data"
        isCorrect: true
      - id: "c"
        text: "To satisfy a Meshery API requirement before running mesheryctl"
        isCorrect: false
      - id: "d"
        text: "To give the model access to the cluster credentials"
        isCorrect: false

  - id: "q3"
    text: "Which of the following techniques for getting reliable YAML output from an LLM involves providing two or three complete examples of correctly formatted manifests before stating the actual task?"
    type: "single-answer"
    marks: 2
    explanation: "Few-shot prompting provides the model with complete input-output examples before the actual task. The examples calibrate the model's output structure - including organization-specific labels and annotations - without requiring verbose schema descriptions. A skeleton with placeholders is a different structural technique, and role prompting assigns an expert persona."
    options:
      - id: "a"
        text: "Role prompting"
        isCorrect: false
      - id: "b"
        text: "Checklist prompting"
        isCorrect: false
      - id: "c"
        text: "Few-shot prompting"
        isCorrect: true
      - id: "d"
        text: "Skeleton with placeholders"
        isCorrect: false

  - id: "q4"
    text: "Before scaling a prompt-driven agentic workflow to production, which of the following should be true about your eval set? Select all that apply."
    type: "multiple-answers"
    marks: 2
    explanation: "A production-ready eval set should cover the main input variations (at least three cases), include at least one refusal scenario to verify the model correctly declines ungrounded or out-of-scope requests, and be stored in version control alongside the prompt so changes to either are tracked together. Running evals on every model update is also required to catch regressions from model changes."
    options:
      - id: "a"
        text: "At least three eval cases covering the main input variations"
        isCorrect: true
      - id: "b"
        text: "At least one eval case covering a refusal scenario"
        isCorrect: true
      - id: "c"
        text: "Eval cases stored in version control alongside the prompt definition"
        isCorrect: true
      - id: "d"
        text: "All eval cases must use exact string matching to verify output"
        isCorrect: false
---
