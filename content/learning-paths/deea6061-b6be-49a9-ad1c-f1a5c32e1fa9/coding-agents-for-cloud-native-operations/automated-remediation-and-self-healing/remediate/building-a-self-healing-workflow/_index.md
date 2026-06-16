---
type: "page"
id: "building-a-self-healing-workflow"
title: "Building a Self-Healing Workflow"
description: "Assemble a guarded, auditable self-healing workflow: trigger, agent diagnosis, proposed remediation, approval gate, and verification step."
weight: 3
---

## The Five Components of a Guarded Workflow

A self-healing workflow that is both effective and safe requires exactly five components in a fixed sequence. Skipping any one of them produces a workflow that is either blind, reckless, or unauditable.

1. **Trigger** - An event or threshold crossing that starts the workflow
2. **Agent diagnosis** - Structured reasoning over cluster state to identify the root cause
3. **Proposed remediation** - A concrete, human-readable action plan with rollback information
4. **Approval gate** - A synchronous human checkpoint before any write operation executes
5. **Verification step** - Confirmation that the action resolved the triggering condition

This lesson walks through assembling each component using Meshery and a coding agent.

## Step 1: Define the Trigger

The trigger is the detect phase of the remediation loop. For this workflow, use a Prometheus alert that fires when a deployment's available replica count drops below the desired count for more than two minutes.

First, import the observability stack that wires Prometheus into your cluster:

```bash
mesheryctl design import -f designs/observability-stack.yaml -s "Kubernetes Manifest"
```

Your trigger fires when the `kube_deployment_status_replicas_available` metric falls below `kube_deployment_spec_replicas` for 120 seconds. The alert payload should include the deployment name, namespace, desired count, and available count.

The trigger must be narrow. A broad trigger (any pod in any namespace) produces noise that trains reviewers to ignore approval requests. A narrow trigger (specific deployment in production namespace) produces actionable signals.

## Step 2: Agent Diagnosis

When the trigger fires, the agent's first job is to gather enough context to reason about root cause. A minimal diagnosis sequence using Meshery:

```bash
# Pull current state from MeshSync
mesheryctl system check

# List designs to identify the affected component in Meshery's model
mesheryctl design list
```

The agent then constructs a structured context object containing:

- Current pod status for the affected deployment
- Recent Kubernetes events filtered to the deployment's namespace and pod label selector
- Resource utilization for the affected pods (CPU throttling, OOM kills)
- Any recent design or configuration changes MeshSync has recorded

Pass this structured context to the LLM with a diagnosis prompt:

```text
You are diagnosing a production incident. A deployment named {deployment_name} in
namespace {namespace} has {available} of {desired} replicas available for the past
{duration}. 

The following cluster state was collected at {timestamp}:
{structured_context}

Identify the most likely root cause. Classify it as one of: resource-exhaustion,
configuration-error, dependency-failure, or node-failure. Propose a single remediation
action. Include a rollback command.
```

The structured context keeps the diagnosis grounded. An agent reasoning over a 50-token JSON object produces more reliable output than one reading a 5000-token log dump.

## Step 3: Proposed Remediation

The agent's output must be a structured proposal, not free text. Define the schema your workflow expects and validate against it before passing the proposal to the gate:

```yaml
remediation_proposal:
  trigger_id: "alert-abc123"
  timestamp: "2025-06-16T14:32:00Z"
  affected_resource: "deployment/payments-api"
  namespace: "production"
  root_cause_class: "resource-exhaustion"
  root_cause_summary: "Container OOM-killed 3 times in 10 minutes; memory limit 256Mi too low for current load"
  proposed_action: "Patch memory limit to 512Mi on deployment/payments-api"
  action_command: "kubectl patch deployment payments-api -n production -p '{\"spec\":{\"template\":{\"spec\":{\"containers\":[{\"name\":\"payments-api\",\"resources\":{\"limits\":{\"memory\":\"512Mi\"}}}]}}}}'"
  rollback_command: "kubectl patch deployment payments-api -n production -p '{\"spec\":{\"template\":{\"spec\":{\"containers\":[{\"name\":\"payments-api\",\"resources\":{\"limits\":{\"memory\":\"256Mi\"}}}]}}}}'"
  risk_tier: "medium"
  confidence: 0.87
```

If the agent's output does not parse into this schema, reject it and escalate. A malformed proposal is a signal that the agent's reasoning went off-track.

## Step 4: Approval Gate

Send the structured proposal to your review channel. The gate implementation waits for a structured response - approved or rejected - from an authorized reviewer. On rejection, log the decision with the reviewer's reason and exit the workflow without executing the action.

Configure the gate timeout to match your incident SLA. A 10-minute gate timeout is reasonable for medium-risk actions. For low-risk actions in off-hours, you may want to auto-approve if no reviewer responds - but only if you have validated the action's safety profile against the metrics from lesson 4.

Use the policy guardrails design to enforce gate requirements per environment:

```bash
mesheryctl design import -f designs/policy-guardrails.yaml -s "Kubernetes Manifest"
```

The OPA policies in this design express which risk tiers require human approval in which environments, so the gate check is declarative rather than hardcoded in the workflow logic.

## Step 5: Verification

After the approved action executes, the workflow enters the verify phase. It watches the same metric that triggered the alert and waits for it to resolve within a defined window (typically 5-10 minutes).

```bash
# After action executes, confirm Meshery's view of the component has updated
mesheryctl system check

# Verify the deployment shows the expected replica count
mesheryctl design list
```

If the trigger condition does not resolve within the window:

1. Log the failure with full context (trigger, diagnosis, action, post-action state)
2. Execute the rollback command from the proposal
3. Escalate to a human with the full audit trail

## Audit Trail Requirements

Every step must produce a log entry. A complete audit trail for a single remediation cycle includes:

| Event | Required Fields |
|---|---|
| Trigger received | timestamp, alert ID, alert payload |
| Diagnosis started | timestamp, context snapshot hash |
| Proposal generated | timestamp, full proposal YAML, model used |
| Gate opened | timestamp, proposal ID, reviewer list |
| Gate decision | timestamp, reviewer ID, decision, reason |
| Action executed | timestamp, exact command, exit code |
| Verification result | timestamp, metric value, resolved: true/false |
| Rollback (if needed) | timestamp, rollback command, exit code |

Store this trail in a durable log - not in ephemeral container logs. If you cannot reconstruct what happened and why from the audit trail alone, the workflow is not auditable.
