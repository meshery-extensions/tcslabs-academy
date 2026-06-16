---
title: "Module Quiz"
passPercentage: 70
type: "test"
questions:
  - id: "q1"
    text: "In the agent deploy loop, at what point must the design be committed to Git?"
    type: "single-answer"
    marks: 2
    explanation: "Git must be committed before any apply step so that the source of truth is updated before cluster state changes. The dry-run and apply both happen after the commit."
    options:
      - id: "a"
        text: "After the dry-run passes and human approval is granted"
        isCorrect: false
      - id: "b"
        text: "Before the dry-run, as soon as the design file is ready"
        isCorrect: true
      - id: "c"
        text: "After the deploy completes successfully"
        isCorrect: false
      - id: "d"
        text: "Git commit is optional if mesheryctl is used directly"
        isCorrect: false
  - id: "q2"
    text: "Which kubectl flag should be preferred for a dry-run because it passes through admission webhooks and OPA/Gatekeeper policies?"
    type: "single-answer"
    marks: 2
    explanation: "--dry-run=server sends the request to the API server, which exercises admission webhooks and policy checks. --dry-run=client validates only client-side and does not exercise server-side policies."
    options:
      - id: "a"
        text: "--dry-run=client"
        isCorrect: false
      - id: "b"
        text: "--dry-run=server"
        isCorrect: true
      - id: "c"
        text: "--validate=true"
        isCorrect: false
      - id: "d"
        text: "--force"
        isCorrect: false
  - id: "q3"
    text: "What does MeshSync do after a design is deployed to the cluster?"
    type: "single-answer"
    marks: 2
    explanation: "MeshSync continuously observes cluster state and reports it back to Meshery Server. This is how Meshery knows whether the live cluster matches the intended design."
    options:
      - id: "a"
        text: "It generates a new design YAML from current cluster state"
        isCorrect: false
      - id: "b"
        text: "It applies the design to the cluster on a schedule"
        isCorrect: false
      - id: "c"
        text: "It continuously reconciles observed cluster state with Meshery's design view"
        isCorrect: true
      - id: "d"
        text: "It pushes design changes back to the Git repository"
        isCorrect: false
  - id: "q4"
    text: "When rolling back a failed deploy in a GitOps workflow, which of the following actions are part of the correct procedure?"
    type: "multiple-answers"
    marks: 3
    explanation: "The correct rollback sequence is: use kubectl rollout undo as an emergency stop, then revert the Git commit to restore the source of truth, then re-apply the reverted design so Git, Meshery, and the cluster are all aligned."
    options:
      - id: "a"
        text: "Run kubectl rollout undo as an emergency stop to restore the previous ReplicaSet"
        isCorrect: true
      - id: "b"
        text: "Revert the broken commit in Git with git revert"
        isCorrect: true
      - id: "c"
        text: "Re-import and re-apply the reverted design via mesheryctl and kubectl"
        isCorrect: true
      - id: "d"
        text: "Skip the dry-run on the retry to save time"
        isCorrect: false
---
