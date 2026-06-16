---
type: "page"
id: "supply-chain-for-ai-generated-infrastructure"
title: "Supply Chain for AI-Generated Infrastructure"
description: "Verify the provenance and integrity of AI-generated manifests and the container images they reference before applying them to any cluster."
weight: 2
---

When a coding agent generates a Kubernetes manifest, it is authoring infrastructure code - and like any code, that manifest can introduce vulnerable images, misconfigured RBAC, or supply chain artifacts of unknown provenance. The difference from traditional infrastructure-as-code is speed and volume: an agent can produce hundreds of manifests in minutes, outpacing manual review if no automated gate exists.

Treating AI-generated manifests as first-class software artifacts - subject to the same provenance, scanning, and signing requirements as human-authored code - is the correct model. This lesson covers how to build that discipline into a Meshery-based pipeline.

## The Provenance Problem

A manifest's provenance answers: where did this come from, when, under what conditions, and has it been tampered with since? For AI-generated manifests, provenance has an additional dimension: which model version produced it, from which prompt, and with which retrieved context.

At minimum, track:

- The commit SHA or content hash of the generated manifest
- The agent run identifier and timestamp
- The input design file or prompt template used
- Whether a human reviewer approved the output before apply

Store this metadata as annotations or OCI labels alongside the manifest in your GitOps repository.

## Image Pinning

One of the most common and dangerous AI agent mistakes is generating manifests that reference mutable image tags such as `latest` or `v1`. Mutable tags can be overwritten at the registry without changing the manifest, silently introducing a different image into your cluster.

**Always pin container images to their digest:**

```yaml
containers:
  - name: api
    image: ghcr.io/your-org/api@sha256:a3f2c1d4e5b6...
```

When reviewing manifests produced by an agent, reject any manifest containing a mutable tag. Encode this as a policy using OPA Gatekeeper or Kyverno:

```yaml
# Kyverno ClusterPolicy example
spec:
  rules:
    - name: require-image-digest
      match:
        resources:
          kinds: ["Pod"]
      validate:
        message: "Image must be pinned to a digest, not a mutable tag."
        pattern:
          spec:
            containers:
              - image: "*@sha256:*"
```

Import `designs/policy-guardrails.yaml` with `mesheryctl design import -f designs/policy-guardrails.yaml -s "Kubernetes Manifest"` to get a baseline set of admission policies you can extend with this check.

## Scanning AI-Generated Manifests

Static analysis and vulnerability scanning should run before any agent-generated manifest is applied. Integrate these tools at the GitOps pull-request stage:

| Tool | What it checks |
|------|---------------|
| `trivy config` | Misconfigurations in YAML/Helm (privileged containers, missing resource limits, etc.) |
| `trivy image` | CVEs in referenced container images |
| `kubesec` | Security risk score for workload manifests |
| `kube-score` | Best-practice checks (readiness probes, network policies, etc.) |

A pipeline that gates on `trivy config` and `trivy image` catches the most common agent errors before they reach a cluster.

## Signing and Verifying Manifests

For high-assurance environments, sign manifests and images using Sigstore's Cosign toolchain. Sign at generation time (as part of the agent pipeline's CI step), and verify at admission time using a policy controller.

```bash
# Sign an image after the agent-generated build completes
cosign sign --key cosign.key ghcr.io/your-org/api@sha256:a3f2c1d4e5b6...

# Verify before apply
cosign verify --key cosign.pub ghcr.io/your-org/api@sha256:a3f2c1d4e5b6...
```

For manifest files themselves, you can sign the Git commit using GPG or SSH signing, and enforce signed commits on the GitOps repository so that only pipeline identities - not interactive users or unverified agents - can merge to the apply branch.

## Human Review Before Trust

Automation does not eliminate the need for human judgment; it shifts where that judgment is applied. For AI-generated infrastructure, the right checkpoint is the pull-request review step - after scanning passes but before merge.

Establish a policy: no AI-generated manifest merges to the production branch without at least one human approval from the infrastructure team. The reviewer's job is not to re-examine every line but to:

1. Confirm the manifest's purpose matches the stated intent
2. Check that all images are digest-pinned
3. Verify no secrets appear inline
4. Confirm the RBAC scope looks appropriate for the workload

Meshery's Kanvas provides a visual diff of design changes between versions, making this review faster than reading raw YAML. Use `mesheryctl design import` to load the candidate manifest into a staging environment and inspect it in Kanvas before approving.

## Key Takeaways

- Treat AI-generated manifests as software artifacts requiring provenance tracking, scanning, and signing.
- Pin all container images to SHA digests. Enforce this with an admission policy.
- Run `trivy config` and `trivy image` at PR time. Block merges on critical findings.
- Require human approval before AI-generated manifests reach a production apply branch.
- Use Kanvas for visual design review as part of the approval workflow.
