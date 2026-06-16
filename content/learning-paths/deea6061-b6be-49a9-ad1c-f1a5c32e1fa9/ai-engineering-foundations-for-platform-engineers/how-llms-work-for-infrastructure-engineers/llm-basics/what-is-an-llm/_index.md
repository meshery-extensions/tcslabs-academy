---
type: "page"
id: "what-is-an-llm"
title: "What Is an LLM?"
description: "A practical mental model of large language models - next-token prediction, training vs inference, and what LLMs are and are not good at for operations work."
weight: 1
---

If you are going to use an LLM as part of a Meshery automation workflow, you need a working mental model of what it actually does. Not a marketing summary - a mechanical description you can reason from when things go wrong.

## The Core Mechanism: Next-Token Prediction

An LLM is a neural network trained to predict the most probable next token given a sequence of preceding tokens. That is the whole game. When you send a prompt, the model reads your input and emits tokens one at a time, each token selected based on probability distributions computed from everything that came before.

A token is roughly 3-4 characters of English text. "Meshery" is one token. "kubectl" is one token. A YAML block with 50 keys might consume 400-600 tokens. This matters when you are trying to feed cluster state into a prompt.

The model does not retrieve facts. It does not query a database. It does not look things up. It produces text that is statistically consistent with patterns seen during training. When the output looks like a fact, it is because similar text appeared in training data - not because the model verified anything.

## Training vs Inference

These two phases are completely different in cost, time, and purpose.

**Training** is the process of adjusting billions of numerical weights in the neural network so that next-token predictions improve across a huge corpus of text. Training a frontier model requires weeks of compute across thousands of GPUs and costs tens to hundreds of millions of dollars. You are not doing this.

**Inference** is the process of running the trained model on new input to produce output. This is what happens every time you send a prompt. Inference is comparatively cheap - milliseconds to seconds per response depending on output length and model size - and it is what you are paying for when you call an LLM API.

The distinction matters operationally: you cannot change what a model knows by talking to it. Knowledge is baked into weights at training time. If the model was trained before a Meshery release, it has no knowledge of features introduced in that release. The only way to give an LLM current information is to put that information in the prompt - which is the premise behind retrieval-augmented generation (RAG) and tool-equipped agents.

## What LLMs Are Actually Good At for Ops Work

LLMs excel at tasks that require generating or transforming text according to patterns:

- **Drafting YAML and configuration** - given a description, an LLM can produce a plausible first draft of a Kubernetes manifest or Meshery design that you then verify and apply
- **Explaining unfamiliar resources** - paste a CRD or an error log and ask what it means
- **Pattern matching across text** - classify log lines by severity, summarize a long policy document, extract structured data from unstructured output
- **Translating between formats** - convert a Helm values file into equivalent Meshery design parameters
- **Suggesting next steps** - given the output of `mesheryctl system check`, suggest what to investigate next

Notice what all these have in common: the output needs human review before it has operational effect.

## What LLMs Are Not Good At for Ops Work

- **Ground truth about live systems** - an LLM has no access to your cluster unless you explicitly pass state into the prompt. It cannot tell you what is currently running.
- **Deterministic arithmetic and bit-level operations** - token prediction is probabilistic; exact calculations can and do go wrong
- **Up-to-date information** - training cutoffs are real. A model trained six months ago does not know about a CVE published last week.
- **Authoritative command syntax** - flags change, APIs version, defaults shift. Always verify generated commands against current documentation at [docs.meshery.io](https://docs.meshery.io).

## The Right Mental Model

Think of an LLM as a very fast, very well-read collaborator who has read most of the internet but cannot see your screen, has not worked at your company, and occasionally states incorrect things with complete confidence. It is useful precisely because of the reading - and dangerous for the same reason it is useful, because it produces fluent output whether or not the content is correct.

This is not a flaw to work around. It is the nature of the mechanism. Your job as the infrastructure engineer is to design workflows where LLM output is checked before it acts on production systems. The lessons that follow will give you the vocabulary to do that well.
