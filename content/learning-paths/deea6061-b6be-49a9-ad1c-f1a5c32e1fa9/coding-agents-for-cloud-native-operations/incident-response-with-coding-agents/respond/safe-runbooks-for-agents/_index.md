---
type: "page"
id: "safe-runbooks-for-agents"
title: "Safe Runbooks for Agents"
description: "Learn how to write structured runbooks that a coding agent can follow safely, with explicit approval points, read-only defaults, and clear stop conditions."
weight: 2
---

## Why Runbooks Need a New Shape

A runbook written for a human engineer relies on tacit knowledge. Phrases like "check if things look normal" or "restart it if you think it's stuck" are meaningful to an experienced operator. To a coding agent, they are ambiguous instructions that produce unpredictable behavior.

Agent-safe runbooks are explicit, structured, and conservative by design. Every step either reads state or waits for human approval before writing state. The result is a runbook that is safer to delegate to an agent - and, as a side benefit, clearer for a human to follow under stress at 3 AM.

## Principle 1: Read-Only by Default

Structure every runbook so that the first N steps are purely observational. The agent gathers state, formats a summary, and presents it. No mutations occur until a human explicitly approves a change step.

```yaml
# runbook-crashloop.yaml
steps:
  - id: gather-pod-state
    type: read
    command: "kubectl get pods -n {{ .namespace }} -l app={{ .app }}"

  - id: gather-recent-events
    type: read
    command: "kubectl get events -n {{ .namespace }} --sort-by='.metadata.creationTimestamp' | tail -30"

  - id: gather-logs
    type: read
    command: "kubectl logs -n {{ .namespace }} -l app={{ .app }} --since=15m --tail=200"

  - id: human-approval-1
    type: approval
    prompt: "Review the above state. Approve to proceed to stabilization, or abort."
```

This structure means an agent can safely begin a runbook the moment an alert fires, without risk of unintended state changes.

## Principle 2: Explicit Steps

Never allow a runbook step to contain ambiguity. Each step must specify:

- **What command or API call to execute** - exact syntax, no interpretation required
- **What the expected output looks like** - so the agent knows when a step succeeded
- **What to do if the expected output is not observed** - an explicit fallback or a stop condition

```yaml
  - id: check-image-tag
    type: read
    command: "kubectl get deployment {{ .app }} -n {{ .namespace }} -o jsonpath='{.spec.template.spec.containers[0].image}'"
    expected_pattern: "{{ .expected_image }}"
    on_mismatch: "escalate"
```

Vague steps ("investigate the logs") must be replaced with a sequence of explicit commands. If you cannot write explicit steps, that portion of the runbook is not ready to delegate to an agent.

## Principle 3: Approval Points

An approval point is a step that halts the agent and requires explicit human confirmation before proceeding. Insert an approval point:

- Before any `kubectl apply`, `kubectl delete`, or `kubectl rollout` command
- Before any Meshery design deployment or update
- Before any configuration change to a service mesh policy
- Whenever the next step could affect more than the workload under investigation

```yaml
  - id: approval-before-rollback
    type: approval
    prompt: |
      Proposed action: roll back {{ .app }} to image {{ .previous_image }}.
      Affected namespace: {{ .namespace }}.
      Estimated recovery time: unknown.
      Type APPROVE to proceed or ABORT to stop.
```

Approval points are not optional checkboxes. They are hard stops in the runbook execution. An agent that skips an approval point is a runbook defect, not an efficiency improvement.

## Principle 4: Stop Conditions

A stop condition terminates runbook execution when the situation has moved outside the runbook's designed scope. Without explicit stop conditions, an agent will continue executing steps even when the environment is behaving in ways the runbook author did not anticipate.

```yaml
stop_conditions:
  - condition: "pod_count < expected_minimum"
    message: "Cluster state has degraded beyond runbook scope. Escalate to on-call lead."
  - condition: "error_rate > 0.5"
    message: "Error rate exceeds 50%. This incident requires manual intervention. Stop."
  - condition: "step_duration_exceeded"
    threshold_minutes: 10
    message: "Runbook step took longer than expected. Human review required."
```

Stop conditions should be evaluated before each step, not just at the end of the runbook. A condition that was safe at step 2 may no longer be safe at step 8 if the environment changed during execution.

## Structuring a Runbook for Meshery

When your runbook involves Meshery designs, use `mesheryctl` commands that read before they write. The import command is safe as a read step when used to preview a design; deployment requires approval.

```bash
# Read-only: inspect the current design state
mesheryctl design list
mesheryctl system check

# Write: requires approval gate before execution
mesheryctl design import -f designs/microservices-demo.yaml -s "Kubernetes Manifest"
```

Store your runbooks as versioned YAML files in the same repository as your infrastructure code. This makes runbook changes reviewable, auditable, and rollback-capable - the same properties you require of the infrastructure itself.

## Runbook Template Checklist

Before delegating a runbook to an agent, verify:

- [ ] All steps are explicit - no ambiguous instructions
- [ ] The first steps are read-only
- [ ] Every write step is preceded by an approval point
- [ ] Stop conditions are defined and cover out-of-scope failure modes
- [ ] Expected output is specified for each read step
- [ ] The runbook has been tested by a human following it manually

A runbook that passes this checklist is ready to be handed to a coding agent. One that does not pass is still a human-only runbook, regardless of how you structure the agent's prompt.
