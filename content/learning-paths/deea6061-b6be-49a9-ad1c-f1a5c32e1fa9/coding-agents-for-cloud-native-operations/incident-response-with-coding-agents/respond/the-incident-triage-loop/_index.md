---
type: "page"
id: "the-incident-triage-loop"
title: "The Incident Triage Loop"
description: "Understand the five phases of incident triage and where a coding agent accelerates each phase versus where a human must lead."
weight: 1
---

## What the Triage Loop Is

Every incident, from a single pod crashloop to a full-cluster outage, passes through the same five phases: detect, assess severity, stabilize, diagnose, and resolve. The speed at which you move through these phases determines how long your users are affected. A coding agent can compress the time spent on data gathering and hypothesis generation - the phases where human attention is most often the bottleneck.

Understanding where the agent helps and where human judgment is irreplaceable is the first discipline of agent-assisted incident response.

## Phase 1: Detect

**What happens:** An alert fires, a user reports an error, or automated health checks surface a degraded signal.

**Agent's role:** An agent can be wired into your alerting pipeline to receive the raw alert payload and immediately begin gathering context - current pod state, recent deployment events, relevant metrics from Prometheus or Grafana. By the time a human opens the incident channel, the agent may already have assembled a structured summary.

```bash
# Agent-initiated: gather state the moment the alert fires
kubectl get pods -n production --field-selector=status.phase!=Running
kubectl get events -n production --sort-by='.metadata.creationTimestamp' | tail -20
mesheryctl system check
```

**Human's role:** A human must confirm the alert is genuine and decide whether to escalate. Automated detection cannot reliably distinguish a real outage from a noisy sensor. That judgment call stays with the on-call engineer.

## Phase 2: Assess Severity

**What happens:** Determine the blast radius - how many users, services, or regions are affected.

**Agent's role:** The agent can query service dependency graphs, check related services using MeshSync data surfaced through Meshery, and cross-reference error rates across namespaces. It can produce a structured severity assessment using predefined criteria you supply in the runbook.

**Human's role:** Severity level drives escalation paths, communication to stakeholders, and decision authority. A human owns this call. The agent provides evidence; the human assigns the severity tier.

## Phase 3: Stabilize

**What happens:** Stop the bleeding before diagnosing the root cause. This might mean rolling back a deployment, disabling a feature flag, or shifting traffic away from a degraded zone.

**Agent's role:** An agent can propose stabilization actions based on runbook templates, but it must not execute them autonomously. Stabilization changes production state. The blast radius of a wrong stabilization action can exceed the blast radius of the original incident.

**Human's role:** Approve every stabilization action. Even well-structured runbooks contain conditional branches that require situational judgment. The human is the approval gate.

## Phase 4: Diagnose

**What happens:** Identify the root cause of the failure.

**Agent's role:** This is where the coding agent adds the most value. Diagnosis is time-consuming, context-heavy, and often requires correlating data from many sources simultaneously. An agent can:

- Retrieve logs across multiple pods in parallel
- Compare the current Meshery design snapshot against the last known-good state
- Query Prometheus for metric anomalies correlated with the incident timestamp
- Search past postmortems for similar failure signatures

```bash
# Parallel log retrieval - agent-executable
kubectl logs -n production -l app=payments --since=30m --tail=500
kubectl describe pod -n production <failing-pod>
```

**Human's role:** Validate the agent's hypothesis. The agent reasons from patterns; the human understands the system's history, recent changes, and business context that the agent's context window may not fully capture.

## Phase 5: Resolve

**What happens:** Apply the fix, verify recovery, and hand off to a postmortem.

**Agent's role:** The agent can scaffold the fix - generating the corrected manifest, importing it as a Meshery design, or producing a diff for human review. After the fix is applied, the agent can monitor recovery by polling pod status and error rates until steady-state is confirmed.

**Human's role:** Approve and apply the fix. Confirm that recovery is genuine and not a transient lull. Declare the incident resolved and open the postmortem.

## Designing the Loop

The triage loop is not linear in practice. Phase 4 often loops back to phase 2 as you discover the incident is larger than initially assessed. Design your agent's runbook with explicit re-entry points and stop conditions for each phase.

| Phase | Agent contribution | Human gate |
|---|---|---|
| Detect | Alert context aggregation | Confirm and escalate |
| Assess | Blast radius evidence | Assign severity tier |
| Stabilize | Propose actions | Approve every change |
| Diagnose | Parallel data gathering, hypothesis | Validate root cause |
| Resolve | Fix scaffold, recovery monitoring | Approve fix, declare resolved |

The key discipline is keeping the agent in an advisory and observational role until a human explicitly delegates a specific, bounded action. An agent that acts without approval is not an incident responder - it is an incident risk.
