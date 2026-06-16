---
type: "page"
id: "why-agents-need-context"
title: "Why Agents Need Context"
description: "Understand why finite context windows and stale training data make retrieval necessary for any agent that operates on live infrastructure."
weight: 1
---

## The Two Problems with Training Data

An LLM is a snapshot. Its weights encode patterns from text that existed up to a training cutoff - a date that is almost certainly months or years before the agent is running in your environment. That snapshot has two structural problems for infrastructure operations.

**The data is stale.** Your cluster topology changes every time you deploy. Service versions drift. ConfigMaps are updated. Nodes are replaced. A model trained on documentation from twelve months ago does not know any of this. When it describes your cluster it is describing a composite hallucination assembled from similar clusters it has seen in training, not yours.

**The data is generic.** Training corpora are full of Kubernetes tutorials, blog posts, and open-source configs. They contain almost nothing about your specific environment: your naming conventions, your custom resource definitions, your internal runbooks, your approved patterns. Even a perfectly current model cannot know what "production" means in your organization without being told.

These are not bugs that a better model will fix. They are structural properties of how LLMs work. The answer is not a bigger model - it is better context.

## The Context Window Is a Finite Resource

Every invocation of an LLM operates within a context window: a fixed number of tokens that the model can attend to at once. This window holds the system prompt, the conversation history, any tool outputs, and whatever state you inject.

Context windows have grown substantially over the past few years, but they remain finite, and large inputs have real costs in both latency and compute. More importantly, research consistently shows that models attend poorly to content buried deep in a long context - a phenomenon sometimes called the "lost in the middle" problem. You cannot solve the grounding problem by simply pasting your entire cluster state into the prompt.

What you need is selective retrieval: fetch only the fragments of state that are relevant to the current query, and inject exactly those. That is the core idea behind retrieval-augmented generation (RAG).

## RAG in One Sentence

RAG = retrieve relevant context at query time, inject it into the prompt, then generate.

The model's weights provide general language understanding and reasoning capability. The retrieved context provides the specific, current facts needed to answer correctly. Neither is sufficient alone.

## Why This Matters More for Infrastructure Than for Chat

In a customer support chatbot, a hallucinated answer is embarrassing. In an infrastructure agent, a hallucinated resource name or flag value can cause a service outage. The stakes are different.

Consider an agent asked to scale a deployment. Without context, it guesses the deployment name, the namespace, and the current replica count. With retrieved context, it knows all three with certainty before it generates a single command. The difference between a confident hallucination and a grounded action is the retrieval step.

| Without RAG | With RAG |
|---|---|
| Model guesses resource names | Model reads actual resource list from `kubectl` or MeshSync |
| Outdated API versions | Current schema from registry |
| Generic advice | Advice grounded in your specific state |
| High hallucination risk | Risk bounded by retrieval quality |

## The Three Questions for Every Agent

Before you design a retrieval pipeline, answer these three questions about your agent:

1. **What state does it need?** Cluster topology, service health, design files, runbooks, policy constraints - be specific.
2. **How stale can that state be?** Real-time data requires live tool calls; reference data can be pre-indexed.
3. **How much of it fits in context?** Be aggressive about filtering. Retrieve the minimum that allows a correct answer.

The rest of this module answers each question in the context of Meshery and Kubernetes operations. In the next lesson you will see exactly which sources of truth are available to you and how to surface them to an agent.
