---
title: "Module Quiz"
passPercentage: 70
type: "test"
questions:
  - id: "q1"
    text: "What CLI flag tells Meshery to treat an imported file as a Kubernetes manifest?"
    type: "single-answer"
    marks: 2
    explanation: "The -s flag specifies the design source type. 'Kubernetes Manifest' is the correct value when importing standard Kubernetes YAML files."
    options:
      - id: "a"
        text: "-t \"Kubernetes Manifest\""
        isCorrect: false
      - id: "b"
        text: "-s \"Kubernetes Manifest\""
        isCorrect: true
      - id: "c"
        text: "--format kubernetes"
        isCorrect: false
      - id: "d"
        text: "--source-type manifest"
        isCorrect: false
  - id: "q2"
    text: "Which of the following are common LLM mistakes that cause Meshery import or validation failures? Select all that apply."
    type: "multiple-answers"
    marks: 2
    explanation: "Deprecated apiVersions are not recognised by the Meshery registry. A selector that does not match pod template labels fails Kubernetes admission and Meshery relationship validation. Missing resource limits trigger validation warnings. Using correct, stable apiVersions and matching selectors are requirements, not mistakes."
    options:
      - id: "a"
        text: "Using apiVersion extensions/v1beta1 for a Deployment"
        isCorrect: true
      - id: "b"
        text: "Setting selector.matchLabels to a key not present in pod template labels"
        isCorrect: true
      - id: "c"
        text: "Using apiVersion apps/v1 for a Deployment"
        isCorrect: false
      - id: "d"
        text: "Omitting resource requests and limits from container specs"
        isCorrect: true
  - id: "q3"
    text: "When refining a design that fails validation, what is the recommended approach?"
    type: "single-answer"
    marks: 2
    explanation: "Surgical, targeted follow-up prompts that address only the failing document preserve the correct parts of the design and produce a smaller, verifiable change. Regenerating the entire design discards correct work and may repeat the same errors."
    options:
      - id: "a"
        text: "Regenerate the entire design from the original prompt and hope for different output"
        isCorrect: false
      - id: "b"
        text: "Paste only the failing YAML document and the exact error into a follow-up prompt"
        isCorrect: true
      - id: "c"
        text: "Edit the YAML manually without involving the LLM again"
        isCorrect: false
      - id: "d"
        text: "Delete the failing resource and redeploy without it"
        isCorrect: false
  - id: "q4"
    text: "In a Meshery design, what is the correct document order for reliable import?"
    type: "single-answer"
    marks: 2
    explanation: "Meshery's import parser resolves intra-design references in document order. Placing the Namespace first ensures that all subsequent resources can be scoped correctly during parsing."
    options:
      - id: "a"
        text: "Services first, then Deployments, then Namespace"
        isCorrect: false
      - id: "b"
        text: "Deployments first, then Services, then Namespace last"
        isCorrect: false
      - id: "c"
        text: "Namespace first, then Deployments, then Services and supporting resources"
        isCorrect: true
      - id: "d"
        text: "Document order does not matter for Meshery import"
        isCorrect: false
---
