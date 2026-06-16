---
title: "Module Quiz"
passPercentage: 70
type: "test"
questions:
  - id: "q1"
    text: "Which Kubernetes RBAC object grants permissions scoped to a single namespace?"
    type: "single-answer"
    marks: 2
    explanation: "A Role is namespace-scoped, while a ClusterRole is cluster-wide. For agents operating in a specific namespace, a Role is always preferred to minimize scope."
    options:
      - id: "a"
        text: "ClusterRole"
        isCorrect: false
      - id: "b"
        text: "Role"
        isCorrect: true
      - id: "c"
        text: "RoleBinding"
        isCorrect: false
      - id: "d"
        text: "ClusterRoleBinding"
        isCorrect: false
  - id: "q2"
    text: "Which of the following are required elements of a complete audit trail for an agent-executed infrastructure change?"
    type: "multiple-answers"
    marks: 2
    explanation: "A complete audit trail must capture who triggered the action, what was changed, when it happened, and why it was approved. Missing any of these four makes the trail unusable for incident investigation or compliance."
    options:
      - id: "a"
        text: "The agent's identity (who)"
        isCorrect: true
      - id: "b"
        text: "The exact resource diff (what)"
        isCorrect: true
      - id: "c"
        text: "The number of retries attempted"
        isCorrect: false
      - id: "d"
        text: "The reviewer identity and rationale (why)"
        isCorrect: true
  - id: "q3"
    text: "What does a Kubernetes server-side dry-run validate that a client-side dry-run does not?"
    type: "single-answer"
    marks: 2
    explanation: "Server-side dry-run passes the request through the full admission control chain - including OPA validating webhooks and RBAC - without persisting state. Client-side dry-run only checks local schema validity."
    options:
      - id: "a"
        text: "YAML syntax"
        isCorrect: false
      - id: "b"
        text: "Admission control policies and RBAC"
        isCorrect: true
      - id: "c"
        text: "Whether the workload runs correctly after the change"
        isCorrect: false
      - id: "d"
        text: "Network connectivity between pods"
        isCorrect: false
  - id: "q4"
    text: "What is the correct state sequence for an agent circuit breaker?"
    type: "single-answer"
    marks: 2
    explanation: "A circuit breaker transitions from Closed (normal) to Open (error threshold exceeded, actions blocked) to Half-Open (one trial action after operator reset) and back to Closed if the trial succeeds."
    options:
      - id: "a"
        text: "Open -> Closed -> Half-Open"
        isCorrect: false
      - id: "b"
        text: "Closed -> Open -> Half-Open"
        isCorrect: true
      - id: "c"
        text: "Half-Open -> Closed -> Open"
        isCorrect: false
      - id: "d"
        text: "Closed -> Half-Open -> Open"
        isCorrect: false
---
