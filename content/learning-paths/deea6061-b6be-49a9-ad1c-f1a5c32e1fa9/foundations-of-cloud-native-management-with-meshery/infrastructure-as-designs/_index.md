---
type: "course"
id: "infrastructure-as-designs"
title: "3. Infrastructure as Designs"
description: "Learn how Meshery designs capture infrastructure intent as version-controlled, shareable artifacts - and how to import, inspect, deploy, and collaborate on them using Kanvas, the Catalog, GitHub, and Meshery's environment model."
weight: 3
tags: ["meshery", "designs"]
categories: "Meshery"
level: "beginner"
---

A Meshery design is the unit of infrastructure intent. It is a YAML document that describes components - Kubernetes resources, service mesh configuration, policies - along with the relationships between them. Designs are declarative, portable, and version-controllable, which makes them the natural pairing for agent-generated infrastructure changes.

This course walks you through the full design lifecycle: authoring and importing a design, opening it in Kanvas for visual inspection, deploying it to a cluster, saving it to the Catalog so your team can reuse it, and backing it with a GitHub repository so that pull requests carry infrastructure previews alongside code changes.

The final module introduces environments and workspaces - the organizational model Meshery uses to scope designs across teams and promotion stages - giving you the mental model you need to safely promote a design from development through to production.
