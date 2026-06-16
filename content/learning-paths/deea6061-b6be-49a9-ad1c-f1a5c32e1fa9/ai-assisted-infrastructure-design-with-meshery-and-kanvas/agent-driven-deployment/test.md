---
title: "Course Test"
passPercentage: 70
type: "test"
questions:
  - id: "q1"
    text: "What is the correct mesheryctl command to import a Kubernetes manifest file named designs/microservices-demo.yaml?"
    type: "single-answer"
    marks: 2
    explanation: "The -f flag specifies the file path and the -s flag specifies the source schema type. 'Kubernetes Manifest' is the correct schema identifier for raw Kubernetes YAML files."
    options:
      - id: "a"
        text: "mesheryctl design apply -f designs/microservices-demo.yaml"
        isCorrect: false
      - id: "b"
        text: "mesheryctl design import -f designs/microservices-demo.yaml -s \"Kubernetes Manifest\""
        isCorrect: true
      - id: "c"
        text: "mesheryctl system import designs/microservices-demo.yaml"
        isCorrect: false
      - id: "d"
        text: "mesheryctl design upload --file designs/microservices-demo.yaml"
        isCorrect: false
  - id: "q2"
    text: "In the agent deploy loop, the human-in-the-loop checkpoint occurs between which two stages?"
    type: "single-answer"
    marks: 2
    explanation: "The human reviews the dry-run diff after the design has been committed to Git but before any apply command is run. This preserves the audit trail in Git while preventing unapproved changes from reaching the cluster."
    options:
      - id: "a"
        text: "Between design generation and Git commit"
        isCorrect: false
      - id: "b"
        text: "Between Git commit and cluster apply, during the dry-run review"
        isCorrect: true
      - id: "c"
        text: "After cluster apply, during rollout monitoring"
        isCorrect: false
      - id: "d"
        text: "Before design generation, as a requirements sign-off"
        isCorrect: false
  - id: "q3"
    text: "Which of the following conditions should an agent use as pre-defined rollback triggers?"
    type: "multiple-answers"
    marks: 3
    explanation: "Pre-defined rollback triggers should be objective and measurable: a rollout that exceeds its expected time window and an application error rate that rises above a defined threshold are both clear signals. A single pod restart and a Pending pod on a new node are normal transient conditions that do not require rollback."
    options:
      - id: "a"
        text: "Rollout does not complete within the expected time window"
        isCorrect: true
      - id: "b"
        text: "Application error rate rises above the defined threshold shortly after apply"
        isCorrect: true
      - id: "c"
        text: "A single pod restarts once during the rollout"
        isCorrect: false
      - id: "d"
        text: "One pod is in Pending state on a newly added node"
        isCorrect: false
  - id: "q4"
    text: "What tool does kubectl diff compare to produce its output?"
    type: "single-answer"
    marks: 2
    explanation: "kubectl diff compares the live state currently stored in the Kubernetes cluster against the incoming manifest to show which fields will change if the manifest is applied."
    options:
      - id: "a"
        text: "The Git HEAD version of the file against the incoming manifest"
        isCorrect: false
      - id: "b"
        text: "The live cluster state against the incoming manifest"
        isCorrect: true
      - id: "c"
        text: "The Meshery design registry against the Kubernetes API server"
        isCorrect: false
      - id: "d"
        text: "The previous Deployment revision against the new one"
        isCorrect: false
  - id: "q5"
    text: "Why should kubectl rollout undo NOT be used as the sole rollback mechanism in a GitOps workflow?"
    type: "single-answer"
    marks: 2
    explanation: "kubectl rollout undo restores the previous Kubernetes Deployment revision in the cluster but does not update the file in Git. This creates a divergence between the Git source of truth and the actual cluster state, which can cause confusion for future deployments and audit reviews."
    options:
      - id: "a"
        text: "It is slower than a Git revert and re-apply"
        isCorrect: false
      - id: "b"
        text: "It does not work on Deployments that use rolling update strategy"
        isCorrect: false
      - id: "c"
        text: "It restores cluster state but does not update the Git source of truth, creating a gap"
        isCorrect: true
      - id: "d"
        text: "It requires Meshery Operator to be running and will fail if MeshSync is down"
        isCorrect: false
  - id: "q6"
    text: "What information should an agent record after a successful deployment to make future rollbacks deterministic?"
    type: "multiple-answers"
    marks: 3
    explanation: "The Git commit hash identifies exactly what was deployed, the Meshery Design ID ties the deployment to the Meshery record, and the rollout status for each Deployment confirms what the cluster state was at deployment time. These three together allow a rollback to target the precise previous state without guessing."
    options:
      - id: "a"
        text: "The Git commit hash of the deployed design file"
        isCorrect: true
      - id: "b"
        text: "The Meshery Design ID returned after import"
        isCorrect: true
      - id: "c"
        text: "The rollout status for each Deployment"
        isCorrect: true
      - id: "d"
        text: "The names of all engineers who reviewed the dry-run diff"
        isCorrect: false
---
