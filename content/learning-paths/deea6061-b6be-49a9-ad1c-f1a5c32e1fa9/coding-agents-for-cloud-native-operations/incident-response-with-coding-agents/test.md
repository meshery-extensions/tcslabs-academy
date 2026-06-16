---
title: "Course Test"
passPercentage: 70
type: "test"
questions:
  - id: "q1"
    text: "Which incident triage phase must always have a human make the final call, even when the agent has produced a severity assessment?"
    type: "single-answer"
    marks: 2
    explanation: "Severity level drives escalation paths, stakeholder communication, and decision authority. The agent provides evidence; only a human assigns the severity tier because that decision has organizational and contractual consequences."
    options:
      - id: "a"
        text: "Detect"
        isCorrect: false
      - id: "b"
        text: "Assess Severity"
        isCorrect: true
      - id: "c"
        text: "Diagnose"
        isCorrect: false
      - id: "d"
        text: "Stabilize"
        isCorrect: false

  - id: "q2"
    text: "Why should every write operation in an agent runbook be preceded by an approval point?"
    type: "single-answer"
    marks: 2
    explanation: "Write operations change production state. The blast radius of an incorrect write during an incident can exceed the blast radius of the original failure. Human approval ensures situational judgment governs each state change."
    options:
      - id: "a"
        text: "To give the agent time to re-read the runbook before executing"
        isCorrect: false
      - id: "b"
        text: "Because Kubernetes rejects writes that are not preceded by a human confirmation flag"
        isCorrect: false
      - id: "c"
        text: "Because write operations change production state and a wrong action can worsen the incident"
        isCorrect: true
      - id: "d"
        text: "To satisfy audit logging requirements imposed by Meshery Operator"
        isCorrect: false

  - id: "q3"
    text: "Which mesheryctl command records a corrected configuration in Meshery for audit trail purposes after a fix is applied?"
    type: "single-answer"
    marks: 2
    explanation: "mesheryctl design import -f <file> -s 'Kubernetes Manifest' imports a manifest as a Meshery design, making the intended state visible in Kanvas and queryable via the Meshery API."
    options:
      - id: "a"
        text: "mesheryctl system check"
        isCorrect: false
      - id: "b"
        text: "mesheryctl perf apply"
        isCorrect: false
      - id: "c"
        text: "mesheryctl design import -f designs/microservices-demo.yaml -s \"Kubernetes Manifest\""
        isCorrect: true
      - id: "d"
        text: "mesheryctl system start"
        isCorrect: false

  - id: "q4"
    text: "What is the purpose of a stop condition in an agent runbook?"
    type: "single-answer"
    marks: 2
    explanation: "Stop conditions terminate runbook execution when the environment has moved outside the runbook's designed scope. Without them, an agent will continue executing steps even when conditions make further execution dangerous or undefined."
    options:
      - id: "a"
        text: "To pause the runbook until a Prometheus alert clears"
        isCorrect: false
      - id: "b"
        text: "To terminate runbook execution when the environment is outside the runbook's designed scope"
        isCorrect: true
      - id: "c"
        text: "To restart the agent process if it consumes too much memory"
        isCorrect: false
      - id: "d"
        text: "To notify MeshSync that the runbook has completed"
        isCorrect: false

  - id: "q5"
    text: "In the incident walkthrough, what did the on-call engineer independently verify before typing APPROVE?"
    type: "single-answer"
    marks: 2
    explanation: "The engineer independently checked that tag v2.4.0 existed and was healthy in the registry before approving the rollback. This is an example of a human verifying the agent's root cause hypothesis rather than accepting it uncritically."
    options:
      - id: "a"
        text: "That the payments service had no open circuit breakers in the service mesh"
        isCorrect: false
      - id: "b"
        text: "That the target rollback image tag existed and was healthy in the registry"
        isCorrect: true
      - id: "c"
        text: "That Meshery Operator was running and had synced the latest design"
        isCorrect: false
      - id: "d"
        text: "That all three pods had been evicted before issuing the rollback command"
        isCorrect: false

  - id: "q6"
    text: "Which of the following correctly describes how postmortem findings should be converted into durable guardrails?"
    type: "multiple-answers"
    marks: 2
    explanation: "Findings should drive runbook updates (fixing gaps in existing runbooks), policy guardrails (encoding constraints that prevent recurrence), and observability improvements (adding missing signals). All three categories address structural weaknesses surfaced by the incident."
    options:
      - id: "a"
        text: "Update runbooks to fix gaps exposed during the incident - missing stop conditions, late approval points"
        isCorrect: true
      - id: "b"
        text: "Import and extend policy guardrail designs to encode constraints that prevent recurrence"
        isCorrect: true
      - id: "c"
        text: "Delete all runbooks involved in the incident and rewrite them from scratch"
        isCorrect: false
      - id: "d"
        text: "Add missing observability signals so the same failure class is detected sooner next time"
        isCorrect: true
---
