---
title: "Module Quiz"
passPercentage: 70
type: "test"
questions:
  - id: "q1"
    text: "Why should secrets never be passed as literal values into an agent's context window?"
    type: "multiple-answers"
    marks: 2
    explanation: "The context window is not a vault. Values in the context can be echoed in model responses, captured in orchestration logs, or embedded in generated manifests that reach version control. Both logging risk and manifest embedding are direct, documented threats."
    options:
      - id: "a"
        text: "The model may echo the value in its response or explanation"
        isCorrect: true
      - id: "b"
        text: "Kubernetes cannot mount secrets that originate from an LLM context"
        isCorrect: false
      - id: "c"
        text: "The value can be captured in orchestration or MCP server logs"
        isCorrect: true
      - id: "d"
        text: "LLMs automatically redact base64-encoded strings from all outputs"
        isCorrect: false
  - id: "q2"
    text: "Which image reference format correctly pins a container image to an immutable digest?"
    type: "single-answer"
    marks: 2
    explanation: "Mutable tags such as 'latest' or semantic version tags can be overwritten at the registry without changing the manifest. Pinning to a SHA256 digest ensures the exact layer set is locked and cannot change silently."
    options:
      - id: "a"
        text: "ghcr.io/your-org/api:latest"
        isCorrect: false
      - id: "b"
        text: "ghcr.io/your-org/api:v1.4"
        isCorrect: false
      - id: "c"
        text: "ghcr.io/your-org/api@sha256:a3f2c1d4e5b6..."
        isCorrect: true
      - id: "d"
        text: "ghcr.io/your-org/api:stable"
        isCorrect: false
  - id: "q3"
    text: "What is the primary purpose of separating a pipeline into a read identity and a write identity?"
    type: "single-answer"
    marks: 2
    explanation: "Splitting read and write into distinct service accounts limits what a compromised or misbehaving agent can do. The read identity can gather context broadly but cannot modify cluster state. The write identity is activated only for approved operations and can be scoped to the minimum required resource types and verbs."
    options:
      - id: "a"
        text: "To comply with Kubernetes RBAC naming conventions"
        isCorrect: false
      - id: "b"
        text: "To limit the blast radius when an agent behaves unexpectedly, so context gathering and cluster modification are gated separately"
        isCorrect: true
      - id: "c"
        text: "To allow the agent to bypass admission controllers for read operations"
        isCorrect: false
      - id: "d"
        text: "To enable the agent to cache cluster state in a local database"
        isCorrect: false
  - id: "q4"
    text: "Which kubectl command issues a time-bounded service account token valid for 15 minutes?"
    type: "short-answer"
    marks: 2
    explanation: "The TokenRequest API (kubectl create token) generates a short-lived OIDC token for a named service account. Specifying --duration 15m means the token expires automatically without requiring explicit revocation."
    correctAnswer: "kubectl create token meshery-design-applier --namespace meshery-agents --duration 15m"
    case_sensitive: false
---
