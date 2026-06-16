---
title: "Course Test"
passPercentage: 70
type: "test"
questions:
  - id: "q1"
    text: "A Meshery design differs from a plain Kubernetes manifest primarily because it:"
    type: "single-answer"
    marks: 2
    explanation: "A Meshery design carries relationship declarations between components - dependencies, communication paths, routing rules - that Kubernetes manifests do not express natively. These relationships enable validation and visual topology rendering in Kanvas."
    options:
      - id: "a"
        text: "Uses a proprietary binary format that is smaller than YAML"
        isCorrect: false
      - id: "b"
        text: "Can only be deployed via the Meshery UI, not the CLI"
        isCorrect: false
      - id: "c"
        text: "Carries relationship declarations between components that enable validation and topology rendering"
        isCorrect: true
      - id: "d"
        text: "Requires a Meshery Operator to be installed before it can be stored"
        isCorrect: false

  - id: "q2"
    text: "After running `mesheryctl design import -f designs/microservices-demo.yaml -s \"Kubernetes Manifest\"`, what does Meshery return on success?"
    type: "single-answer"
    marks: 2
    explanation: "A successful import returns a confirmation message and the UUID assigned to the imported design. This ID is used in subsequent commands such as `mesheryctl design deploy --id <design-id>`."
    options:
      - id: "a"
        text: "A Kanvas URL where the design can be viewed immediately"
        isCorrect: false
      - id: "b"
        text: "A confirmation message and the design ID (UUID)"
        isCorrect: true
      - id: "c"
        text: "A diff showing what changed relative to the current cluster state"
        isCorrect: false
      - id: "d"
        text: "An OPA policy report listing any policy violations in the manifest"
        isCorrect: false

  - id: "q3"
    text: "Which of the following actions are part of the recommended pull-request preview workflow for GitHub-backed designs?"
    type: "multiple-answers"
    marks: 2
    explanation: "The PR preview workflow involves: a CI job importing the changed design into a staging Meshery instance, capturing a Kanvas snapshot and posting it as a PR comment, and a platform engineer reviewing both the visual topology and the YAML diff before approving. Automatic deployment to production on PR open (before merge and approval) is not recommended."
    options:
      - id: "a"
        text: "A CI job imports the modified design into a staging Meshery instance when a PR is opened"
        isCorrect: true
      - id: "b"
        text: "A Kanvas snapshot of the topology is posted as a PR comment for reviewer inspection"
        isCorrect: true
      - id: "c"
        text: "The design is automatically deployed to production as soon as the PR is opened"
        isCorrect: false
      - id: "d"
        text: "A platform engineer reviews the visual topology diff and YAML diff before approving"
        isCorrect: true

  - id: "q4"
    text: "In Meshery's RBAC model, which built-in workspace role is appropriate for a CI pipeline or coding agent that only needs to create and modify designs in a non-production workspace?"
    type: "single-answer"
    marks: 2
    explanation: "The Editor role grants all Viewer permissions plus the ability to create and modify designs - exactly the scope needed for a CI pipeline or coding agent. Admin grants unnecessary management permissions; Viewer is too restrictive; Deployer is not a built-in Meshery role."
    options:
      - id: "a"
        text: "Admin"
        isCorrect: false
      - id: "b"
        text: "Viewer"
        isCorrect: false
      - id: "c"
        text: "Editor"
        isCorrect: true
      - id: "d"
        text: "Deployer"
        isCorrect: false

  - id: "q5"
    text: "What is the purpose of the `-s \"Kubernetes Manifest\"` flag in the `mesheryctl design import` command?"
    type: "single-answer"
    marks: 2
    explanation: "The `-s` flag tells Meshery which source schema to apply when parsing the imported file. `\"Kubernetes Manifest\"` instructs Meshery to parse each document in the file by its Kubernetes `kind` and map it to a registered component in the Meshery registry."
    options:
      - id: "a"
        text: "It sets the storage backend where the design will be saved"
        isCorrect: false
      - id: "b"
        text: "It specifies the source schema Meshery uses to parse and map the file's contents to registered components"
        isCorrect: true
      - id: "c"
        text: "It selects the Kubernetes namespace the design will be deployed into"
        isCorrect: false
      - id: "d"
        text: "It authenticates the import operation against the Meshery server"
        isCorrect: false

  - id: "q6"
    text: "Which of the following correctly describes the relationship between environments and workspaces in Meshery?"
    type: "single-answer"
    marks: 2
    explanation: "Environments are deployment targets (named groups of cluster connections). Workspaces are the access-control containers that include environments among their resources. A workspace can contain multiple environments, and environments are scoped within workspaces - not the other way around."
    options:
      - id: "a"
        text: "An environment contains one or more workspaces; each workspace maps to a single cluster"
        isCorrect: false
      - id: "b"
        text: "Workspaces and environments are the same concept, just named differently in different versions of Meshery"
        isCorrect: false
      - id: "c"
        text: "A workspace is the access-control container that groups environments, designs, and members; environments are the deployment targets within a workspace"
        isCorrect: true
      - id: "d"
        text: "Environments are created automatically when a workspace is created and cannot be managed independently"
        isCorrect: false
---
