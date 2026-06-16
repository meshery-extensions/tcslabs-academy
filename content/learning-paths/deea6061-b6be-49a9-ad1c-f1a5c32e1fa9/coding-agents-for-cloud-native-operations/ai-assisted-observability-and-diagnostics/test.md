---
title: "Course Test"
passPercentage: 70
type: "test"
questions:
  - id: "q1"
    text: "Which command imports the observability stack design into Meshery using the Kubernetes Manifest source type?"
    type: "single-answer"
    marks: 2
    explanation: "The correct command uses mesheryctl design import with the -f flag for the file path and -s flag to specify the source type 'Kubernetes Manifest'. This is how all importable academy designs are loaded into Meshery."
    options:
      - id: "a"
        text: "mesheryctl system start -f designs/observability-stack.yaml"
        isCorrect: false
      - id: "b"
        text: "mesheryctl design import -f designs/observability-stack.yaml -s \"Kubernetes Manifest\""
        isCorrect: true
      - id: "c"
        text: "mesheryctl perf apply -f designs/observability-stack.yaml"
        isCorrect: false
      - id: "d"
        text: "mesheryctl design apply designs/observability-stack.yaml"
        isCorrect: false
  - id: "q2"
    text: "What are the four primary signal categories that Meshery surfaces for observability?"
    type: "multiple-answers"
    marks: 2
    explanation: "Meshery surfaces MeshSync reconciled cluster state, component and workload status (lifecycle conditions), Kubernetes events captured durably, and performance metrics via the Prometheus and Grafana integration. These four categories together form the signal foundation for agent-driven diagnostics."
    options:
      - id: "a"
        text: "MeshSync state"
        isCorrect: true
      - id: "b"
        text: "Component and workload status"
        isCorrect: true
      - id: "c"
        text: "Git commit history"
        isCorrect: false
      - id: "d"
        text: "Kubernetes events"
        isCorrect: true
      - id: "e"
        text: "Metrics via the Prometheus and Grafana integration"
        isCorrect: true
  - id: "q3"
    text: "Why should an agent be instructed NOT to suggest remediation steps during the diagnostic analysis phase?"
    type: "single-answer"
    marks: 2
    explanation: "Mixing diagnosis and remediation causes the agent to bias its hypotheses toward conclusions that justify its preferred fix, rather than following the evidence impartially. Diagnostic and remediation phases must be kept separate to preserve analytical rigor."
    options:
      - id: "a"
        text: "Because the agent cannot understand remediation steps"
        isCorrect: false
      - id: "b"
        text: "Because remediation steps are always wrong and should never be automated"
        isCorrect: false
      - id: "c"
        text: "Because mixing diagnosis and remediation biases the agent toward conclusions that justify its preferred fix rather than following the evidence"
        isCorrect: true
      - id: "d"
        text: "Because Meshery handles all remediation automatically through MeshSync"
        isCorrect: false
  - id: "q4"
    text: "When an agent's hypothesis is falsified by a test result, what is the correct next step?"
    type: "single-answer"
    marks: 2
    explanation: "When a hypothesis is falsified, you return to the hypothesis-formation phase: give the agent the test result and ask it to re-rank the remaining hypotheses with the new information. This loop continues until a hypothesis is confirmed or all candidates are exhausted."
    options:
      - id: "a"
        text: "Accept the next hypothesis on the list without further analysis"
        isCorrect: false
      - id: "b"
        text: "Restart the entire diagnostic process from scratch"
        isCorrect: false
      - id: "c"
        text: "Give the agent the test result and ask it to re-rank the remaining hypotheses"
        isCorrect: true
      - id: "d"
        text: "Escalate immediately to a rollback without further diagnosis"
        isCorrect: false
  - id: "q5"
    text: "Which kubectl flag retrieves logs from the previous container instance of a restarted Pod, which often contains the actual crash reason?"
    type: "single-answer"
    marks: 2
    explanation: "The --previous flag on kubectl logs retrieves logs from the prior (terminated) container instance. This is critical when a Pod has restarted, because the current container's logs start fresh from after the crash."
    options:
      - id: "a"
        text: "--last-crash"
        isCorrect: false
      - id: "b"
        text: "--restart-logs"
        isCorrect: false
      - id: "c"
        text: "--previous"
        isCorrect: true
      - id: "d"
        text: "--history"
        isCorrect: false
  - id: "q6"
    text: "A symptom is best defined as which of the following?"
    type: "single-answer"
    marks: 2
    explanation: "A symptom is a specific, observable deviation from expected behavior with a defined time reference. Vague statements like 'the service is slow' are not symptoms - they are impressions. Precise symptoms enable focused signal gathering and grounded hypothesis formation."
    options:
      - id: "a"
        text: "A guess about what caused the incident based on past experience"
        isCorrect: false
      - id: "b"
        text: "A specific, observable deviation from expected behavior with a defined time reference"
        isCorrect: true
      - id: "c"
        text: "A remediation step that has not yet been applied"
        isCorrect: false
      - id: "d"
        text: "An LLM-generated hypothesis about the root cause of an error"
        isCorrect: false
---
