---
type: "page"
id: "measuring-remediation-safety"
title: "Measuring Remediation Safety"
description: "Define and track the metrics that determine whether your automated remediation is safe enough to expand - and when to pull back."
weight: 4
---

## Why Metrics Are the Prerequisite for Autonomy

Expanding an agent's autonomy without measuring safety is the same mistake as deploying software without monitoring. You will not know when something goes wrong until the impact is large enough to be undeniable.

The metrics in this lesson are not about whether your workflow is fast. They are about whether your workflow is trustworthy - and trustworthiness is what earns the right to reduce human oversight over time.

A workflow that acts quickly but incorrectly 20% of the time is worse than a slower workflow that requires human approval for every action. Speed is a quality-of-life improvement. Safety is a requirement.

## The Four Core Safety Metrics

### 1. Remediation Success Rate

**Definition:** The percentage of automated remediation cycles that resolved the triggering condition without requiring rollback or manual intervention.

**Formula:**
```text
success_rate = resolved_without_rollback / total_remediation_attempts
```

**Target:** Above 95% before expanding automation to a new action class. Below 90% is a signal to pause automation for that action class and diagnose.

**What it reveals:** Whether the agent's diagnoses are correct and the actions it proposes are appropriate for the failure modes it encounters. A low success rate means either the diagnosis model is wrong or the action set is too narrow.

### 2. False-Positive Rate

**Definition:** The percentage of triggered remediations where the agent acted on a condition that would have resolved on its own, or that was not actually a problem.

**Formula:**
```text
false_positive_rate = unnecessary_actions / total_remediation_attempts
```

**Target:** Below 5% for fully automated actions. Above 10% means the trigger is too sensitive and humans are approving remediations that should not fire.

**What it reveals:** Whether the trigger and diagnosis are calibrated correctly. A high false-positive rate trains reviewers to dismiss approval requests, which erodes the entire oversight model. It is worth taking the time to tune thresholds even if it means missing some real incidents.

### 3. Mean Time to Recover (MTTR)

**Definition:** The average elapsed time from trigger to verified resolution, measured across all remediation cycles (including human-approval delays).

**Formula:**
```text
MTTR = sum(resolution_timestamp - trigger_timestamp) / total_resolved_cycles
```

**Target:** Compare against your pre-automation MTTR baseline. Agent-driven remediation should reduce MTTR even with the approval gate overhead. If it does not, the gate design or the diagnosis latency needs attention.

**What it reveals:** Whether the workflow is delivering operational value. MTTR is the metric that justifies the investment in building automated remediation. Track it per action class so you can identify which workflows contribute most.

### 4. Rollback Rate

**Definition:** The percentage of executed remediations that required rollback because the action did not resolve the condition or made things worse.

**Formula:**
```text
rollback_rate = rolled_back_actions / executed_actions
```

**Target:** Below 3% for actions you consider safe to fully automate. A rollback rate above 5% means the agent is executing actions on incorrect diagnoses or that the action itself is not safe for the failure mode.

**What it reveals:** The quality of the act phase. A high rollback rate with a low false-positive rate means the triggers are accurate but the actions are wrong. This points to problems in the diagnosis prompt, the action selection logic, or the blast radius of the actions being taken.

## Building a Safety Dashboard

Track these four metrics in Grafana alongside your infrastructure metrics. The observability stack design includes the Prometheus and Grafana setup:

```bash
mesheryctl design import -f designs/observability-stack.yaml -s "Kubernetes Manifest"
```

Define recording rules in Prometheus that compute these metrics from your remediation audit trail. A minimal Prometheus recording rule for success rate:

```yaml
groups:
  - name: remediation_safety
    rules:
      - record: remediation:success_rate:7d
        expr: |
          sum_over_time(remediation_resolved_without_rollback_total[7d])
          /
          sum_over_time(remediation_attempts_total[7d])
```

Use a 7-day rolling window for stability. Shorter windows are too noisy; longer windows mask recent regressions.

## Growing Autonomy with Evidence

Autonomy expansion follows a staged model. Each stage requires meeting the safety thresholds at the previous stage before proceeding.

| Stage | Gate Policy | Required Evidence |
|---|---|---|
| 1 - Supervised | All actions require human approval | Baseline metrics established over 30 days |
| 2 - Assisted | Low-risk actions auto-execute; medium and high require approval | Success rate > 95%, false-positive rate < 5% over 30 days |
| 3 - Delegated | Low and medium actions auto-execute; high requires approval | All metrics at target for 60 days; rollback rate < 3% |
| 4 - Autonomous | Most actions auto-execute; critical tier always requires approval | All metrics at target for 90 days with no regression |

Critical-tier actions - those that modify RBAC, network policies, or cluster-level configuration - should always require human approval regardless of your autonomy stage. The blast radius is too wide and the failure modes too varied for full automation to be responsible.

## Signals That Autonomy Is Moving Too Fast

Treat any of the following as a circuit breaker - pause automation expansion and investigate:

- Rollback rate increases by more than 2 percentage points week-over-week
- Any single remediation attempt causes a secondary incident
- The approval queue shows reviewers rejecting more than 15% of proposals (suggests the agent's diagnoses are drifting)
- MTTR increases after removing an approval gate (suggests the gate was catching incorrect actions, not just slowing good ones)

Autonomy that exceeds what the evidence supports is not a feature. It is a liability that will eventually produce an outage that could have been prevented by a 30-second human review.
