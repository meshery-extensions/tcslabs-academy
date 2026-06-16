---
title: "Module Quiz"
passPercentage: 70
type: "test"
questions:
  - id: "q1"
    text: "Which phase of the closed-loop remediation pattern is responsible for determining what action to take after a signal is received?"
    type: "single-answer"
    marks: 2
    explanation: "The decide phase is where the system or agent reasons over the triggering signal and cluster state to produce a proposed remediation action. Detect surfaces the signal, act executes the chosen action, and verify confirms the outcome."
    options:
      - id: "a"
        text: "Detect"
        isCorrect: false
      - id: "b"
        text: "Decide"
        isCorrect: true
      - id: "c"
        text: "Act"
        isCorrect: false
      - id: "d"
        text: "Verify"
        isCorrect: false
  - id: "q2"
    text: "Which of the following failure modes does Kubernetes handle natively without requiring agent-driven remediation?"
    type: "multiple-answers"
    marks: 2
    explanation: "Kubernetes' kubelet restart policy handles container crashes, and the ReplicaSet controller maintains desired replica counts. Cross-service dependency failures and actions requiring runbook reasoning both require agent involvement because they cannot be expressed as single-resource state transitions."
    options:
      - id: "a"
        text: "Container crash (restart policy)"
        isCorrect: true
      - id: "b"
        text: "Replica count drift (ReplicaSet controller)"
        isCorrect: true
      - id: "c"
        text: "Cross-service dependency failure requiring runbook lookup"
        isCorrect: false
      - id: "d"
        text: "Proposing a rollback and waiting for human approval"
        isCorrect: false
  - id: "q3"
    text: "According to the risk classification in this module, which action requires a mandatory human approval gate?"
    type: "single-answer"
    marks: 2
    explanation: "Deleting a PersistentVolumeClaim is classified as high risk because the action may be irreversible and affects persistent state. Restarting a single stateless pod is low risk and can be automated. Scaling a stateless deployment up by one replica is also low risk."
    options:
      - id: "a"
        text: "Restarting a single stateless pod"
        isCorrect: false
      - id: "b"
        text: "Scaling a stateless deployment up by one replica"
        isCorrect: false
      - id: "c"
        text: "Deleting a PersistentVolumeClaim"
        isCorrect: true
      - id: "d"
        text: "Applying a resource limit increase to a running deployment"
        isCorrect: false
  - id: "q4"
    text: "What is the recommended target rollback rate threshold before expanding a remediation action to full automation (no approval gate)?"
    type: "single-answer"
    marks: 2
    explanation: "A rollback rate below 3% is the threshold for actions considered safe to fully automate. Above 5% indicates the agent is executing actions on incorrect diagnoses or the actions are not appropriate for the failure modes being encountered."
    options:
      - id: "a"
        text: "Below 10%"
        isCorrect: false
      - id: "b"
        text: "Below 5%"
        isCorrect: false
      - id: "c"
        text: "Below 3%"
        isCorrect: true
      - id: "d"
        text: "Below 1%"
        isCorrect: false
---
