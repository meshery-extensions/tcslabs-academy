---
title: "Course Test"
passPercentage: 70
type: "test"
questions:
  - id: "q1"
    text: "What are the four phases of the closed-loop remediation pattern, in correct order?"
    type: "single-answer"
    marks: 2
    explanation: "The correct order is detect, decide, act, verify. Detect surfaces the signal, decide produces the proposed action, act executes it, and verify confirms the condition has resolved. Skipping any phase produces an incomplete remediation loop."
    options:
      - id: "a"
        text: "Decide, detect, act, verify"
        isCorrect: false
      - id: "b"
        text: "Detect, decide, act, verify"
        isCorrect: true
      - id: "c"
        text: "Detect, act, decide, verify"
        isCorrect: false
      - id: "d"
        text: "Detect, decide, verify, act"
        isCorrect: false
  - id: "q2"
    text: "Which of the following best describes why agent-driven remediation adds value beyond Kubernetes' built-in self-healing?"
    type: "single-answer"
    marks: 2
    explanation: "Kubernetes controllers are narrow by design - they handle single-resource state transitions. Agents add value in the decide phase by correlating signals across multiple resources and services, consulting runbooks, and distinguishing transient from sustained failures - capabilities controllers cannot express."
    options:
      - id: "a"
        text: "Agents restart pods faster than the kubelet restart policy"
        isCorrect: false
      - id: "b"
        text: "Agents can correlate signals across multiple services and apply runbook reasoning to produce targeted remediation proposals"
        isCorrect: true
      - id: "c"
        text: "Agents bypass approval gates to resolve incidents more quickly"
        isCorrect: false
      - id: "d"
        text: "Agents replace the HorizontalPodAutoscaler for scaling decisions"
        isCorrect: false
  - id: "q3"
    text: "A remediation proposal must include which of the following to satisfy the approval gate requirements described in this course?"
    type: "multiple-answers"
    marks: 2
    explanation: "A complete approval proposal requires the trigger description, root cause summary, proposed action command, rollback command, and risk tier classification. These give the reviewer enough context to make an informed decision without reading raw logs."
    options:
      - id: "a"
        text: "Root cause summary"
        isCorrect: true
      - id: "b"
        text: "Rollback command"
        isCorrect: true
      - id: "c"
        text: "The full cluster event log"
        isCorrect: false
      - id: "d"
        text: "Risk tier classification"
        isCorrect: true
  - id: "q4"
    text: "What is the correct mesheryctl command to import the policy guardrails design used in the approval gate workflow?"
    type: "single-answer"
    marks: 2
    explanation: "The correct command is mesheryctl design import -f designs/policy-guardrails.yaml -s \"Kubernetes Manifest\". The -f flag specifies the file path and -s specifies the source type. This design contains the OPA policies that express which risk tiers require human approval in which environments."
    options:
      - id: "a"
        text: "mesheryctl design apply -f designs/policy-guardrails.yaml"
        isCorrect: false
      - id: "b"
        text: "mesheryctl design import -f designs/policy-guardrails.yaml -s \"Kubernetes Manifest\""
        isCorrect: true
      - id: "c"
        text: "mesheryctl system apply -f designs/policy-guardrails.yaml"
        isCorrect: false
      - id: "d"
        text: "mesheryctl design import designs/policy-guardrails.yaml"
        isCorrect: false
  - id: "q5"
    text: "Which metric measures whether agents are triggering remediations on conditions that would have resolved on their own?"
    type: "single-answer"
    marks: 2
    explanation: "The false-positive rate measures the percentage of triggered remediations where the agent acted on a condition that was not actually a problem or would have self-resolved. A high false-positive rate trains reviewers to dismiss approval requests, eroding the entire oversight model."
    options:
      - id: "a"
        text: "Remediation success rate"
        isCorrect: false
      - id: "b"
        text: "Mean time to recover (MTTR)"
        isCorrect: false
      - id: "c"
        text: "False-positive rate"
        isCorrect: true
      - id: "d"
        text: "Rollback rate"
        isCorrect: false
  - id: "q6"
    text: "According to the autonomy expansion model in this course, which tier of remediation action should ALWAYS require human approval regardless of autonomy stage?"
    type: "single-answer"
    marks: 2
    explanation: "Critical-tier actions - those that modify RBAC, network policies, or cluster-level configuration - should always require human approval at every autonomy stage. The blast radius is cluster-wide and the failure modes are too varied for full automation to be responsible, regardless of how good the safety metrics are."
    options:
      - id: "a"
        text: "Low-risk actions like restarting a stateless pod"
        isCorrect: false
      - id: "b"
        text: "Medium-risk actions like changing a ConfigMap"
        isCorrect: false
      - id: "c"
        text: "High-risk actions like deleting a PersistentVolumeClaim"
        isCorrect: false
      - id: "d"
        text: "Critical-tier actions like modifying RBAC or network policies"
        isCorrect: true
---
