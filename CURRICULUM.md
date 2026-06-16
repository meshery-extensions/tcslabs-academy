# TCS Labs Academy — Curriculum Master Outline

> A comprehensive, **AI-first** learning library for the **TCS Labs Academy**, built on the
> [Layer5 Academy](https://docs.layer5.io/cloud/academy/) platform. The curriculum teaches
> engineers to **use LLMs and coding agents to design, deploy, operate, and govern cloud native
> infrastructure**, with **[Meshery](https://meshery.io/)** — the open source cloud native manager —
> as the management plane. TCS Labs is a Meshery adopter; this academy is its
> [Internal Developer Platform](https://www.tata-consulting.co.uk/idp.html) learning track.

This document is the **skeletal outline** of the entire academy. It defines the learning paths,
their courses, chapters (modules), and lessons; the hands-on challenges; the importable Meshery
designs; and the **tiered AI certification** (Associate + Professional). The generated Hugo content
under `content/` implements this outline.

- **Organization UID:** `deea6061-b6be-49a9-ad1c-f1a5c32e1fa9`
- **Content model:** `Learning Path → Course → Chapter (module) → Lesson (page)`
- **Assessment model:** module `quiz.md` · course `test.md` · learning-path `exam.md` · `Challenge → { lab, exam }`

---

## Curriculum at a glance

| # | Learning Path | Level | Courses | Focus |
|---|---------------|-------|---------|-------|
| 1 | Foundations of Cloud Native Management with Meshery | Beginner | 3 | Cloud native, Kubernetes, Meshery, designs |
| 2 | AI Engineering Foundations for Platform Engineers | Beginner–Intermediate | 4 | LLMs, prompting, coding agents, RAG for ops |
| 3 | **AI-Assisted Infrastructure Design with Meshery & Kanvas** *(flagship)* | Intermediate | 4 | Generating, deploying & validating designs with AI |
| 4 | Coding Agents for Cloud Native Operations (Day-2) | Advanced | 4 | AI observability, incident response, performance, self-healing |
| 5 | Model Context Protocol & Agentic Integrations for Meshery | Advanced | 4 | MCP, building Meshery tools, safe automation |
| 6 | Governance, Security & Responsible AI for Infrastructure | Advanced | 4 | Policy as code, security, responsible AI, compliance |

**Certifications (tiered):**

| Credential | Level | Built on | Format |
|-----------|-------|----------|--------|
| **CAINA** — Certified AI-Native Infrastructure **Associate** | Associate | LP 1–3 | Written exam + hands-on lab |
| **CAINP** — Certified AI-Native Infrastructure **Professional** | Professional | CAINA + LP 4–6 | Written exam + mandatory capstone |

**Hands-on challenges:** 5 standalone challenges (each a guided **lab** + a graded **exam**), including
the two certification capstones.

**Importable Meshery designs:** real, valid Kubernetes YAML in [`designs/`](./designs/) used throughout
the design, deployment, operations, and governance lessons.

---

## Learning Path 1 — Foundations of Cloud Native Management with Meshery

**Level:** Beginner · **Audience:** Engineers new to cloud native and/or Meshery ·
**Outcome:** Understand cloud native fundamentals, install Meshery, connect a cluster, and capture
infrastructure as reusable **Designs**.

1. **Cloud Native & Kubernetes Essentials** *(module: Foundations)*
   - What is cloud native? Containers, orchestration, and the CNCF landscape
   - Containers and images: the unit of deployment
   - Kubernetes essentials: pods, deployments, services, namespaces
   - Declarative infrastructure and the GitOps mindset
2. **Meshery Essentials** *(module: Orientation)*
   - What Meshery is: the cloud native manager ("manager of managers")
   - Meshery architecture: Server, Operator, MeshSync, Adapters, Broker
   - Installing Meshery and connecting a cluster with `mesheryctl`
   - Models, components, and relationships
   - Kanvas: the visual designer
3. **Infrastructure as Designs** *(module: Designs)*
   - Authoring your first Design
   - The Meshery Catalog
   - Designs as code: GitHub-backed designs and versioning
   - Environments and Workspaces

---

## Learning Path 2 — AI Engineering Foundations for Platform Engineers

**Level:** Beginner–Intermediate · **Outcome:** Understand how LLMs and coding agents work, prompt
them well for operations, and ground them in your infrastructure's real state.

1. **How LLMs Work for Infrastructure Engineers** *(module: LLM Basics)*
   - What is an LLM? A mental model for engineers
   - Tokens, context windows, and limits
   - Strengths and failure modes (and why they matter for infra)
   - Choosing a model for infrastructure tasks
2. **Prompt Engineering for Cloud Native Operations** *(module: Prompting)*
   - System vs. user instructions
   - Grounding prompts in infrastructure state
   - Structured output: getting reliable YAML and JSON
   - Prompt patterns for operations
   - Evaluating your prompts before you scale
3. **Coding Agents 101** *(module: Agents)*
   - What is a coding agent?
   - The agentic loop and tool use
   - Claude Code for infrastructure work
   - Human-in-the-loop and guardrails
4. **Retrieval & Context (RAG) for Infrastructure** *(module: RAG)*
   - Why agents need context
   - Grounding agents in cluster and Meshery state
   - Building a knowledge base for operations
   - Evaluating infrastructure agents

---

## Learning Path 3 — AI-Assisted Infrastructure Design with Meshery & Kanvas *(flagship)*

**Level:** Intermediate · **Theme:** Use AI to go from intent to a deployed, validated design ·
**Outcome:** Generate, deploy, and validate Meshery designs with LLMs and coding agents.

1. **Designing Infrastructure with AI + Kanvas** *(module: From Intent to Design)*
   - From intent to topology
   - Co-designing in Kanvas
   - Describing infrastructure in natural language
   - Reviewing an AI-proposed design
2. **Generating Meshery Designs with LLMs** *(module: Generating Designs)*
   - Anatomy of a Meshery design
   - Prompting an LLM to produce design YAML
   - Getting models and relationships right
   - Iterating and refining generated designs
3. **Agent-Driven Deployment** *(module: Deploying with Agents)*
   - The deploy loop: agent + `mesheryctl` + GitOps
   - Dry-runs and diffs before you apply
   - Deploying a design with a coding agent
   - Rollback and recovery
4. **Validating AI-Generated Infrastructure** *(module: Validation & Guardrails)*
   - Relationship and policy validation in Meshery
   - Catching misconfigurations early
   - Designing guardrails for generated infrastructure
   - A review checklist for AI-generated infra

---

## Learning Path 4 — Coding Agents for Cloud Native Operations (Day-2)

**Level:** Advanced · **Outcome:** Use coding agents and LLMs to observe, diagnose, respond,
performance-test, and self-heal running infrastructure with Meshery.

1. **AI-Assisted Observability & Diagnostics** *(module: Observe)*
   - Signals Meshery surfaces (MeshSync, metrics, events)
   - LLM-assisted log and event analysis
   - Building a diagnostic prompt
   - From symptom to hypothesis
2. **Incident Response with Coding Agents** *(module: Respond)*
   - The incident triage loop
   - Safe runbooks for agents
   - An agent-assisted incident walkthrough
   - Postmortems with LLMs
3. **Performance Management with AI** *(module: Perf)*
   - Performance Profiles in Meshery
   - Load generators: fortio, wrk2, and nighthawk
   - LLM-assisted performance tuning
   - Regression detection over time
4. **Automated Remediation & Self-Healing** *(module: Remediate)*
   - Closed-loop remediation patterns
   - Approval gates and human oversight
   - Building a self-healing workflow
   - Measuring remediation safety

---

## Learning Path 5 — Model Context Protocol & Agentic Integrations for Meshery

**Level:** Advanced · **Outcome:** Connect coding agents to Meshery safely using the Model Context
Protocol (MCP) and Meshery's APIs.

1. **MCP Fundamentals** *(module: MCP Basics)*
   - What is the Model Context Protocol?
   - Tools, resources, and prompts
   - MCP clients and servers
   - When to use MCP for infrastructure
2. **Building MCP Tools for Meshery** *(module: Build MCP)*
   - Designing tools for Meshery
   - Wrapping the Meshery API
   - Exposing cluster state as MCP resources
   - Testing and debugging an MCP server
3. **Integrating Coding Agents with Meshery** *(module: Integrate)*
   - Connecting an agent to Meshery
   - The Meshery GraphQL and REST APIs
   - Combining MCP with `mesheryctl`
   - An end-to-end agent-to-Meshery workflow
4. **Safe Automation** *(module: Safe Automation)*
   - Permissions and least privilege
   - Approvals and audit trails
   - Sandboxing agent actions
   - Rate limits and blast radius

---

## Learning Path 6 — Governance, Security & Responsible AI for Infrastructure

**Level:** Advanced · **Outcome:** Govern AI-driven infrastructure with policy as code, secure the
pipeline, and apply responsible-AI practices in an enterprise/IDP context.

1. **Policy as Code with Meshery** *(module: Policy)*
   - Relationships as policy
   - OPA and constraints
   - Validating designs against policy
   - Policy across environments
2. **Securing AI-Driven Pipelines** *(module: Secure)*
   - Secrets and credentials for agents
   - Supply chain for AI-generated infrastructure
   - Sandboxing and isolation
   - Least privilege for automation
3. **Responsible AI for Operations** *(module: Responsible AI)*
   - Hallucination guardrails for infrastructure
   - Audit trails and explainability
   - FinOps and cost control for AI
   - Human oversight and accountability
4. **Compliance & Evidence** *(module: Compliance)*
   - Compliance in an IDP context
   - Generating attestations and evidence
   - Drift and continuous compliance
   - Putting it all together

---

## Certifications

The Academy offers a **two-tier** credential. Each certification is a first-class
`type: "certification"` entity under
`content/certifications/deea6061-b6be-49a9-ad1c-f1a5c32e1fa9/`, carrying its competency blueprint
(domains + weighting), `prerequisite_knowledge`, `related_resources`, and `additional_attributes`
(format, pass mark, retake policy, validity). Each is **supported by** the core learning paths and a
**capstone challenge**.

### CAINA — Certified AI-Native Infrastructure Associate

**Level:** Associate · **Recommended prep:** Learning Paths 1–3 · **Format:** 50 multiple-choice and
scenario questions, 75 minutes, **70%** to pass, plus a passing hands-on lab.

| Domain | Weight |
|--------|--------|
| 1. Cloud native & Meshery fundamentals | 20% |
| 2. AI/LLM foundations for infrastructure | 18% |
| 3. Prompt engineering & coding agents | 18% |
| 4. AI-assisted design with Kanvas | 22% |
| 5. Generating & validating Meshery designs | 22% |

### CAINP — Certified AI-Native Infrastructure Professional

**Level:** Professional · **Prerequisite:** CAINA · **Recommended prep:** Learning Paths 4–6 ·
**Format:** 65 multiple-choice and scenario questions, 90 minutes, **70%** to pass, plus a
**mandatory capstone**.

| Domain | Weight |
|--------|--------|
| 1. Agentic day-2 operations (observability, incident, performance, remediation) | 28% |
| 2. MCP & agentic integrations for Meshery | 22% |
| 3. Safe automation (permissions, audit, blast radius) | 16% |
| 4. Policy as code & governance | 18% |
| 5. Security & responsible AI for infrastructure | 16% |

---

## Hands-on Challenges

Each challenge ships a guided **lab** (`lab.md`) and a graded **exam** (`exam.md`, `passPercentage: 70`).

1. **Ship It with an Agent** — use a coding agent + Meshery to deploy a microservices application from a Design.
2. **Heal the Mesh** — LLM-assisted diagnosis and remediation of a broken deployment.
3. **Build a Meshery MCP Tool** — build an MCP tool that queries live Meshery/cluster state.
4. **CAINA Capstone** — the Associate certification's hands-on lab + exam.
5. **CAINP Capstone** — the Professional certification's end-to-end capstone + exam.

---

## Importable Meshery designs

The design, deployment, operations, and governance content is backed by real, importable designs in
the [`designs/`](./designs/) directory. Each file is valid Kubernetes YAML, so it can be **imported
into Meshery** (`mesheryctl design import -f <file> -s "Kubernetes Manifest"`), opened and validated
in **Kanvas**, deployed, and saved to the Meshery **Catalog** as a reusable template — or applied
directly with `kubectl`.

| Design | File | What it installs |
|--------|------|------------------|
| Microservices demo app | [`designs/microservices-demo.yaml`](designs/microservices-demo.yaml) | A small multi-service web app (frontend + API + Redis) used for deploy and operations exercises |
| Observability stack | [`designs/observability-stack.yaml`](designs/observability-stack.yaml) | Prometheus + Grafana for the day-2 observability lessons |
| LLM / MCP gateway | [`designs/llm-mcp-gateway.yaml`](designs/llm-mcp-gateway.yaml) | An OpenAI-compatible inference service + an MCP gateway, used by the AI-infra and MCP lessons |
| Policy & guardrails | [`designs/policy-guardrails.yaml`](designs/policy-guardrails.yaml) | NetworkPolicy + ResourceQuota + LimitRange + PodDisruptionBudget illustrating governance |

See [`designs/README.md`](designs/README.md) for prerequisites and step-by-step import instructions.

---

## Delivery plan (phased pull requests)

| PR | Contents |
|----|----------|
| 1 | Foundation: Hugo scaffolding + CI, this `CURRICULUM.md`, section indexes, README, the `designs/` library, and both certifications (CAINA + CAINP) with their capstone challenges |
| 2 | LP 1 + LP 2 — all courses, modules, lessons, quizzes, tests, and exams |
| 3 | LP 3 (flagship) — all content + assessments |
| 4 | LP 4 — all content + assessments |
| 5 | LP 5 + LP 6 — all content + assessments, plus the three skill challenges |

---

## Content conventions (for contributors)

Front matter by level (matches the Layer5 Academy theme). IDs are stable UUIDs that must be
**registered via the Cloud content wizard** before production publishing.

```yaml
# Learning Path  (_index.md)
type: "learning-path"
title: "…"
description: "…"
id: "<uuid>"
banner: "meshery-logo-dark-text-side.svg"
weight: <n>
level: "beginner|intermediate|advanced"
```

```yaml
# Course (_index.md)
type: "course"
id: "<slug>"
title: "…"
description: "…"
weight: <n>
tags: ["…"]
categories: "…"
level: "…"
```

```yaml
# Chapter / module (_index.md)
type: "module"
id: "<slug>"
title: "…"
weight: <n>
```

```yaml
# Lesson / page (_index.md)
type: "page"
id: "<slug>"
title: "…"
weight: <n>
```

Assessments use `type: "test"` (`quiz.md`, `test.md`, `exam.md`) and `type: "lab"` (`lab.md`) as
documented in the [README](./README.md). Images are referenced with the `usestatic` shortcode for
multi-tenant compatibility, and live under `static/deea6061-b6be-49a9-ad1c-f1a5c32e1fa9/`.

> **Publishing note.** This academy is authored under the TCS Labs organization UID
> `deea6061-b6be-49a9-ad1c-f1a5c32e1fa9`. Before it is aggregated into production by
> [`layer5io/academy-build`](https://github.com/layer5io/academy-build), this UID and each content
> `id` must be registered through the Cloud content wizard, and the module must be added to
> `academy-build`'s `academy_config.json` and `hugo.yaml`.
