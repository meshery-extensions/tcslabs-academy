---
type: "course"
id: "generating-meshery-designs-with-llms"
title: "2. Generating Meshery Designs with LLMs"
description: "Learn to generate valid, importable Meshery designs with an LLM: understand the YAML structure, craft precise prompts, align output with the Meshery registry, and iteratively refine designs in Kanvas."
weight: 2
tags: ["ai","designs"]
categories: "AI"
level: "intermediate"
---

Meshery designs are valid Kubernetes YAML - multi-document files that Meshery imports, visualises, and deploys. Getting an LLM to produce designs that pass import and validation requires more than asking it to "write some YAML". You need to understand the structure a design must have, give the model the right constraints and context, verify that generated resources align with Meshery's component registry, and refine iteratively rather than starting from scratch on every failure.

This course walks through all four stages of that workflow. You will start by dissecting the anatomy of a real importable design, move through prompting and constraint techniques, learn why registry alignment matters and how validation surfaces mismatches, and finish with a disciplined iteration loop that converges on a correct, deployable design. The designs used throughout - including `designs/microservices-demo.yaml` - are importable directly with `mesheryctl design import -f <file> -s "Kubernetes Manifest"`.
