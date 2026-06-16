---
title: "Module Quiz"
passPercentage: 70
type: "test"
questions:
  - id: "q1"
    text: "Which two Linux kernel primitives does a container use to isolate processes from the rest of the system?"
    type: "multiple-answers"
    marks: 2
    explanation: "Containers rely on namespaces to limit what a process can see (filesystem, network, process table) and cgroups to limit what it can consume (CPU, memory, I/O). There is no hardware emulation involved - the host kernel is shared."
    options:
      - id: "a"
        text: "Hypervisor and hardware emulation"
        isCorrect: false
      - id: "b"
        text: "Namespaces"
        isCorrect: true
      - id: "c"
        text: "cgroups"
        isCorrect: true
      - id: "d"
        text: "Virtual network adapters"
        isCorrect: false

  - id: "q2"
    text: "What is the smallest schedulable unit in Kubernetes?"
    type: "single-answer"
    marks: 2
    explanation: "A Pod is the smallest deployable and schedulable unit in Kubernetes. It wraps one or more containers that share a network namespace. Deployments, StatefulSets, and DaemonSets all manage pods, but the pod itself is the atomic unit the scheduler places on a node."
    options:
      - id: "a"
        text: "Container"
        isCorrect: false
      - id: "b"
        text: "Deployment"
        isCorrect: false
      - id: "c"
        text: "Pod"
        isCorrect: true
      - id: "d"
        text: "Namespace"
        isCorrect: false

  - id: "q3"
    text: "In the context of GitOps, what is the role of the Git repository?"
    type: "single-answer"
    marks: 2
    explanation: "In a GitOps workflow, the Git repository is the single source of truth for desired cluster state. A GitOps operator continuously reconciles the cluster to match the manifests stored in the repository. Merging a pull request is the act of approving an infrastructure change."
    options:
      - id: "a"
        text: "A backup location for kubectl command history"
        isCorrect: false
      - id: "b"
        text: "The single source of truth for desired cluster state"
        isCorrect: true
      - id: "c"
        text: "A read-only audit log of cluster events"
        isCorrect: false
      - id: "d"
        text: "The registry where container images are stored"
        isCorrect: false

  - id: "q4"
    text: "Which CNCF project is used as the container orchestrator in a cloud native stack?"
    type: "short-answer"
    marks: 2
    explanation: "Kubernetes is the container orchestrator the industry has standardized on. It schedules containers onto nodes, manages their lifecycle, and continuously reconciles actual cluster state against the desired state declared in manifests."
    correctAnswer: "Kubernetes"
    case_sensitive: false
---
