---
type: "page"
id: "approvals-and-audit-trails"
title: "Approvals and Audit Trails"
description: "Require human sign-off before agents execute mutating actions and record who, what, when, and why using Git history and Meshery activity logs."
weight: 2
---

## The Human-in-the-Loop Requirement

An autonomous agent running inside the agentic loop can chain dozens of tool calls together without pausing. That autonomy is the source of its productivity - and the source of its risk. For read-only analysis tasks, full autonomy is fine. For actions that mutate live infrastructure - applying a design, scaling a Deployment, deleting a resource - the loop must pause and wait for a human to approve before execution continues.

This is called human-in-the-loop (HITL), and implementing it correctly requires two things: a mechanism that actually blocks the action until approval arrives, and a record showing that approval was granted before the action ran.

## Designing the Approval Gate

The simplest reliable approval gate is a GitHub Pull Request. The agent produces a diff - either a Kubernetes manifest, a Meshery design file, or a structured change description - commits it to a branch, and opens a PR. The agentic loop halts at that point. A human reviews the diff, approves, and merges. A CI/CD pipeline (or a subsequent agent invocation triggered by the merge event) actually applies the change.

```text
Agent produces diff
       |
       v
Branch + PR created
       |
       v
Human reviews and approves
       |
       v
Merge triggers application
       |
       v
Meshery applies design to environment
```

This pattern works for Meshery designs: the agent calls `mesheryctl design import` in a dry-run context, serializes the resulting manifest to a file, commits it, and opens a PR. The PR body should include the agent's reasoning - what it intended to change and why - so the reviewer has context.

For lower-latency workflows where PR overhead is too high, a webhook-based approval flow is an alternative: the agent posts a structured message to a team channel describing the proposed action, and a designated approver responds with a specific keyword or button click. The agent's tool invocation waits on that response before proceeding. Either way, the key constraint is that the mutation cannot occur until an explicit human signal has been received.

## What the Audit Trail Must Capture

An audit trail is only useful if it answers four questions unambiguously after the fact:

| Question | Source |
|---|---|
| **Who** triggered the action? | Agent identity (ServiceAccount, token, or user who invoked the agent) |
| **What** was changed? | The exact resource diff, design content, or API call parameters |
| **When** did it happen? | UTC timestamp at approval time and at application time |
| **Why** was it approved? | Reviewer identity, PR link, or approval message with rationale |

If any of these four are missing, the trail cannot be used for incident investigation or compliance review.

## Git History as the Audit Trail

When agent-produced changes flow through a Git repository, the commit log becomes the audit trail automatically. Each commit carries the author, timestamp, and commit message. Require agents to write descriptive commit messages:

```bash
git commit -m "chore(agent): scale api-gateway to 5 replicas

Reason: p95 latency exceeded 200 ms threshold at 14:32 UTC.
Approved via PR #847 by @ops-team.
Meshery design: designs/microservices-demo.yaml
Environment: staging"
```

Require PR descriptions to include the agent's reasoning and link to any supporting evidence (metrics, alerts, logs). When the PR is merged, that merge commit ties the human approval event to the exact change that was applied.

## Meshery Activity as a Secondary Trail

Meshery maintains an activity log recording every design application, every environment change, and every user or system action. This log is available in the Meshery UI under the activity panel and complements the Git history with Kubernetes-level detail: which resources were created, updated, or deleted, and in which environment.

For compliance purposes, export Meshery activity logs to your organization's SIEM or log aggregation system. The combination of Git commit history (showing intent and approval) and Meshery activity logs (showing the actual Kubernetes API calls) gives a complete before-and-after picture.

## Structuring Agent Commits for Traceability

When an agent applies a design using Meshery, make traceability a first-class concern in the workflow:

1. The agent records the Meshery workspace and environment it targeted.
2. The design file applied is committed to the repository at a known path (e.g., `designs/microservices-demo.yaml`) before application.
3. The commit includes the agent's reasoning and the PR approval reference.
4. After application, the agent posts a summary back to the PR or ticket, confirming what was applied.

```bash
# Agent workflow - after PR approval is detected
mesheryctl design import \
  -f designs/microservices-demo.yaml \
  -s "Kubernetes Manifest"
# Record the outcome
git commit -m "apply(agent): applied microservices-demo to staging [PR #847]"
```

## What Good Approval Culture Looks Like

An approval gate is only effective if reviewers actually review. A rubber-stamp approval process gives the appearance of oversight without the substance. Establish team norms:

- Reviewers must check the diff, not just click approve.
- Agent-generated PRs must be as readable as human-authored ones - if the agent cannot explain its change clearly, the PR should be rejected.
- Approval records are retained for at least 90 days (or whatever your compliance requirement dictates).
- Post-incident reviews must include the approval trail as evidence.

The goal is not bureaucracy - it is making autonomous infrastructure changes as traceable and reviewable as any other engineering decision.
