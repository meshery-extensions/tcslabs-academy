---
type: "page"
id: "sandboxing-agent-actions"
title: "Sandboxing Agent Actions"
description: "Prove agent behaviors in dev, dry-run, and ephemeral namespace environments before allowing them to touch production infrastructure."
weight: 3
---

## The Principle of Progressive Promotion

An agent that generates a change in response to an instruction has not been tested - it has been generated. Those are very different things. A generated change may be structurally valid YAML that passes schema checks and still destroy a production workload when applied. Sandboxing is the practice of running agent actions in progressively more real environments until confidence is high enough to promote to production.

The sequence looks like this:

```text
Dry-run validation
       |
       v
Ephemeral namespace (cluster, no real traffic)
       |
       v
Staging environment (realistic data, low stakes)
       |
       v
Production (with human approval gate from the previous lesson)
```

Each stage catches a different class of problem. Do not skip stages under time pressure - the stages exist precisely because time pressure is when mistakes happen.

## Dry-Run Validation

Kubernetes supports server-side dry-run on any mutating API call. A dry-run request goes through the full admission control chain - including OPA policies, validating webhooks, and RBAC - but does not persist any state. This makes it the cheapest and fastest first check for an agent-generated change.

```bash
kubectl apply -f agent-output.yaml \
  --dry-run=server \
  --namespace=staging
```

A successful server-side dry-run tells you the manifest is valid, passes admission, and would not conflict with existing resources. It does not tell you whether the running workload will behave correctly after the change - that requires a real environment.

When an agent produces a Meshery design, import it with a dry-run flag before committing:

```bash
mesheryctl design import \
  -f designs/microservices-demo.yaml \
  -s "Kubernetes Manifest"
```

Review the output carefully. If Meshery reports validation warnings or relationship conflicts, treat them as blocking - do not proceed to the next stage until they are resolved.

## Ephemeral Namespaces

An ephemeral namespace is a short-lived Kubernetes namespace created specifically for a single test run. The agent applies its changes there, tests run, and the namespace is deleted. Because it is isolated from other namespaces by default, a failure in an ephemeral namespace cannot affect production workloads.

Create an ephemeral namespace per agent run:

```yaml
apiVersion: v1
kind: Namespace
metadata:
  name: agent-test-run-42
  labels:
    purpose: ephemeral-agent-test
    ttl: "1h"
```

Apply the agent's output to the ephemeral namespace, run smoke tests, and then tear it down:

```bash
kubectl apply -f agent-output.yaml -n agent-test-run-42
# run tests
kubectl delete namespace agent-test-run-42
```

A TTL controller (such as the one provided by [kube-janitor](https://codeberg.org/hjacobs/kube-janitor)) can automatically delete namespaces marked with a TTL label, ensuring cleanup even if the agent run fails before reaching the teardown step.

## Staging Environment Promotion

Staging differs from an ephemeral namespace in two ways: it is persistent across test runs, and it receives realistic (though not live production) traffic. An agent change that survives the ephemeral namespace stage is promoted to staging by the same design-import workflow used in production, but targeting the staging environment registered in Meshery.

The `designs/observability-stack.yaml` design should be deployed in staging so that the agent's changes are visible in metrics and traces:

```bash
mesheryctl design import \
  -f designs/observability-stack.yaml \
  -s "Kubernetes Manifest"
```

After applying the agent's change in staging, observe Prometheus and Grafana dashboards (deployed by the observability stack) for at least one traffic cycle before promoting. Automated checks should gate the promotion - for example, a CI step that fails if error rate exceeds 1% in the five minutes after the change was applied.

## Comparing Environments Before Promotion

A common failure mode is assuming staging and production are identical when they are not. Before relying on staging validation, audit the differences:

| Dimension | Check |
|---|---|
| Resource quotas | Are staging quotas comparable to production? |
| ConfigMaps / Secrets | Does staging reference the same config keys (with safe values)? |
| Installed CRDs | Are the same operator versions installed? |
| Network policies | Does staging enforce the same ingress/egress rules? |

Use `mesheryctl system check` to surface environment health before each promotion:

```bash
mesheryctl system check
```

Discrepancies between staging and production make staging validation unreliable. Fix environment parity first.

## Integrating Sandboxing into the Agentic Loop

The agentic loop should treat each sandboxing stage as a tool call with a pass/fail result. If a stage fails, the loop stops and reports the failure to the operator rather than attempting to proceed:

```text
Agent generates change
       |
       v
Tool: dry-run validate --> FAIL? --> Report and stop
       |
       v
Tool: apply to ephemeral namespace --> FAIL? --> Report and stop
       |
       v
Tool: apply to staging --> FAIL? --> Report and stop
       |
       v
Human approval gate
       |
       v
Tool: apply to production
```

This structure ensures that no production change is attempted unless every prior validation stage passed. Build each tool call to return structured output that the agent can evaluate - not just an exit code, but a machine-readable summary of what changed, what succeeded, and what the agent should include in its approval request.
