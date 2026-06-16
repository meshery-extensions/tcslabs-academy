---
type: "page"
id: "audit-trails-and-explainability"
title: "Audit Trails and Explainability"
description: "Record every AI proposal and its rationale, and structure decisions so they remain explainable and reviewable long after the change was applied."
weight: 2
---

## The Audit Problem in AI-Driven Operations

When a human engineer applies a change, there is a natural trail: a ticket, a pull request, a commit message, a review comment. When a coding agent applies a change, none of that exists by default. The agent's reasoning lives in a context window that evaporates at the end of the session.

Audit trails serve post-incident investigation, compliance, knowledge transfer, and regression prevention. If an agent deploys a change that causes an outage six weeks later, you need to know what was proposed, why it was accepted, who approved it, and what the cluster state was at the time. Without deliberate design, none of that is recoverable.

## What a Complete Audit Record Contains

A useful audit entry for an AI-driven change captures the following:

| Field | What to record |
|---|---|
| Timestamp | ISO 8601 with timezone |
| Agent identifier | Which agent or session produced the proposal |
| Prompt summary | The intent the agent was given (not the full prompt unless required by policy) |
| Proposal | The exact manifest, diff, or design the agent produced |
| Rationale | The agent's explanation of why it made each structural choice |
| Validation results | Schema check output, dry-run output, policy evaluation results |
| Approver | Identity of the human who signed off |
| Approval timestamp | When sign-off occurred |
| Cluster state snapshot | The relevant resource state before the change was applied |
| Post-apply state | Confirmation of what was actually applied |

The rationale field is the most frequently omitted and the most valuable. Instruct your agent to output a field-by-field justification for non-obvious choices alongside every proposal.

## Capturing Rationale in the Agentic Loop

Require a structured JSON envelope around every proposal so rationale is a first-class field:

```json
{
  "proposal_id": "deploy-2024-06-10-001",
  "intent": "Scale the payments service to handle projected load for the upcoming release",
  "rationale": {
    "replicas": "Increased from 3 to 6 based on p95 latency trend over the past 7 days",
    "resources.limits.memory": "Raised from 512Mi to 768Mi; OOMKill events observed in staging",
    "podDisruptionBudget": "Added to guarantee rolling update does not drop below 4 ready pods"
  },
  "manifest": "..."
}
```

Storing this envelope alongside the applied manifest gives you the agent's reasoning at the time it made the decision - reasoning that is not reconstructible later from the manifest alone.

## Meshery as an Audit Substrate

Meshery's design versioning provides a foundation for AI audit trails. When an agent imports a design, the snapshot is persisted and every modification creates a new version. This is a partial audit log of what the agent proposed and when.

Supplement it with external metadata - the rationale envelope, approver identity, and validation results - stored in a system your organization already audits: a Git repository, a ticketing system, or a dedicated policy log.

```bash
# Import creates a versioned entry in Meshery
mesheryctl design import -f agent-output.yaml -s "Kubernetes Manifest"
# Record the returned design ID and attach the rationale envelope before promoting
```

## Making Decisions Explainable After the Fact

A change is explainable if, given only the audit record, an engineer unfamiliar with the original context can understand what problem the agent was solving, what it proposed and why, what validation confirmed safety, who approved it, and what the cluster state was before and after. Structure the agent's workflow to produce those answers as a side effect of normal operation.

## Retention and Access Control

Retain audit records for at least twelve months for production systems, longer for regulated industries. Access to the rationale field should match the access control policy for the underlying infrastructure.

Use structured logs, not free-form text files. When an incident occurs and you need to answer "what did the agent change in the payments namespace between June 1 and June 10," a queryable log answers in a single query. A directory of YAML files does not.

## Key Practices

- Require the agent to output a structured rationale alongside every proposal
- Store the complete proposal envelope - intent, rationale, manifest, validation results - before promoting any change
- Use Meshery's design versioning as the infrastructure-side audit record
- Retain records in a queryable, access-controlled system for a defined retention period
