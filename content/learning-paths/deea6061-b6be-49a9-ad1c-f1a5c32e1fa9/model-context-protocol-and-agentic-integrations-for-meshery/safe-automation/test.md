---
title: "Course Test"
passPercentage: 70
type: "test"
questions:
  - id: "q1"
    text: "An agent needs to list and watch Pods in the `production` namespace and nothing else. Which RBAC configuration is most appropriate?"
    type: "single-answer"
    marks: 2
    explanation: "A namespace-scoped Role with only `get`, `list`, and `watch` verbs on Pods gives exactly the access needed. A ClusterRole would grant cluster-wide access, violating least privilege."
    options:
      - id: "a"
        text: "ClusterRole with `get`, `list`, `watch` on all resources"
        isCorrect: false
      - id: "b"
        text: "Role in `production` with `get`, `list`, `watch` on Pods"
        isCorrect: true
      - id: "c"
        text: "ClusterRoleBinding to the built-in `view` ClusterRole"
        isCorrect: false
      - id: "d"
        text: "Role in `production` with `create`, `update`, `delete` on Pods"
        isCorrect: false
  - id: "q2"
    text: "Which command audits the effective permissions of a ServiceAccount named `meshery-agent` in the `staging` namespace?"
    type: "single-answer"
    marks: 2
    explanation: "`kubectl auth can-i --list` with the `--as` flag impersonates the ServiceAccount and lists all permissions currently effective for that identity in the specified namespace."
    options:
      - id: "a"
        text: "`kubectl get rolebindings -n staging`"
        isCorrect: false
      - id: "b"
        text: "`kubectl auth can-i --list --as=system:serviceaccount:staging:meshery-agent -n staging`"
        isCorrect: true
      - id: "c"
        text: "`kubectl describe serviceaccount meshery-agent -n staging`"
        isCorrect: false
      - id: "d"
        text: "`mesheryctl system check`"
        isCorrect: false
  - id: "q3"
    text: "What two scoping controls should be applied together for an agent that operates through Meshery?"
    type: "multiple-answers"
    marks: 2
    explanation: "Kubernetes RBAC scopes what the agent can do at the API level. Meshery workspace scoping restricts which environments the agent's token can see and act on within Meshery. Neither alone is sufficient."
    options:
      - id: "a"
        text: "Kubernetes RBAC with a namespace-scoped Role"
        isCorrect: true
      - id: "b"
        text: "Meshery workspace token bound to only target environments"
        isCorrect: true
      - id: "c"
        text: "Cluster-admin ClusterRoleBinding for full control"
        isCorrect: false
      - id: "d"
        text: "Shared ServiceAccount across all agent roles"
        isCorrect: false
  - id: "q4"
    text: "In the PR-based approval workflow, when does the agent actually apply the change to the environment?"
    type: "single-answer"
    marks: 2
    explanation: "The agent halts after opening the PR. A CI/CD pipeline or subsequent agent invocation triggered by the merge event applies the change. The mutation cannot occur until the human approves and merges."
    options:
      - id: "a"
        text: "Immediately after generating the diff"
        isCorrect: false
      - id: "b"
        text: "After the PR is opened, in the same agent run"
        isCorrect: false
      - id: "c"
        text: "After a human approves and merges the PR"
        isCorrect: true
      - id: "d"
        text: "After a 10-minute cooling-off period"
        isCorrect: false
  - id: "q5"
    text: "Which sandboxing stage catches admission control policy failures without persisting any state to the cluster?"
    type: "single-answer"
    marks: 2
    explanation: "A server-side dry-run runs through the full admission control chain - including OPA policies and validating webhooks - but does not persist any state, making it the fastest and cheapest first validation stage."
    options:
      - id: "a"
        text: "Ephemeral namespace"
        isCorrect: false
      - id: "b"
        text: "Staging environment"
        isCorrect: false
      - id: "c"
        text: "Server-side dry-run"
        isCorrect: true
      - id: "d"
        text: "Production canary"
        isCorrect: false
  - id: "q6"
    text: "Which of the following blast-radius controls are recommended for production agent deployments?"
    type: "multiple-answers"
    marks: 2
    explanation: "All three controls work together: rate limiting slows runaway agents, change caps bound the total impact per run, and circuit breakers stop agents that are already failing. None alone is sufficient."
    options:
      - id: "a"
        text: "API call rate limit (QPS and burst)"
        isCorrect: true
      - id: "b"
        text: "Change cap per agent run"
        isCorrect: true
      - id: "c"
        text: "Auto-retry that silently resets a tripped circuit breaker"
        isCorrect: false
      - id: "d"
        text: "Circuit breaker that blocks mutating actions after an error threshold"
        isCorrect: true
---
