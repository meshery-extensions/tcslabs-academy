---
type: "certification"
title: "Certified AI-Native Infrastructure Associate (CAINA)"
description: "Prove you can use LLMs and coding agents to design, generate, deploy, and validate cloud native infrastructure with Meshery and Kanvas. The associate-level credential of the TCS Labs Academy."
id: "0f3ed1dc-536b-4fc9-a409-de67dadefcb0"
banner: "banner.svg"
weight: 1
level: "intermediate"
categories: "AI"
tags: ["AI", "Certification", "Meshery", "Kanvas", "Associate"]

# Exam blueprint - domains and their weighting (sums to 100).
competencies:
  - title: "Cloud native & Meshery fundamentals"
    percentage: 20
    items:
      - "Containers, Kubernetes, and the declarative model"
      - "Meshery architecture: Server, Operator, MeshSync, Adapters"
      - "Connecting a cluster with mesheryctl"
      - "Models, components, and relationships"
      - "Designs, the Catalog, environments, and workspaces"
  - title: "AI/LLM foundations for infrastructure"
    percentage: 18
    items:
      - "How LLMs work: tokens, context windows, and limits"
      - "Strengths and failure modes for infrastructure tasks"
      - "Choosing a model for a given operations task"
      - "Grounding agents in cluster and Meshery state (RAG)"
  - title: "Prompt engineering & coding agents"
    percentage: 18
    items:
      - "System vs. user instructions and structured output"
      - "Prompt patterns for cloud native operations"
      - "The agentic loop and tool use"
      - "Human-in-the-loop and guardrails"
  - title: "AI-assisted design with Kanvas"
    percentage: 22
    items:
      - "From natural-language intent to a topology"
      - "Co-designing in Kanvas"
      - "Reviewing an AI-proposed design"
      - "Anatomy of a Meshery design"
  - title: "Generating & validating Meshery designs"
    percentage: 22
    items:
      - "Prompting an LLM to produce correct design YAML"
      - "Getting models and relationships right"
      - "Agent-driven deployment with mesheryctl and GitOps"
      - "Relationship and policy validation; guardrails"

# Recommended preparation before attempting the exam and lab.
prerequisite_knowledge:
  - title: "Learning Paths"
    children:
      - title: "Foundations of Cloud Native Management with Meshery"
        link: "https://cloud.meshery.io/academy/learning-paths/deea6061-b6be-49a9-ad1c-f1a5c32e1fa9/foundations-of-cloud-native-management-with-meshery/"
      - title: "AI Engineering Foundations for Platform Engineers"
        link: "https://cloud.meshery.io/academy/learning-paths/deea6061-b6be-49a9-ad1c-f1a5c32e1fa9/ai-engineering-foundations-for-platform-engineers/"
      - title: "AI-Assisted Infrastructure Design with Meshery & Kanvas"
        link: "https://cloud.meshery.io/academy/learning-paths/deea6061-b6be-49a9-ad1c-f1a5c32e1fa9/ai-assisted-infrastructure-design-with-meshery-and-kanvas/"
  - title: "Recommended skills"
    children:
      - title: "Comfort with the Linux command line"
        link: "https://linuxcommand.org/"
      - title: "Basic Kubernetes"
        link: "https://kubernetes.io/docs/tutorials/kubernetes-basics/"

# Hands-on challenges and documentation for further study.
related_resources:
  - title: "Hands-on Challenges"
    children:
      - title: "Ship It with an Agent"
        link: "https://cloud.meshery.io/academy/challenges/deea6061-b6be-49a9-ad1c-f1a5c32e1fa9/ship-it-with-an-agent/"
      - title: "CAINA Capstone"
        link: "https://cloud.meshery.io/academy/challenges/deea6061-b6be-49a9-ad1c-f1a5c32e1fa9/caina-capstone/"
  - title: "Documentation"
    children:
      - title: "Meshery"
        link: "https://docs.meshery.io/"
      - title: "Kanvas Designer"
        link: "https://docs.layer5.io/kanvas/designer/"
      - title: "Meshery Designs"
        link: "https://docs.meshery.io/concepts/logical/designs"

# Exam logistics and policies.
additional_attributes:
  - title: "Exam Format"
    value: "50 questions"
    description: "Multiple-choice and scenario questions; 75 minutes; proctored online"
  - title: "Pass Mark"
    value: "70%"
    description: "On the written exam, plus a passing hands-on lab"
  - title: "Hands-on Lab"
    value: "Mandatory"
    description: "Generate, deploy, and validate a design with an agent and Meshery"
  - title: "Retake Policy"
    value: "14 days"
    description: "Retake after 14 days; a second retake after 30 days"
  - title: "Validity"
    value: "2 years"
    description: "Recertify via a delta exam or the Professional (CAINP) credential"
---

The **Certified AI-Native Infrastructure Associate (CAINA)** is the entry-level credential of the
TCS Labs Academy. It validates that you can put LLMs and coding agents to work on real cloud native
infrastructure - turning intent into a [Meshery](https://meshery.io/) design, deploying it, and
validating it - rather than just talking about AI in the abstract.

## How you earn it

The credential has two required parts:

1. A **written exam** - 50 multiple-choice and scenario questions across the five domains above
   (75 minutes, proctored). Pass mark **70%**.
2. A **hands-on lab** - generate a design with an LLM, deploy it with a coding agent and Meshery,
   and validate it. Delivered as the
   [CAINA Capstone challenge](https://cloud.meshery.io/academy/challenges/deea6061-b6be-49a9-ad1c-f1a5c32e1fa9/caina-capstone/).

## How to prepare

Work through Learning Paths 1-3, then attempt the
[Ship It with an Agent](https://cloud.meshery.io/academy/challenges/deea6061-b6be-49a9-ad1c-f1a5c32e1fa9/ship-it-with-an-agent/)
challenge as a warm-up. The competency blueprint above shows where to focus your study time.

## What it proves

A CAINA holder can explain how Meshery manages cloud native infrastructure, prompt an LLM to produce
correct design YAML, use a coding agent to deploy a design through `mesheryctl`, and validate the
result with Meshery's relationship and policy checks - safely, with a human in the loop.

Ready for more? The
[Certified AI-Native Infrastructure Professional (CAINP)](https://cloud.meshery.io/academy/certifications/deea6061-b6be-49a9-ad1c-f1a5c32e1fa9/certified-ai-native-infrastructure-professional/)
builds on CAINA to cover agentic day-2 operations, MCP integrations, and governance.
