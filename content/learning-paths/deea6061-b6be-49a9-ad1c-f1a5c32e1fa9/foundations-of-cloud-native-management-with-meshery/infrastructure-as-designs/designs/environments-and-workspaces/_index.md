---
type: "page"
id: "environments-and-workspaces"
title: "Environments and Workspaces"
description: "Understand Meshery environments, workspaces, teams, and RBAC, and learn how to promote designs across development, staging, and production stages."
weight: 4
---

## The Organizational Model

Meshery provides two layered abstractions for organizing infrastructure: **environments** and **workspaces**. Together they let a platform team manage multiple clusters and promotion stages without mixing concerns. When coding agents are generating changes, these boundaries are critical - an agent acting in a development context must not be able to affect a production cluster.

## Environments

An environment in Meshery is a named grouping of connections - cluster connections, metrics endpoints, and other infrastructure integrations. An environment represents a deployment target. Common environments in a typical organization:

| Environment | Cluster | Purpose |
|---|---|---|
| `dev` | `minikube` or `kind` | Individual developer iteration |
| `staging` | Shared cluster, isolated namespace | Integration testing and pre-release validation |
| `production` | Production cluster | Live traffic |

You create and manage environments in the Meshery UI under **Settings > Environments**, or via the API. Each environment holds one or more connections, which are authenticated references to cluster API servers. When you deploy a design, you select the target environment; Meshery routes the deployment to the connections in that environment.

This separation means that importing a design into Meshery does not automatically deploy it anywhere. The import step stores the design; the deploy step targets a specific environment. That two-step model is an important safety boundary, especially when agents are generating designs automatically.

## Workspaces

A workspace is a collaborative container that groups environments, designs, and team members. It is the unit of access control in Meshery. A workspace might map to a business unit, an application squad, or a product area.

Key properties of a workspace:

- **Members** - users who can view and modify resources in the workspace
- **Environments** - the deployment targets available to workspace members
- **Designs** - the designs owned by the workspace
- **Tokens** - API tokens scoped to the workspace, used by CI pipelines and coding agents

When a coding agent operates against Meshery, it authenticates with a workspace-scoped token. That token grants the agent access only to the designs, environments, and connections associated with that workspace - nothing outside it. This is the RBAC boundary that prevents an agent from reaching across workspace boundaries.

## Teams and RBAC

Meshery Cloud provides role-based access control at the workspace level. Three built-in roles cover most use cases:

| Role | Permissions |
|---|---|
| Viewer | Read designs, view deployments, read environment status |
| Editor | All Viewer permissions, plus create and modify designs |
| Admin | All Editor permissions, plus manage members, environments, and tokens |

In practice, individual contributors are Editors in their team's workspace, senior platform engineers are Admins, and service accounts used by CI pipelines or coding agents are granted the narrowest role sufficient for their task - usually Editor in a single non-production workspace.

## Promoting Designs Across Environments

Design promotion moves a validated design from one environment to the next. The workflow integrates with the GitHub-backed design pattern from the previous lesson:

1. A developer or coding agent creates or modifies a design in the `dev` workspace and deploys it to `dev` for initial validation.
2. A pull request opens against the main branch. The CI pipeline imports the design into `staging` and runs validation checks.
3. After approval and merge, the pipeline deploys to `staging`. Automated tests run against the live deployment.
4. A final approval gate triggers deployment to `production`.

The CLI commands for each promotion step follow the same pattern:

```bash
# Deploy to staging
mesheryctl design deploy --id <design-id> --environment staging

# Deploy to production after approval
mesheryctl design deploy --id <design-id> --environment production
```

The `--environment` flag accepts the environment name configured in Meshery. The deployment is routed to all cluster connections in that environment.

## Policy Guardrails at Promotion Boundaries

The academy's `designs/policy-guardrails.yaml` design demonstrates how OPA-based policy checks can be embedded in the design lifecycle. Import it to see how policy components sit alongside workload components in a design topology:

```bash
mesheryctl design import -f designs/policy-guardrails.yaml -s "Kubernetes Manifest"
```

Meshery evaluates OPA policies against a design before deployment, rejecting those that violate organizational standards: no `latest` image tags in production, required resource limits, mandatory network policies. Combined with environment-scoped deployment and workspace RBAC, policy checks make agent-generated infrastructure safe to promote automatically.

With environments, workspaces, and policy guardrails in place, you have a complete organizational model for managing designs at scale.
