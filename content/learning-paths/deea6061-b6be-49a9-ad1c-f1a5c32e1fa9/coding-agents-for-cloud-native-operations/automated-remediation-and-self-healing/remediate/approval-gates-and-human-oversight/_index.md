---
type: "page"
id: "approval-gates-and-human-oversight"
title: "Approval Gates and Human Oversight"
description: "Design human approval checkpoints by risk and blast radius, and identify which remediation actions are safe to fully automate."
weight: 2
---

## Why Approval Gates Are Not Optional

An agent that can propose a remediation action and execute it without any human checkpoint is a liability, not an asset. The failure modes are predictable: the agent misidentifies the root cause, selects a valid-sounding action that is wrong for the specific context, and executes it before anyone can intervene. In a production environment, this can turn a recoverable incident into a prolonged outage.

Approval gates do not slow down remediation - they bound the blast radius of misdiagnosis. A well-designed gate adds seconds to the human-in-the-loop path while preventing irreversible actions from executing autonomously.

The goal is not maximum automation. The goal is maximum safe automation.

## Classifying Actions by Risk

Not all remediation actions carry equal risk. Use this classification to decide where gates are required:

| Risk Tier | Example Actions | Gate Required? |
|---|---|---|
| Low | Restart a single pod, scale a stateless deployment up by 1 | Optional - can automate with rollback detection |
| Medium | Scale down a deployment, change a ConfigMap, apply a resource limit | Recommended - changes are reversible but have user-visible impact |
| High | Delete a PersistentVolumeClaim, change a Service's selector, roll back a database migration | Required - actions may be irreversible or affect persistent state |
| Critical | Modify RBAC, change network policies, alter cluster-level configuration | Required + secondary approval - blast radius is cluster-wide |

The tiers are not prescriptive. Your organization's risk tolerance and rollback capabilities will shift boundaries. What matters is that you have an explicit classification and that agents cannot promote themselves to a higher tier at runtime.

## Designing the Gate

An approval gate in an agent workflow is a synchronous pause point. The agent:

1. Produces a proposed action in a structured, human-readable format
2. Sends it to a review channel (Slack, GitHub PR, PagerDuty, or your incident management tool)
3. Waits for an explicit approval or rejection signal
4. Proceeds only on approval; on rejection, logs the decision and escalates or terminates

The proposed action must include enough context for a reviewer to make an informed decision without reading logs. A minimal approval request looks like this:

```text
PROPOSED REMEDIATION
--------------------
Trigger:    CrashLoopBackOff on pod payments-api-7d9f4c-xkzqp (namespace: production)
Root cause: OOM kill - container exceeded 256Mi memory limit 3 times in 10 minutes
Action:     Scale memory limit from 256Mi to 512Mi on Deployment/payments-api
Rollback:   kubectl patch deployment payments-api -p '{"spec":{"template":{"spec":{"containers":[{"name":"payments-api","resources":{"limits":{"memory":"256Mi"}}}]}}}}'
Risk tier:  Medium
Approver:   on-call SRE
```

A reviewer can act on this in under 30 seconds. A wall of logs cannot be triaged in that time.

## What Can Be Safely Automated

Full automation - no human gate - is appropriate when all of the following are true:

- The action is reversible within seconds with no user-visible impact
- The trigger condition has a false-positive rate below a defined threshold (see lesson 4 on measuring safety)
- The action has been exercised in a staging environment with a representative load profile
- A circuit breaker exists that disables automation if the action fires more than N times in a window

Restarting a pod that has just entered `CrashLoopBackOff` for a container that has no persistent state is the canonical safe-automation case. Even here, the circuit breaker matters: if the pod restarts successfully and crashes again within five minutes, the correct action is escalation, not another restart.

## Integrating Gates with Meshery

Meshery's environment model gives you a natural scope boundary for gate policies. You can configure different gate requirements per environment - stricter in production, looser in staging.

Import the policy guardrails design to establish the gate policy baseline:

```bash
mesheryctl design import -f designs/policy-guardrails.yaml -s "Kubernetes Manifest"
```

Use Kanvas to inspect the policy model visually and confirm that environment scopes match your intended gate boundaries before deploying the workflow. The design's OPA-based policies express which actions require approval in which environments - your agent checks these at the decide phase before constructing an approval request.

## The Human Judgment Boundary

Agents are good at pattern matching over structured state at scale and speed. They are poor at:

- Knowing when "technically correct" is operationally wrong (a rollback that is valid but will disrupt a time-sensitive batch job)
- Weighing factors outside the signal set (a change freeze, an upcoming maintenance window, a business-critical transaction in flight)
- Recognizing when the situation has no good automated answer

These are human judgment calls. The gate is the mechanism that ensures a human makes them. Design your workflows so that the agent's job is to prepare the best possible decision package, and the human's job is to approve or reject it - not to gather the data themselves.
