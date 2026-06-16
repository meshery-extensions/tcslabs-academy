---
type: "page"
id: "generating-attestations-and-evidence"
title: "Generating Attestations and Evidence"
description: "How to produce durable compliance evidence automatically using Git history, Meshery validation results, and deploy records as attestations."
weight: 2
---

## What Is an Attestation?

An attestation is a signed, timestamped claim about an event or state - "this design passed policy validation at 14:32 UTC on 2026-06-15, approved by operator X." It differs from a log entry in that it is structured, tamper-evident, and traceable to a specific actor and artifact.

In a Meshery-based IDP, attestations do not require a separate tool. They arise naturally from the platform's existing records - provided you know where to look and how to preserve them.

## Git History as an Attestation Layer

Every design managed as code carries its full change history in Git. A Git commit records:

- What changed (the diff)
- Who made the change (committer identity)
- When it happened (commit timestamp)
- Why it happened (commit message, PR description, linked issue)
- Who reviewed it (PR approval records, merge commit)

For a coding agent workflow, the agent's proposed change lands in a branch. A human reviewer approves and merges it. The merge commit is an attestation that a qualified human authorized the change before it reached the deployment pipeline.

To make this evidence durable, enforce branch protection rules that require pull request approval before merge. The merge commit then serves as the authorization record that auditors need.

```bash
# Example: import a design version that has been approved via Git
mesheryctl design import -f designs/policy-guardrails.yaml -s "Kubernetes Manifest"
```

The imported design version is linked to the Git commit SHA, giving you a chain: commit -> design version -> deployment event.

## Meshery Validation Results as Evidence

When Meshery evaluates a design against its active policies, it produces a structured validation result. This result includes:

- The design ID and version
- The timestamp of evaluation
- Which policies were evaluated
- The verdict for each policy (pass, fail, or warning)
- The specific component and field that triggered each finding

This result is stored in Meshery and can be retrieved via the Meshery API or exported for external storage. For audit purposes, treat the validation result as a first-class artifact: export it alongside the design version and the deployment record.

A compliant deployment chain looks like this:

```text
Git commit (change + approval)
    |
    v
mesheryctl design import (design version created)
    |
    v
Meshery policy evaluation (validation result produced)
    |
    v
mesheryctl design apply (deployment event recorded)
    |
    v
MeshSync observation (actual cluster state captured)
```

Each step produces a record. Together they form an unbroken evidence chain.

## Deploy Records from Meshery Activity

Meshery records every design apply operation: which design, which environment, which operator or agent, and at what time. These records constitute the deploy log that change management frameworks require.

For environments with strict requirements, configure Meshery to require explicit environment selection before apply. This creates a record that the operator (human or agent) chose the target environment intentionally - preventing accidental production deployments.

```bash
# Apply a design to a named environment - the operation is logged with the environment name
mesheryctl design apply --design policy-guardrails --environment staging
```

The environment name in the log is evidence that the deployment followed the correct promotion path.

## MeshSync as a Witness

MeshSync is Meshery's in-cluster agent. It continuously observes cluster state and reports it back to Meshery. This observation record is a form of attestation: "at time T, the cluster state matched design D" or "at time T, these components were present that are not in any managed design."

For compliance purposes, MeshSync observations provide:

- **Post-deployment verification** - confirming that what was applied matches what was intended
- **Drift detection baseline** - establishing the expected state against which future observations are compared
- **Out-of-band change detection** - surfacing changes made outside Meshery (for example, direct `kubectl apply` commands)

Out-of-band changes are particularly important for AI-assisted workflows: if an agent bypasses Meshery and applies changes directly to the cluster, MeshSync will detect the discrepancy. That detection is itself an audit signal.

## Structuring Evidence for Auditors

Auditors need evidence to be findable, readable, and traceable to a specific requirement. A simple structure that works:

| Evidence Artifact | Source | Retention |
|---|---|---|
| Git commit + PR approval | Git / GitHub | Indefinite (repo history) |
| Design validation result | Meshery API export | 90 days minimum |
| Deploy event log | Meshery activity feed | 90 days minimum |
| MeshSync observation snapshot | Meshery API export | 30 days minimum |

Automate the export and archival of Meshery artifacts on a schedule. A coding agent can perform this export as a routine task, writing the results to an immutable store (an object storage bucket with object lock enabled, for example).

## Key Takeaway

Compliance evidence does not need to be assembled manually. Git history provides the authorization chain. Meshery's validation results provide the policy check record. Deploy events provide the change log. MeshSync provides the post-deployment verification. Each artifact is produced automatically as a side effect of normal platform operations - the engineering task is to preserve and index them, not to create them.
