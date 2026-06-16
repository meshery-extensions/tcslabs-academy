---
type: "page"
id: "human-oversight-and-accountability"
title: "Human Oversight and Accountability"
description: "Define clear ownership so a named human is accountable for every AI-driven infrastructure change, with explicit roles, sign-off requirements, and escalation paths."
weight: 4
---

## The Accountability Gap

AI agents make decisions and apply changes. They do not own outcomes. When an agent-driven change causes an outage or violates a compliance requirement, the relevant question is not "which agent did this" - it is "which human owned this change." Without deliberate design, that question has no answer.

Every mature incident management framework - SRE on-call rotations, SOC 2 controls - assumes a named human is accountable for production changes. AI agents do not fit this model unless you explicitly wire them into it.

## Defining Roles in an AI-Augmented Workflow

At minimum, three roles must be defined before any coding agent is permitted to propose production changes:

| Role | Responsibility |
|---|---|
| **AI Operator** | Configures the agent, sets the task scope, reviews proposals, and holds final authority to approve or reject |
| **Domain Reviewer** | Reviews proposals for correctness within a specific domain (networking, storage, security) when the operator lacks the depth to assess them alone |
| **Escalation Owner** | The senior engineer or team lead who is contacted when a proposal cannot be approved by the operator or reviewer, or when the agent's behavior is unexpected |

Every task must have a named AI Operator before it begins. This puts a human in the loop before the agent acts, not only after an incident.

## Sign-Off Requirements by Environment

Not every change requires the same level of human review. A tiered sign-off model balances operational velocity against risk:

| Environment | Required sign-off |
|---|---|
| Development | AI Operator review (async acceptable) |
| Staging | AI Operator sign-off before promotion |
| Production | AI Operator + Domain Reviewer sign-off before apply |
| Production (security-sensitive namespace) | AI Operator + Domain Reviewer + Escalation Owner |

In Meshery, environment promotion provides the structural mechanism for this tiering. A design that has passed validation in staging is not promoted to production until the required approvals are recorded. The promotion gate is where the sign-off requirement becomes technically enforced rather than procedurally hoped for.

```bash
# Check current environment state before promoting
mesheryctl system check

# View designs available for promotion review in Kanvas
# Promotion from staging to production requires sign-off in the platform
```

## Structuring the Human-in-the-Loop Checkpoint

The checkpoint is a technical step where the agent pauses and a human examines four artifacts before giving any approval: the diff (what will change), the rationale (why each choice was made), the validation results (schema, dry-run, policy), and the blast radius (which workloads are affected). The agent produces all four. The approver reads a structured document:

```text
PROPOSAL: Scale payments service in production
OPERATOR: platform-eng@example.com
DOMAIN REVIEWER: networking-lead@example.com

DIFF:
  spec.replicas: 3 -> 6
  resources.limits.memory: 512Mi -> 768Mi

RATIONALE:
  replicas: p95 latency exceeded SLO threshold over the past 72 hours
  memory: OOMKill events in staging indicate current limit is insufficient

VALIDATION:
  schema: PASS
  dry-run: PASS (server-side, production cluster)
  policy: PASS (OPA policy-guardrails profile)

BLAST RADIUS:
  Workloads affected: payments-service (production namespace)
  Downstream services: checkout, fraud-detection (consumer of payments API)

APPROVE / REJECT:
```

## Escalation Paths

Define escalation triggers explicitly. When any of the following fires, the operator does not approve - the task pauses, the escalation owner is notified with the full audit record, and the owner decides whether to proceed, modify, or cancel:

- The proposal affects more than one namespace
- The agent retried the same task more than twice without success
- The proposal touches RBAC, NetworkPolicy, or Secret resources
- The token budget was exhausted before the task completed

## Agent Behavior as Organizational Policy

Which tools an agent can call, which namespaces it can write to, and what approval is required before it proceeds are organizational policy decisions, not technical ones. Encode them in Meshery's environment and permission configuration:

```bash
mesheryctl design import -f designs/policy-guardrails.yaml -s "Kubernetes Manifest"
```

When the policy changes - because an incident revealed a gap or a compliance requirement arrives - update the platform configuration first, then the documented policy to match. The platform is the source of truth.

## Key Principle

Human oversight is not about slowing down the agent. It is about ensuring that when something goes wrong - and something will eventually go wrong - there is a named person who owns the outcome, a clear record of what was decided and why, and an established path for escalation. Agents can move fast. Accountability is what makes fast safe.
