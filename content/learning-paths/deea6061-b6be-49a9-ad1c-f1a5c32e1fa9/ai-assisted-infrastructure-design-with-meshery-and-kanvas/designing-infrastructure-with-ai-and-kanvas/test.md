---
title: "Course Test"
passPercentage: 70
type: "test"
questions:
  - id: "q1"
    text: "What is the gap between an infrastructure 'intent' and a 'topology'?"
    type: "single-answer"
    marks: 2
    explanation: "An intent is a plain-language requirement. A topology is the explicit, structured representation of every workload, service, data store, and networking rule needed to satisfy that requirement. The gap is where most design errors occur."
    options:
      - id: "a"
        text: "The intent is written in YAML; the topology is written in natural language"
        isCorrect: false
      - id: "b"
        text: "The intent states what is needed; the topology names every component, service, data dependency, and networking rule required to deliver it"
        isCorrect: true
      - id: "c"
        text: "The intent is created by the LLM; the topology is created by the engineer"
        isCorrect: false
      - id: "d"
        text: "There is no gap - a well-written intent is equivalent to a topology"
        isCorrect: false

  - id: "q2"
    text: "Which Kubernetes primitives should you map out before handing a brief to an LLM, to use as a completeness checklist for the output?"
    type: "multiple-answers"
    marks: 2
    explanation: "Before asking the LLM to design, you should identify the expected Deployments or StatefulSets, Services, Ingress or Gateway resources, NetworkPolicies, PersistentVolumeClaims, ConfigMaps, Secrets, and ServiceAccounts. These form the checklist you verify against the proposal."
    options:
      - id: "a"
        text: "Deployment or StatefulSet per workload"
        isCorrect: true
      - id: "b"
        text: "Service per workload"
        isCorrect: true
      - id: "c"
        text: "Helm chart version per dependency"
        isCorrect: false
      - id: "d"
        text: "NetworkPolicy per namespace or isolation boundary"
        isCorrect: true
      - id: "e"
        text: "PersistentVolumeClaim per stateful workload"
        isCorrect: true

  - id: "q3"
    text: "In the co-design loop, what should you do when you find a problem in the Kanvas canvas after an LLM proposal?"
    type: "single-answer"
    marks: 2
    explanation: "The correct action is to compile a correction list and return it to the LLM as a correction brief for a revised proposal. Fixing items directly on the canvas causes the design to diverge from its source-of-truth brief."
    options:
      - id: "a"
        text: "Fix the problem directly in the Kanvas canvas and deploy"
        isCorrect: false
      - id: "b"
        text: "Discard the design and start over without LLM assistance"
        isCorrect: false
      - id: "c"
        text: "Compile a correction list and return it to the LLM as a correction brief, then review the revised proposal"
        isCorrect: true
      - id: "d"
        text: "Skip the problem if it appears minor and proceed to deployment"
        isCorrect: false

  - id: "q4"
    text: "What does an 'Exclusions' section in an infrastructure brief accomplish?"
    type: "single-answer"
    marks: 2
    explanation: "Exclusions explicitly tell the LLM what is out of scope - preventing it from adding components you have not authorized, such as a service mesh when TLS is mentioned. Without exclusions, the LLM may make associations from training data that violate your requirements."
    options:
      - id: "a"
        text: "Lists the components the LLM must include in the design"
        isCorrect: false
      - id: "b"
        text: "Prevents the LLM from adding unauthorized components by explicitly stating what is out of scope"
        isCorrect: true
      - id: "c"
        text: "Documents components that were considered but are deferred to a future iteration"
        isCorrect: false
      - id: "d"
        text: "Reduces the context window size by removing irrelevant information"
        isCorrect: false

  - id: "q5"
    text: "Which of the following are resource hygiene checks you should perform when reviewing an AI-proposed design?"
    type: "multiple-answers"
    marks: 2
    explanation: "Resource hygiene requires that every container has CPU and memory requests set, memory limits set, HPA bounds match availability requirements, and PodDisruptionBudgets are in place for availability-sensitive workloads. Missing any of these can cause cluster instability or wasted capacity."
    options:
      - id: "a"
        text: "Every container has resources.requests.cpu and resources.requests.memory set"
        isCorrect: true
      - id: "b"
        text: "Every container has resources.limits.memory set"
        isCorrect: true
      - id: "c"
        text: "Every Service uses the LoadBalancer type for external access"
        isCorrect: false
      - id: "d"
        text: "PodDisruptionBudgets are present for availability-sensitive workloads"
        isCorrect: true
      - id: "e"
        text: "HPA min and max replica counts are consistent with brief availability requirements"
        isCorrect: true

  - id: "q6"
    text: "When during a design review should you update the infrastructure brief rather than sending a correction list to the LLM?"
    type: "single-answer"
    marks: 2
    explanation: "If you find yourself inventing requirements during review - recognizing a need that was never stated in the brief - that is a signal the brief was incomplete. Stop, update the brief, and regenerate. Patching the design manually creates divergence from the source-of-truth brief."
    options:
      - id: "a"
        text: "When the design has more than three corrections needed"
        isCorrect: false
      - id: "b"
        text: "When you discover during review that you are inventing requirements that were never in the brief"
        isCorrect: true
      - id: "c"
        text: "When the LLM proposal is more than 100 lines of YAML"
        isCorrect: false
      - id: "d"
        text: "When the design passes the completeness check but fails the security check"
        isCorrect: false
---
