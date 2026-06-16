---
title: "Course Test"
passPercentage: 70
type: "test"
questions:
  - id: "q1"
    text: "An agent generates a Deployment manifest that includes a plaintext API key in an environment variable field. Which corrective pattern should you apply?"
    type: "single-answer"
    marks: 2
    explanation: "The correct fix is to reference the secret by name using secretKeyRef, which causes the kubelet to inject the value at runtime from a Kubernetes Secret without the literal value ever appearing in the manifest or in the agent's output."
    options:
      - id: "a"
        text: "Base64-encode the API key before embedding it in the manifest"
        isCorrect: false
      - id: "b"
        text: "Replace the inline value with a secretKeyRef pointing to a Kubernetes Secret"
        isCorrect: true
      - id: "c"
        text: "Store the API key in a ConfigMap instead of the Deployment manifest"
        isCorrect: false
      - id: "d"
        text: "Pass the API key as a command-line argument to the container entrypoint"
        isCorrect: false
  - id: "q2"
    text: "Which of the following are valid reasons to use the External Secrets Operator (ESO) rather than native Kubernetes Secrets for agent credentials? Select all that apply."
    type: "multiple-answers"
    marks: 2
    explanation: "ESO enables automatic rotation (the controller re-syncs on the refreshInterval) and keeps the source of truth in an external vault so the credential value is never stored in etcd. Both are significant advantages for agent pipeline security."
    options:
      - id: "a"
        text: "ESO enables automatic credential rotation by re-syncing from the external store on a configurable interval"
        isCorrect: true
      - id: "b"
        text: "ESO prevents the credential value from being stored in etcd"
        isCorrect: true
      - id: "c"
        text: "ESO removes the need for RBAC on Kubernetes Secrets"
        isCorrect: false
      - id: "d"
        text: "ESO automatically redacts secrets from kubectl describe output"
        isCorrect: false
  - id: "q3"
    text: "A Kyverno ClusterPolicy is configured to require images of the form '*@sha256:*'. What class of supply chain risk does this policy directly address?"
    type: "single-answer"
    marks: 2
    explanation: "Mutable tags (latest, v1, stable, etc.) can be overwritten at the registry after the manifest is written, silently changing what runs in the cluster. Requiring a SHA256 digest ensures the exact image layers are locked at manifest-write time."
    options:
      - id: "a"
        text: "Prompt injection attacks via malicious container entry points"
        isCorrect: false
      - id: "b"
        text: "Silent image substitution through mutable registry tags being overwritten after manifest authoring"
        isCorrect: true
      - id: "c"
        text: "Missing resource limits causing CPU starvation"
        isCorrect: false
      - id: "d"
        text: "Privilege escalation via RBAC misconfiguration"
        isCorrect: false
  - id: "q4"
    text: "You are designing the network policy for the namespace where a Meshery agent pod runs. What should the default stance be before adding specific allow rules?"
    type: "single-answer"
    marks: 2
    explanation: "A default-deny NetworkPolicy with an empty podSelector applies to all pods in the namespace and blocks all ingress and egress. Specific allow rules are then added only for connections the agent actually requires, minimizing the network attack surface."
    options:
      - id: "a"
        text: "Default allow all ingress, default deny all egress"
        isCorrect: false
      - id: "b"
        text: "Default allow all traffic and add deny rules for known-bad destinations"
        isCorrect: false
      - id: "c"
        text: "Default deny all ingress and egress, then add explicit allow rules for required connections only"
        isCorrect: true
      - id: "d"
        text: "No network policy is needed because the agent namespace is internal-only"
        isCorrect: false
  - id: "q5"
    text: "In a least-privilege pipeline model, which verbs should typically be ABSENT from the write service account's Role for a Meshery design applier? Select all that apply."
    type: "multiple-answers"
    marks: 2
    explanation: "The delete verb risks irreversible destructive actions. Access to secrets would allow credential exfiltration. The ability to create or modify ClusterRoleBindings would allow privilege escalation. None of these are needed to apply a Deployment or Service manifest."
    options:
      - id: "a"
        text: "delete"
        isCorrect: true
      - id: "b"
        text: "create"
        isCorrect: false
      - id: "c"
        text: "get on secrets"
        isCorrect: true
      - id: "d"
        text: "create on clusterrolebindings"
        isCorrect: true
  - id: "q6"
    text: "What Meshery CLI command verifies that the Meshery system is reachable and healthy after a credential rotation?"
    type: "short-answer"
    marks: 2
    explanation: "mesheryctl system check probes the Meshery server, adapters, and operator to confirm connectivity and component health. Running it after credential rotation confirms the new credentials are accepted and all components are communicating correctly."
    correctAnswer: "mesheryctl system check"
    case_sensitive: false
---
