---
type: "course"
id: "agent-driven-deployment"
title: "3. Agent-Driven Deployment"
description: "Learn how to close the loop between AI-generated infrastructure designs and live clusters by having a coding agent drive the deploy pipeline through mesheryctl and GitOps tooling."
weight: 3
tags: ["ai","agents","gitops"]
categories: "AI"
level: "intermediate"
---

Platform engineers rarely deploy by hand anymore - the same coding agents that generate and refine a Meshery design can also commit that design to Git, run a dry-run diff, and push it to a cluster once a human approves the output. This course walks through every stage of that loop with concrete commands and realistic scenarios.

You will learn how to wire an agent into a GitOps pipeline so that `mesheryctl` is the enforced execution path, how to read a dry-run diff and reason about blast radius before applying anything, and how to recover cleanly when a deployment goes wrong. The four lessons move in order from architecture to practice: the big-picture loop, safe preview workflows, a hands-on deployment walkthrough, and finally rollback and recovery.

By the end of this course you can instruct an agent to deploy `designs/microservices-demo.yaml`, verify the rollout, and revert it - all with a reproducible, auditable trail in Git.
