# vaam-apps

Rust and TypeScript products built with heavy AI assistance, under
[adorsys-gis's AI-governance framework](https://adorsys-gis.github.io/ai-governance/):
[vsms](https://github.com/vaam-apps/vsms) (an A2P SMS gateway), vpay,
[ui](https://github.com/vaam-apps/ui) (a shared operator-console component
library), and a handful of smaller tools.

> AI may accelerate the work, but it must not launder ignorance into
> polished artifacts.

That's the rule this org runs on. What it means concretely, and what's
actually checked by a workflow versus by a human, is written down here:

- **[Governance](../GOVERNANCE.md)** — what runs, what it checks, what it
  doesn't, and how to get an exemption.
- **[AI working agreement](../docs/ai-working-agreement.md)** — the rules
  contributors follow.
- **[Definition of Ready & Done](../docs/definition-of-ready-and-done.md)**
  — the checklists a ticket and a piece of work are measured against.
- **[`README.md`](../README.md)** — the reusable CI workflows (SAST, lint,
  Trivy, issue governance) this repo publishes, and how another repo in the
  org adopts them.
