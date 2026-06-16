---
title: "Course Test"
passPercentage: 70
type: "test"
questions:
  - id: "q1"
    text: "What are the three enforcement postures a Meshery relationship definition can express?"
    type: "multiple-answers"
    marks: 2
    explanation: "Meshery relationship definitions express Required (the binding must exist), Allowed (the combination is explicitly permitted), and Denied (the combination is forbidden). These three postures cover the full range of structural policy enforcement."
    options:
      - id: "a"
        text: "Required"
        isCorrect: true
      - id: "b"
        text: "Allowed"
        isCorrect: true
      - id: "c"
        text: "Denied"
        isCorrect: true
      - id: "d"
        text: "Encrypted"
        isCorrect: false
      - id: "e"
        text: "Deprecated"
        isCorrect: false

  - id: "q2"
    text: "Which `mesheryctl` command imports a design file in Kubernetes Manifest format?"
    type: "single-answer"
    marks: 2
    explanation: "The correct command is `mesheryctl design import -f <file> -s \"Kubernetes Manifest\"`. This imports the file and triggers schema validation immediately."
    options:
      - id: "a"
        text: "mesheryctl system start"
        isCorrect: false
      - id: "b"
        text: "mesheryctl design import -f <file> -s \"Kubernetes Manifest\""
        isCorrect: true
      - id: "c"
        text: "mesheryctl perf apply"
        isCorrect: false
      - id: "d"
        text: "mesheryctl system check"
        isCorrect: false

  - id: "q3"
    text: "A coding agent generates a design that violates two OPA constraints. What is the recommended next step before any human reviews the design?"
    type: "single-answer"
    marks: 2
    explanation: "The agent should revise the design based on the structured violation response and re-submit for validation. The human reviewer should only see a design that has already passed policy validation - not one with known violations."
    options:
      - id: "a"
        text: "Deploy the design to dev immediately and note the violations in a ticket"
        isCorrect: false
      - id: "b"
        text: "Ask a human reviewer to decide whether the violations are acceptable"
        isCorrect: false
      - id: "c"
        text: "The agent revises the design to resolve violations and re-validates before human review"
        isCorrect: true
      - id: "d"
        text: "Disable the OPA constraint that is failing and retry"
        isCorrect: false

  - id: "q4"
    text: "What is the purpose of a ConstraintTemplate in an OPA constraint framework?"
    type: "single-answer"
    marks: 2
    explanation: "A ConstraintTemplate defines the Rego logic once. Operators then create Constraint instances that supply parameters (such as an approved image registry list) without duplicating the Rego logic. This keeps policy logic in one place."
    options:
      - id: "a"
        text: "It stores the list of approved container image registries"
        isCorrect: false
      - id: "b"
        text: "It defines the reusable Rego logic that Constraint instances parameterise"
        isCorrect: true
      - id: "c"
        text: "It generates violation messages automatically without writing Rego"
        isCorrect: false
      - id: "d"
        text: "It maps Meshery environments to OPA server endpoints"
        isCorrect: false

  - id: "q5"
    text: "Which of the following accurately describes the three phases of Meshery's validation pipeline in order?"
    type: "single-answer"
    marks: 2
    explanation: "Meshery validates in sequence: (1) JSON Schema validation of component fields, (2) relationship evaluation against the design graph, (3) OPA constraint evaluation of field-level rules. All three must pass for a design to be policy-conformant."
    options:
      - id: "a"
        text: "OPA evaluation, then schema validation, then relationship evaluation"
        isCorrect: false
      - id: "b"
        text: "Schema validation, then relationship evaluation, then OPA constraint evaluation"
        isCorrect: true
      - id: "c"
        text: "Relationship evaluation, then OPA evaluation, then schema validation"
        isCorrect: false
      - id: "d"
        text: "Schema validation only - relationship and OPA checks are optional"
        isCorrect: false

  - id: "q6"
    text: "Why should policy constraint sets be stored in version control alongside infrastructure definitions?"
    type: "short-answer"
    marks: 2
    correctAnswer: "So policy changes are reviewed, tracked, and distributed consistently - the same practices applied to application code"
    case_sensitive: false
    explanation: "Storing policy as code in version control enables review (pull requests), change history, and consistent distribution through tools like the Meshery Catalog - ensuring that new or updated constraints are applied uniformly without manual coordination."
---
