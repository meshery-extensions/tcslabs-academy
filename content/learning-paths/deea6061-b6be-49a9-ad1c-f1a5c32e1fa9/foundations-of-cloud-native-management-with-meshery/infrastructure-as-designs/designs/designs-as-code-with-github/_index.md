---
type: "page"
id: "designs-as-code-with-github"
title: "Designs as Code with GitHub"
description: "Back Meshery designs with a GitHub repository, version them alongside application code, and understand why design-as-code is essential for agent-generated infrastructure changes."
weight: 3
---

## Why Designs Belong in Git

A Meshery design deployed directly from the UI or CLI exists only in Meshery's local database. If the instance is reset, or a teammate needs to reproduce the deployment, there is no durable record. Checking designs into a GitHub repository adds commit history, branch isolation, code review, and CI/CD integration.

Design-as-code matters specifically for agent-generated infrastructure. When a coding agent modifies a design - adding a sidecar, adjusting resource limits, wiring a new service - that change must go through the same review process as application code. A pull request is the natural human-in-the-loop checkpoint: the agent proposes, a human reviews, and the merge triggers deployment. Without version control, agent changes are invisible and irreversible.

## Setting Up a GitHub-Backed Design Repository

The minimal structure for a design repository is straightforward:

```text
infrastructure/
  designs/
    microservices-demo.yaml
    observability-stack.yaml
    llm-mcp-gateway.yaml
    policy-guardrails.yaml
  README.md
```

Each `.yaml` file is a Meshery design exported from Kanvas or produced by an agent. The repository is the source of truth; Meshery is the deployment engine.

To export a design from Meshery for committing to the repository, use the CLI:

```bash
mesheryctl design export --id <design-id> -o designs/microservices-demo.yaml
```

Commit and push the file as you would any other code change:

```bash
git add designs/microservices-demo.yaml
git commit -s -m "feat: add microservices demo design"
git push origin main
```

## Importing from GitHub

Once designs are in a repository, import them directly from a raw URL rather than a local file path:

```bash
mesheryctl design import \
  -f https://raw.githubusercontent.com/<org>/<repo>/main/designs/microservices-demo.yaml \
  -s "Kubernetes Manifest"
```

This works in CI pipelines as well. A GitHub Actions workflow can import a design and deploy it on every merge to `main`, giving you continuous delivery for infrastructure alongside application deployments.

## Pull-Request Previews

The most powerful pattern in design-as-code is the pull-request preview: when a pull request modifies a design file, a CI job imports the changed design into a preview environment and posts a Kanvas snapshot as a PR comment. Reviewers see the topology diff - what was added, removed, or changed - without needing to clone the branch and load it locally.

The workflow looks like this:

1. A developer (or a coding agent) opens a PR that modifies `designs/microservices-demo.yaml`.
2. A CI job runs `mesheryctl design import` against the changed file in a staging Meshery instance.
3. The job captures a Kanvas snapshot and posts it as a PR comment alongside a diff of the YAML.
4. A platform engineer reviews the visual topology and the YAML diff, then approves or requests changes.
5. On merge, a second job deploys the design to the production environment.

This pattern is why design-as-code pairs so naturally with agent-generated changes. An agent operating in an agentic loop can draft infrastructure changes, open a pull request, and surface the preview for human review - without requiring the reviewing engineer to understand the raw YAML. The visual diff in Kanvas is the communication layer between the agent and the human.

## Versioning and Rollback

Because designs are files in Git, every change is addressable by commit SHA. Rolling back to a previous infrastructure state is a `git revert` followed by a re-import and re-deploy:

```bash
git revert <commit-sha>
git push origin main
# CI imports and deploys the reverted design automatically
```

## Why Agent-Generated Changes Need This Model

An agent generates infrastructure changes at a rate that makes manual auditing impractical without tooling. The Git-backed design workflow provides three essential guardrails:

| Guardrail | Mechanism |
|---|---|
| Auditability | Every agent change is a commit with a message, author, and timestamp |
| Reviewability | Pull requests expose the change for human approval before deployment |
| Reversibility | Git history makes rollback deterministic and fast |

The academy's `designs/llm-mcp-gateway.yaml` design represents the kind of infrastructure an agent might generate or modify: a gateway that routes traffic between an LLM inference service and downstream consumers. Import it and inspect it in Kanvas to see how a more complex agent-related topology is structured:

```bash
mesheryctl design import -f designs/llm-mcp-gateway.yaml -s "Kubernetes Manifest"
```

In the next lesson you will learn how Meshery's environments and workspaces provide the organizational model for promoting designs across dev, staging, and production stages.
