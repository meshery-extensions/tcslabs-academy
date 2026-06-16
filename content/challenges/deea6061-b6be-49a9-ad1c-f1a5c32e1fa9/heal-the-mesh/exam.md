---
title: "Heal the Mesh - Exam"
passPercentage: 70
timeLimit: 20
type: "test"
questions:
  - id: "q1"
    text: "Why keep the agent read-only during diagnosis?"
    type: "single-answer"
    marks: 2
    explanation: "Read-only diagnosis has minimal blast radius; changes are made only after a human approves a proposed fix."
    options:
      - id: "a"
        text: "Read-only is slower, which is safer"
        isCorrect: false
      - id: "b"
        text: "To minimize blast radius until a human approves a fix"
        isCorrect: true
      - id: "c"
        text: "Because kubectl cannot make changes"
        isCorrect: false
      - id: "d"
        text: "To save tokens"
        isCorrect: false
  - id: "q2"
    text: "Which signals help diagnose an unhealthy workload? (Select all that apply.)"
    type: "multiple-answers"
    marks: 3
    explanation: "Pod status, deployment description, recent events, and logs are all diagnostic signals. The model's training date is irrelevant."
    options:
      - id: "a"
        text: "Pod status and restart counts"
        isCorrect: true
      - id: "b"
        text: "kubectl describe / events"
        isCorrect: true
      - id: "c"
        text: "Container logs"
        isCorrect: true
      - id: "d"
        text: "The model's training cutoff date"
        isCorrect: false
  - id: "q3"
    text: "A pod shows ImagePullBackOff. What is the most likely root cause?"
    type: "single-answer"
    marks: 2
    explanation: "ImagePullBackOff means the image reference cannot be pulled - commonly a wrong/nonexistent tag or registry auth issue."
    options:
      - id: "a"
        text: "The image tag is wrong or the image cannot be pulled"
        isCorrect: true
      - id: "b"
        text: "The Service has too many ports"
        isCorrect: false
      - id: "c"
        text: "The namespace is missing a label"
        isCorrect: false
      - id: "d"
        text: "The cluster is out of disk"
        isCorrect: false
  - id: "q4"
    text: "Before approving the agent's proposed fix, what should you check?"
    type: "single-answer"
    marks: 2
    explanation: "Confirm the fix actually matches the evidence/root cause - do not approve a plausible-looking change that is not supported by the signals."
    options:
      - id: "a"
        text: "That the fix matches the evidence and root cause"
        isCorrect: true
      - id: "b"
        text: "That it is the longest option"
        isCorrect: false
      - id: "c"
        text: "Nothing; approve everything"
        isCorrect: false
      - id: "d"
        text: "That it deletes the namespace"
        isCorrect: false
  - id: "q5"
    text: "Which command confirms the workload recovered?"
    type: "short-answer"
    marks: 2
    correctAnswer: "kubectl rollout status"
    case_sensitive: false
    explanation: "kubectl rollout status deploy/api confirms the Deployment returned to a healthy, complete rollout."
  - id: "q6"
    text: "What is the purpose of a blameless postmortem?"
    type: "single-answer"
    marks: 2
    explanation: "It captures what happened and how to prevent recurrence without assigning individual blame, turning incidents into guardrails."
    options:
      - id: "a"
        text: "To assign blame to an individual"
        isCorrect: false
      - id: "b"
        text: "To learn what happened and prevent recurrence without blame"
        isCorrect: true
      - id: "c"
        text: "To satisfy the agent"
        isCorrect: false
      - id: "d"
        text: "To delete the incident record"
        isCorrect: false
---
