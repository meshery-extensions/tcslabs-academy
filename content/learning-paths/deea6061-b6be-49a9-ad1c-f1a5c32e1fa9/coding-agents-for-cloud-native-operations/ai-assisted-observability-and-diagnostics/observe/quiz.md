---
title: "Module Quiz"
passPercentage: 70
type: "test"
questions:
  - id: "q1"
    text: "Which Meshery Operator component continuously watches the Kubernetes cluster and syncs discovered state into Meshery's data layer?"
    type: "single-answer"
    marks: 2
    explanation: "MeshSync is the Meshery Operator component responsible for continuous cluster reconciliation. It keeps Meshery's internal model in sync with what the cluster actually reports."
    options:
      - id: "a"
        text: "Meshery Server"
        isCorrect: false
      - id: "b"
        text: "MeshSync"
        isCorrect: true
      - id: "c"
        text: "Kanvas"
        isCorrect: false
      - id: "d"
        text: "Prometheus Adapter"
        isCorrect: false
  - id: "q2"
    text: "When preparing log and event data for LLM analysis, which of the following pre-processing steps reduce token usage and improve output quality?"
    type: "multiple-answers"
    marks: 2
    explanation: "Deduplicating repeated events and sorting by recency both directly reduce token count and bias the LLM toward the most relevant recent signal. Stripping uninformative metadata fields (resourceVersion, uid) also removes token cost with no diagnostic loss."
    options:
      - id: "a"
        text: "Deduplicate repeated events, collapsing them to a single entry with a count field"
        isCorrect: true
      - id: "b"
        text: "Include all metadata fields such as resourceVersion and managedFields to preserve full fidelity"
        isCorrect: false
      - id: "c"
        text: "Sort entries by recency so the freshest signal appears first"
        isCorrect: true
      - id: "d"
        text: "Strip metadata fields that carry no diagnostic value"
        isCorrect: true
  - id: "q3"
    text: "In a well-structured diagnostic prompt, what is the purpose of requiring the agent to include verbatim quotes from the input signals for each hypothesis?"
    type: "single-answer"
    marks: 2
    explanation: "Requiring verbatim quotes forces the agent to anchor its reasoning to what is actually present in the input, suppressing confabulation and making the output verifiable by a human reviewer."
    options:
      - id: "a"
        text: "To make the output longer and more detailed"
        isCorrect: false
      - id: "b"
        text: "To suppress hallucination and make hypotheses verifiable against the source data"
        isCorrect: true
      - id: "c"
        text: "To allow the agent to suggest remediation steps based on specific log lines"
        isCorrect: false
      - id: "d"
        text: "To enable the agent to correlate metrics with deployment events automatically"
        isCorrect: false
  - id: "q4"
    text: "In the four-phase symptom-to-hypothesis method, what is the correct order of phases?"
    type: "single-answer"
    marks: 2
    explanation: "The disciplined sequence is: observe the symptom precisely, gather state from relevant signals, form ranked hypotheses with evidence, then test the cheapest hypothesis first. Acting on fixes before hypotheses are formed is the failure mode the method is designed to prevent."
    options:
      - id: "a"
        text: "Gather state, observe symptom, form hypotheses, test cheapest hypothesis"
        isCorrect: false
      - id: "b"
        text: "Observe symptom, gather state, form hypotheses, test cheapest hypothesis"
        isCorrect: true
      - id: "c"
        text: "Form hypotheses, observe symptom, gather state, apply fix"
        isCorrect: false
      - id: "d"
        text: "Observe symptom, form hypotheses, apply fix, gather state to confirm"
        isCorrect: false
---
