---
title: "Module Quiz"
passPercentage: 70
type: "test"
questions:
  - id: "q1"
    text: "What is the core mechanism by which an LLM produces output?"
    type: "single-answer"
    marks: 2
    explanation: "An LLM is a neural network that predicts the most probable next token given the preceding sequence of tokens. It does not retrieve facts from a database or perform deterministic lookups."
    options:
      - id: "a"
        text: "It queries a structured knowledge base and returns matching facts"
        isCorrect: false
      - id: "b"
        text: "It predicts the most probable next token based on all preceding tokens"
        isCorrect: true
      - id: "c"
        text: "It executes a set of logical inference rules over a symbolic knowledge graph"
        isCorrect: false
      - id: "d"
        text: "It searches training data at inference time to find the closest matching example"
        isCorrect: false

  - id: "q2"
    text: "Which of the following best explains why an LLM may recommend a flag that does not exist in the mesheryctl CLI?"
    type: "single-answer"
    marks: 2
    explanation: "LLMs generate statistically likely token sequences. If a flag name pattern looks plausible based on training data, the model will produce it whether or not it actually exists. This is hallucination - confident, fluent output that is factually wrong."
    options:
      - id: "a"
        text: "The model has access to an outdated version of the mesheryctl documentation"
        isCorrect: false
      - id: "b"
        text: "The model generates statistically plausible text regardless of whether the content is accurate"
        isCorrect: true
      - id: "c"
        text: "The model is deliberately testing whether the user will verify its output"
        isCorrect: false
      - id: "d"
        text: "The model misread the user's prompt and answered a different question"
        isCorrect: false

  - id: "q3"
    text: "A Meshery design with 10 components serializes to approximately 2,000 tokens. You also want to include a 3,000-token policy document and a 500-token system prompt. Which of the following statements is true?"
    type: "single-answer"
    marks: 2
    explanation: "The total input is 5,500 tokens. Both input and output tokens count against the context window, so you must also leave room for the model's response. A model with an 8K context window would have less than 3,000 tokens remaining for output, which may be insufficient for detailed analysis. Planning the token budget before sending a request prevents truncation."
    options:
      - id: "a"
        text: "Context window limits only apply to the model's output, not the input"
        isCorrect: false
      - id: "b"
        text: "The total input of 5,500 tokens leaves limited room for model output in smaller context windows"
        isCorrect: true
      - id: "c"
        text: "Token counts are irrelevant because modern models have unlimited context"
        isCorrect: false
      - id: "d"
        text: "Only the system prompt counts against the context window"
        isCorrect: false

  - id: "q4"
    text: "Which task types are well-suited to smaller, faster LLMs rather than large frontier models? Select all that apply."
    type: "multiple-answers"
    marks: 2
    explanation: "Classification tasks (assigning inputs to categories) and short structured output generation are well-suited to smaller models because they have bounded, well-defined correct outputs. Multi-step root cause reasoning across complex system state benefits from larger models where the capability gap is most pronounced."
    options:
      - id: "a"
        text: "Classifying log lines as error, warning, or informational"
        isCorrect: true
      - id: "b"
        text: "Multi-step root cause analysis across a distributed system incident"
        isCorrect: false
      - id: "c"
        text: "Routing a support request to the correct team based on its content"
        isCorrect: true
      - id: "d"
        text: "Evaluating whether a proposed network policy satisfies multiple security constraints simultaneously"
        isCorrect: false
---
