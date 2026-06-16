---
type: "page"
id: "the-deploy-loop-agent-mesheryctl-gitops"
title: "The Deploy Loop: Agent + mesheryctl + GitOps"
description: "Understand the end-to-end loop connecting an AI agent, a Git repository, and mesheryctl to produce auditable, reproducible cluster deployments."
weight: 1
---

## Why a Loop, Not a Script

A one-shot deploy script answers only the question in front of it. An agentic deploy loop answers a class of questions: it can regenerate a design when requirements change, catch a failed health check and retry with a modified configuration, and leave a readable commit trail behind every change. The difference between a script and a loop is that the loop can reason.

This lesson maps the architecture of that loop so you can see where each tool fits - and where the human-in-the-loop checkpoint must sit.

## The Four Stages

### 1. Generate or Edit the Design

Your agent starts in Meshery's design workspace. It can generate a new design from a natural-language prompt (using the Meshery Kanvas design API or MCP tooling) or load an existing design file such as `designs/microservices-demo.yaml` and patch it to match updated requirements.

The agent outputs a valid Meshery design - either as a YAML file or directly registered in Meshery under a named design. At this stage nothing has touched a cluster.

### 2. Commit to Git

Once the design YAML is ready, the agent commits it to the infrastructure Git repository. This step is non-negotiable. Git is the source of truth; the file must be versioned before it is deployed.

A minimal commit workflow:

```bash
git add designs/microservices-demo.yaml
git commit -m "chore: update microservices-demo for release-1.4 rollout"
git push origin main
```

The agent should write a commit message that references the intent it was given - this creates a human-readable audit trail that does not depend on reconstructing agent context later.

### 3. Preview - Do Not Skip

Before applying, the agent runs a dry-run. See the next lesson for the full dry-run workflow. The important architectural point here is that the dry-run happens **between commit and apply** - the design is already in Git, but no cluster state has changed. This is the human checkpoint.

### 4. Apply via mesheryctl

After a human (or a policy gate) approves the diff, the agent calls `mesheryctl` to import and deploy:

```bash
mesheryctl design import -f designs/microservices-demo.yaml -s "Kubernetes Manifest"
```

`mesheryctl` communicates with the Meshery server, which in turn drives MeshSync and the Meshery Operator to reconcile cluster state.

## How the Pieces Connect

```text
Agent (LLM + tools)
  |
  |-- generates/edits design YAML
  |
  v
Git repository  <-- single source of truth
  |
  |-- dry-run diff (human reviews)
  |
  v
mesheryctl design import
  |
  v
Meshery Server
  |
  +-- Meshery Operator  -->  cluster resources
  |
  +-- MeshSync          -->  discovery / drift detection
```

MeshSync continuously reconciles what is in the cluster against what Meshery expects. If an agent deploys a design and MeshSync later detects drift, that signal can feed back to the agent as a new task: reconcile the drift.

## GitOps Integration

If your organization runs a GitOps controller (Argo CD, Flux), the agent can target the same Git repository that the controller watches. In that model:

- The agent writes and commits the design YAML.
- The GitOps controller picks up the commit and drives the reconcile loop.
- `mesheryctl` is used for health checks and Meshery-specific operations (`mesheryctl system check`) rather than as the primary apply mechanism.

Both models - direct `mesheryctl` apply and GitOps controller - are valid. The key invariant is the same: **Git is committed before anything reaches the cluster**, and the diff is reviewed before apply.

## Context Window and Tool Budget

An agentic loop that spans generate, commit, preview, and apply makes many tool calls. Agents with a limited context window can lose track of the original intent by the time they reach the apply step. Mitigate this by:

- Writing the intent to a file at the start of the session and having the agent re-read it before apply.
- Keeping each step atomic - generate, commit, preview, apply as separate, logged calls.
- Using structured output at each stage so the next stage has a clean input rather than free-form text.

## Verify the Loop is Healthy

After `mesheryctl` returns, verify with:

```bash
mesheryctl system check
kubectl get pods -n <target-namespace>
```

A passing `mesheryctl system check` confirms Meshery Server, MeshSync, and the Operator are all reachable. The `kubectl` check confirms the workloads the design specified are actually running.

The loop closes here: if the verification passes, the agent can mark the task complete and record the commit hash as the deployed version. If it fails, the rollback lesson covers the next step.
