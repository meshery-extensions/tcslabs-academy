---
type: "page"
id: "evaluating-your-prompts"
title: "Evaluating Your Prompts"
description: "Build a small eval set before scaling your prompts, use golden examples to catch regressions, and detect when a prompt or model change breaks expected behavior."
weight: 5
---

A prompt that works once in an interactive session is not a prompt you can trust in an automated pipeline. Models change. Context changes. The same prompt that produced a correct HPA manifest last week might produce one with a subtly wrong `scaleTargetRef` today if the underlying model was updated. Evaluation is how you detect these regressions before they reach your cluster.

Prompt evaluation does not require a sophisticated platform. A small, well-chosen set of test cases run consistently is worth more than an elaborate framework run inconsistently.

## What an Eval Set Is

An eval set is a collection of (input, expected output) pairs that you run against your prompt to verify it still behaves correctly. Each pair is called an **eval case**.

For infrastructure prompts, an eval case typically contains:

- **Input context** - the grounded state you would pass to the model (kubectl output, design YAML, etc.)
- **Task instruction** - the user turn prompt
- **Expected output** - a "golden" example of what a correct response looks like
- **Pass criteria** - how you determine whether the actual output matches the expected output

## Building Your First Eval Set

Start small. Three to five eval cases cover the most important behaviors. You can expand the set as you discover edge cases.

### Step 1: Identify the High-Value Cases

For each prompt in your agentic workflow, ask:
- What is the most common input this prompt will receive?
- What inputs are structurally different but equally valid? (e.g., single-container vs. multi-container pods)
- What inputs have historically caused problems? (e.g., deployments without resource limits)
- What is the minimum correct output? (e.g., valid YAML with required fields)

A good starting eval set for a "generate HPA manifest" prompt might include:
1. A simple single-container deployment
2. A deployment that already has an HPA (expect the prompt to output a diff, not a duplicate)
3. A deployment with no resource limits (expect the prompt to flag this rather than guess at CPU targets)

### Step 2: Capture Golden Examples

A golden example is a manually verified output for a specific input. It is the reference answer.

Capture golden examples while you are still in the interactive prompt development phase. When the model produces a response that is exactly correct, save it as a golden example for that input. Do not rely on memory or informal approval - write the golden to a file.

```bash
# Directory structure for eval cases
prompts/
  generate-hpa/
    eval-01-simple-deployment/
      input.yaml         # kubectl get deployment output
      task.txt           # the user turn prompt
      golden.yaml        # expected output YAML
    eval-02-existing-hpa/
      input.yaml
      task.txt
      golden.yaml
    eval-03-missing-limits/
      input.yaml
      task.txt
      golden.txt         # expected: an error or refusal, not a manifest
```

### Step 3: Define Pass Criteria

Exact string matching rarely works for LLM outputs. Define what "correct" means for your use case:

| Criteria type | When to use | Example |
|---|---|---|
| Exact match | Short, deterministic outputs | A specific command string |
| Structural match | YAML/JSON with required fields | All required Kubernetes fields present |
| Schema validation | Kubernetes manifests | `kubectl apply --dry-run=server` passes |
| Semantic match | Natural language in the output | Key phrase is present |
| Absence check | The model should refuse | No manifest produced when state is missing |

For most infrastructure prompts, a combination of schema validation (does it apply cleanly?) and structural match (are the required fields set to the expected values?) is sufficient.

## Running Evals

A minimal eval runner for infrastructure prompts is a shell script that calls your LLM via its API, applies the output to a test cluster with `--dry-run=server`, and compares specific fields:

```bash
#!/usr/bin/env bash
# eval-run.sh - run a single eval case

CASE_DIR="$1"
INPUT=$(cat "$CASE_DIR/input.yaml")
TASK=$(cat "$CASE_DIR/task.txt")

# Call your LLM (replace with your actual API wrapper)
OUTPUT=$(call_llm --system "$(cat prompts/system.txt)" --user "$TASK\n\nState:\n$INPUT")

# Validate the output applies cleanly
echo "$OUTPUT" | kubectl apply --dry-run=server -f - 2>&1
DRY_RUN_EXIT=$?

if [ $DRY_RUN_EXIT -ne 0 ]; then
  echo "FAIL: dry-run validation failed"
  exit 1
fi

# Check a required field
ACTUAL_MAX=$(echo "$OUTPUT" | yq '.spec.maxReplicas')
EXPECTED_MAX=$(cat "$CASE_DIR/golden.yaml" | yq '.spec.maxReplicas')

if [ "$ACTUAL_MAX" = "$EXPECTED_MAX" ]; then
  echo "PASS"
else
  echo "FAIL: maxReplicas expected $EXPECTED_MAX, got $ACTUAL_MAX"
fi
```

This is a starting point, not a production-grade framework. The critical habit is running it.

## Detecting Regressions

Run your eval set whenever:

- You change the system prompt
- You change the model or model version
- You add a new use case to an existing prompt
- A user reports that the prompt produced unexpected output

The eval set catches regressions. Without it, you will not know that a system prompt edit that fixed one case silently broke another.

## Scaling the Eval Set

As you accumulate more eval cases, patterns emerge. Edge cases that caused failures become new golden examples. Over time, your eval set documents the behavior contract of your prompt - what it should do and what it should refuse to do.

Before scaling an agentic workflow from development to production, verify that:

- [ ] You have at least three eval cases covering the main input variations
- [ ] All eval cases pass against the current prompt and model
- [ ] At least one eval case covers a refusal scenario (model should not produce output)
- [ ] Evals are stored in version control alongside the prompt definition
- [ ] There is a process to run evals before any prompt or model change is deployed

Evaluation is not overhead - it is the mechanism that makes prompt-driven infrastructure automation trustworthy enough to run without a human reviewing every output.
