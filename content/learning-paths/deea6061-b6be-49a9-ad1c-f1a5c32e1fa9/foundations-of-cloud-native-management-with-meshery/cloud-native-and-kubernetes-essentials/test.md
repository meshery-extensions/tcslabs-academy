---
title: "Course Test"
passPercentage: 70
type: "test"
questions:
  - id: "q1"
    text: "Which three pillars define cloud native computing according to the CNCF definition used in this course?"
    type: "multiple-answers"
    marks: 2
    explanation: "The three pillars are containers (the unit of packaging and deployment), orchestration (the system that manages container lifecycle and scheduling), and dynamic management (the infrastructure responds to declared intent via continuous reconciliation). Virtual machines and SSH-based provisioning belong to the pre-cloud-native era."
    options:
      - id: "a"
        text: "Containers"
        isCorrect: true
      - id: "b"
        text: "Orchestration"
        isCorrect: true
      - id: "c"
        text: "Dynamic management"
        isCorrect: true
      - id: "d"
        text: "Virtual machines"
        isCorrect: false
      - id: "e"
        text: "SSH-based provisioning"
        isCorrect: false

  - id: "q2"
    text: "A container image is built in layers. What is the operational benefit of this layered architecture?"
    type: "single-answer"
    marks: 2
    explanation: "Layers are content-addressed and cached. When you rebuild an image and only the application code changed, the base OS and runtime layers are reused from cache. This makes builds faster and means multiple images sharing the same base layer store that layer only once in the registry."
    options:
      - id: "a"
        text: "It allows the container to share a kernel with virtual machines on the same host"
        isCorrect: false
      - id: "b"
        text: "Shared layers are cached and reused, making builds faster and storage more efficient"
        isCorrect: true
      - id: "c"
        text: "It prevents the container from accessing the host filesystem"
        isCorrect: false
      - id: "d"
        text: "It enables containers to run without a container runtime"
        isCorrect: false

  - id: "q3"
    text: "What Kubernetes object provides a stable network endpoint for a set of pods selected by label?"
    type: "single-answer"
    marks: 2
    explanation: "A Service provides a stable IP address and DNS name for a set of pods identified by a label selector. Pods are ephemeral and their IPs change; the Service IP and DNS name remain constant, making it the correct object for network routing within a cluster."
    options:
      - id: "a"
        text: "Pod"
        isCorrect: false
      - id: "b"
        text: "Deployment"
        isCorrect: false
      - id: "c"
        text: "Namespace"
        isCorrect: false
      - id: "d"
        text: "Service"
        isCorrect: true

  - id: "q4"
    text: "In the Kubernetes reconciliation control loop, what happens immediately after a controller observes that current state differs from desired state?"
    type: "single-answer"
    marks: 2
    explanation: "After observing a divergence between current state (status) and desired state (spec), the controller acts - it issues API calls to create, update, or delete resources to close the gap. The loop then repeats continuously: watch, observe, diff, act."
    options:
      - id: "a"
        text: "The controller shuts down the affected pods and waits for a human operator"
        isCorrect: false
      - id: "b"
        text: "The controller acts by issuing API calls to reconcile current state to desired state"
        isCorrect: true
      - id: "c"
        text: "The controller logs a warning and waits for the next scheduled sync"
        isCorrect: false
      - id: "d"
        text: "The controller updates the spec to match current state"
        isCorrect: false

  - id: "q5"
    text: "Why is the declarative infrastructure model more suitable for coding agent automation than the imperative model?"
    type: "multiple-answers"
    marks: 2
    explanation: "The declarative model stores desired state explicitly in manifests, which are machine-readable, diffable, and version-controlled. Agents can read manifests, propose changes as diffs, apply them, and observe reconciliation. Drift is automatically detectable. With imperative approaches, current state exists only in the operator's head and side effects are opaque to an agent."
    options:
      - id: "a"
        text: "Desired state is explicit, stored in manifests, and machine-readable"
        isCorrect: true
      - id: "b"
        text: "Drift between desired and actual state is automatically detectable"
        isCorrect: true
      - id: "c"
        text: "Agents can execute shell scripts more efficiently than humans"
        isCorrect: false
      - id: "d"
        text: "Rollback is as simple as applying a previous version of the manifest"
        isCorrect: true

  - id: "q6"
    text: "Which mesheryctl command imports an existing Kubernetes manifest file into Meshery as a design?"
    type: "single-answer"
    marks: 2
    explanation: "The correct command is `mesheryctl design import -f <file> -s \"Kubernetes Manifest\"`. This tells Meshery to parse the file as a Kubernetes Manifest source type, model the relationships between objects, and make the design available in Kanvas and the Meshery Catalog."
    options:
      - id: "a"
        text: "mesheryctl system import -f designs/microservices-demo.yaml"
        isCorrect: false
      - id: "b"
        text: "mesheryctl design apply -f designs/microservices-demo.yaml"
        isCorrect: false
      - id: "c"
        text: "mesheryctl design import -f designs/microservices-demo.yaml -s \"Kubernetes Manifest\""
        isCorrect: true
      - id: "d"
        text: "mesheryctl perf apply -f designs/microservices-demo.yaml"
        isCorrect: false
---
