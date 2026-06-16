---
type: "page"
id: "declarative-infrastructure-and-gitops"
title: "Declarative Infrastructure and GitOps"
description: "Contrast declarative and imperative infrastructure models, understand desired state management, and learn why a version-controlled declarative model is the ideal substrate for LLM and agent-driven automation."
weight: 4
---

## Declarative vs Imperative Infrastructure

Every infrastructure management approach falls somewhere on a spectrum between two poles.

**Imperative** means you describe the steps to reach a desired outcome: "SSH into each node, install the package, restart the service, update the config file." The operator - human or script - holds the model of current state in their head. The system itself has no memory of what was intended.

**Declarative** means you describe the outcome and let the system figure out the steps: "I want three replicas of this pod running with this image in this namespace." The desired state is explicit, stored, and continuously reconciled against actual state.

| Property | Imperative | Declarative |
|----------|-----------|-------------|
| State model | In the operator's head | In the manifest |
| Drift detection | Manual | Automatic |
| Rollback | Re-run previous commands | Apply previous manifest |
| Auditability | Script history | Diff of manifest versions |
| Agent-friendliness | Low - side effects are opaque | High - intent is explicit |

Kubernetes is built entirely on the declarative model. Every resource you apply to the cluster is a desired-state specification. This is not a convention - it is enforced by the API.

## Desired State and Reconciliation

**Desired state** is the authoritative specification of what should be running. In Kubernetes, it lives in the cluster's etcd store as the `spec` field of every resource object. The `status` field reflects what is actually running. The control loop - described in the previous lesson - continuously works to make `status` match `spec`.

This means:

- If you delete a pod that is managed by a Deployment, the Deployment controller creates a new one.
- If you scale a Deployment manually on the command line, a GitOps operator will revert it to the version in Git the next time it syncs.
- If a node fails and its pods are rescheduled, the cluster moves back toward the desired replica count automatically.

Desired state is also what gives infrastructure-as-code its power: the manifest files on disk are the source of truth. Any divergence between the files and the running cluster is a signal worth investigating.

## The GitOps Model

GitOps is the practice of managing desired state in a version control repository (Git) and using automated operators to continuously synchronize the cluster to match.

The canonical GitOps workflow:

1. **Declare** - write Kubernetes manifests and store them in a Git repository.
2. **Review** - propose changes via pull requests, review and approve them through the normal code review process.
3. **Merge** - merging the PR is the act of approving the infrastructure change.
4. **Sync** - a GitOps operator (running inside the cluster) detects the change and applies it automatically.
5. **Observe** - dashboards and alerts surface the resulting state.

The critical insight is that the Git repository becomes the single source of truth for everything running in the cluster. You do not apply changes by running `kubectl apply` on a local machine. You commit a manifest change and let the operator apply it.

```text
Developer                Git Repository         GitOps Operator        Cluster
   |                          |                      |                    |
   |-- git commit/push -----> |                      |                    |
   |                          |-- webhook/poll -----> |                    |
   |                          |                      |-- kubectl apply --> |
   |                          |                      |                    |-- reconcile
   |                          |                      | <-- status -------- |
```

## Why This Model Is Ideal for LLM and Agent Automation

Platform engineers who integrate coding agents into their workflow quickly discover that the declarative, GitOps model fits agentic automation naturally.

**Agents work on files, not live systems.** An agent can read manifest files from a Git repository, propose edits, open a pull request, and wait for a human to review and merge. The human-in-the-loop step is the PR review - a familiar process with a clear approval gate. The agent never touches the cluster directly.

**Desired state is machine-readable intent.** A YAML manifest is structured, versioned, and semantically meaningful. An LLM can read a Deployment spec and reason about what it does. It can compare two versions of a manifest and explain what changed and why it might matter. This is far more tractable than asking an agent to reason about the output of imperative scripts.

**Drift is detectable and explainable.** When a GitOps operator reports that the cluster has drifted from the repository, an agent can read both the manifest and the live state, identify the delta, and propose a reconciliation. Meshery surfaces this kind of drift through MeshSync, which continuously synchronizes cluster state into Meshery's data plane.

**You can import existing designs and version-control them.** If you have existing Kubernetes manifests, you can import them into Meshery with:

```bash
mesheryctl design import -f designs/microservices-demo.yaml -s "Kubernetes Manifest"
```

Meshery parses the manifests, models the relationships between objects, and renders a visual representation in Kanvas. You can then export the design, check it into Git, and manage it through the GitOps workflow - with an agent proposing changes and a human approving them.

**Reversibility is built in.** Because every state is a commit, rolling back means reverting a commit. The blast radius of any change is bounded by the scope of the PR. An agent that makes a mistake does not corrupt live state irreversibly - it produces a manifest that a human can reject before it reaches the cluster.

The declarative, version-controlled model is not just operationally sound - it is the architectural prerequisite for safe, auditable, human-supervised agentic infrastructure management. The rest of this learning path builds on top of this foundation.
