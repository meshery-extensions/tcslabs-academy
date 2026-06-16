---
type: "page"
id: "drift-and-continuous-compliance"
title: "Drift and Continuous Compliance"
description: "How to detect infrastructure drift with Meshery and MeshSync, and how to run continuous compliance checks so the platform stays audit-ready between formal reviews."
weight: 3
---

## What Is Drift?

Drift is the divergence between the infrastructure you intend to have and the infrastructure you actually have. It accumulates whenever a change is made to the cluster without going through the managed change path - a direct `kubectl apply`, a manual Helm override, a broken rollback, or an agent that bypassed policy controls.

Drift is a compliance problem because it means your documentation no longer reflects reality. An auditor who reviews your design library and your Meshery deploy log is reading a description of a system that no longer exists. The actual cluster has additional components, modified configurations, or missing resources.

In an AI-assisted IDP, drift risk is elevated. A coding agent operating quickly can apply many small changes. If even one bypasses Meshery, the gap between intended and actual state widens without any audit trail.

## How MeshSync Detects Drift

MeshSync runs as a Kubernetes operator inside each managed cluster. It continuously watches all resources in the cluster and reports their current state to the Meshery control plane. Meshery then compares that observed state against the designs it has applied.

The comparison produces one of three outcomes for each resource:

| Outcome | Meaning |
|---|---|
| **In sync** | The resource matches the design that was applied |
| **Drifted** | The resource exists but its configuration differs from the design |
| **Unmanaged** | The resource exists in the cluster but is not part of any Meshery design |

Unmanaged resources are particularly significant: they represent changes that bypassed the platform entirely and carry no evidence chain.

## Running a Drift Check

You can query the current drift status through Meshery's interface or `mesheryctl`:

```bash
mesheryctl system check
```

This command reports the health of the Meshery components including the connection to MeshSync. For a detailed view of design-to-cluster discrepancies, use the Meshery UI or the Kanvas canvas to visualize the current observed state alongside the intended design.

The recommended workflow for continuous compliance is:

1. Apply a design through Meshery.
2. MeshSync observes the cluster and reports state back within seconds.
3. Meshery computes the diff between the applied design and the observed state.
4. Any discrepancy triggers a drift alert that is logged in the activity feed.

## Continuous Compliance vs. Point-in-Time Audit

Traditional compliance operates on a cycle: collect evidence for a specific period, present it to auditors, receive a certification, repeat annually. This model was designed for systems that change slowly. It does not fit an IDP where dozens of changes may land in a single day.

Continuous compliance replaces the cycle with a persistent check. At any moment, the system can report its compliance posture - not because an audit was scheduled, but because the checks run constantly.

For Meshery, continuous compliance means:

- **Relationships evaluated on every design change** - a new design import immediately triggers constraint evaluation.
- **OPA policies re-evaluated on every apply** - policy changes propagate to the next deployment cycle.
- **MeshSync reports drift as it occurs** - not at the end of the quarter.
- **Activity logs accumulate in real time** - evidence is available the moment an auditor requests it.

## Integrating Drift Detection into Agent Workflows

A coding agent that manages infrastructure should check for drift before making additional changes. Applying a new design on top of a drifted cluster can mask the drift or compound it.

The agent workflow should include a pre-flight step:

```text
1. Query Meshery for the current drift status of the target environment.
2. If drift is detected, surface it to the human operator before proceeding.
3. If the human approves continuation, log the approval explicitly.
4. Apply the new design.
5. Verify post-apply state via MeshSync before marking the task complete.
```

This pattern - check, surface, approve, apply, verify - keeps the human informed at each decision point where drift could affect the outcome.

## Remediation and Re-attestation

When drift is detected, remediation has two paths:

**Path A - Reconcile to intended state.** Re-apply the Meshery design that represents the desired state. Meshery will emit a reconciliation event that serves as a new attestation: "at time T, design D was re-applied to bring the cluster back into compliance."

**Path B - Update the design to match reality.** If the out-of-band change was intentional and valid (an emergency hotfix, for example), import the current cluster state as a new design version, run it through the validation pipeline, and produce the missing evidence retroactively. This path requires explicit approval and documentation of why the change bypassed normal process.

Either path produces a new evidence artifact. The compliance posture is restored, and the audit trail reflects both the drift event and the remediation action.

## Observability for Compliance

Compliance-relevant events should flow into the same observability stack used for operational monitoring. Meshery activity events can be exported to external systems for long-term retention and alerting.

A useful baseline for compliance observability:

- Alert on any MeshSync drift detection event in a production environment.
- Alert on any design apply that did not have a preceding validation pass.
- Alert on any unmanaged resource appearing in a production namespace.
- Report weekly drift status across all managed environments.

These alerts give the platform team advance notice of compliance issues rather than discovering them during an audit.

## Key Takeaway

Continuous compliance requires continuous observation. MeshSync provides that observation layer inside each cluster, and Meshery computes the delta between intended and actual state in real time. In an AI-assisted IDP, this capability is not optional - it is the mechanism that keeps human operators informed when agents introduce changes that deviate from the governed path.
