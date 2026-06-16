---
type: "page"
id: "finops-and-cost-control-for-ai"
title: "FinOps and Cost Control for AI"
description: "Manage LLM token spend and the cloud infrastructure cost that AI agents create, using budgets, monitoring, and architectural patterns that prevent runaway expenditure."
weight: 3
---

## Two Cost Dimensions

AI agents create cost exposure on two axes:

1. **LLM token cost** - every prompt and completion consumes tokens. An agent that loops on a planning task or carries a large context window accumulates spend quickly.
2. **Infrastructure resource cost** - the cloud spend of resources the agent creates or modifies. A correct scale-up increases bills by design; a hallucinated one inflates them without value.

FinOps for AI operations means instrumenting and capping both.

## Controlling LLM Token Spend

### Budget Guardrails in the Agentic Loop

Every agent session should be initialized with an explicit token budget. When the budget is exhausted, the agent should surface a summary of what it has done and what remains, and halt - not loop indefinitely seeking to complete the task.

Implement this as a wrapper around the agent's tool-use loop:

```python
MAX_INPUT_TOKENS = 50_000
MAX_OUTPUT_TOKENS = 10_000
tokens_used = {"input": 0, "output": 0}

def check_budget(response):
    tokens_used["input"] += response.usage.input_tokens
    tokens_used["output"] += response.usage.output_tokens
    if tokens_used["input"] > MAX_INPUT_TOKENS:
        raise BudgetExceeded(f"Input token budget exceeded: {tokens_used['input']}")
```

This is not just a cost control - it is a safety control. An agent that cannot complete a task within a reasonable token budget is likely stuck in a loop or working on a problem that requires human decomposition, not more computation.

### Context Window Management

Context window size is the largest driver of token cost. Agents carrying the full history of a session grow context - and cost - rapidly. Reduce this by summarizing completed sub-tasks in place of detailed tool call history, using RAG to fetch only relevant document sections at the moment they are needed, and scoping each session to one well-defined task.

### Monitoring Token Spend

Instrument every agent invocation to emit token usage as a metric. A minimal observability setup:

```text
agent_tokens_input_total{task="scale-payments-service",env="production"} 12400
agent_tokens_output_total{task="scale-payments-service",env="production"} 3200
agent_sessions_total{status="completed"} 47
agent_sessions_total{status="budget_exceeded"} 3
```

Export these metrics to [Prometheus](https://prometheus.io/) and visualize them in [Grafana](https://grafana.com/). Alert when per-session token use exceeds a defined threshold or when the ratio of budget-exceeded sessions rises above baseline.

## Controlling Infrastructure Resource Cost

### Tagging AI-Created Resources

Every resource created or modified by an agent should carry a label indicating its AI origin:

```yaml
metadata:
  labels:
    managed-by: "ai-agent"
    agent-session: "session-2024-06-10-001"
    approved-by: "platform-team"
```

This allows your cost management tool to aggregate AI-driven provisioning spend separately from human-authored changes, and makes rollback faster - the label immediately identifies the full set of related resources when an incident is traced to an agent-created resource.

### Meshery Environment Cost Gates

Use Meshery's environment model to enforce resource budget constraints before promotion. Before a design is promoted from staging to production, a policy check can verify that the requested resources fall within defined cost envelopes.

```bash
# Import the observability stack design to see cost-relevant resource annotations
mesheryctl design import -f designs/observability-stack.yaml -s "Kubernetes Manifest"
```

The `designs/observability-stack.yaml` design includes resource limit annotations that represent cost-relevant constraints. Apply the same pattern to agent-produced designs: encode the resource budget as annotations and validate them at the policy gate.

### Preventing Infrastructure Proliferation

Agents that create resources to test an idea and do not clean them up generate idle infrastructure cost over time. Counter this with TTL labels on non-production resources and periodic inventory reconciliation:

```bash
mesheryctl system check
```

A drift report between Meshery's registry and the live cluster surfaces orphaned resources - including those an agent created and forgot.

## Budget Summary Table

| Budget type | Recommended control | Alert threshold |
|---|---|---|
| LLM input tokens per session | Hard cap in agent wrapper | >80% of budget |
| LLM output tokens per session | Hard cap in agent wrapper | >80% of budget |
| LLM spend per day | Cloud billing alert | 20% over 7-day average |
| AI-created cloud resources per environment | Policy gate at Meshery promotion | Exceeds environment resource quota |
| Orphaned resources | TTL labels + cleanup job | Any resource past TTL with no activity |

Cost visibility and cost limits are both required. Visibility without limits lets you observe a problem after it has become expensive. Limits without visibility leave you unable to understand the pattern of spend.
