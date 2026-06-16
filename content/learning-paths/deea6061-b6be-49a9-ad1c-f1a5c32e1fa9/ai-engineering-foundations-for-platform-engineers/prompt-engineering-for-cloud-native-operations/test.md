---
title: "Course Test"
passPercentage: 70
type: "test"
questions:
  - id: "q1"
    text: "A platform engineer wants every LLM response that contains Kubernetes configuration to use a specific YAML fenced code block format with no surrounding prose. Where should this output format requirement be defined?"
    type: "single-answer"
    marks: 2
    explanation: "Output format requirements that apply to every interaction belong in the system prompt. The system prompt runs before any user message and establishes non-negotiable constraints. A user turn instruction can be diluted or overridden as a conversation grows; a system prompt instruction cannot."
    options:
      - id: "a"
        text: "In each user turn, reminding the model of the format for that request"
        isCorrect: false
      - id: "b"
        text: "In the system prompt, so it applies to all responses without repetition"
        isCorrect: true
      - id: "c"
        text: "In a post-processing script that reformats the raw model output"
        isCorrect: false
      - id: "d"
        text: "In a Kubernetes ConfigMap that the agent reads before responding"
        isCorrect: false

  - id: "q2"
    text: "An SRE asks an LLM to 'optimize the resource requests for my api-gateway deployment' without providing any cluster state. What is the most likely failure mode?"
    type: "single-answer"
    marks: 2
    explanation: "Without real cluster state in the context window, the LLM must invent plausible values. It has no knowledge of the actual resource usage, actual current requests, or the actual label selectors and API version of the specific deployment. The result is a manifest that looks syntactically correct but is fabricated - the classic hallucination risk for infrastructure prompts."
    options:
      - id: "a"
        text: "The LLM will refuse to answer because the task is too vague"
        isCorrect: false
      - id: "b"
        text: "The LLM will produce a manifest with fabricated resource values that do not reflect actual usage"
        isCorrect: true
      - id: "c"
        text: "The LLM will call kubectl directly to fetch the current state"
        isCorrect: false
      - id: "d"
        text: "The LLM will produce a manifest with no resource requests at all"
        isCorrect: false

  - id: "q3"
    text: "Which kubectl command validates a model-generated Kubernetes manifest against the cluster API without making any changes to the cluster?"
    type: "single-answer"
    marks: 2
    explanation: "kubectl apply --dry-run=server sends the manifest to the Kubernetes API server for validation against the current schema and CRDs without persisting any changes. This is the correct validation step for LLM-generated manifests before applying them. The --dry-run=client flag only validates locally against a static schema and does not catch CRD or admission webhook failures."
    options:
      - id: "a"
        text: "kubectl validate -f manifest.yaml"
        isCorrect: false
      - id: "b"
        text: "kubectl apply --dry-run=client -f manifest.yaml"
        isCorrect: false
      - id: "c"
        text: "kubectl apply --dry-run=server -f manifest.yaml"
        isCorrect: true
      - id: "d"
        text: "kubectl diff -f manifest.yaml"
        isCorrect: false

  - id: "q4"
    text: "A team uses a custom label scheme (team, managed-by, cost-center) on all their Kubernetes resources. They want an LLM to always include these labels when generating new manifests. Which prompt technique is most effective for teaching the model this convention?"
    type: "single-answer"
    marks: 2
    explanation: "Few-shot prompting provides complete input-output examples that show the model the exact label structure in context. Because the examples are concrete, the model learns the convention by demonstration rather than description. A verbose verbal description of the label scheme is less reliable because the model must interpret and apply it; examples show exactly what the output should look like."
    options:
      - id: "a"
        text: "Role prompting - assign the model the persona of a senior platform engineer"
        isCorrect: false
      - id: "b"
        text: "Few-shot prompting - provide two or three example manifests with the correct labels"
        isCorrect: true
      - id: "c"
        text: "Step-by-step decomposition - ask the model to add labels one at a time"
        isCorrect: false
      - id: "d"
        text: "Checklist prompting - include the label requirements in a review checklist"
        isCorrect: false

  - id: "q5"
    text: "What is the 'retrieval over recall' principle in the context of infrastructure prompting?"
    type: "short-answer"
    marks: 2
    correctAnswer: "fetch current cluster state"
    case_sensitive: false
    explanation: "Retrieval over recall means always fetching current, authoritative state (from kubectl, MeshSync, or another live source) and injecting it into the prompt at inference time, rather than relying on what the model learned during training. Training data can be months old and specific to different environments. Retrieval ensures the model reasons from real, current state."

  - id: "q6"
    text: "Which of the following are valid reasons to run your prompt eval set? Select all that apply."
    type: "multiple-answers"
    marks: 2
    explanation: "Evals should be run whenever the system prompt changes, when the model or model version changes, when a new use case is added to an existing prompt, and when a user reports unexpected output. These are all scenarios where a previously working prompt may have regressed. Running evals only on new prompts misses regressions caused by changes to existing prompts or model updates."
    options:
      - id: "a"
        text: "When the system prompt is changed"
        isCorrect: true
      - id: "b"
        text: "When the underlying model or model version is updated"
        isCorrect: true
      - id: "c"
        text: "When a user reports that the prompt produced unexpected output"
        isCorrect: true
      - id: "d"
        text: "Only when a completely new prompt is written for the first time"
        isCorrect: false
---
