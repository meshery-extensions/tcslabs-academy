---
type: "page"
id: "llm-assisted-log-and-event-analysis"
title: "LLM-Assisted Log and Event Analysis"
description: "Feed logs and Kubernetes events to an LLM to summarize, cluster, and surface anomalies - while keeping the input grounded and scoped."
weight: 2
---

## Why LLMs Are Useful Here

Logs and Kubernetes events contain the truth about what a system did. The problem is volume and format: a busy namespace produces thousands of event objects and log lines per minute, in inconsistent structures, with signal buried in noise. Human triage is slow. Grep is brittle.

A coding agent backed by an LLM can read a bounded set of logs and events and produce a structured summary - grouping related errors, flagging recurrence patterns, and surfacing the handful of entries most likely to be diagnostic - in seconds. The key word is "bounded." An agent that ingests unbounded input loses quality rapidly as the context window fills with low-signal content.

## Selecting the Right Input

Before handing anything to the agent, decide what to include. The selection criteria depend on what you know about the symptom:

| Known information | Filter strategy |
|---|---|
| Specific component is unhealthy | Events + logs scoped to that component's Pod(s) |
| Namespace-wide degradation | Warning events across the namespace, last 30 minutes |
| Post-deployment regression | Events from the rollout window; diff against pre-deploy baseline |
| Unknown origin | Start with Warning events cluster-wide, then narrow |

Scoping is not just about token count - it is about keeping the LLM grounded. An agent given too broad a scope may surface correlations that are statistically spurious. Narrow the window first; widen only if the first pass yields nothing actionable.

## Extracting Events from Meshery

Meshery surfaces events through its UI and via MeshSync's reconciled state. For agent workflows, you typically extract relevant events programmatically and format them as structured input.

A minimal event extraction targeting a specific namespace looks like this in practice:

```bash
kubectl get events -n <namespace> --field-selector type=Warning \
  --sort-by='.lastTimestamp' -o json > /tmp/events.json
```

The `-o json` flag gives the agent consistent field names (`reason`, `message`, `involvedObject.name`, `count`, `lastTimestamp`) rather than the tabular format that is harder to parse reliably.

For logs, scope to the container you suspect:

```bash
kubectl logs -n <namespace> <pod-name> --since=30m > /tmp/pod-logs.txt
```

If the pod has restarted, add `--previous` to capture the prior container's output, which often holds the actual crash reason.

## Structuring the Input for the Agent

Raw JSON and raw log text can be passed directly to an LLM, but a small amount of pre-processing significantly improves output quality:

1. **Deduplicate repeated events.** Kubernetes often emits the same event dozens of times. Collapse them to a single entry with a `count` field. This alone can reduce token usage by 60-80% on a busy cluster.

2. **Sort by recency.** Put the most recent entries first. LLMs tend to weight earlier context more heavily, so the freshest signal should appear at the top.

3. **Strip metadata you do not need.** Fields like `resourceVersion`, `uid`, and `managedFields` add tokens with no diagnostic value. Remove them before passing to the agent.

4. **Label the sections.** Tell the agent what it is looking at. A header like `## Kubernetes Warning Events - namespace: payments - last 30m` helps the LLM understand provenance.

## What to Ask the Agent to Produce

The agent's task is analysis, not remediation - at least in this step. Ask for:

- A **summary** of the error types present (one or two sentences)
- A **clustering** of related errors (which events are caused by the same underlying condition)
- A **ranked list** of the two or three entries most likely to represent root cause rather than downstream effect
- Any **recurrence pattern** - errors that first appeared at a specific time, or that are accelerating

A sample task framing for the agent:

```text
You are analyzing Kubernetes events and container logs from the payments namespace.
Your goal is to summarize, cluster related errors, and identify the two most likely
root-cause candidates. Do not suggest fixes. Output structured markdown with sections:
Summary, Error Clusters, Top Candidates.

## Kubernetes Warning Events
<events JSON here>

## Container Logs
<log lines here>
```

The explicit instruction "do not suggest fixes" is important. An agent that jumps to remediation before the hypothesis step is bypassing the diagnostic discipline that makes it reliable. Fixes come later, after hypotheses are tested.

## Grounding and Hallucination Risk

LLMs can confabulate - asserting facts that are plausible but not present in the input. In log analysis, this typically appears as the agent referencing an error message it constructed rather than copied. Two mitigations:

- **Ask for verbatim quotes.** Instruct the agent to include the exact log line or event message it is citing as evidence.
- **Keep input short enough to verify.** If the output cites something you cannot find in the input you gave it, the input was too large and the agent filled gaps.

A well-scoped input that fits comfortably within the agent's effective context window is more reliable than a complete dump that technically fits but degrades coherence. Prefer two focused agent calls over one sprawling one.
