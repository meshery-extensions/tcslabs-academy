<p align="center">
  <picture>
    <source
      media="(prefers-color-scheme: dark)"
      srcset=".github/assets/images/meshery/meshery-logo-dark-text-side.svg">
    <source
      media="(prefers-color-scheme: light)"
      srcset=".github/assets/images/meshery/meshery-logo-light-text-side.svg">
    <img
      src=".github/assets/images/meshery/meshery-logo-light-text-side.svg"
      width="45%"
      alt="Meshery Logo">
  </picture>
</p>

<p align="center">
<a href="https://layer5.io/learn/academy"><img src="https://img.shields.io/badge/Meshery-Academy-00B39F?style=flat-square&logo=meshery&logoColor=white"   alt="Meshery Academy"></a>
<a href="LICENSE"><img src="https://img.shields.io/github/license/meshery-extensions/tcslabs-academy?style=flat-square" alt="Apache 2.0 License"></a>  <img alt="GitHub go.mod Go version" src="https://img.shields.io/github/go-mod/go-version/meshery-extensions/meshery-academy">
</p>

<img src=".github/assets/images/readme/tcslabs-academy-color.svg"
       width="50"
       alt="Academy"
       align="left"
       style="margin-right:15px;" />

# TCS Labs Academy

TCS Labs Academy is the official learning-content repository for TCS Labs on the [Meshery Academy](https://platform.tata-consulting.co.uk/academy) platform. It hosts structured learning paths, challenges, certifications, and Meshery infrastructure designs - teaching engineers to **use LLMs and coding agents to design, deploy, operate, and govern cloud native infrastructure**, with [Meshery](https://meshery.io/) as the management plane.

> 🗺️ **Start with the [Curriculum Master Outline](./CURRICULUM.md)** - the complete map of learning paths, courses, the tiered AI certification (CAINA + CAINP), challenges, and importable designs.

<!-- 🔗 **Live site:** <https://platform.tata-consulting.co.uk/academy> -->

---

## 📚 Overview

| | |
|---|---|
| **Purpose** | Primary source of TCS Labs-specific Meshery learning content |
| **Platform** | Runs on the shared [Layer5 Academy](https://platform.tata-consulting.co.uk/academy) platform |
| **Authoring** | Markdown-based content with live local preview via Hugo |
| **Content types** | Learning paths · Challenges · Certifications · Infrastructure designs |
| **Curriculum** | 6 learning paths, tiered AI certification (CAINA + CAINP) - see [CURRICULUM.md](./CURRICULUM.md) |
| **Org ID** | `25d5053d-9be3-4af2-98dc-fcc3cf1cc4e1` |

---

## 🛠️ Prerequisites

Before you begin, ensure you have the following installed:

| Tool | Version | Link |
|------|---------|------|
| **Hugo** (extended) | see go.mod| [Install Hugo](https://gohugo.io/getting-started/installing/) |
| **Go** | see go.mod | [Install Go](https://go.dev/doc/install) |
| **Node.js / npm** | see package.json | [Install Node.js](https://nodejs.org/) |
| **Git** | latest | [Install Git](https://git-scm.com/) |

---

## 🚀 Getting Started

### 1. Fork & Clone

```bash
# Fork this repository on GitHub, then clone your fork
git clone https://github.com/<your-username>/tcslabs-academy.git
cd tcslabs-academy
```

### 2. Install Dependencies

```bash
make setup
```

### 3. Run the Site Locally

_Preferred:_ Start the Hugo development server with drafts and future content enabled, using the Makefile target:

```bash
make site
```

_Alternative: _ Or use the hugo CLI directly (at your own risk):

```bash
hugo server -D
```

The site will be available at `http://localhost:1313/academy/` (or the port shown in your terminal).

> **Note:** The local preview uses basic styling. Full Academy branding is applied after content is integrated into the cloud platform.

### 4. Other Useful Commands

| Command | Description |
|---------|-------------|
| `make setup` | Install npm dependencies |
| `make site`  | Build and run site locally with draft and future content enabled
| `make build` | Build the site for production |
| `make build-preview` | Build site for preview draft and future content enabled (honors `BASEURL`) |
| `make clean` | Clear build cache and restart the dev server |
| `make lint-fix` | Fix Markdown linting issues with `markdownlint-cli2` |
| `make check-go` | Verify Go is installed locally |
| `make theme-update` | Update the `academy-theme` Hugo module to the latest version |

---

## 📁 Repository Structure

```text
tcslabs-academy/
├── .github/                  # GitHub workflows, issue templates, PR templates
│   ├── build/                # Makefile includes
│   ├── readme/images/        # README assets
│   ├── workflows/            # CI/CD pipelines
│   └── PULL_REQUEST_TEMPLATE.md
├── assets/json/              # JSON data assets
├── content/                  # 📝 All learning content lives here
│   ├── _index.md             # Site root page
│   ├── learning-paths/       # Learning paths scoped by org ID
│   ├── certifications/       # Certification content
│   └── challenges/           # Challenge content
├── designs/                  # Meshery infrastructure designs (YAML)
├── layouts/                  # Hugo layout overrides & shortcodes
│   ├── _partials/            # Partial templates
│   └── shortcodes/           # Custom Hugo shortcodes
├── public/                   # Generated site output (git-ignored)
├── resources/                # Hugo resource cache
├── go.mod / go.sum           # Go module (pulls academy-theme)
├── hugo.yaml                 # Hugo configuration
├── Makefile                  # Build & dev targets
├── package.json              # Node.js dependencies
└── README.md                 # ← You are here
```

---

## ✍️ Content Authoring

### Content Hierarchy

The Academy content follows this structure: **Learning Path → Course → Chapter → Lesson**.

```text
content/
└── learning-paths/
    ├── _index.md
    └── 25d5053d-9be3-4af2-98dc-fcc3cf1cc4e1/   # TCS Labs org UID
        └── <your-learning-path>/
            ├── _index.md
            └── <your-course>/
                ├── _index.md
                └── content/
                    ├── lesson-1.md
                    └── lesson-2.md
```


### How to Add an Image

1. Place your image files directly in the same directory as your markdown content (Page Bundling method):

```shell
content/learning-paths/<orgID>/
└── your-course/
    └── your-module/
        ├── _index.md
        └── meshery-logo.png
```

### How to Add a Video

Embed videos in a visually distinct card using:

```markdown
{{</*card title="Video: Example" */>}}
<video width="100%" height="100%" controls>
    <source src="https://example.com/your-video.mp4" type="video/mp4">
    Your browser does not support the video tag.
</video>
{{</* /card*/>}}
```

### How to Add a Meshery Design

1. Place Design Assets Put your design files (e.g., `cdn.js`, design YAMLs) alongside your course or module content, ideally following the same directory conventions used for images.

2. Embed Using the meshery-design-embed Shortcode In your markdown file, use:

```bash
{{< meshery-design-embed
id="embedded-design-0e3abb9c-39e7-4d09-b46f-26a0238c3c3d"
src="cdn.js"
>}}
```

- Replace `id` with the unique identifier for your design.
- Replace `src` with the path to your JS asset responsible for rendering.

> Always use these shortcodes for images, videos, and embedded designs. This keeps assets portable, ensures they resolve correctly for each organization, and integrates properly with the Academy platform’s build and deployment flow.

### Adding Assessments

Assessment files use the Academy test layout. Question and option IDs must be unique within their scope.

```yaml
---
title: "Assessment Example"
id: "assessment-example"
type: "test"
layout: "test"
passPercentage: 70
maxAttempts: 3
timeLimit: 30
numberOfQuestions: 1
questions:
  - id: "q1"
    text: "DigitalOcean Academy content is authored in Markdown."
    type: "true-false"
    marks: 1
    options:
      - id: "true"
        text: "True"
        isCorrect: true
      - id: "false"
        text: "False"
---
```

---

## 🤝 Contribution Workflow

We welcome contributions! Please follow the **fork → branch → commit → push → pull request** workflow:

### Step-by-Step

1. **Fork** this repository on GitHub.
2. **Clone** your fork locally:
   ```bash
   git clone https://github.com/<your-username>/tcslabs-academy.git
   cd tcslabs-academy
   ```
3. **Create a branch** for your changes:
   ```bash
   git checkout -b feature/<your-username>/<issue-number>
   ```
4. **Make your changes** — add or edit content in `content/`, fix bugs, improve docs.
5. **Preview locally** to verify:
   ```bash
   hugo server -D
   ```
6. **Commit** with a sign-off (required by DCO):
   ```bash
   git commit -s -m "docs: describe your change"
   ```
7. **Push** to your fork:
   ```bash
   git push origin feature/<your-username>/<issue-number>
   ```
8. **Open a Pull Request** against the `master` branch of this repository.

> For a detailed guide on the fork-and-pull workflow, see [CONTRIBUTING-gitflow.md](./CONTRIBUTING-gitflow.md).

### Important Guidelines

- All commits must be **signed-off** ([Developer Certificate of Origin](https://developercertificate.org/)).
- Pull requests should reference an open issue.
- See [CONTRIBUTING.md](./CONTRIBUTING.md) for the full contribution guide.
- See [CODE_OF_CONDUCT.md](./CODE_OF_CONDUCT.md) for community standards.

---

## 🔗 Related Repositories

Find other related academies by browsing the "[meshery-academy](https://github.com/topics/meshery-academy)" topic in GitHub. See [Academies](https://docs.meshery.io/extensions/academies/) in Meshery Docs for more about these extensions.

---

## 📄 License

This repository is available as open source under the terms of the [Apache 2.0 License](./LICENSE).

---
       
## 👥 Community & Contributions

We warmly welcome all contributors! As you get started, please review this project's [contributing guidelines](CONTRIBUTING.md).


Contributors are expected to follow the [CNCF Code of Conduct](https://github.com/cncf/foundation/blob/master/code-of-conduct.md).

<p>
<a href="https://slack.meshery.io">

<picture align="right">
  <source media="(prefers-color-scheme: dark)" srcset=".github/assets/images/readme/slack.svg">
  <source media="(prefers-color-scheme: light)" srcset=".github/assets/images/readme/slack.svg">
  <img src=".github/assets/images/readme/slack.svg"
       width="120"
       align="right"
       alt="Join Meshery Slack">
</picture>

</a>

<a href="https://meshery.io/community">
  <img src=".github/assets/images/readme/community.svg"
       width="140"
       align="left"
       style="margin-right:10px;"
       alt="Meshery Community">
</a>

✔️ <em><strong>Join</strong></em> the <a href="https://slack.meshery.io">Meshery Slack Community</a>.<br />
✔️ <em><strong>Discuss</strong></em> in the <a href="https://discuss.meshery.io/">Community Forum</a>.<br />
✔️ <em><strong>Explore</strong></em> the <a href="https://discuss.meshery.io/c/community/12">Meshery Community Discussions</a>.<br />
✔️ <em><strong>Get Started</strong></em> with <a href="https://meshery.io/#getting-started">Meshery</a>.<br />

</p>

<br clear="both" />

