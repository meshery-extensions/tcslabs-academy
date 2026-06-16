---
type: "page"
id: "a-review-checklist-for-ai-infra"
title: "A Review Checklist for AI-Generated Infra"
description: "A concrete, reusable checklist covering correctness, security, resources, policy, and rollback that engineers run before merging or deploying AI-generated infrastructure."
weight: 4
---

## Why a Checklist

Automated validation catches well-defined violations. A human reviewer catches everything else: intent drift (the design does not match the original requirement), implicit assumptions baked in by the LLM, and organizational context that no policy rule encodes.

A checklist forces the reviewer to look at each risk category deliberately rather than skimming for obvious errors. The five categories below correspond to the most common failure modes in AI-generated infrastructure: correctness, security, resources, policy, and rollback readiness.

Use this checklist on every pull request or design promotion that contains LLM-generated content, regardless of how confident you are in the agent's output.

---

## The Checklist

### Category 1: Correctness

These checks confirm that the design does what was intended.

- [ ] **Intent match** - re-read the original requirement or prompt. Does the generated design implement what was asked for, or did the LLM substitute a related but different approach?
- [ ] **Component completeness** - are all required components present? (Services, ConfigMaps, Secrets, Ingress, HPA, etc. as appropriate for the workload)
- [ ] **Relationship wiring** - Meshery validation is clean. No selector/label mismatches. All Services resolve to at least one Pod in the design.
- [ ] **Namespace assignment** - every resource targets the correct namespace. No resource is in `default` when it belongs in a scoped namespace.
- [ ] **Image references** - all container images use pinned tags or digests. No `:latest` tags.
- [ ] **Configuration sources** - all ConfigMaps and Secrets referenced by volumes or environment variables actually exist in the design or are documented as pre-existing.

### Category 2: Security

These checks prevent the design from expanding the attack surface.

- [ ] **No root containers** - every container sets `securityContext.runAsNonRoot: true` or specifies a non-zero `runAsUser`.
- [ ] **Read-only root filesystem** - where the workload permits it, `readOnlyRootFilesystem: true` is set.
- [ ] **Dropped capabilities** - `capabilities.drop: ["ALL"]` is present; any required capabilities are explicitly added back and justified.
- [ ] **No host path mounts** - no `hostPath` volumes unless specifically required and documented.
- [ ] **NetworkPolicy present** - the design includes explicit NetworkPolicy rules or relies on a documented namespace-level default-deny that is already in place.
- [ ] **RBAC scoped** - ServiceAccounts bind only the permissions the workload actually needs. No cluster-admin bindings.
- [ ] **Secret handling** - Secrets are not embedded as plaintext in ConfigMaps or environment variable values. They reference a Secret object or an external secrets provider.

### Category 3: Resources

These checks protect cluster stability and cost.

- [ ] **Limits declared** - every container has `resources.limits.cpu` and `resources.limits.memory`.
- [ ] **Requests reasonable** - `resources.requests` values are proportionate. CPU requests are not zero; memory requests are not orders of magnitude below limits.
- [ ] **Replica count appropriate** - Deployment/StatefulSet replica counts match the workload's availability and load expectations, not the LLM's default of `1`.
- [ ] **HPA configured where needed** - workloads with variable load have a HorizontalPodAutoscaler. Min and max replicas are sensible for the namespace quota.
- [ ] **PodDisruptionBudget present** - any Deployment with `replicas > 1` has an associated PDB with `minAvailable >= 1`.

### Category 4: Policy

These checks confirm the design complies with your organization's rules.

- [ ] **Meshery policy report is clean** - import the design with `mesheryctl design import -f <file> -s "Kubernetes Manifest"` and confirm zero policy violations for the target environment.
- [ ] **Required labels present** - team, cost-center, environment, and any other mandatory label keys are on every resource.
- [ ] **Admission webhook compatibility** - if the cluster runs OPA Gatekeeper or Kyverno, verify the design passes locally or in a staging cluster before targeting production.
- [ ] **ResourceQuota headroom** - the aggregate resources requested by this design fit within the remaining quota of the target namespace. Check current usage before submitting.

### Category 5: Rollback Readiness

These checks ensure you can recover quickly if the deploy goes wrong.

- [ ] **Deployment strategy set** - `RollingUpdate` with a meaningful `maxUnavailable` and `maxSurge`. Avoid `Recreate` for stateless services.
- [ ] **Health probes defined** - every container has `readinessProbe` and `livenessProbe`. Misconfigured probes are a leading cause of failed rollouts.
- [ ] **Previous version documented** - the image tags and replica counts of the current running version are recorded in the PR or design commit message, so rollback is one command.
- [ ] **Stateful data handled** - if the design includes StatefulSets or PersistentVolumeClaims, the data migration or retention plan is documented alongside the design change.

---

## Incorporating the Checklist into Your Workflow

Store the checklist as a pull request template in your repository (`.github/pull_request_template.md`). Require reviewers to check off each item before approving a PR that contains AI-generated infrastructure.

For designs managed in Meshery workspaces, add a custom annotation to track checklist completion:

```yaml
metadata:
  annotations:
    tcslabs.io/review-checklist-completed: "true"
    tcslabs.io/reviewer: "your-username"
    tcslabs.io/review-date: "2025-06-16"
```

This creates an auditable trail alongside the design itself. Combined with Meshery's policy validation output, it gives any future maintainer a clear picture of what was checked and when.

The checklist is a living document. As your agent's output patterns evolve and as new failure modes surface in post-incident reviews, add items. A checklist that grows with operational experience is more valuable than a static template.
