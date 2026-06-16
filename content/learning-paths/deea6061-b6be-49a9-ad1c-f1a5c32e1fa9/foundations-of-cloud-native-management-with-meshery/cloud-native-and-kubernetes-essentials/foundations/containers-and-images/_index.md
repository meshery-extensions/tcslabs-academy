---
type: "page"
id: "containers-and-images"
title: "Containers and Images"
description: "Understand containers versus virtual machines, how images are built from layers, and why immutability makes containers the right unit of deployment for automated infrastructure."
weight: 2
---

## Containers Are Not Virtual Machines

The most common misconception about containers is that they are "lightweight VMs." They share a goal - process isolation - but the mechanism is fundamentally different.

A virtual machine emulates hardware. Each VM carries a full operating system kernel, its own memory allocation, and its own network stack. Spinning one up takes seconds to minutes. Running 50 VMs on a single host is a resource-intensive proposition.

A container uses Linux kernel primitives - **namespaces** and **cgroups** - to isolate a process (or a small set of processes) from the rest of the system:

- **Namespaces** limit what the process can see: its own filesystem view, its own network interfaces, its own process table.
- **cgroups** limit what the process can consume: CPU shares, memory ceilings, I/O bandwidth.

The host kernel is shared. There is no hardware emulation. A container starts in milliseconds and consumes only the memory its process actually uses. A single node can run hundreds of containers.

| Property | Container | Virtual Machine |
|----------|-----------|-----------------|
| Startup time | Milliseconds | Seconds to minutes |
| Kernel | Shared with host | Dedicated, emulated |
| Isolation unit | Process(es) | Full OS |
| Typical density | Hundreds per node | Tens per host |
| Portability | Image is self-contained | Depends on hypervisor |

## Images and Layers

A **container image** is the blueprint for a container. It is a read-only, layered filesystem snapshot that contains everything the application needs to run: the OS userspace libraries, the language runtime, the application binaries, and the configuration.

Images are built in layers. Each instruction in a `Dockerfile` (or equivalent build file) adds a layer on top of the previous one:

```text
Base OS layer        (e.g. debian:bookworm-slim)
  + Runtime layer    (e.g. apt-get install python3)
  + App layer        (e.g. COPY app/ /app)
  + Config layer     (e.g. ENV PORT=8080)
```

Layers are content-addressed and cached. If you rebuild an image and only the application code changed, the base and runtime layers are reused from cache. This makes builds fast and image storage efficient - multiple images that share a base layer store that layer only once in the registry.

## Registries

Images live in a **registry**: a content-addressable store that tags images with a name and version. When Kubernetes schedules a workload, each node pulls the image from the registry if it is not already cached locally.

A fully-qualified image reference looks like this:

```text
registry.example.com/namespace/image-name:tag@sha256:digest
```

The `tag` (e.g. `v1.4.2`) is a human-readable alias. The `sha256` digest is the cryptographic content address of the image. In production environments, pinning to a digest rather than a mutable tag is the correct practice - it guarantees you are running exactly the artifact you tested, not whatever `latest` happens to point to today.

## Immutability as an Operational Property

An image, once built and pushed, is immutable. You cannot modify it in place. When a change is needed, you build a new image, push it to the registry under a new tag or digest, and update the workload definition to reference the new image.

This immutability is not a constraint - it is a design property with significant operational consequences:

- **Reproducibility** - the same image produces the same behavior on every node, in every environment, at any point in time.
- **Auditability** - you can trace exactly what ran in production by examining image digests.
- **Rollback** - reverting to a previous version means pointing to a previous image reference, not reconstructing a previous state by hand.
- **Agent safety** - when a coding agent proposes an infrastructure change, it operates on image references and YAML manifests, not on running process state. The blast radius of a mistake is bounded and reversible.

## The Container as the Unit of Deployment

Kubernetes does not deploy applications - it deploys containers, grouped into **pods**. A pod is the smallest schedulable unit, and it contains one or more containers that share a network namespace and, optionally, storage volumes.

The consequence for platform engineers: everything you want to run on Kubernetes must be packaged as a container image. That constraint is also an abstraction that lets Kubernetes (and Meshery, and coding agents operating through Meshery) reason about workloads uniformly, regardless of the language or framework they use.

The image reference in a Deployment manifest is the contract between the platform team (which manages the cluster) and the application team (which builds the image). Meshery's registry models that contract and the relationships that flow from it.
