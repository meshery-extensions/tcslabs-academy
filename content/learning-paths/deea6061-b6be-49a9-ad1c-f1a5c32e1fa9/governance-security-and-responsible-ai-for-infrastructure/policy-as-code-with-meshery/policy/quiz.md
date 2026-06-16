---
title: "Module Quiz"
passPercentage: 70
type: "test"
questions:
  - id: "q1"
    text: "Which two artifacts in the Meshery registry together make up the policy evaluation stack for a design?"
    type: "multiple-answers"
    marks: 2
    explanation: "Meshery evaluates designs using relationship definitions (structural graph rules) and OPA constraints (field-level Rego rules). Models define component schemas and are used in schema validation, but are not the policy evaluation stack themselves."
    options:
      - id: "a"
        text: "Relationship definitions"
        isCorrect: true
      - id: "b"
        text: "OPA constraint bundles"
        isCorrect: true
      - id: "c"
        text: "Catalog entries"
        isCorrect: false
      - id: "d"
        text: "Performance profiles"
        isCorrect: false

  - id: "q2"
    text: "What does fail-closed validation mean in Meshery's policy engine?"
    type: "single-answer"
    marks: 2
    explanation: "Fail-closed means that if the policy engine cannot reach OPA or encounters an evaluation error, it returns a failure rather than a pass. This prevents connectivity or configuration failures from silently bypassing policy checks."
    options:
      - id: "a"
        text: "Validation blocks all designs regardless of their content"
        isCorrect: false
      - id: "b"
        text: "If the policy engine is unreachable, validation returns an error rather than passing"
        isCorrect: true
      - id: "c"
        text: "Only designs with zero components pass validation"
        isCorrect: false
      - id: "d"
        text: "Designs are closed (locked) after validation passes"
        isCorrect: false

  - id: "q3"
    text: "In a graduated policy stack, which environment typically applies the full constraint set including NetworkPolicy and PodDisruptionBudget requirements?"
    type: "single-answer"
    marks: 2
    explanation: "Production applies the complete constraint set. Dev permits incomplete designs with warnings only, and staging enforces critical constraints but not the full production rule set."
    options:
      - id: "a"
        text: "dev"
        isCorrect: false
      - id: "b"
        text: "staging"
        isCorrect: false
      - id: "c"
        text: "prod"
        isCorrect: true
      - id: "d"
        text: "All environments apply identical constraints"
        isCorrect: false

  - id: "q4"
    text: "In Rego, what is the role of the `input` keyword?"
    type: "single-answer"
    marks: 2
    explanation: "In OPA Rego, `input` is the structured data being evaluated - in Meshery's context this is the component data from the active design passed by the policy engine."
    options:
      - id: "a"
        text: "It defines the package namespace for the policy module"
        isCorrect: false
      - id: "b"
        text: "It imports external Rego libraries"
        isCorrect: false
      - id: "c"
        text: "It references the structured data being evaluated by the policy rule"
        isCorrect: true
      - id: "d"
        text: "It declares which OPA server to connect to"
        isCorrect: false
---
