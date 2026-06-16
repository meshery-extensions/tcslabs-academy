---
type: "page"
id: "reviewing-an-ai-proposed-design"
title: "Reviewing an AI-Proposed Design"
description: "Apply a structured review checklist to an AI-generated infrastructure design, catching completeness gaps, correctness issues, and security and resource red flags."
weight: 4
---

## Why Review Is Not Optional

An LLM generates plausible infrastructure. It does not generate correct infrastructure. The distinction matters because a plausible-but-incorrect design will pass a casual read and fail under load, under attack, or during a maintenance window. Your review is the control that closes that gap.

Reviewing an AI-proposed design is not about reading YAML carefully. It is a structured process with four dimensions: completeness, correctness, security, and resource hygiene. Each dimension has a short checklist. Working through all four takes less time than debugging a production incident that a missed item would have caused.

## The Four Review Dimensions

### 1. Completeness

Does the design contain everything the brief required? Compare the brief (lesson 3) to the canvas in Kanvas component by component.

**Completeness checklist:**

- [ ] Every workload named in the brief has a corresponding Deployment, StatefulSet, or Job
- [ ] Every workload has a corresponding Service (ClusterIP minimum)
- [ ] Every external entry point has an Ingress or Gateway resource
- [ ] Every stateful workload has a PersistentVolumeClaim
- [ ] Every workload that the brief specified as autoscaled has an HorizontalPodAutoscaler
- [ ] Every workload listed in the brief's exclusions is absent from the design

Missing components are the most common LLM error. Run through this list before moving to the other dimensions.

### 2. Correctness

Do the components that are present actually do what they are supposed to do? This is where selector mismatches, wrong port references, and broken relationships hide.

**Correctness checklist:**

- [ ] Service selectors match the labels on their target Deployment pods
- [ ] Ingress backend service names and port numbers match the corresponding Service definitions
- [ ] HPA target references match the correct Deployment name
- [ ] PVC storageClassName is appropriate for the cluster (or omitted to use the default)
- [ ] Container port numbers in Deployment specs match the ports in the corresponding Service

In Kanvas, a broken relationship - for example, a Service that does not resolve to a Deployment - is visible as a disconnected or warning-state edge between components. Use the relationship view to catch these before they reach `kubectl apply`.

### 3. Security Red Flags

AI-generated designs frequently default to permissive security settings because they optimize for "works" rather than "works securely." Check each of the following explicitly.

**Security checklist:**

- [ ] No container runs as root (check `securityContext.runAsNonRoot: true`)
- [ ] No container has `privileged: true` or `allowPrivilegeEscalation: true`
- [ ] No container mounts `hostPath` volumes
- [ ] Pod security standard is set at the namespace level (label `pod-security.kubernetes.io/enforce`)
- [ ] NetworkPolicy resources are present and restrict ingress/egress to the minimum required
- [ ] Secrets are referenced as environment variables from Secret objects, not hardcoded in ConfigMaps
- [ ] No container image uses the `latest` tag (demand a pinned tag or a placeholder that forces an explicit update)

If the brief specified `pod security standard: restricted`, every container in the design must satisfy the restricted profile. Check this mechanically - do not assume the LLM applied it consistently.

### 4. Resource Hygiene

Under-specified resources cause cluster instability. Over-specified resources waste capacity. Both are design errors.

**Resource hygiene checklist:**

- [ ] Every container has `resources.requests.cpu` and `resources.requests.memory` set
- [ ] Every container has `resources.limits.memory` set (CPU limit is optional but memory limit is required to prevent OOM kill cascades)
- [ ] HPA min and max replica counts are consistent with the brief's availability requirements
- [ ] PodDisruptionBudgets are present for workloads the brief marked as availability-sensitive
- [ ] No container has a memory limit lower than its memory request

A design from `designs/policy-guardrails.yaml` demonstrates resource hygiene applied across a multi-service topology. Import it and compare its resource specifications to this checklist:

```bash
mesheryctl design import -f designs/policy-guardrails.yaml -s "Kubernetes Manifest"
```

## A Short Review Workflow

Apply the four dimensions in order on the Kanvas canvas:

1. **Open the design in Kanvas.** Use the visual layout to get a spatial overview before reading any YAML.
2. **Run the completeness check.** Mark off each expected component. Note any missing ones.
3. **Inspect relationships.** Switch to the relationship view and verify selector correctness and port references.
4. **Read security contexts.** Open each component's detail panel and check the security context fields.
5. **Read resource specs.** Verify requests, limits, and HPA parameters for every workload.
6. **Compile a correction list.** Write down every item that failed a check. Do not fix items in the canvas directly - return the list to the LLM as a correction brief and let it generate a revised proposal.
7. **Re-review the revision.** Run the same four dimensions on the revised design. The revision loop is expected - do not skip it because the first pass looked mostly correct.

## When to Escalate

Some findings during review are not corrections to send back to the LLM - they are signals that the brief was incomplete. If you find yourself inventing requirements during review ("we should probably add a NetworkPolicy for this"), stop and update the brief. Then regenerate from the revised brief rather than patching the design manually. A patched design diverges from its source-of-truth brief, which creates a maintenance problem later.

## Summary

Review an AI-proposed design across four dimensions: completeness (is everything present?), correctness (do selectors and ports resolve?), security (no root containers, no permissive profiles, NetworkPolicies in place), and resource hygiene (requests, limits, HPA bounds all set). Work through the dimensions in order, compile a correction list, and return it to the LLM for a revised proposal. Repeat until the design passes all four dimensions.
