---
title: "Course Test"
passPercentage: 70
type: "test"
questions:
  - id: "q1"
    text: "A platform engineer needs to demonstrate to an auditor that a production infrastructure change was authorized before it was applied. Which artifact provides the clearest evidence of authorization?"
    type: "single-answer"
    marks: 2
    explanation: "A Git merge commit from a branch protected by pull request approval requirements records who proposed the change, who reviewed it, and when it was merged - providing the authorization chain auditors need."
    options:
      - id: "a"
        text: "The Meshery design YAML file as it exists in the repository at the time of audit"
        isCorrect: false
      - id: "b"
        text: "A Git merge commit from a branch that required pull request approval before merging"
        isCorrect: true
      - id: "c"
        text: "A MeshSync observation snapshot taken after the deployment"
        isCorrect: false
      - id: "d"
        text: "The output of mesheryctl system check run on the day of the change"
        isCorrect: false

  - id: "q2"
    text: "Which command imports a design file into Meshery for policy evaluation and versioning?"
    type: "single-answer"
    marks: 2
    explanation: "The mesheryctl design import command with the -f flag for the file path and -s for the source type is the correct way to bring a design into Meshery where it will be versioned and evaluated."
    options:
      - id: "a"
        text: "mesheryctl design apply -f designs/policy-guardrails.yaml"
        isCorrect: false
      - id: "b"
        text: "mesheryctl system start --design policy-guardrails.yaml"
        isCorrect: false
      - id: "c"
        text: "mesheryctl design import -f designs/policy-guardrails.yaml -s \"Kubernetes Manifest\""
        isCorrect: true
      - id: "d"
        text: "mesheryctl perf apply -f designs/policy-guardrails.yaml"
        isCorrect: false

  - id: "q3"
    text: "In the five-layer operating model presented in this course, what is the role of the MCP server in the agent integration layer?"
    type: "single-answer"
    marks: 2
    explanation: "The Meshery MCP server exposes platform capabilities to coding agents through a standard interface. Every agent action through MCP is subject to the same policy evaluation and logging as human operator actions - the platform is the trust boundary, not the agent."
    options:
      - id: "a"
        text: "It stores the agent's reasoning history as a compliance artifact"
        isCorrect: false
      - id: "b"
        text: "It lets the agent bypass Meshery's policy checks to operate faster"
        isCorrect: false
      - id: "c"
        text: "It exposes Meshery capabilities to agents through a standard interface while enforcing the same policy and logging controls that apply to human operators"
        isCorrect: true
      - id: "d"
        text: "It replaces MeshSync for drift detection in agent-managed clusters"
        isCorrect: false

  - id: "q4"
    text: "What is the correct remediation path when an unmanaged resource is detected in a production cluster that represents an unauthorized out-of-band change?"
    type: "single-answer"
    marks: 2
    explanation: "Reconciling the cluster to its intended state by re-applying the Meshery design produces a new attestation event. This restores compliance posture and creates an audit trail that covers both the drift event and the remediation action."
    options:
      - id: "a"
        text: "Delete the resource immediately using kubectl without logging the action"
        isCorrect: false
      - id: "b"
        text: "Re-apply the Meshery design that represents the desired state, which produces a reconciliation attestation event"
        isCorrect: true
      - id: "c"
        text: "Disable MeshSync temporarily to stop generating drift alerts"
        isCorrect: false
      - id: "d"
        text: "Import the unmanaged resource into a new design without running policy validation"
        isCorrect: false

  - id: "q5"
    text: "Which of the following represent failure modes that degrade the AI-native operating model described in this course? Select all that apply."
    type: "multiple-answers"
    marks: 2
    explanation: "All three represent breaks in the operating model: bypassing Meshery removes the evidence chain, removing human-in-the-loop gates eliminates authorization records for high-stakes agent actions, and a disconnected MeshSync means drift goes undetected and the compliance posture is unknown."
    options:
      - id: "a"
        text: "Making cluster changes directly with kubectl without an associated Meshery design"
        isCorrect: true
      - id: "b"
        text: "Removing human-in-the-loop approval gates from agent workflows to increase deployment speed"
        isCorrect: true
      - id: "c"
        text: "MeshSync becoming disconnected so drift events are not reported"
        isCorrect: true
      - id: "d"
        text: "Running mesheryctl system check before applying a new design"
        isCorrect: false

  - id: "q6"
    text: "What does 'continuous compliance' mean in the context of this course, and how does it differ from a point-in-time audit?"
    type: "short-answer"
    marks: 2
    correctAnswer: "continuous compliance"
    case_sensitive: false
    explanation: "Continuous compliance means the platform evaluates and records its compliance posture in real time - policies run on every design change, MeshSync detects drift as it occurs, and evidence accumulates continuously. A point-in-time audit collects evidence for a fixed period and presents it periodically. Continuous compliance makes the platform permanently audit-ready rather than audit-ready only after evidence is manually assembled."
---
