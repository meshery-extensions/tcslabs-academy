---
type: "page"
id: "regression-detection-over-time"
title: "Regression Detection Over Time"
description: "Compare performance runs against a baseline to catch regressions after changes and enforce performance budgets as a deploy-time quality gate."
weight: 4
---

## The Regression Problem

A service that passes all unit tests and integration checks can still regress in production if a dependency update, a configuration change, or a new code path degrades latency or throughput. These regressions are invisible to functional tests because functional tests do not measure performance - they only verify correctness.

The solution is to treat performance the same way you treat correctness: define a budget, measure against it on every change, and block the deploy when the budget is violated. Meshery performance profiles give you the measurement; the regression detection workflow closes the loop.

## Establishing a Baseline

A baseline is a stored performance result that represents acceptable behavior at a known point in time - typically a stable release or a tagged commit. To create a baseline, run the profile against your known-good state and note the result ID:

```bash
mesheryctl perf apply --profile payment-service-checkout-flow --output json \
  > baseline.json
```

Store `baseline.json` in your repository alongside the deployment manifests it corresponds to. This makes the baseline version-controlled and reproducible: when a future engineer asks "what were the performance characteristics of v1.4.2?", the answer is in the repo.

## Defining Performance Budgets

A performance budget is a set of thresholds that a run must satisfy to be considered passing. Define budgets explicitly rather than informally:

| Metric | Budget |
|--------|--------|
| p50 latency | <= 20 ms |
| p95 latency | <= 60 ms |
| p99 latency | <= 150 ms |
| Error rate | < 0.1% |
| Throughput | >= 150 req/s |

Codify these thresholds in a configuration file alongside the profile definition. Your coding agent or CI script compares each new result against the thresholds and fails the run when any metric exceeds its budget.

## Comparing Runs Programmatically

After a code change, run the profile and compare the output against the baseline:

```bash
mesheryctl perf apply --profile payment-service-checkout-flow --output json \
  > candidate.json
```

A simple comparison script in any language checks each percentile:

```bash
# Compare p99 against the baseline value
BASELINE_P99=$(jq '.Percentiles.p99' baseline.json)
CANDIDATE_P99=$(jq '.Percentiles.p99' candidate.json)
THRESHOLD=150

if (( $(echo "$CANDIDATE_P99 > $THRESHOLD" | bc -l) )); then
  echo "REGRESSION: p99 ${CANDIDATE_P99}ms exceeds budget of ${THRESHOLD}ms (baseline: ${BASELINE_P99}ms)"
  exit 1
fi
echo "PASS: p99 ${CANDIDATE_P99}ms is within budget"
```

Pass the baseline and candidate JSON files to your coding agent for a richer analysis: "Identify any metrics that regressed by more than 10% relative to the baseline and explain the likely cause given the following diff."

## Making Performance a Deploy Gate

Integrating regression detection into your deploy loop requires three components:

1. **A profile that is stable and representative** - noisy or poorly scoped profiles produce false positives. Run the profile at least three times against the baseline and verify the results are consistent before relying on it as a gate.
2. **A comparison step in your pipeline** - run `mesheryctl perf apply`, capture the JSON output, and evaluate the thresholds as part of your CI/CD pipeline. Fail the pipeline when a threshold is breached.
3. **A clear escalation path** - when a threshold is breached, the pipeline should produce a report showing which metric regressed, by how much, and against which baseline. Engineers need enough signal to diagnose and fix the regression without having to reproduce the test locally.

After importing `designs/microservices-demo.yaml` with `mesheryctl design import -f designs/microservices-demo.yaml -s "Kubernetes Manifest"`, you have a stable, reproducible topology for running baseline tests against - the same infrastructure configuration every time.

## Rolling the Baseline Forward

A baseline should not be frozen indefinitely. As the service evolves and performance improves, the baseline should move forward. Update the baseline when:

- A deliberate optimization produces verified improvements.
- The traffic pattern or SLO is intentionally changed.
- The infrastructure changes in a way that makes the old baseline irrelevant (e.g., moving from a 2-node to a 4-node cluster).

Update the baseline explicitly by running the profile against the new known-good state and committing the new `baseline.json` to the repository with a note describing what changed and why the budget was adjusted.

## Handling Flaky Results

Performance tests are inherently more variable than functional tests. Network jitter, node scheduling, and shared-cluster contention can cause legitimate variance that triggers false positive regressions. Handle this with:

- **Statistical thresholds** - require that a metric exceed its budget by more than 15% before failing the gate. Small fluctuations are noise; large changes are signals.
- **Multi-run averaging** - run the profile three times and use the median result for comparison rather than a single run.
- **Warm-up periods** - add a short warm-up phase before the measurement window to avoid cold-start latency contaminating the result.

With these practices in place, your performance gate becomes a reliable signal rather than a source of friction. Every deploy either passes the gate cleanly or produces a concrete, actionable regression report.
