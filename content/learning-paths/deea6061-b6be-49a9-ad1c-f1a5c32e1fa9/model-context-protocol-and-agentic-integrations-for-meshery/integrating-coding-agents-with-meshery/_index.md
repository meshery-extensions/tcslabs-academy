---
type: "course"
id: "integrating-coding-agents-with-meshery"
title: "3. Integrating Coding Agents with Meshery"
description: "Learn how to wire a coding agent to Meshery using MCP, the REST and GraphQL APIs, and mesheryctl to build automated, approval-gated infrastructure workflows."
weight: 3
tags: ["ai","integration"]
categories: "AI"
level: "advanced"
---

Modern platform engineering increasingly relies on coding agents to automate routine infrastructure tasks - reading cluster state, proposing design changes, and deploying workloads without manual intervention at every step. Meshery provides multiple programmatic surfaces - an MCP server, a REST API, a GraphQL API, and the `mesheryctl` CLI - that a coding agent can combine to act as a capable infrastructure operator.

This course walks through each surface in detail: how to authenticate and connect an agent, when to reach for GraphQL versus REST, and how to combine MCP tools with `mesheryctl` for tasks that require both structured reads and imperative actions. The course concludes with a complete end-to-end workflow in which an agent reads live cluster state, proposes a design change, deploys it through an approval gate, and verifies the outcome - a pattern directly applicable to production platform automation.
