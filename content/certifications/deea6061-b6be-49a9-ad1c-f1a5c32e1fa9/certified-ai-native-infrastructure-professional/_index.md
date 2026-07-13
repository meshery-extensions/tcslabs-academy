---
type: "certification"
title: "Certified AI-Native Infrastructure Professional (CAINP)"
description: "Prove you can run cloud native infrastructure with coding agents in production - agentic day-2 operations, Model Context Protocol integrations with Meshery, safe automation, and governance. The professional-level credential of the TCS Labs Academy."
id: "303d4cc4-6523-41e7-8c4d-784af813f0bc"
banner: "banner.svg"
weight: 2
level: "advanced"
categories: "AI"
tags: ["AI", "Certification", "Meshery", "MCP", "Professional"]

# Exam blueprint - domains and their weighting (sums to 100).
competencies:
  - title: "Agentic day-2 operations"
    percentage: 28
    items:
      - "AI-assisted observability and diagnostics with Meshery signals"
      - "Incident response with coding agents and safe runbooks"
      - "Performance management: Profiles, load generators, and tuning"
      - "Closed-loop remediation and self-healing with approval gates"
  - title: "MCP & agentic integrations for Meshery"
    percentage: 22
    items:
      - "Model Context Protocol: tools, resources, and prompts"
      - "Building MCP tools that wrap the Meshery API"
      - "Exposing live cluster state as MCP resources"
      - "End-to-end agent-to-Meshery workflows"
  - title: "Safe automation"
    percentage: 16
    items:
      - "Permissions and least privilege for automation"
      - "Approvals, audit trails, and human oversight"
      - "Sandboxing agent actions"
      - "Rate limits and controlling blast radius"
  - title: "Policy as code & governance"
    percentage: 18
    items:
      - "Relationships as policy in Meshery"
      - "OPA and constraints"
      - "Validating designs against policy across environments"
      - "Drift detection and continuous compliance"
  - title: "Security & responsible AI for infrastructure"
    percentage: 16
    items:
      - "Secrets and supply chain for AI-generated infrastructure"
      - "Hallucination guardrails and explainability"
      - "FinOps and cost control for AI"
      - "Compliance and evidence in an IDP context"

# Recommended preparation before attempting the exam and capstone.
prerequisite_knowledge:
  - title: "Required certification"
    children:
      - title: "Certified AI-Native Infrastructure Associate (CAINA)"
        link: "https://platform.tata-consulting.co.uk/academy/certifications/25d5053d-9be3-4af2-98dc-fcc3cf1cc4e1/certified-ai-native-infrastructure-associate/"
  - title: "Learning Paths"
    children:
      - title: "Coding Agents for Cloud Native Operations (Day-2)"
        link: "https://platform.tata-consulting.co.uk/academy/learning-paths/25d5053d-9be3-4af2-98dc-fcc3cf1cc4e1/coding-agents-for-cloud-native-operations/"
      - title: "Model Context Protocol & Agentic Integrations for Meshery"
        link: "https://platform.tata-consulting.co.uk/academy/learning-paths/25d5053d-9be3-4af2-98dc-fcc3cf1cc4e1/model-context-protocol-and-agentic-integrations-for-meshery/"
      - title: "Governance, Security & Responsible AI for Infrastructure"
        link: "https://platform.tata-consulting.co.uk/academy/learning-paths/25d5053d-9be3-4af2-98dc-fcc3cf1cc4e1/governance-security-and-responsible-ai-for-infrastructure/"

# Hands-on challenges and documentation for further study.
related_resources:
  - title: "Hands-on Challenges"
    children:
      - title: "Heal the Mesh"
        link: "https://platform.tata-consulting.co.uk/academy/challenges/25d5053d-9be3-4af2-98dc-fcc3cf1cc4e1/heal-the-mesh/"
      - title: "Build a Meshery MCP Tool"
        link: "https://platform.tata-consulting.co.uk/academy/challenges/25d5053d-9be3-4af2-98dc-fcc3cf1cc4e1/build-a-meshery-mcp-tool/"
      - title: "CAINP Capstone"
        link: "https://platform.tata-consulting.co.uk/academy/challenges/25d5053d-9be3-4af2-98dc-fcc3cf1cc4e1/cainp-capstone/"
  - title: "Documentation"
    children:
      - title: "Meshery"
        link: "https://docs.meshery.io/"
      - title: "Meshery Performance Management"
        link: "https://docs.meshery.io/concepts/logical/performance-profiles"
      - title: "Model Context Protocol"
        link: "https://modelcontextprotocol.io/"

# Exam logistics and policies.
additional_attributes:
  - title: "Exam Format"
    value: "65 questions"
    description: "Multiple-choice and scenario questions; 90 minutes; proctored online"
  - title: "Pass Mark"
    value: "70%"
    description: "On the written exam, plus a passing capstone"
  - title: "Capstone"
    value: "Mandatory"
    description: "Operate an AI workload with agents and Meshery end to end, graded by rubric"
  - title: "Prerequisite"
    value: "CAINA"
    description: "Hold a current Certified AI-Native Infrastructure Associate credential"
  - title: "Validity"
    value: "2 years"
    description: "Recertify via a delta exam or a recertification capstone"
---

The **Certified AI-Native Infrastructure Professional (CAINP)** is the TCS Labs Academy's advanced
credential. It validates that you can operate cloud native infrastructure with coding agents in
production - observing, diagnosing, responding, performance-testing, and self-healing with
[Meshery](https://meshery.io/) - and that you can integrate agents safely with Meshery through the
Model Context Protocol while governing the whole pipeline.

## How you earn it

The credential has two required parts:

1. A **written exam** - 65 multiple-choice and scenario questions across the five domains above
   (90 minutes, proctored). Pass mark **70%**.
2. A **mandatory capstone** - operate an AI workload end to end with coding agents and Meshery,
   graded against a published rubric. Delivered as the
   [CAINP Capstone challenge](https://platform.tata-consulting.co.uk/academy/challenges/25d5053d-9be3-4af2-98dc-fcc3cf1cc4e1/cainp-capstone/).

## How to prepare

Earn the
[CAINA](https://platform.tata-consulting.co.uk/academy/certifications/25d5053d-9be3-4af2-98dc-fcc3cf1cc4e1/certified-ai-native-infrastructure-associate/)
credential first, then work through Learning Paths 4-6 and the
[Heal the Mesh](https://platform.tata-consulting.co.uk/academy/challenges/25d5053d-9be3-4af2-98dc-fcc3cf1cc4e1/heal-the-mesh/)
and
[Build a Meshery MCP Tool](https://platform.tata-consulting.co.uk/academy/challenges/25d5053d-9be3-4af2-98dc-fcc3cf1cc4e1/build-a-meshery-mcp-tool/)
challenges.

## What it proves

A CAINP holder can stand up an agent-assisted operations loop: surface the right signals from
Meshery, drive triage and remediation through safe runbooks with approval gates, build an MCP tool
that exposes Meshery and cluster state to an agent, and keep it all within policy, budget, and audit
requirements suitable for an enterprise Internal Developer Platform.
