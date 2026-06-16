---
type: "page"
id: "catching-misconfigurations-early"
title: "Catching Misconfigurations Early"
description: "Apply shift-left validation techniques to AI-generated manifests before any deployment command runs, with concrete examples of common misconfiguration patterns."
weight: 2
---

## Shift Left in the AI Workflow

"Shift left" means moving quality checks as early in the pipeline as possible - closer to authorship, farther from production. In a traditional workflow, that means running linters and schema checks in CI before a merge. In an AI-assisted workflow, it means validating LLM output before you even commit it to version control.

The earlier you catch a misconfiguration, the cheaper it is to fix. A design error caught in Meshery before import costs one edit. The same error caught by a crashing Pod in staging costs a rollout, an incident, and an investigation.

## Where Pre-Deploy Checks Fit

The check sequence for AI-generated infrastructure looks like this:

```text
LLM output (YAML)
    |
    v
1. Schema validation  <-- mesheryctl design import catches parse errors
    |
    v
2. Relationship validation  <-- Meshery registry resolves component wiring
    |
    v
3. Policy evaluation  <-- OPA rules enforce your environment's standards
    |
    v
4. Human review  <-- you or a peer inspects the validated design in Kanvas
    |
    v
5. Deploy
```

Steps 1-3 run automatically on import. Step 4 is the human-in-the-loop gate before any cluster operation.

## Common Misconfiguration Patterns from LLM Output

### 1. Missing Resource Limits

An LLM often omits `resources.limits` because training data contains many manifests that skip them. Without limits, a single runaway container can starve other workloads on the node.

```yaml
# What the LLM produced - no limits
containers:
  - name: api
    image: myregistry/api:1.4.2
    resources:
      requests:
        cpu: "100m"
        memory: "128Mi"
      # limits section missing entirely
```

Meshery's policy engine flags this if a `require-resource-limits` rule is active for the target environment. Fix: add explicit `limits` that are at least as large as `requests`.

### 2. Selector / Label Mismatch

LLMs that generate Service and Deployment in a single pass sometimes use slightly different label values across the two resources.

```yaml
# Deployment labels
metadata:
  labels:
    app: payments-api
    tier: backend

# Service selector - note the different value
spec:
  selector:
    app: payments   # <-- does not match "payments-api"
```

Meshery's relationship engine catches this during design validation: the Service's selector resolves to zero matching components, which surfaces as a `Network` relationship error.

### 3. Wrong Namespace

When prompted to generate resources for a "production" environment, an LLM may set `namespace: default` because that is the most common value in its training data. Resources in the wrong namespace miss namespace-scoped RBAC, NetworkPolicies, and ResourceQuotas.

```yaml
metadata:
  name: order-processor
  namespace: default   # should be: production
```

You can catch this with a Meshery policy rule that rejects resources whose namespace does not appear in an approved list for the target environment. The import-time policy report will flag every violating component.

### 4. Inconsistent Replica Count and PodDisruptionBudget

An LLM might generate a Deployment with `replicas: 1` alongside a PodDisruptionBudget that requires `minAvailable: 2`. This passes schema validation but is logically incoherent: the PDB makes it impossible to drain the single node hosting the only replica.

Meshery's relationship validation can surface this via a policy rule that compares `Deployment.spec.replicas` against any associated PDB's `minAvailable` or `maxUnavailable`.

## Running the Check Before Committing

A practical pre-commit workflow:

```bash
# Validate locally before touching git
mesheryctl design import -f generated-infra.yaml -s "Kubernetes Manifest"

# Review the validation output - if any errors appear, fix the YAML and re-import
# Only commit once the validation report shows no errors or policy violations
```

For teams using GitOps, add a CI step that imports the design to a Meshery instance configured for the target environment. The import command exits non-zero on policy violations, which blocks the merge.

## Building a Pattern Library of Known Failures

Keep a running list of misconfigurations you have caught in AI output for your specific stack. Feed that list back as few-shot examples in your agent's system prompt:

```text
KNOWN VALIDATION FAILURES - always check for these before returning YAML:
- service selector must exactly match deployment .metadata.labels
- resources.limits must be present on every container
- namespace must be one of: staging, production (never "default")
```

This closes the feedback loop: validation findings improve the agent's future output, which reduces the manual review burden over time. Even so, do not remove the automated checks - the agent will still miss cases, and the checks are cheap to run.
