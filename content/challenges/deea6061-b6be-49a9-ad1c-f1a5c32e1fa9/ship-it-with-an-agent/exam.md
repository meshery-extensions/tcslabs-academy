---
title: "Ship It with an Agent - Exam"
passPercentage: 70
timeLimit: 20
type: "test"
questions:
  - id: "q1"
    text: "Which command imports the demo design into Meshery?"
    type: "single-answer"
    marks: 2
    explanation: "mesheryctl design import -f <file> -s \"Kubernetes Manifest\" imports a Kubernetes manifest as a design."
    options:
      - id: "a"
        text: "mesheryctl design import -f <file> -s \"Kubernetes Manifest\""
        isCorrect: true
      - id: "b"
        text: "kubectl meshery deploy <file>"
        isCorrect: false
      - id: "c"
        text: "helm install demo <file>"
        isCorrect: false
      - id: "d"
        text: "mesheryctl apply -f <file>"
        isCorrect: false
  - id: "q2"
    text: "What is the correct topology of the microservices demo?"
    type: "single-answer"
    marks: 2
    explanation: "The frontend calls the api, which uses redis as a cache."
    options:
      - id: "a"
        text: "frontend -> api -> redis"
        isCorrect: true
      - id: "b"
        text: "redis -> frontend -> api"
        isCorrect: false
      - id: "c"
        text: "api -> frontend -> redis"
        isCorrect: false
      - id: "d"
        text: "They are unrelated"
        isCorrect: false
  - id: "q3"
    text: "Before the agent applies changes, what belongs in its runbook?"
    type: "multiple-answers"
    marks: 3
    explanation: "A dry-run/diff, an explicit approval gate, and post-deploy verification are all part of a safe runbook. 'Skip verification' is not."
    options:
      - id: "a"
        text: "Show a dry-run / diff first"
        isCorrect: true
      - id: "b"
        text: "Wait for human approval"
        isCorrect: true
      - id: "c"
        text: "Verify rollout and report status"
        isCorrect: true
      - id: "d"
        text: "Skip verification to be fast"
        isCorrect: false
  - id: "q4"
    text: "Which command confirms a Deployment finished rolling out?"
    type: "short-answer"
    marks: 2
    correctAnswer: "kubectl rollout status"
    case_sensitive: false
    explanation: "kubectl rollout status deploy/<name> reports when a Deployment is complete."
  - id: "q5"
    text: "In which namespace does the demo deploy?"
    type: "short-answer"
    marks: 2
    correctAnswer: "tcslabs-demo"
    case_sensitive: false
    explanation: "The design creates and uses the tcslabs-demo namespace."
  - id: "q6"
    text: "Why open the design in Kanvas before deploying?"
    type: "single-answer"
    marks: 2
    explanation: "Kanvas lets you visualize and validate the topology and catch issues before deploying - a human-in-the-loop checkpoint."
    options:
      - id: "a"
        text: "To visualize and validate the topology before deploying"
        isCorrect: true
      - id: "b"
        text: "To train a model"
        isCorrect: false
      - id: "c"
        text: "To build container images"
        isCorrect: false
      - id: "d"
        text: "It is required to run kubectl"
        isCorrect: false
---
