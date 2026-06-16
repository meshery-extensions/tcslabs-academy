---
title: "Course Test"
passPercentage: 70
type: "test"
questions:
  - id: "q1"
    text: "What command imports a Kubernetes manifest file named 'my-app.yaml' into Meshery?"
    type: "short-answer"
    marks: 2
    correctAnswer: "mesheryctl design import -f my-app.yaml -s \"Kubernetes Manifest\""
    case_sensitive: false
    explanation: "The mesheryctl design import command requires the -f flag for the file path and the -s flag specifying 'Kubernetes Manifest' as the source type."
  - id: "q2"
    text: "Which Kubernetes resource kinds map to apiVersion apps/v1?"
    type: "multiple-answers"
    marks: 2
    explanation: "Deployment and StatefulSet both use apiVersion apps/v1. Namespace, Service, and ConfigMap all use apiVersion v1. Ingress uses networking.k8s.io/v1."
    options:
      - id: "a"
        text: "Deployment"
        isCorrect: true
      - id: "b"
        text: "Namespace"
        isCorrect: false
      - id: "c"
        text: "StatefulSet"
        isCorrect: true
      - id: "d"
        text: "Service"
        isCorrect: false
      - id: "e"
        text: "ConfigMap"
        isCorrect: false
  - id: "q3"
    text: "What does the Meshery registry use to identify a component in an imported design?"
    type: "single-answer"
    marks: 2
    explanation: "Meshery identifies each component in a design by the combination of its kind and apiVersion fields. If this pair is not in the registry, the resource is flagged as unrecognised."
    options:
      - id: "a"
        text: "The resource name and namespace"
        isCorrect: false
      - id: "b"
        text: "The kind and apiVersion combination"
        isCorrect: true
      - id: "c"
        text: "The label selector and pod template"
        isCorrect: false
      - id: "d"
        text: "The container image name"
        isCorrect: false
  - id: "q4"
    text: "Which prompting techniques reliably reduce LLM design generation failures? Select all that apply."
    type: "multiple-answers"
    marks: 2
    explanation: "Specifying exact resource kinds, adding 'output only YAML' to prevent prose wrapping, listing explicit constraints such as resource limits and selector requirements, and providing a reference example from a working design all reduce generation failures. Asking for a general Kubernetes template without specifics produces variable and often incorrect output."
    options:
      - id: "a"
        text: "Listing exact resource kinds with names, images, and ports"
        isCorrect: true
      - id: "b"
        text: "Instructing the model to output only YAML with no explanation"
        isCorrect: true
      - id: "c"
        text: "Asking for a general Kubernetes template without specifying resource kinds"
        isCorrect: false
      - id: "d"
        text: "Providing a reference excerpt from a working design such as designs/microservices-demo.yaml"
        isCorrect: true
      - id: "e"
        text: "Explicitly stating resource limit constraints in the prompt"
        isCorrect: true
  - id: "q5"
    text: "A Deployment in a generated design has selector.matchLabels: {app: api, tier: backend} but its pod template labels are {app: api, component: api}. What will Meshery report?"
    type: "single-answer"
    marks: 2
    explanation: "Meshery's relationship validation checks that a Deployment's selector.matchLabels is a subset of the pod template labels. The key 'tier' in the selector does not appear in the template labels, so Meshery flags this as a relationship validation failure."
    options:
      - id: "a"
        text: "No error - Kubernetes allows selector keys that are not in the pod template"
        isCorrect: false
      - id: "b"
        text: "An import parsing error before any validation runs"
        isCorrect: false
      - id: "c"
        text: "A relationship validation failure because the selector key 'tier' is not in the pod template labels"
        isCorrect: true
      - id: "d"
        text: "A warning about the container image tag only"
        isCorrect: false
  - id: "q6"
    text: "A design has converged and is ready to deploy when which of the following are true? Select all that apply."
    type: "multiple-answers"
    marks: 2
    explanation: "A converged design must pass import without errors, show no red validation badges in Kanvas, have topology that matches the intended architecture, and have all containers with resource requests and limits. An LLM generating it without errors is not a convergence criterion - only Meshery import and Kanvas validation determine correctness."
    options:
      - id: "a"
        text: "mesheryctl design import completes without errors"
        isCorrect: true
      - id: "b"
        text: "Kanvas shows no red validation badges"
        isCorrect: true
      - id: "c"
        text: "The LLM generated the design without any follow-up prompts"
        isCorrect: false
      - id: "d"
        text: "All containers have resource requests and limits"
        isCorrect: true
      - id: "e"
        text: "The topology in Kanvas matches the intended architecture"
        isCorrect: true
---
