---
title: "Learning Path Exam"
passPercentage: 70
timeLimit: 30
type: "test"
questions:
  - id: "q1"
    text: "At its core, what does a large language model do?"
    type: "single-answer"
    marks: 2
    explanation: "An LLM predicts the next token given the preceding context; everything else is built on that."
    options:
      - id: "a"
        text: "Looks answers up in a database"
        isCorrect: false
      - id: "b"
        text: "Predicts the next token given the preceding context"
        isCorrect: true
      - id: "c"
        text: "Executes code deterministically"
        isCorrect: false
      - id: "d"
        text: "Compiles YAML into binaries"
        isCorrect: false
  - id: "q2"
    text: "What is the 'context window'?"
    type: "single-answer"
    marks: 2
    explanation: "The context window is the maximum amount of text (in tokens) the model can consider at once."
    options:
      - id: "a"
        text: "The model's training dataset"
        isCorrect: false
      - id: "b"
        text: "The maximum amount of text (tokens) the model can consider at once"
        isCorrect: true
      - id: "c"
        text: "A UI panel in the terminal"
        isCorrect: false
      - id: "d"
        text: "The GPU memory size"
        isCorrect: false
  - id: "q3"
    text: "Which are real LLM failure modes to guard against in operations? (Select all that apply.)"
    type: "multiple-answers"
    marks: 3
    explanation: "Hallucination, confident wrongness, and stale knowledge are all real failure modes. 'Deterministic output' is not a failure mode (and LLM output is generally not deterministic)."
    options:
      - id: "a"
        text: "Hallucinating commands or fields that do not exist"
        isCorrect: true
      - id: "b"
        text: "Being confidently wrong"
        isCorrect: true
      - id: "c"
        text: "Relying on stale training knowledge"
        isCorrect: true
      - id: "d"
        text: "Producing perfectly deterministic output every time"
        isCorrect: false
  - id: "q4"
    text: "Why ground a prompt in live cluster/Meshery state instead of relying on the model's memory?"
    type: "single-answer"
    marks: 2
    explanation: "The model's training data is generic and stale; grounding in current, specific state produces accurate, relevant answers."
    options:
      - id: "a"
        text: "It makes the response longer"
        isCorrect: false
      - id: "b"
        text: "Current, specific state yields accurate, relevant answers; training data is stale"
        isCorrect: true
      - id: "c"
        text: "It disables hallucination entirely"
        isCorrect: false
      - id: "d"
        text: "It is required by Kubernetes"
        isCorrect: false
  - id: "q5"
    text: "Which instruction most reliably yields a parseable design artifact from an LLM?"
    type: "single-answer"
    marks: 2
    explanation: "Constraining the output ('output only YAML, no commentary') yields a clean, directly usable artifact."
    options:
      - id: "a"
        text: "'Explain your reasoning in detail'"
        isCorrect: false
      - id: "b"
        text: "'Output only valid YAML, no commentary'"
        isCorrect: true
      - id: "c"
        text: "'Be creative with the format'"
        isCorrect: false
      - id: "d"
        text: "'Use as many tokens as possible'"
        isCorrect: false
  - id: "q6"
    text: "Describe the agentic loop in three words (one common phrasing)."
    type: "short-answer"
    marks: 2
    correctAnswer: "plan act observe"
    case_sensitive: false
    explanation: "A coding agent repeatedly plans, acts (calls a tool), and observes the result until the task is done."
  - id: "q7"
    text: "What distinguishes a coding agent from a plain chat assistant?"
    type: "single-answer"
    marks: 2
    explanation: "An agent can take actions through tools - reading/writing files and running commands - not just produce text."
    options:
      - id: "a"
        text: "It can take actions via tools (files, shell, APIs), not just produce text"
        isCorrect: true
      - id: "b"
        text: "It uses a larger font"
        isCorrect: false
      - id: "c"
        text: "It never makes mistakes"
        isCorrect: false
      - id: "d"
        text: "It runs without any model"
        isCorrect: false
  - id: "q8"
    text: "Why keep a human in the loop for agent-driven infrastructure changes?"
    type: "single-answer"
    marks: 2
    explanation: "A human reviews and approves changes before they apply, bounding blast radius and keeping accountability."
    options:
      - id: "a"
        text: "To slow the agent down for no reason"
        isCorrect: false
      - id: "b"
        text: "To review and approve changes before they apply, bounding blast radius"
        isCorrect: true
      - id: "c"
        text: "Because agents cannot run commands"
        isCorrect: false
      - id: "d"
        text: "To increase token usage"
        isCorrect: false
  - id: "q9"
    text: "In retrieval-augmented generation for ops, what is 'retrieval'?"
    type: "single-answer"
    marks: 2
    explanation: "Retrieval fetches relevant, current information (state, runbooks, designs) and supplies it to the model as context."
    options:
      - id: "a"
        text: "Fetching relevant current information and supplying it to the model as context"
        isCorrect: true
      - id: "b"
        text: "Retraining the model on your data nightly"
        isCorrect: false
      - id: "c"
        text: "Deleting old logs"
        isCorrect: false
      - id: "d"
        text: "Compressing container images"
        isCorrect: false
  - id: "q10"
    text: "Before trusting an infrastructure agent with real changes, you should evaluate it. Which practices help? (Select all that apply.)"
    type: "multiple-answers"
    marks: 3
    explanation: "Golden tasks, an eval harness, and safety checks (dry-run, approvals) all build justified trust. 'Skipping all testing' does the opposite."
    options:
      - id: "a"
        text: "Define golden tasks with known-good outcomes"
        isCorrect: true
      - id: "b"
        text: "Run an eval harness across fixtures"
        isCorrect: true
      - id: "c"
        text: "Gate real changes behind dry-runs and approvals"
        isCorrect: true
      - id: "d"
        text: "Skip all testing to move faster"
        isCorrect: false
---
