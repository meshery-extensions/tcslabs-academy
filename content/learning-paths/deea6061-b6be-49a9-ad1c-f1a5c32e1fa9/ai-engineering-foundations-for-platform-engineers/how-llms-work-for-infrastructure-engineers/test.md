---
title: "Course Test"
passPercentage: 70
type: "test"
questions:
  - id: "q1"
    text: "What is the fundamental difference between LLM training and LLM inference?"
    type: "single-answer"
    marks: 2
    explanation: "Training adjusts the model's weights across a large corpus and happens once, at enormous cost. Inference runs the frozen trained model on a new input to produce output. You cannot update what a model knows by talking to it - knowledge is fixed at training time."
    options:
      - id: "a"
        text: "Training uses GPU clusters; inference uses CPU clusters"
        isCorrect: false
      - id: "b"
        text: "Training adjusts model weights using a corpus; inference runs the frozen model on new input"
        isCorrect: true
      - id: "c"
        text: "Training is fast and cheap; inference is slow and expensive"
        isCorrect: false
      - id: "d"
        text: "Training happens on your prompt; inference happens on the training dataset"
        isCorrect: false

  - id: "q2"
    text: "An LLM generates a Meshery design manifest that includes a component field named `spec.meshSync.autoDiscovery.enabled`. You cannot find this field in the Meshery documentation. What is the most likely explanation?"
    type: "single-answer"
    marks: 2
    explanation: "This is a hallucinated field. The LLM produced a plausible-looking field name based on patterns in its training data, but the field does not exist. This is why generated YAML must be validated against the actual schema before use."
    options:
      - id: "a"
        text: "The field exists but is undocumented"
        isCorrect: false
      - id: "b"
        text: "The field was removed in a recent Meshery release"
        isCorrect: false
      - id: "c"
        text: "The LLM hallucinated a plausible-looking field that does not actually exist"
        isCorrect: true
      - id: "d"
        text: "The field exists only when MeshSync is installed separately"
        isCorrect: false

  - id: "q3"
    text: "Which of the following approaches correctly addresses the problem of an LLM having no knowledge of your live cluster state?"
    type: "multiple-answers"
    marks: 2
    explanation: "Passing relevant cluster state into the prompt and using tool-equipped agents that call kubectl or Meshery APIs at query time are both valid approaches to grounding an LLM in real system state. The model cannot access live data on its own - you must put that data in the context."
    options:
      - id: "a"
        text: "Asking the LLM to predict cluster state based on your description of the system design"
        isCorrect: false
      - id: "b"
        text: "Passing the output of mesheryctl system check into the prompt before asking questions about it"
        isCorrect: true
      - id: "c"
        text: "Using a tool-equipped agent that calls Meshery APIs to retrieve live state at query time"
        isCorrect: true
      - id: "d"
        text: "Using a model with a larger context window, which gives it access to more recent information"
        isCorrect: false

  - id: "q4"
    text: "You are designing an automated pipeline where an LLM generates a Meshery design, and the design is applied to your production cluster immediately without human review. Which failure mode makes this architecture most risky?"
    type: "single-answer"
    marks: 2
    explanation: "Confident wrongness - the combination of hallucination and lack of internal accuracy signal - means the LLM can produce an invalid or dangerous configuration that sounds completely correct. Without a human review or programmatic validation step, that configuration goes directly to production. Human-in-the-loop is non-optional for infrastructure automation."
    options:
      - id: "a"
        text: "The LLM will refuse to generate YAML for production environments"
        isCorrect: false
      - id: "b"
        text: "The LLM may generate invalid or dangerous configurations with the same confident tone as correct ones"
        isCorrect: true
      - id: "c"
        text: "The LLM cannot generate valid YAML without access to the Kubernetes API"
        isCorrect: false
      - id: "d"
        text: "The context window will always be exceeded by production-scale manifests"
        isCorrect: false

  - id: "q5"
    text: "What does it mean that LLM output is non-deterministic, and what is the correct mitigation for infrastructure automation?"
    type: "short-answer"
    marks: 2
    correctAnswer: "Non-determinism means the model may produce different output for the same input across runs due to probabilistic token sampling. The mitigation is to use low temperature settings for structured output tasks and to validate all generated output programmatically before use rather than assuming consistency."
    case_sensitive: false

  - id: "q6"
    text: "You need an LLM to analyze the output of mesheryctl system check and identify the root cause across several warnings, then recommend which configuration change to make. Which model tier is most appropriate and why?"
    type: "single-answer"
    marks: 2
    explanation: "Multi-step root cause reasoning across multiple signals is a reasoning task - the type where the capability gap between model tiers is most pronounced. A small model may produce plausible-sounding but incorrect reasoning, which is more dangerous than clearly wrong output. Reasoning tasks warrant a larger, higher-capability model."
    options:
      - id: "a"
        text: "A small, fast model - because low latency is more important than accuracy for incident response"
        isCorrect: false
      - id: "b"
        text: "A mid-tier model for classification, because the task is just categorizing warnings"
        isCorrect: false
      - id: "c"
        text: "A larger, higher-capability model - because multi-step root cause reasoning is where capability gaps are most pronounced"
        isCorrect: true
      - id: "d"
        text: "Model tier does not matter for this task because mesheryctl output is always structured"
        isCorrect: false
---
