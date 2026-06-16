---
type: "page"
id: "what-is-a-coding-agent"
title: "What Is a Coding Agent?"
description: "Distinguish a coding agent from a chat assistant, understand what it can do with files and commands, and learn the spectrum of autonomy."
weight: 1
---

## Agent vs Chat

When you send a message to an LLM in chat mode, the model reads your message, generates a response, and stops. Every turn requires you to prompt it again. The model has no memory between sessions, cannot read your files, and cannot run anything - it can only produce text.

A coding agent is different in three concrete ways:

- **It can act, not just respond.** The agent is given a set of tools - functions it is allowed to call. A tool might read a file, write a file, list a directory, run a shell command, or query an API. After generating text, the agent can invoke one of these tools and receive back the result.
- **It can loop.** After observing the result of a tool call, the agent generates its next step. This continues until the task is complete or the agent decides it is stuck and needs to ask the human.
- **It has a task, not just a turn.** You give the agent a goal ("find the pod that is crashlooping and explain why"), and it works toward that goal across as many steps as required.

The practical consequence for a platform engineer: you describe the outcome you want, and the agent handles the operational steps - reading logs, running commands, correlating results - rather than requiring you to run each command yourself and paste the output back in.

## What an Agent Can Do

The capabilities of any given agent depend entirely on which tools it has been given. Common tool categories include:

| Tool category | Examples |
|---|---|
| File system | Read file, write file, list directory, search for pattern |
| Shell execution | Run a command, capture stdout and stderr |
| API calls | Query a REST endpoint, submit a manifest |
| Memory / search | Retrieve relevant context from a vector store |
| Human escalation | Ask the user a question, request approval |

An agent running in your environment with shell access and `kubectl` configured can do a great deal: read pod logs, apply manifests, check node status, describe resources. The same model without those tools is just a text generator.

This is an important separation of concerns. The model itself - its weights, its training - determines how well it reasons about what to do. The tools determine what it is actually permitted to do. Good agent design treats these independently: pick the right model for the reasoning task, and grant only the tools the task requires.

## Levels of Autonomy

Not every agent operates the same way. There is a spectrum from fully supervised to fully autonomous, and where you land should be a deliberate engineering decision, not an accident.

**Fully supervised:** The agent proposes every action and waits for human approval before executing. Slow but safe. Good for early adoption, sensitive environments, or tasks where a wrong action is hard to undo.

**Supervised with exceptions:** The agent acts autonomously within a defined scope (read-only, a single namespace, a staging environment) and escalates outside it. This is the most practical starting point for infrastructure work.

**Checkpoint-based:** The agent runs freely but pauses at defined checkpoints - before applying any change, before deleting any resource - for a human to review a diff and approve.

**Fully autonomous:** The agent acts without approval. Appropriate only for well-scoped, reversible tasks in environments where the blast radius of a mistake is negligible (generating a report, formatting a document).

For infrastructure, fully autonomous operation on production systems is rarely appropriate. The value of an agent is not that it replaces human judgment - it is that it handles the mechanical work so the human judgment it does request is focused and informed.

## Why the Distinction Matters

Chat mode is useful for learning, drafting, and exploring ideas. Agent mode is useful for getting work done. The shift is not about the underlying model - it is about the architecture around it.

When you hear "AI-assisted infrastructure operations," the operative word is not "AI" - it is "operations." An agent that can run `kubectl get events --field-selector reason=BackOff -A` and then read the relevant pod spec and then summarize the failure is doing work that would otherwise require a human to run three commands, correlate the output, and write a summary. That is the value proposition: mechanical steps handled automatically, human judgment applied at the right moment.

Understanding this distinction - model vs agent, capability vs permission, supervised vs autonomous - is the foundation for everything else in this course.
