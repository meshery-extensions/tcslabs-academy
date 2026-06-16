---
title: "Course Test"
passPercentage: 70
type: "test"
questions:
  - id: "q1"
    text: "Which of the following best describes what a coding agent can do that a standard chat LLM cannot?"
    type: "single-answer"
    marks: 2
    explanation: "A coding agent is given a set of tools it can call - such as reading files, running shell commands, or querying APIs - and loops over plan-act-observe cycles to complete a task. A chat LLM only generates text in a single turn."
    options:
      - id: "a"
        text: "Generate longer responses with more detail."
        isCorrect: false
      - id: "b"
        text: "Call tools, execute commands, and iterate across multiple steps to complete a task."
        isCorrect: true
      - id: "c"
        text: "Access the internet in real time."
        isCorrect: false
      - id: "d"
        text: "Use a different underlying model architecture."
        isCorrect: false

  - id: "q2"
    text: "In the agentic loop, what is the purpose of the 'observe' step?"
    type: "single-answer"
    marks: 2
    explanation: "The observe step appends the tool's output to the agent's context, giving it the information it needs to plan the next action. Without this step, the agent would not learn from what it just did."
    options:
      - id: "a"
        text: "To pause the loop and wait for human approval."
        isCorrect: false
      - id: "b"
        text: "To record the action in an audit log."
        isCorrect: false
      - id: "c"
        text: "To append the tool result to the agent's context so it can plan the next step."
        isCorrect: true
      - id: "d"
        text: "To determine whether the step limit has been reached."
        isCorrect: false

  - id: "q3"
    text: "Which of the following are valid reasons to terminate an agentic loop before the task is complete?"
    type: "multiple-answers"
    marks: 2
    explanation: "A step limit prevents runaway agents, and a blocked state (where the agent cannot proceed without information it lacks) is a valid reason to stop and escalate. Producing an intermediate result is not a termination condition - that is normal operation."
    options:
      - id: "a"
        text: "The maximum number of allowed steps has been reached."
        isCorrect: true
      - id: "b"
        text: "The agent has produced an intermediate result but has not finished."
        isCorrect: false
      - id: "c"
        text: "The agent cannot proceed without information or permission it does not have."
        isCorrect: true
      - id: "d"
        text: "The agent has called at least one tool."
        isCorrect: false

  - id: "q4"
    text: "What is the primary reason to use `kubectl apply --dry-run=server` before an agent applies a manifest to a cluster?"
    type: "single-answer"
    marks: 2
    explanation: "Server-side dry run validates the manifest against the API server - checking schema, admission webhooks, and resource constraints - without persisting any change. This catches errors before they affect running workloads."
    options:
      - id: "a"
        text: "To speed up the apply operation on the next run."
        isCorrect: false
      - id: "b"
        text: "To validate the manifest against the API server without persisting any change."
        isCorrect: true
      - id: "c"
        text: "To create a backup of the current cluster state."
        isCorrect: false
      - id: "d"
        text: "To notify the human operator that a change is about to be applied."
        isCorrect: false

  - id: "q5"
    text: "Which of the following best describes 'blast-radius thinking' in the context of agent permissions?"
    type: "single-answer"
    marks: 2
    explanation: "Blast-radius thinking means asking what the worst outcome of a given tool access would be in a single action, then scoping permissions so that even a buggy or confused agent cannot cause damage beyond what the task requires."
    options:
      - id: "a"
        text: "Estimating how fast the agent can complete its task."
        isCorrect: false
      - id: "b"
        text: "Calculating the number of tool calls in the agentic loop."
        isCorrect: false
      - id: "c"
        text: "Assessing the worst-case impact of a tool access and constraining permissions accordingly."
        isCorrect: true
      - id: "d"
        text: "Measuring the agent's confidence score before it takes an action."
        isCorrect: false

  - id: "q6"
    text: "Which Meshery command would you run to check that Meshery's adapters and cluster connectivity are healthy before delegating infrastructure tasks to an agent?"
    type: "short-answer"
    marks: 2
    correctAnswer: "mesheryctl system check"
    case_sensitive: false
    explanation: "The `mesheryctl system check` command validates Meshery's operational status, including adapter connectivity and cluster reachability, making it the appropriate pre-flight step before running agent-driven infrastructure tasks."
---
