---
type: "page"
id: "building-a-knowledge-base-for-operations"
title: "Building a Knowledge Base for Operations"
description: "Turn runbooks, documentation, and designs into a retrievable knowledge base that keeps agents grounded in your organization's operational standards."
weight: 3
---

## What Goes in an Ops Knowledge Base

Live cluster state tells an agent what is. A knowledge base tells it what should be and what to do when things go wrong. The two are complementary.

An operations knowledge base for a Meshery-managed environment typically contains: runbooks (step-by-step procedures for rolling restarts, certificate rotation, scaling, incident response); architecture decisions (why the system is structured the way it is); Meshery designs (importable with `mesheryctl design import`); policy documents (OPA rules in human-readable form); and known failure modes with documented resolutions.

The Meshery Catalog is a shared, versioned store for designs in a structured, retrievable format.

## Chunking: Splitting Documents for Retrieval

Retrieval works by comparing the semantic content of a query against the semantic content of stored fragments. The operative word is "fragments": you almost never retrieve whole documents, because most of a document is irrelevant to any given query.

Chunking is the process of splitting documents into retrievable units. The key decisions are:

**Chunk size.** Too small and a chunk loses context - a step in a runbook is meaningless without knowing what the runbook is about. Too large and retrieval returns irrelevant content alongside the relevant fragment.

A practical starting point for ops content:
- Runbook sections: one procedure per chunk, with a header that names the procedure and the service it applies to.
- Architecture documents: one decision or one component description per chunk.
- Designs: index at the component level - one chunk per service or resource group defined in the design.

**Chunk overlap.** Including a few sentences of overlap between consecutive chunks prevents a key sentence from falling at a boundary and being split across two chunks that are retrieved separately.

**Metadata.** Attach metadata to every chunk: source file, last-modified date, relevant service or namespace, tags. This metadata enables filtered retrieval - "find runbooks tagged `production` modified in the last thirty days" - which dramatically narrows the search space before semantic comparison happens.

```yaml
# Example chunk metadata schema
chunk_id: "runbook-cert-rotation-step-3"
source: "runbooks/certificate-rotation.md"
last_modified: "2025-03-10"
tags: ["certificates", "tls", "production"]
service: "ingress"
text: "Rotate the wildcard certificate by running..."
```

## Retrieval: Finding the Right Chunk at Query Time

A retrieval system finds relevant chunks from potentially thousands of stored documents.

**Embedding-based retrieval** converts the query and stored chunks into vector representations and finds chunks whose embeddings are closest in vector space. This is semantic retrieval: it finds relevant content even when exact words do not match. **Keyword retrieval** matches exact terms - faster, but misses synonyms. In practice, hybrid retrieval combining both outperforms either alone: keyword filtering narrows the candidate set, embedding search ranks within it. The top-k chunks (typically three to five) are injected into the agent's prompt alongside the query.

## Keeping the Knowledge Base Fresh

A knowledge base that is not maintained becomes a liability. An agent that retrieves an outdated runbook and follows it may take the wrong action with full confidence. Freshness is a correctness requirement, not a nice-to-have.

Strategies for keeping retrieval content current:

| Trigger | Action |
|---|---|
| Runbook committed to version control | Re-index the affected document automatically in CI |
| Design updated in Meshery Catalog | Re-index the design components |
| Incident resolved with a new root cause | Add a post-incident chunk immediately |
| Policy document revised | Re-index and mark old version as superseded |

Attach a `last_indexed` timestamp to every chunk and surface it to the agent alongside retrieved content. An agent that sees "last indexed: 14 months ago" can flag the content as potentially stale rather than acting on it blindly.

For the academy's importable designs - `designs/microservices-demo.yaml`, `designs/observability-stack.yaml`, `designs/llm-mcp-gateway.yaml`, `designs/policy-guardrails.yaml` - treat the version-controlled file as the source of truth. Any time a design is updated and re-imported with `mesheryctl design import`, re-index the corresponding knowledge base entries.

## What the Agent Does with Retrieved Content

The agent receives retrieved chunks as additional context before generating a response:

```text
[Retrieved - certificate rotation runbook, last indexed 2025-03-10]
Step 3: Rotate the wildcard cert:
  kubectl create secret tls wildcard-cert --cert=cert.pem --key=key.pem \
    -n ingress-nginx --dry-run=client -o yaml | kubectl apply -f -
Verify the new certificate is active before deleting the old secret.
[End retrieved context]

User query: How do I rotate the TLS certificate for the ingress controller?
```

The agent can now cite the runbook, use the exact command, and include the verification step - none of which it could produce reliably from training data alone.
