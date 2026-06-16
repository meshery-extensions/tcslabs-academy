---
title: "Module Quiz"
passPercentage: 70
type: "test"
questions:
  - id: "q1"
    text: "Which phase of the incident triage loop is where a coding agent provides the most value, according to this module?"
    type: "single-answer"
    marks: 2
    explanation: "Diagnosis requires gathering and correlating data from many sources simultaneously - exactly the kind of parallel, context-heavy work where agents outperform human responders working alone."
    options:
      - id: "a"
        text: "Detect"
        isCorrect: false
      - id: "b"
        text: "Assess Severity"
        isCorrect: false
      - id: "c"
        text: "Diagnose"
        isCorrect: true
      - id: "d"
        text: "Resolve"
        isCorrect: false

  - id: "q2"
    text: "Which of the following are required properties of an agent-safe runbook? Select all that apply."
    type: "multiple-answers"
    marks: 2
    explanation: "Agent-safe runbooks must default to read-only operations, include approval points before any write, and define explicit stop conditions that terminate execution when the environment moves out of scope."
    options:
      - id: "a"
        text: "Read-only steps by default, with write steps gated by approval points"
        isCorrect: true
      - id: "b"
        text: "Explicit stop conditions that halt execution when out-of-scope conditions are detected"
        isCorrect: true
      - id: "c"
        text: "Natural-language instructions like 'check if things look normal'"
        isCorrect: false
      - id: "d"
        text: "Specific expected output defined for each read step"
        isCorrect: true

  - id: "q3"
    text: "In the agent-assisted incident walkthrough, what was the root cause of the payments CrashLoopBackOff?"
    type: "single-answer"
    marks: 2
    explanation: "The deployment was referencing image tag v2.4.1-rc3, which had been pushed then deleted during a pre-release pipeline run. The deployment was never reverted, causing ImagePullBackOff across all replicas."
    options:
      - id: "a"
        text: "A misconfigured service mesh policy blocked traffic to the payments pods"
        isCorrect: false
      - id: "b"
        text: "The deployment referenced a container image tag that did not exist in the registry"
        isCorrect: true
      - id: "c"
        text: "A resource quota prevented the pods from being scheduled"
        isCorrect: false
      - id: "d"
        text: "A recent Kubernetes upgrade broke the payments container runtime"
        isCorrect: false

  - id: "q4"
    text: "What must a human do before an LLM-drafted postmortem can be published?"
    type: "multiple-answers"
    marks: 2
    explanation: "Humans must verify factual accuracy against the raw timeline, confirm the root cause reflects actual system knowledge, ensure action items are specific and assignable, and check the document is genuinely blameless."
    options:
      - id: "a"
        text: "Verify every factual claim against the raw incident timeline"
        isCorrect: true
      - id: "b"
        text: "Confirm root cause validity using knowledge of the system's history and design decisions"
        isCorrect: true
      - id: "c"
        text: "Accept the stakeholder summary as-is since LLMs write clearly for non-technical audiences"
        isCorrect: false
      - id: "d"
        text: "Rewrite any action items that lack a specific owner, deliverable, and due date"
        isCorrect: true
---
