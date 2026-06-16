# Meshery Designs — TCS Labs Academy

This folder contains **importable, runnable Meshery designs** used throughout the academy's design,
operations, and governance learning paths and challenges. Each file is valid Kubernetes YAML, so it
can be:

- **imported into Meshery** as a design (and opened in **Kanvas** to visualize, validate, and deploy), or
- applied directly with `kubectl` for a quick start.

| Design | File | What it installs |
|--------|------|------------------|
| Microservices demo app | [`microservices-demo.yaml`](microservices-demo.yaml) | A three-tier app — `frontend` (nginx) → `api` ([podinfo](https://github.com/stefanprodan/podinfo)) → `redis` cache — in the `tcslabs-demo` namespace |
| Observability stack | [`observability-stack.yaml`](observability-stack.yaml) | Prometheus (with scrape RBAC) + Grafana in the `tcslabs-observability` namespace |
| LLM / MCP gateway | [`llm-mcp-gateway.yaml`](llm-mcp-gateway.yaml) | An OpenAI-compatible inference service (Ollama) behind a gateway in the `tcslabs-ai` namespace |
| Policy & guardrails | [`policy-guardrails.yaml`](policy-guardrails.yaml) | ResourceQuota + LimitRange + default-deny NetworkPolicy + PodDisruptionBudget in `tcslabs-guardrails` |

## Prerequisites

- A Kubernetes cluster (any conformant cluster: kind, k3d, minikube, or a managed cluster).
- [Meshery](https://docs.meshery.io/) running (`mesheryctl system start`) with the cluster connected
  (`mesheryctl system check`).
- For GPU-backed inference, a GPU node pool and the NVIDIA device plugin (see the comments in
  `llm-mcp-gateway.yaml`).

## Import into Meshery

Import a design from a local file (run from the repository root):

```bash
mesheryctl design import -f designs/microservices-demo.yaml -s "Kubernetes Manifest"
```

...or straight from its raw URL once this content is merged:

```bash
mesheryctl design import \
  -f https://raw.githubusercontent.com/meshery-extensions/tcslabs-academy/master/designs/observability-stack.yaml \
  -s "Kubernetes Manifest"
```

After importing, open the design in **Kanvas** to inspect components and relationships, run
**relationship and policy validation**, and **deploy** it to your cluster. You can also save it to
the **Meshery Catalog** as a reusable template, or back it with GitHub for versioning and
pull-request previews.

## Apply directly with kubectl (quick start)

```bash
kubectl apply -f designs/microservices-demo.yaml
kubectl -n tcslabs-demo get deploy,svc,pods
```

## How the academy uses these

- **LP 3 — AI-Assisted Infrastructure Design:** generate a design with an LLM, then compare it to
  `microservices-demo.yaml`; deploy with a coding agent + `mesheryctl`.
- **LP 4 — Day-2 Operations:** deploy `observability-stack.yaml`, then practice AI-assisted
  diagnostics and performance testing against `microservices-demo.yaml`.
- **LP 5 — MCP & Integrations:** point an MCP tool / coding agent at the `llm-mcp-gateway.yaml`
  endpoint and at live cluster state.
- **LP 6 — Governance:** apply `policy-guardrails.yaml` and validate designs against policy.

> **Note:** These designs are intentionally minimal and education-focused. They use `emptyDir`
> storage and demo credentials. Harden storage, secrets, resource limits, replicas, ingress, and
> network policy before any production use.
