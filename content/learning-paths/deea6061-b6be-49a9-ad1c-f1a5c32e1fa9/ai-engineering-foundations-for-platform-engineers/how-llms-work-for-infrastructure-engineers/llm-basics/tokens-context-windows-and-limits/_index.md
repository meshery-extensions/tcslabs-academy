---
type: "page"
id: "tokens-context-windows-and-limits"
title: "Tokens, Context Windows, and Limits"
description: "What tokens are, how context windows bound every LLM interaction, and what that means for how much infrastructure state you can feed an LLM at once."
weight: 2
---

Every constraint you will hit when using an LLM for infrastructure tasks flows from two things: tokens and context windows. Understanding them prevents wasted prompts, unexpected truncation, and surprising cost spikes.

## What a Token Is

A token is the unit a language model reads and writes. Tokenization splits text into chunks before the model ever sees it. For English prose, one token is roughly 3-4 characters, or about 0.75 words on average. For structured text like YAML, JSON, or shell output, the ratio is less favorable because symbols, whitespace, and repeated keys each consume tokens.

Some practical benchmarks for infrastructure text:

| Content | Approximate Tokens |
|---|---|
| 1 line of shell output | 10-30 |
| A 20-line YAML deployment manifest | 200-350 |
| `kubectl get pods -A` output for 50 pods | 800-1,200 |
| A full Meshery design with 10 components | 1,500-3,000 |
| A 100-line Prometheus alerting rules file | 500-900 |

These are rough estimates. The exact count depends on the tokenizer used by the specific model, and tokenizers differ between model families. Most LLM APIs expose a token-counting endpoint you can call before committing to a request.

## What a Context Window Is

The context window is the maximum number of tokens the model can process in a single request - input plus output combined. Every token in your prompt, every token in any conversation history you include, and every token in the model's response comes out of this shared budget.

Context window sizes have grown substantially. A small model might have an 8K-token window; many current models sit at 128K tokens or more. One model family used in coding agents supports up to 1 million tokens. These numbers sound large until you start feeding real infrastructure state into a prompt.

Consider a realistic workflow: you want an LLM to review your `designs/microservices-demo.yaml` Meshery design against a security policy. If the design serializes to 2,000 tokens and the policy document is 3,000 tokens, you have used 5,000 tokens before writing a single instruction. Add conversation history, system prompt, and output space - you are using a meaningful fraction of a 32K window.

## Why Context Limits Matter for Infrastructure Work

Infrastructure state is verbose. YAML is verbose. Log output is verbose. The artifacts you want to hand an LLM are often large.

Three practical consequences:

**Truncation is silent.** If your input exceeds the context window, the API will either return an error or silently truncate the input. Silent truncation is the dangerous case - the model receives an incomplete picture and produces output based on a partial view of your system. Always check that your prompt fits within the model's limit before sending.

**More context costs more.** Most hosted LLM APIs price on tokens in plus tokens out. Feeding the entire output of `kubectl get all -n production` into every prompt is expensive. Design your prompts to include only the state relevant to the question.

**Context is stateless across requests.** Each API call starts with a fresh context. The model has no memory of previous calls unless you explicitly include prior conversation in the new prompt. If your agent is having a multi-turn conversation with the LLM, each turn must carry all relevant prior context as tokens.

## Strategies for Infrastructure State

When you need to give an LLM information about your cluster or Meshery environment, you have several options:

**Trim the input.** Instead of passing raw `kubectl get pods -A` output, filter to the namespace or resource type that is actually relevant. Pass `kubectl get pods -n observability --field-selector=status.phase!=Running` when you are troubleshooting non-running pods.

**Use structured summaries.** An agent can call `mesheryctl system check` and pass only the warning and error lines to the LLM, rather than the full output.

**Import and reference designs.** Meshery designs provide a compact, structured representation of infrastructure intent. Instead of pasting raw Kubernetes manifests, import a design with:

```bash
mesheryctl design import -f designs/microservices-demo.yaml -s "Kubernetes Manifest"
```

Then reference the design by name in your prompt. The LLM receives a focused description rather than a sprawling manifest dump.

**Use RAG for large corpora.** If you need the LLM to reason about a large body of documentation - a whole runbook, a policy library, all your alerting rules - retrieval-augmented generation lets you fetch only the relevant chunks at query time rather than loading everything into the context window. This is covered in a later course.

## Context Window as a Design Constraint

When you build any agentic workflow around Meshery, treat the context window as a first-class design constraint - the same way you would treat a memory limit or a request timeout. Before writing a single line of prompt, ask: what is the minimum state the LLM needs to complete this task, and does it fit? Design toward the minimum.
