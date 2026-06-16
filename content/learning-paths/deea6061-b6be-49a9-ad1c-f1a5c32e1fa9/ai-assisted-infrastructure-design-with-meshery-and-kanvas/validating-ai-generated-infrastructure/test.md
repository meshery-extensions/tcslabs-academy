---
title: "Course Test"
passPercentage: 70
type: "test"
questions:
  - id: "q1"
    text: "What is the key difference between schema validation and relationship validation in Meshery?"
    type: "single-answer"
    marks: 2
    explanation: "Schema validation checks whether the YAML is structurally well-formed. Relationship validation checks whether the operational wiring between components is semantically correct - for example, whether a Service's selector actually resolves to Pods in the design. A selector mismatch passes schema validation but fails relationship validation."
    options:
      - id: "a"
        text: "Schema validation is faster; relationship validation is slower"
        isCorrect: false
      - id: "b"
        text: "Schema validation checks structural correctness; relationship validation checks semantic wiring between components"
        isCorrect: true
      - id: "c"
        text: "Schema validation runs in CI; relationship validation runs only in production"
        isCorrect: false
      - id: "d"
        text: "Schema validation uses OPA; relationship validation uses the Kubernetes API"
        isCorrect: false
  - id: "q2"
    text: "Which mesheryctl command imports an AI-generated Kubernetes manifest into Meshery for validation?"
    type: "short-answer"
    marks: 2
    correctAnswer: "mesheryctl design import -f"
    case_sensitive: false
    explanation: "The correct command is `mesheryctl design import -f <file> -s \"Kubernetes Manifest\"`. This imports the file, resolves components against the registry, evaluates relationships, and runs any policy rules attached to the target environment."
  - id: "q3"
    text: "An AI-generated Deployment has replicas: 2 but no PodDisruptionBudget. What is the risk, and which checklist category covers it?"
    type: "single-answer"
    marks: 2
    explanation: "Without a PDB, a node drain or cluster upgrade can terminate both replicas simultaneously, causing a full service outage. The review checklist's Resources category requires a PDB for any Deployment with more than one replica."
    options:
      - id: "a"
        text: "The Deployment may exceed namespace quota; covered by the Policy category"
        isCorrect: false
      - id: "b"
        text: "Both replicas can be terminated simultaneously during a node drain; covered by the Resources category"
        isCorrect: true
      - id: "c"
        text: "The container may run as root; covered by the Security category"
        isCorrect: false
      - id: "d"
        text: "The image tag may be mutable; covered by the Correctness category"
        isCorrect: false
  - id: "q4"
    text: "Which of the following guardrails protect a namespace from AI-generated workloads that omit resource constraints? Select all that apply."
    type: "multiple-answers"
    marks: 2
    explanation: "ResourceQuota caps aggregate CPU, memory, and object counts for the entire namespace - bounding total consumption regardless of individual container limits. LimitRange injects default requests and limits into any container that omits them. Together they ensure that even incomplete AI-generated manifests cannot consume unbounded resources."
    options:
      - id: "a"
        text: "ResourceQuota"
        isCorrect: true
      - id: "b"
        text: "LimitRange"
        isCorrect: true
      - id: "c"
        text: "PodDisruptionBudget"
        isCorrect: false
      - id: "d"
        text: "NetworkPolicy"
        isCorrect: false
  - id: "q5"
    text: "Why does the checklist's Security category require checking that container images use pinned tags or digests rather than the :latest tag?"
    type: "single-answer"
    marks: 2
    explanation: "A mutable tag like :latest can silently resolve to a different image between deployments. This makes rollbacks unreliable and introduces unpredictable behavior when the upstream image changes. Pinned tags or digests ensure every deploy uses exactly the image that was reviewed."
    options:
      - id: "a"
        text: "Because :latest images are always larger and consume more cluster resources"
        isCorrect: false
      - id: "b"
        text: "Because mutable tags can silently resolve to different images between deployments, making rollbacks unreliable"
        isCorrect: true
      - id: "c"
        text: "Because Meshery's registry does not support mutable tags"
        isCorrect: false
      - id: "d"
        text: "Because Kubernetes rejects :latest images by default"
        isCorrect: false
  - id: "q6"
    text: "In the shift-left validation sequence for AI-generated infrastructure, what happens at step 3 (policy evaluation) and what tool executes it?"
    type: "single-answer"
    marks: 2
    explanation: "After schema validation and relationship resolution, Meshery runs OPA-based Rego rules that are attached to the target environment. These rules enforce organizational standards that no schema can express - such as requiring resource limits, banning :latest tags, or mandating specific label keys. The rules execute automatically during design import."
    options:
      - id: "a"
        text: "Kubernetes applies admission webhooks using kube-apiserver"
        isCorrect: false
      - id: "b"
        text: "The CI pipeline runs kubectl apply --dry-run against a live cluster"
        isCorrect: false
      - id: "c"
        text: "Meshery evaluates OPA-based Rego rules attached to the target environment, enforcing standards that schema validation cannot express"
        isCorrect: true
      - id: "d"
        text: "A human reviewer manually checks the manifest against a printed policy document"
        isCorrect: false
---
