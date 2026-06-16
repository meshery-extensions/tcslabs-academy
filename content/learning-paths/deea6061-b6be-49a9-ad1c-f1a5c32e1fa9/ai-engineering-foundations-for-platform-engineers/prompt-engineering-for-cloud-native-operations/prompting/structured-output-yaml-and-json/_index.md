---
type: "page"
id: "structured-output-yaml-and-json"
title: "Structured Output: YAML and JSON"
description: "Techniques for reliably coercing an LLM into producing valid, parseable YAML or JSON that a coding agent can apply directly to your cluster."
weight: 3
---

The value of an LLM in an infrastructure workflow is realized only when its output can be consumed by the next step in the pipeline - `kubectl apply`, a Meshery design import, or a configuration management tool. That requires the output to be machine-readable every time, not just most of the time.

LLMs are trained to be helpful and conversational. Left unconstrained, they will mix prose and YAML in the same response, add "Here is the manifest:" headers inside code blocks, or produce YAML that is subtly malformed due to incorrect indentation. This lesson covers the techniques that reliably produce clean, parseable output.

## The Core Instruction: Output Only YAML

The most effective single instruction for structured output is to tell the model to output only the target format, with no surrounding text:

```text
Output only valid YAML. Do not include any explanatory text, comments, or prose.
Do not include the ```yaml fence markers - output raw YAML only.
```

Or, if your parser expects fenced blocks:

```text
Output exactly one ```yaml code block containing the manifest. Do not include any text
outside that code block, before or after it.
```

Choose one convention and enforce it in your system prompt. Your parsing code should enforce the same convention on the receiving end.

## Providing a Schema or Example

An LLM that has been shown the exact structure it should produce is significantly more reliable than one working from a verbal description. For Kubernetes manifests, use the official API structure as your schema anchor.

### Technique 1: Skeleton with Placeholders

Provide the structure with placeholders for the values the model should fill in:

```text
Produce a Kubernetes ConfigMap with the following structure, filling in ONLY the
placeholders marked with <angle brackets>. Do not add or remove any fields.

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: <name>
  namespace: <namespace>
  labels:
    app: <app-label>
data:
  <key>: <value>
```
```

### Technique 2: Golden Example

Provide a complete example of a correctly formed output and ask the model to produce one in the same structure for the new inputs:

```text
Produce a HorizontalPodAutoscaler using exactly this structure:

```yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: api-gateway-hpa
  namespace: production
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: api-gateway
  minReplicas: 2
  maxReplicas: 10
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 60
```

Now produce the same for: deployment `payment-service`, namespace `production`,
minReplicas 3, maxReplicas 8, target CPU utilization 70%.
```

Golden examples are especially powerful when your environment uses custom annotations, non-standard label schemes, or organization-specific conventions that a model will not produce correctly from first principles.

## JSON for Programmatic Workflows

When a coding agent needs to parse the model's output in code, JSON is often easier to handle than YAML because every major language has a strict JSON parser and YAML parsers vary in their tolerance for edge cases.

```text
Output a JSON object with the following schema. Output only the JSON object, with no
surrounding text or markdown fences.

Schema:
{
  "action": "apply" | "delete" | "patch",
  "resource_kind": string,
  "resource_name": string,
  "namespace": string,
  "manifest": object
}
```

For Meshery design imports, YAML is the expected format. Use JSON only when your tooling downstream expects it - for example, when writing a webhook handler or a validation step in your agentic pipeline.

## Validating the Result

Producing structured output from an LLM is not a guarantee of correctness - it is a constraint on format. You still need to validate the result before applying it.

### Syntactic Validation

For YAML, use `yq` or a similar tool to confirm the output parses:

```bash
echo "$LLM_OUTPUT" | yq '.' > /dev/null && echo "valid" || echo "invalid"
```

For JSON:

```bash
echo "$LLM_OUTPUT" | python3 -m json.tool > /dev/null && echo "valid" || echo "invalid"
```

### Schema Validation

For Kubernetes manifests, validate against the cluster's API using a dry run:

```bash
kubectl apply --dry-run=server -f - <<EOF
$LLM_OUTPUT
EOF
```

The server-side dry run validates the manifest against the cluster's API schema, including CRDs, without making any actual changes. This is the correct validation step before applying any LLM-generated manifest.

### Integration with Meshery

Meshery's design validation checks a design against the component registry before import. After generating a manifest, import it as a design and let Meshery's registry validate component types, relationships, and constraints:

```bash
mesheryctl design import -f generated-manifest.yaml -s "Kubernetes Manifest"
```

If the design fails validation, the error message gives you the specific field or component type that is wrong - feed that error back into the LLM as a correction turn rather than attempting to fix it manually.

## Common Failure Modes

| Failure | Cause | Fix |
|---|---|---|
| Prose mixed into YAML | No output format in system prompt | Add "output only YAML" to system prompt |
| Wrong indentation | Model uses 4-space indent | Add "use 2-space YAML indentation" to instructions |
| Missing required fields | Model omits fields it considers optional | Provide schema or skeleton with all required fields |
| Wrong API version | Model uses outdated training data | Include target API version in the user turn explicitly |
| Extra comments in YAML | Model is being "helpful" | Add "do not include YAML comments" to instructions |

Structured output is reliable when your prompts are specific about format and your pipeline validates before acting. Never apply LLM-generated manifests directly to a production cluster without a dry-run validation step.
