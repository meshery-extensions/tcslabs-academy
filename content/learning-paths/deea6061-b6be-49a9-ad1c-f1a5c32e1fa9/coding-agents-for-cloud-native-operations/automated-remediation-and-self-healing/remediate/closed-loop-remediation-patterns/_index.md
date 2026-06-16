---
type: "page"
id: "closed-loop-remediation-patterns"
title: "Closed-Loop Remediation Patterns"
description: "Understand the detect-decide-act-verify loop, where Kubernetes' built-in self-healing ends, and where agent-driven remediation begins."
weight: 1
---

## The Four-Phase Remediation Loop

A closed-loop remediation system has exactly four phases, and every robust implementation maps to them. If any phase is missing, you no longer have a loop - you have a script that fires once and hopes for the best.

**Detect** - A signal indicates that something is wrong. This might be a Prometheus alert threshold crossing, a Kubernetes event of type `Warning`, a MeshSync state change that Meshery surfaces, or an SLO burn rate triggering.

**Decide** - Given the signal, the system (or agent) reasons about what action to take. This is the phase where raw alert data becomes a proposed remediation: restart the pod, scale the deployment, roll back the release, or escalate to a human.

**Act** - The proposed action is executed against the cluster. For agent-driven workflows, this is typically a `kubectl` command, a Meshery API call, or a design deployment via `mesheryctl`.

**Verify** - After acting, the system checks whether the condition that triggered detection has resolved. If it has not resolved within a timeout window, the loop either retries a different action or escalates.

This loop is not novel - it mirrors the Kubernetes controller model. What changes with agent-driven remediation is the sophistication of the decide phase and the scope of actions in the act phase.

## What Kubernetes Already Handles

Before reaching for an agent, understand what your cluster already does for free.

| Failure Mode | Kubernetes Mechanism | How It Works |
|---|---|---|
| Container crash | Restart policy + kubelet | kubelet restarts crashed containers up to the backoff limit |
| Node failure | Pod eviction + scheduler | Pods are evicted and rescheduled on healthy nodes |
| Replica count drift | ReplicaSet controller | Controller adds or removes pods to match desired count |
| Rollout failure | Deployment rollout strategy | `maxUnavailable` and `maxSurge` limit blast radius during rollouts |
| Resource pressure | Vertical Pod Autoscaler | Adjusts resource requests and limits based on usage history |
| Traffic load | Horizontal Pod Autoscaler | Scales replica count based on CPU or custom metrics |

These mechanisms are fast, low-overhead, and do not require human involvement. They are the right answer for the failure modes they cover.

## Where Agent-Driven Remediation Begins

Kubernetes' controllers are intentionally narrow. They operate on well-defined state transitions within a single resource type. They cannot:

- Correlate signals across multiple services to identify a dependency failure
- Consult a runbook and decide which of several possible fixes to apply
- Distinguish between a transient spike and a sustained degradation that requires intervention
- Propose a rollback and ask a human to approve it before executing

This is where a coding agent adds value. An agent operating in the decide phase can take a raw alert payload, query Meshery for current component state, pull recent events from MeshSync, and reason over that combined context to produce a specific, actionable recommendation.

Import the policy guardrails design to give your agent a structured set of constraints to reason within:

```bash
mesheryctl design import -f designs/policy-guardrails.yaml -s "Kubernetes Manifest"
```

This design defines the boundaries within which automated actions are permitted - the agent checks proposed actions against these policies before executing.

## Matching the Pattern to the Failure

A practical heuristic for choosing between Kubernetes self-healing and agent-driven remediation:

```text
If the fix can be expressed as a single-resource state transition
  -> Use a Kubernetes controller

If the fix requires correlating signals across multiple resources or services
  -> Use an agent in the decide phase

If the fix changes cluster topology, involves data, or exceeds a defined blast radius
  -> Require human approval before acting
```

The last rule is the most important. Agents are reasoning systems, not infallible authorities. A closed loop without a human gate is a liability when the action space includes writes that cannot be safely undone. The next lesson covers how to design those gates.

## Verifying the Loop End-to-End

Before building anything more complex, verify that your Meshery environment can observe the signals that feed the detect phase:

```bash
# Check that Meshery Operator and MeshSync are active
mesheryctl system check

# Verify designs are being tracked - signals require reconciled state
mesheryctl design list
```

If `mesheryctl system check` reports MeshSync is not running, your detect phase has no reliable data source. Resolve this before proceeding to the decide and act phases - an agent reasoning over stale state will produce incorrect remediations with high confidence.
