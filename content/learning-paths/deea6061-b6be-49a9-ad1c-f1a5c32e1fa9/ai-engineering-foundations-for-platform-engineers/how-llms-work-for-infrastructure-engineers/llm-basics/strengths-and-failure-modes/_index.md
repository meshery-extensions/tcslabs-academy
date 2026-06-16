---
type: "page"
id: "strengths-and-failure-modes"
title: "Strengths and Failure Modes"
description: "Hallucination, confident wrongness, stale knowledge, and non-determinism - why verification and human-in-the-loop are non-negotiable for infrastructure automation."
weight: 3
---

A tool's failure modes tell you more about how to use it safely than its strengths do. LLMs have characteristic ways of going wrong that are especially dangerous in infrastructure contexts, because the consequences of acting on wrong output are not "the document looks funny" - they are "the deployment went sideways" or "the policy rule is silently bypassed."

## Hallucination

Hallucination is the canonical LLM failure mode: the model produces output that is fluent, confident, and factually wrong. The word "hallucination" is somewhat misleading because it implies the model is confused. A more accurate description is that the model is doing exactly what it is designed to do - producing statistically likely token sequences - and the sequence it produces happens to describe something that does not exist.

For infrastructure engineers, hallucination shows up as:

- **Invented command flags** - the LLM generates `mesheryctl design apply --force --namespace production` when no `--force` flag exists for that subcommand
- **Fabricated API fields** - a generated YAML manifest includes a field that does not exist in the CRD spec
- **Made-up version numbers** - the LLM cites a release version or changelog entry that was never published
- **Non-existent integrations** - the model describes a Meshery adapter or provider that was never written

None of these look like errors. They look like documentation. That is what makes hallucination dangerous.

**Mitigation:** Verify every generated command against [docs.meshery.io](https://docs.meshery.io) before running it. Validate generated YAML with `kubectl apply --dry-run=client` or Meshery's built-in validation before applying it to a cluster. Treat LLM output as a draft, not a source of truth.

## Confident Wrongness

Hallucination is a special case of a broader pattern: LLMs express confidence that is unrelated to correctness. The model does not have an internal accuracy signal. It does not know what it does not know. A response that is completely correct and a response that is completely fabricated are produced by the same mechanism and often sound identical.

This is qualitatively different from a human expert who says "I'm not sure about this, you should check." An LLM will typically not volunteer uncertainty unless you explicitly ask it to, and even then the uncertainty it expresses may not correlate with actual accuracy.

**Mitigation:** Build verification into your workflow, not just into your judgment. If you are building an agent that generates Meshery designs, include a validation step - run `mesheryctl system check` after any system change, import the design and inspect it in Kanvas before applying it to a live environment.

## Stale Knowledge

LLM weights are frozen at a training cutoff date. A model trained in mid-2024 has no knowledge of software released, CVEs published, or API changes made after that date. The training cutoff is not always clearly documented and is not always respected consistently even when it is - models sometimes confidently describe behavior from an earlier version of a project.

For infrastructure work, stale knowledge creates specific risks:

- Security advisories that postdate the training cutoff are unknown to the model
- Deprecated API versions may be recommended without any warning
- A Meshery feature introduced in a recent release will be either unknown or incorrectly described

**Mitigation:** Pass current documentation as context when accuracy on recent behavior matters. Use the MCP server pattern (covered in a later course) to give an agent access to live documentation queries rather than relying on baked-in training knowledge.

## Non-Determinism

Given the same prompt, an LLM will typically not produce the same output twice. The sampling process that picks each token includes randomness controlled by a parameter called temperature. At temperature zero the output is deterministic (always the highest-probability token), but most deployed models run at temperatures above zero to produce more varied, natural-sounding responses.

For infrastructure automation, non-determinism means:

- The same prompt that generated a valid YAML manifest yesterday may generate an invalid one today
- Automated pipelines that rely on LLM output must validate that output programmatically, not assume consistency
- Comparing outputs across runs is unreliable for detecting regressions

**Mitigation:** Lower temperature settings produce more consistent output at the cost of some creativity. For structured output tasks - generating YAML, writing policy rules, producing JSON - use the lowest temperature your model supports and use output schemas or structured output modes where the API offers them. Always validate the structure of LLM output programmatically before use.

## Human-in-the-Loop Is Not Optional

The combination of these failure modes - confident, plausible, non-deterministic, potentially stale output - means that any infrastructure workflow where an LLM can directly apply changes to production systems without human review is a reliability risk.

Human-in-the-loop does not mean a human reads every token. It means the workflow is designed so that a human can inspect and approve the LLM's proposed action before it takes effect. In Meshery terms: the agent drafts a design or proposes a configuration change, you review it in Kanvas or inspect it with `mesheryctl design view`, and you apply it deliberately.

This is not a temporary limitation waiting to be solved by a better model. It is the correct operational posture given how the technology works. Build verification and approval steps into your architecture from the start.
