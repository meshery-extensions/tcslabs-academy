---
title: "CAINP Capstone - Exam"
passPercentage: 70
timeLimit: 40
type: "test"
questions:
  - id: "q1"
    text: "In the Model Context Protocol, what is a 'tool'?"
    type: "single-answer"
    marks: 2
    explanation: "An MCP tool is a callable capability the server exposes to a client/agent (with a typed input/output schema) that the agent can invoke to take an action or fetch data."
    options:
      - id: "a"
        text: "A callable capability the server exposes for an agent to invoke"
        isCorrect: true
      - id: "b"
        text: "A Kubernetes CRD"
        isCorrect: false
      - id: "c"
        text: "A Grafana dashboard panel"
        isCorrect: false
      - id: "d"
        text: "A type of load generator"
        isCorrect: false
  - id: "q2"
    text: "Why start an MCP tool for operations as read-only?"
    type: "single-answer"
    marks: 2
    explanation: "Read-only access lets an agent observe and diagnose with minimal blast radius; write/mutating capabilities are added deliberately, behind approval, once trust is established."
    options:
      - id: "a"
        text: "Read-only tools are faster to build and require no schema"
        isCorrect: false
      - id: "b"
        text: "It minimizes blast radius while the agent observes and diagnoses"
        isCorrect: true
      - id: "c"
        text: "Kubernetes does not allow write access from agents"
        isCorrect: false
      - id: "d"
        text: "Read-only tools cannot be audited"
        isCorrect: false
  - id: "q3"
    text: "Which signals would you use to detect that a Deployment rollout is failing? (Select all that apply.)"
    type: "multiple-answers"
    marks: 3
    explanation: "Rollout status, pod/replica readiness, and Kubernetes events all indicate a failing rollout. The model's token count is irrelevant to workload health."
    options:
      - id: "a"
        text: "rollout status / available vs. desired replicas"
        isCorrect: true
      - id: "b"
        text: "Pod readiness and restart counts"
        isCorrect: true
      - id: "c"
        text: "Kubernetes events for the workload"
        isCorrect: true
      - id: "d"
        text: "The number of tokens in the agent's prompt"
        isCorrect: false
  - id: "q4"
    text: "What is the purpose of an approval gate in an agent-driven remediation loop?"
    type: "single-answer"
    marks: 2
    explanation: "An approval gate keeps a human in the loop: the agent proposes a change (as a diff), and a person reviews and authorizes it before it is applied."
    options:
      - id: "a"
        text: "To make the agent run faster"
        isCorrect: false
      - id: "b"
        text: "To require human review and authorization before a change is applied"
        isCorrect: true
      - id: "c"
        text: "To disable Meshery validation"
        isCorrect: false
      - id: "d"
        text: "To increase the model's context window"
        isCorrect: false
  - id: "q5"
    text: "Which Meshery capability measures latency and throughput of an endpoint over repeatable runs?"
    type: "single-answer"
    marks: 2
    explanation: "Meshery Performance Profiles drive load (via fortio/wrk2/nighthawk) and record latency, throughput, and error rate, and can be compared over time."
    options:
      - id: "a"
        text: "Performance Profiles"
        isCorrect: true
      - id: "b"
        text: "MeshSync"
        isCorrect: false
      - id: "c"
        text: "Relationships"
        isCorrect: false
      - id: "d"
        text: "Workspaces"
        isCorrect: false
  - id: "q6"
    text: "Name one load generator Meshery can use for performance testing."
    type: "short-answer"
    marks: 2
    correctAnswer: "fortio"
    case_sensitive: false
    explanation: "Meshery supports fortio, wrk2, and nighthawk as load generators."
  - id: "q7"
    text: "What does 'least privilege' mean for an automation/agent identity?"
    type: "single-answer"
    marks: 2
    explanation: "Grant only the permissions required for the task and nothing more, reducing the damage a mistake or compromise can cause."
    options:
      - id: "a"
        text: "Grant cluster-admin so the agent never gets blocked"
        isCorrect: false
      - id: "b"
        text: "Grant only the permissions required for the task, and no more"
        isCorrect: true
      - id: "c"
        text: "Share one token across all agents"
        isCorrect: false
      - id: "d"
        text: "Disable RBAC for automation namespaces"
        isCorrect: false
  - id: "q8"
    text: "Why is an audit trail essential when agents make infrastructure changes?"
    type: "single-answer"
    marks: 2
    explanation: "An audit trail records who/what changed, when, and why - essential for accountability, debugging, rollback, and compliance."
    options:
      - id: "a"
        text: "It speeds up model inference"
        isCorrect: false
      - id: "b"
        text: "It records what changed, when, and by whom for accountability and rollback"
        isCorrect: true
      - id: "c"
        text: "It is only needed for GPU workloads"
        isCorrect: false
      - id: "d"
        text: "It replaces the need for backups"
        isCorrect: false
  - id: "q9"
    text: "A NetworkPolicy with podSelector {} and policyTypes [Ingress] and no ingress rules does what?"
    type: "single-answer"
    marks: 2
    explanation: "It selects all pods in the namespace and, with no ingress rules, denies all ingress - a default-deny posture."
    options:
      - id: "a"
        text: "Allows all ingress to all pods"
        isCorrect: false
      - id: "b"
        text: "Denies all ingress to all pods in the namespace (default-deny)"
        isCorrect: true
      - id: "c"
        text: "Has no effect"
        isCorrect: false
      - id: "d"
        text: "Blocks all egress"
        isCorrect: false
  - id: "q10"
    text: "True or false: comparing a post-remediation Performance Profile against a saved baseline is a valid way to confirm a workload recovered."
    type: "short-answer"
    marks: 2
    correctAnswer: "true"
    case_sensitive: false
    explanation: "Comparing against a saved baseline confirms the workload returned to expected latency/throughput, catching partial or silent regressions."
---
