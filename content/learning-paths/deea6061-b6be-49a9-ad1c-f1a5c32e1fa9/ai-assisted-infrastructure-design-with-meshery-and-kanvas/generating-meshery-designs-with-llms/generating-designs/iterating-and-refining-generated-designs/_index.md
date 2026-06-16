---
type: "page"
id: "iterating-and-refining-generated-designs"
title: "Iterating and Refining Generated Designs"
description: "Use targeted follow-up prompts and Kanvas validation to converge on a correct, deployable Meshery design."
weight: 4
---

Generating a design that passes import on the first attempt is the goal, but it is not always the outcome. More often, the initial output is 80-90% correct and needs targeted corrections. The disciplined approach is to refine with surgical follow-up prompts, validate each change in Kanvas, and converge incrementally - not to regenerate from scratch and repeat the same mistakes.

## Why Regeneration Is the Wrong Default

When a design fails validation, the instinct is to re-run the original prompt and hope for a different result. That approach has two problems:

1. LLM output is probabilistic. The model may produce the same error again, or introduce new errors while fixing the one you found.
2. You lose the parts of the design that were already correct. A full regeneration discards good work.

The better model is surgical: identify the specific validation failure, construct a follow-up prompt that addresses only that failure, apply the fix, and validate again. Each iteration is small, targeted, and verifiable.

## Step 1 - Import and Read the Error

Start every iteration cycle by importing the current design:

```bash
mesheryctl design import -f designs/my-design.yaml -s "Kubernetes Manifest"
```

Read the CLI output carefully. Import errors include:

- The YAML document index where parsing failed
- The `kind`/`apiVersion` pair that was not recognised
- The field name that is missing or invalid

If the import succeeds, open the design in Kanvas. Validation errors that do not block import (such as missing resource limits or relationship mismatches) appear as component-level warnings in the canvas.

## Step 2 - Construct a Targeted Follow-Up Prompt

Do not paste the entire failed design back into the LLM and ask it to fix everything. That produces another wide-output response that is hard to review. Instead, paste only the failing document (the specific `---` block) and describe the exact error:

```text
The following Kubernetes Service YAML fails Meshery validation with the error:
"targetPort 8080 does not match any containerPort declared in the selected Deployment".

The corresponding Deployment exposes containerPort 9898.

Fix only the Service spec below to correct the targetPort. Return only the corrected YAML
for this Service, no explanation:

---
apiVersion: v1
kind: Service
metadata:
  name: api
  namespace: demo
spec:
  selector:
    app: api
  ports:
    - port: 9898
      targetPort: 8080   # wrong
```

This prompt is unambiguous: it names the error, explains the correct value, restricts the output to the failing document, and asks for YAML only. The response should be a corrected Service block that you can splice back into the full design.

## Step 3 - Splice and Re-import

Replace the failing document in your design file with the corrected block and re-run the import:

```bash
mesheryctl design import -f designs/my-design.yaml -s "Kubernetes Manifest"
```

If the import passes, open Kanvas to verify the visual layout and check for remaining warnings. If a new error appears, go back to step 2 with the new error message.

## Step 4 - Validate in Kanvas

Kanvas is the human-in-the-loop checkpoint. After each successful import, open the design and do three checks:

1. **Topology** - do the component nodes and connectors reflect the intended architecture? A Service should connect to its target Deployment. A ConfigMap should be mounted where you expect.
2. **Warnings** - are there any yellow or red indicator badges on component nodes? Click each one to read the validation message.
3. **Completeness** - are all expected resources present? Kanvas makes it easy to spot a missing ServiceAccount or an orphaned ConfigMap that has no consumer.

If a warning is acceptable (for example, an image without a pinned digest in a development design), note it in your design metadata as a known exception. Do not silently ignore it.

## A Realistic Iteration Example

Starting from a generated design based on `designs/microservices-demo.yaml`:

| Iteration | Error found | Follow-up prompt |
|-----------|------------|-----------------|
| 1 | Import fails: `extensions/v1beta1` not recognised | "Change apiVersion to apps/v1 on all Deployments. Return only the corrected Deployment blocks." |
| 2 | Import passes; Kanvas shows selector mismatch on `cache` Deployment | "The cache Deployment selector.matchLabels has key `component` but template.metadata.labels has key `app`. Fix the selector to match the template. Return only the corrected Deployment." |
| 3 | Import passes; Kanvas shows missing resource limits on cache container | "Add resources.requests and resources.limits to the cache container. Use cpu: 50m/200m and memory: 32Mi/64Mi. Return only the corrected container spec." |
| 4 | All validations pass | None - design is ready |

Four iterations, each targeting one specific problem. This is faster and more reliable than two or three full regenerations.

## When to Start Fresh

Starting from scratch is appropriate when:

- The initial output has the wrong structure entirely (for example, Helm chart syntax instead of plain YAML)
- More than half the documents have errors and the errors are in the structure rather than individual field values
- The model has hallucinated resource kinds that do not exist in the Meshery registry and cannot be mapped to real kinds

In these cases, go back to the prompting techniques from the previous lesson, add the constraints that were missing, and generate again with a cleaner prompt.

## Convergence Criterion

A design has converged when:

- `mesheryctl design import` completes without errors
- Kanvas shows no red validation badges
- The topology in Kanvas matches the intended architecture
- All containers have resource requests and limits
- All selector/label pairs are consistent

At that point the design is importable, visualisable, and deployable. Save it to the Meshery Catalog or commit it to your repository so it can be referenced in future iterations.
