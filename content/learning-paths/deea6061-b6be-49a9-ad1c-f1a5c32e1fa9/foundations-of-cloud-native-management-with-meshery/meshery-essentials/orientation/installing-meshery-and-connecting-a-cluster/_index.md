---
type: "page"
id: "installing-meshery-and-connecting-a-cluster"
title: "Installing Meshery and Connecting a Cluster"
description: "Install Meshery with mesheryctl, verify the deployment, connect a kubeconfig context, choose a provider, and confirm that your cluster is visible in Meshery's UI."
weight: 3
---

## Prerequisites

Before you begin, confirm you have:

- `kubectl` installed and a valid kubeconfig pointing at a running Kubernetes cluster
- Docker running locally (required if you use the default Docker-based install)
- Go 1.21+ or a pre-built `mesheryctl` binary on your `PATH`

## Installing mesheryctl

`mesheryctl` is the command-line interface for Meshery. It manages the Meshery Server lifecycle and exposes every Meshery capability from the terminal.

**macOS (Homebrew):**

```bash
brew install mesheryctl
```

**Linux / manual install:**

```bash
curl -L https://meshery.io/install | bash -
```

Verify the install:

```bash
mesheryctl version
```

You should see the client version printed. The server version will show as unreachable until you start Meshery.

## Starting Meshery

```bash
mesheryctl system start
```

This command:

1. Pulls the Meshery Server container image (or Helm chart manifests if deploying to Kubernetes).
2. Starts the Server and its dependencies (database, Broker if running in-cluster).
3. Opens the Meshery UI in your default browser at `http://localhost:9081`.

By default, Meshery starts using Docker Compose on your local machine. For an in-cluster deployment, add `--platform kubernetes` - Meshery will deploy into the current kubeconfig context.

```bash
mesheryctl system start --platform kubernetes
```

## Verifying the Deployment

```bash
mesheryctl system check
```

`system check` runs a pre-flight inspection of your Meshery deployment. It verifies:

- That the Meshery Server is reachable.
- That the required Kubernetes permissions are available (if running in-cluster).
- That the Meshery Operator and MeshSync are healthy in each connected cluster.

A healthy output looks like:

```text
✓  Meshery Server is running
✓  Meshery Operator is running in context: docker-desktop
✓  MeshSync is running in context: docker-desktop
```

If any check fails, the output includes a remediation hint. Fix the indicated issue and re-run `system check` before proceeding.

## Connecting a Kubeconfig Context

Meshery reads your kubeconfig to discover available clusters. When you open the Meshery UI for the first time, it prompts you to select one or more kubeconfig contexts to connect.

From the CLI, you can also manage connections:

```bash
mesheryctl system context list
mesheryctl system context switch <context-name>
```

Each connected context causes Meshery to deploy the Meshery Operator and MeshSync into that cluster, beginning continuous discovery.

## Choosing a Provider

Meshery's **Provider** system determines where your data (designs, performance profiles, user identity) is stored and what feature set is available.

| Provider | Description |
|---|---|
| `None` | Local only, no login, full feature set, data stored locally |
| `Layer5` | Cloud-backed, persists data to Layer5 Cloud, enables sharing and team features |

For this course, the `None` provider is sufficient. Select it on the login screen to proceed without creating an account.

If you later want to collaborate on designs, share performance profiles, or participate in the Catalog, switch to the `Layer5` provider and authenticate with your Layer5 account.

## Importing a Design to Verify the Connection

The clearest way to confirm everything is working is to import a design and deploy it. The academy provides a microservices demo design you can use:

```bash
mesheryctl design import -f designs/microservices-demo.yaml -s "Kubernetes Manifest"
```

If the import succeeds and the design appears in the Meshery UI under **Designs**, your cluster connection is healthy. You can then deploy it from the UI or with:

```bash
mesheryctl design deploy <design-id>
```

## Stopping and Restarting

```bash
mesheryctl system stop
mesheryctl system start
```

Meshery is stateful: your designs, connections, and performance profiles persist across restarts (they live in the database volume). A `stop` followed by `start` is safe.

## Troubleshooting Common Issues

| Symptom | Likely cause | Fix |
|---|---|---|
| `system check` fails on Operator | Insufficient RBAC | Ensure the kubeconfig user has `cluster-admin` or equivalent |
| UI not reachable at port 9081 | Port conflict | Pass `--port <n>` to `mesheryctl system start` |
| MeshSync not syncing | Broker unreachable | Check NATS pod status: `kubectl get pods -n meshery` |

## Further Reading

- [Getting started with Meshery](https://docs.meshery.io/installation)
- [mesheryctl reference](https://docs.meshery.io/reference/mesheryctl)
- [Meshery providers](https://docs.meshery.io/extensibility/providers)
