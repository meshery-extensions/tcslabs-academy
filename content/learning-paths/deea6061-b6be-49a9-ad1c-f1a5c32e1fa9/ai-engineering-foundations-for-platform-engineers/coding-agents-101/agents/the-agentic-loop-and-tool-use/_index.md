---
type: "page"
id: "the-agentic-loop-and-tool-use"
title: "The Agentic Loop and Tool Use"
description: "Understand the plan-act-observe loop, how function calling works under the hood, and how an agent decides when its task is done."
weight: 2
---

## The Plan-Act-Observe Loop

Every coding agent - regardless of which model powers it or which framework wraps it - runs the same fundamental loop:

```text
[ Receive task ]
      |
      v
[ Plan: decide what to do next ]
      |
      v
[ Act: call a tool OR produce a final answer ]
      |
      v
[ Observe: receive the tool result ]
      |
      v
[ Back to Plan, with updated context ]
```

This loop repeats until the agent either produces a final answer, runs out of allowed steps, or determines it cannot proceed without human input.

The key insight is that the agent's "context window" - the text it reasons over - grows with each iteration. After acting and observing, the result is appended to the context, so the agent's next plan is informed by everything that happened before it. This is what makes multi-step reasoning possible: the agent is not re-reading a static document; it is reading a growing transcript of its own work.

## Tool and Function Calling

Modern LLMs support a feature called function calling (sometimes called tool use). At the API level, the caller provides a list of function definitions - name, description, and parameter schema. The model can then, as part of its response, emit a structured call to one of those functions instead of (or in addition to) natural language.

A simplified tool definition looks like this:

```yaml
name: run_command
description: "Run a shell command and return stdout and stderr."
parameters:
  command:
    type: string
    description: "The shell command to execute."
```

When the model decides to call this tool, it emits a structured object:

```json
{
  "tool": "run_command",
  "parameters": {
    "command": "kubectl get pods -n production -o wide"
  }
}
```

The agent framework intercepts this, executes the actual command, and feeds the output back into the context as an "observation." The model never directly runs the command - the framework does. This is critical for safety: the framework can intercept, log, and gate every tool call before it executes.

## How the Agent Decides What to Do

The model's plan step is not random. It reasons from the task description, the conversation history, and the results of previous tool calls. In practice, a well-prompted agent will:

1. Restate what it understands about the task.
2. Identify what information it still needs.
3. Select the tool most likely to provide that information.
4. Call the tool with the appropriate parameters.
5. Evaluate whether the result answers the question or whether another step is needed.

This is not magic - it is pattern matching informed by training. The model has seen many examples of stepwise problem solving and generalizes from them. The quality of the plan is heavily influenced by the quality of the tool descriptions and the clarity of the initial task.

## When the Agent Stops

An agent terminates the loop when one of these conditions is true:

- **Task complete:** The agent has a confident, complete answer and produces it as a final response.
- **Blocked:** The agent cannot proceed without information or permission it does not have. A well-designed agent surfaces this explicitly rather than guessing.
- **Step limit reached:** Most frameworks enforce a maximum number of loop iterations to prevent runaway agents. When the limit is hit, the agent is forced to report what it has so far.
- **Human escalation:** The agent calls a special tool (e.g., `ask_human`) to request input, pausing the loop until the human responds.

The stopping condition matters as much as the loop itself. An agent that never asks for help and never gives up will eventually do something wrong and keep going. Explicit termination logic - step limits, escalation tools, confidence thresholds - is a design requirement, not an afterthought.

## Context Window and State

Everything the agent knows during a task lives in its context window: the initial prompt, every tool call, every observation, and every intermediate plan. This is both the power and the limit of the agentic loop.

The power: the agent's reasoning is fully auditable. You can read the full context and see exactly what information it had at each decision point.

The limit: context windows are finite. Long-running tasks with many tool calls can exhaust the available context, degrading reasoning quality or causing the agent to lose track of early observations. For infrastructure tasks, this is a practical constraint - keep tasks focused, and break large tasks into smaller ones with clear handoff points.

Understanding the loop, tool calling, and context management gives you the mental model to evaluate any agent implementation - whether you are building one, operating one, or reviewing one for production use.
