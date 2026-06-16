---
type: "page"
id: "policy-across-environments"
title: "Policy Across Environments"
description: "Apply graduated policy strictness across dev, staging, and production environments and promote designs through policy gates using Meshery's environment model."
weight: 4
---

## Why Policy Strictness Should Vary

A development environment needs flexibility. Engineers iterate quickly, explore configuration options, and deliberately test designs that would not be production-ready. Applying production-level policy to dev slows that iteration without reducing risk, because dev clusters carry no production traffic.

Production is the opposite: every deployed configuration must meet the full policy standard. Staging sits in between - it should be close enough to production to catch integration issues, but not so strict that exploratory work is impossible.

Meshery models this through **environments** and **policy gates**. Each environment carries its own policy configuration, and designs must pass that environment's validation before they can be promoted to the next one.

## Meshery Environments

An environment in Meshery is a named, scoped context that groups connections and credentials. Environments correspond to your actual infrastructure tiers - typically dev, staging, and prod - and each environment can be associated with a distinct policy constraint set.

You can view and manage environments from the Meshery UI under **Environments**, or query them via the API. Workspaces group environments for team-scoped access control: a platform team workspace might contain all three environments; an application team workspace might contain only dev and staging.

The policy engine reads the active environment when evaluating a design for promotion. This means the same design YAML can produce different validation outcomes depending on which environment it is being promoted into.

## Designing a Graduated Policy Stack

A practical three-tier policy stack looks like this:

| Environment | Relationship Rules | OPA Constraints | Promotion Gate |
|-------------|-------------------|-----------------|----------------|
| dev | Required bindings only | Warnings only; no blocks | None (free import) |
| staging | Required + allowed set enforced | Errors on critical rules | Staging gate (auto) |
| prod | Full required/deny set | Errors on all rules | Prod gate (human approval) |

**Dev** permits incomplete designs to exist so engineers can work incrementally. Relationship violations are surfaced as warnings in the Kanvas UI but do not block import.

**Staging** enforces critical constraints - image registry allowlists, required labels, resource limit presence - as blocking errors. Designs that do not pass the staging constraint set cannot be deployed to staging clusters.

**Prod** applies the complete constraint set, including stricter relationship rules (for example, requiring a `NetworkPolicy` for every `Deployment`) and additional OPA constraints around replica counts and pod disruption budgets.

## Importing and Promoting the Reference Design

The `designs/policy-guardrails.yaml` design demonstrates a multi-environment promotion workflow. Import it to explore the mechanism:

```bash
mesheryctl design import -f designs/policy-guardrails.yaml -s "Kubernetes Manifest"
```

Once imported, the design is visible in your workspace. Attempt to promote it to the staging environment from the Kanvas UI or via the Meshery API. You will see the staging policy gate evaluate the design and return the violations that must be resolved before staging promotion succeeds.

Resolve each violation - update labels, add resource limits, attach required network policies - and re-validate. When no `error`-severity violations remain, the staging gate opens and the design is eligible for staging deployment.

## The Promotion Workflow in Practice

A typical promotion sequence for a coding agent-assisted workflow:

```text
1. Agent generates design YAML
2. Import into Meshery (dev environment)
   └─ Dev policy: warnings surfaced, no blocks
3. Agent iterates on violations flagged as warnings
4. Engineer reviews policy-clean design
5. Promote to staging
   └─ Staging gate: blocking evaluation runs
   └─ Remaining violations returned if any
6. Agent or engineer resolves staging violations
7. Human approval required for prod gate
8. Promote to prod
   └─ Prod gate: full constraint set evaluated
   └─ Human confirms promotion
```

The human-in-the-loop step at the prod gate is intentional. Policy automation handles mechanical correctness; human judgment handles contextual correctness.

## Per-Environment Constraint Sets

Each environment references a named constraint bundle specifying which OPA packages and relationship rule sets apply. For the `policy-guardrails.yaml` design, the prod bundle adds:

- `meshery.policy.networking/networkpolicy-required` - every `Deployment` must have a `NetworkPolicy`
- `meshery.policy.availability/pdb-required` - every multi-replica `Deployment` must have a `PodDisruptionBudget`
- `meshery.policy.images/digest-pinning-required` - images must reference a digest, not a mutable tag

In dev the constraint bundle is empty; staging applies only the first rule. As a design moves toward production it is progressively hardened.

Policy sets are code. Store them in version control alongside infrastructure definitions. When a compliance requirement changes, update the bundle, commit, and distribute through the Catalog. Teams using the shared bundle pick up new constraints automatically on their next validation run.
