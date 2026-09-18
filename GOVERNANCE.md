# Governance

How `vaam-apps` adopts the [adorsys-gis AI-governance framework](https://adorsys-gis.github.io/ai-governance/).
This document describes what actually runs and what is checked by hand — not
an aspiration, not the framework's own generic pitch. If a claim below
doesn't match a file in this repo, the file wins; open an issue against
`.github`.

The framework's own doctrine, unedited, is the one sentence to keep in mind
reading the rest of this:

> **AI may accelerate the work, but it must not launder ignorance into
> polished artifacts.**

— [13. The blunt rule for your team](https://adorsys-gis.github.io/ai-governance/13-doctrine)

## Why adopt it here

Every repo in this org is built with heavy AI assistance — that's not
changing. The framework doesn't slow that down; it puts a floor under it so
"the agent said it was done" is never the only evidence for anything that
matters. A ticket is not understanding. A generated test is not
verification. A green check is not judgment. The mechanisms below exist to
make sure a human is still the one answering for the work, even when AI
wrote most of it.

## Architecture documentation is the preferred source of truth

`issue-governance.yml` requires a "Source of Truth" section but can only check
that it *looks like* a reference — a URL, an issue number, a ticket id. It
cannot tell a link to a real design decision from a link to a Slack thread
that restates the ticket. This section states, for a human reviewer, which
sources this org actually prefers, in order:

1. **An architecture document or ADR in the repo the work touches.** Cite the
   section or decision by name, not just the file —
   `docs/architecture.md §3.2` or `docs/adr/0014-....md`, not "the
   architecture doc."
2. **An external design doc, spec, or decision record the team already
   agreed on** (a linked RFC, a standards document, an upstream issue) — when
   no architecture doc or ADR yet covers the area.
3. **A tracked issue or epic** that itself cites one of the above — a valid
   pointer, never a terminus. A chain that bottoms out in "see the ticket
   that opened this ticket" has no source of truth.

**Never acceptable as a source of truth on its own:** a chat log, an
AI-generated summary, or a ticket restating its own title.
`issue-governance.yml`'s check cannot detect any of these — a Slack permalink
is a URL and passes the mechanical check just as well as a real citation
does. Catching this is a reviewer's job, every time; see the "What's enforced
automatically" table below for exactly where the automation stops.

### One architecture document per repo, not a folder of them

Stated as a rule with a number, not a preference, because a preference gets
ignored:

> **Each repo carries exactly one architecture document** —
> `docs/architecture.md` (or `ARCHITECTURE.md` at the repo root, for a repo
> with no `docs/` yet) — **plus Architecture Decision Records for decisions
> that need a stated rationale.** Not a `design/`, `notes/`, `plans/`, and
> `architecture/` sitting side by side, each partially current. If a second
> architecture-shaped document is tempting, the answer is a new section or a
> new ADR in the one that already exists, not a new file.

This reacts to a real pattern already present in this org, not a
hypothetical one: `vaam-apps/vpay`'s `docs/` holds ten-plus top-level areas
(`api/`, `flows/`, `plans/`, `reference/`, `rfc/`, `runbooks/`, `sdks/`,
`status.md`, `open-decisions.md`, `adr/`), with its own `docs/README.md`
telling a reader "do not read this directory in order." That may suit
vpay's own domain — it is not the shape this rule asks a repo to start
from, and it is exactly the developer overload this rule exists to head
off elsewhere. `vaam-apps/vsms`'s `docs/architecture.md` — one file, the
declared source of truth for that repo's design, corrected in place every
time something in it turns out wrong rather than superseded by a second
document — is the shape to copy. Read it before writing a new architecture
document in any repo in this org.

### ADRs: numbered, immutable, superseding

For the decision-record half, follow the format `vaam-apps/vpay` already
uses at `docs/adr/NNNN-title.md` (Michael Nygard's format: Status / Date /
Deciders, then Context / Decision / Consequences — see vpay's own
`docs/adr/0001-record-architecture-decisions.md`). An ADR is immutable once
accepted; a changed decision gets a new ADR that supersedes the old one, not
an edit to it. `vsms`'s `docs/architecture.md` takes the other legitimate
approach instead — significant decisions recorded inline, dated, in the
section they belong to — which is an acceptable substitute for a repo whose
decision volume doesn't justify a separate directory. Pick one shape per
repo and stay consistent within it; don't run both for the same decision.

### CPSA-shaped: which sections are mandatory here, and which aren't

iSAQB's CPSA (Certified Professional for Software Architecture) Foundation
curriculum treats architecture documentation, quality scenarios, and
architecture decision records as core competencies, and names arc42 as the
reference template for the first. arc42 itself is explicit that only one of
its twelve sections — Building Block View — is non-optional; the rest exist
to be used when they earn their place, not filled in as a checklist. This
org goes slightly further than arc42's own minimum, because a document
meant to answer "what should I read before touching this system" needs more
than a description of its static structure. The following are **mandatory**
in every repo's one architecture document:

| Section | Answers |
|---|---|
| Introduction & Goals | Why this system exists; its explicit quality goals |
| Context & Scope | What's inside the boundary, what's outside, what it talks to |
| Solution Strategy | The core technical approach, and why that one |
| Building Block View | What exists — arc42's own one non-optional section |
| Quality Requirements | Quality **scenarios** (stimulus → response), not adjectives like "fast" or "secure" |
| Architecture Decisions | Significant decisions and their reasoning — inline or as ADRs, per the section above |
| Risks & Technical Debt | What's known to be wrong, unfinished, or unverified — stated, not hidden |

Everything else in arc42's twelve — Constraints, Runtime View, Deployment
View, Crosscutting Concepts, Glossary — is **optional**: add the section the
day a reader would otherwise have to reconstruct that information from
source, not before. `vsms/docs/architecture.md` is not organized under
arc42's own section numbers, and doesn't need to be — every mandatory row
above has a real, findable home in it regardless (its "R. Engineering
rules" section carries Constraints and Crosscutting Concepts together, and
"13. Risks and open questions" is Risks & Technical Debt under a different
name). Match the *content* a section is supposed to carry, not the exact
heading text.

## What runs, and where it comes from

| Mechanism | Lives at | Checks | Trigger |
|---|---|---|---|
| `issue-governance.yml` | [`vaam-apps/.github/.github/workflows/issue-governance.yml`](.github/workflows/issue-governance.yml) | An issue's structure against the framework's epic / user story / dev ticket templates | `issues: opened, edited, reopened`, per adopting repo |
| `sast.yml` | [`vaam-apps/.github/.github/workflows/sast.yml`](.github/workflows/sast.yml) | CodeQL per language; doc link integrity | pull request, per adopting repo |
| `lint.yml` | [`vaam-apps/.github/.github/workflows/lint.yml`](.github/workflows/lint.yml) | super-linter on Markdown/YAML/JSON/Dockerfile/shell/workflow files; auto-fixes and pushes | pull request, per adopting repo |
| `trivy.yml` | [`vaam-apps/.github/.github/workflows/trivy.yml`](.github/workflows/trivy.yml) | Dependency, secret and IaC-misconfiguration scanning → code scanning alerts | pull request, per adopting repo |
| pull-request structure check | a reusable workflow analogous to `issue-governance.yml`, scoped to pull requests instead of issues, landing in this repo alongside this document | Whether a PR description carries the sections the [governance PR template](https://adorsys-gis.github.io/ai-governance/04-pull-request-template) requires (Summary, Intent, Scope, Verification, Risk Assessment, AI Usage Declaration, Reviewer Focus) | pull request, per adopting repo |

None of these four workflows is self-installing. Each repo opts in with a
small caller workflow that does nothing but reference the reusable one — see
`README.md`'s "Adopting a repo" section for the exact YAML, and
`vsms/.github/workflows/issue-governance.yml` for a working example. A repo
that hasn't added the caller runs none of this, silently — this document
does not claim otherwise for any repo that hasn't wired it in.

The pull-request check above is described at the level of what it's for, not
exactly how it decides pass/fail, because — unlike the other four rows — its
own file was not present in this repo at the time this document was written
and its rule set has not been read by whoever wrote this page. Read that
workflow's own file directly before relying on any more specific claim about
it than what's written here.

### Templates

The issue and pull-request templates this org's repos use are meant to be
the framework's own, verbatim or near it:

- [Epic template](https://adorsys-gis.github.io/ai-governance/01-epic-template)
- [User story template](https://adorsys-gis.github.io/ai-governance/02-user-story-template)
- [Dev ticket template](https://adorsys-gis.github.io/ai-governance/03-dev-ticket-template)
- [Pull request template](https://adorsys-gis.github.io/ai-governance/04-pull-request-template)

`issue-governance.yml` validates against the first three by checking for the
sections the framework itself calls blocking — Source of Truth, Intent, AI
Usage Declaration, Definition of Ready, Definition of Done, and (for
stories/tickets) Acceptance Criteria — not all of a template's headings.
That's a deliberate restraint recorded in the workflow's own top comment: a
validator that rejects every real issue gets switched off within a week, and
then nothing is checked at all.

This repo (`.github`) is where an org-wide default `.github/ISSUE_TEMPLATE/`
and `.github/PULL_REQUEST_TEMPLATE.md` belong, per GitHub's own
[community health file](https://docs.github.com/en/communities/setting-up-your-project-for-healthy-contributions/creating-a-default-community-health-file-for-your-organization)
convention — any repo in the org without its own copy inherits these. That
layout is being populated separately from this document; check
`.github/ISSUE_TEMPLATE/` and `.github/PULL_REQUEST_TEMPLATE.md` in this
repo directly for what currently exists rather than trusting this sentence.

## What's enforced automatically, and what's enforced by review — stated plainly

This is the boundary the doctrine above is warning about, made explicit
rather than left to be discovered the hard way.

**`issue-governance.yml` can verify presence. It cannot verify truth.** It
confirms a "Source of Truth" heading exists and has content that looks like
a link, an issue reference, or a ticket id, rather than being blank or
`TBD`. It cannot confirm that link is the *real* source of truth, that it
still resolves, or that whoever wrote the issue actually read it. It
confirms "AI Usage Declaration" has at least one checkbox ticked. It cannot
confirm the checked boxes are honest, or that the human who ticked "I
understand every meaningful change" actually does. **A structural check
answers "is the section present and non-empty," never "is the claim in it
true."** Closing that second question is what human review is for, every
time, with no shortcut — a label clearing itself is not a substitute for a
reviewer having read the thing.

| | Automated | By review only |
|---|---|---|
| A required section exists and isn't empty | yes | — |
| A "Source of Truth" link is present in a link/reference-shaped form | yes | — |
| At least one AI Usage Declaration checkbox is ticked | yes | — |
| The source of truth is the *actual, correct* one | — | yes |
| The declared AI usage matches what was actually done | — | yes |
| The acceptance criteria are testable and sufficient | — | yes |
| The verification evidence in a PR is real and covers the change | — | yes |
| The human owner genuinely understands the work, not just its description | — | yes |
| Code correctness, security, architecture fit | — | yes (`sast.yml`/`trivy.yml` catch classes of issue; they don't replace a reviewer) |
| A repo's architecture document exists, is singular, and is current | — | yes |
| A cited source of truth is an architecture doc/ADR rather than a chat log or a restated ticket | — | yes |

If a check above passes, read it as "the shape is there to review," not as
"reviewed." Automation gates format; it never gates judgment.

## SSDLC coverage: what's automated, phase by phase

"AI may accelerate the work" applies to code as much as it applies to
tickets. The table below is this org's actual SSDLC gate map, not an
aspirational maturity model — every row names the file that runs the
control it claims, and a phase with no file has no control, stated as such
rather than left implied by omission.

| SSDLC phase | Control | File | NOT covered |
|---|---|---|---|
| Plan | Work-item structure: Source of Truth, Intent, AI Usage Declaration, Definition of Ready, Definition of Done, and (for stories/tickets) Acceptance Criteria — presence and non-emptiness only | `.github/workflows/issue-governance.yml` | Whether the linked source is the *real* one; whether acceptance criteria are *testable* — review only |
| Design | *(none automated)* — the one-architecture-document-per-repo rule above is this org's design control, but nothing checks that a repo has one, that it's current, or that a PR changing architecture also updates it | — | No file implements this. A real gap, not a hidden one |
| Develop — application code | *(none org-wide)* — each repo's own linter (clippy, biome, …) is configured per repo and isn't run from here | — | No org-wide secure-coding check at commit time |
| Develop — workflow code | zizmor: template-injection via `${{ }}` in a `run:` body, over-broad permissions, unpinned actions — SAST for the workflows themselves | `.github/workflows/lint.yml` (`VALIDATE_GITHUB_ACTIONS_ZIZMOR`) | Only `.github/workflows/**` YAML; never looks at application source |
| Verify — static analysis | CodeQL, one pass per language a caller opts into via `codeql-languages` | `.github/workflows/sast.yml` (`codeql` job) | A language the caller doesn't list gets no analysis at all |
| Verify — documentation integrity | Link-checking (lychee): a confidently-wrong URL is a defect a reader can't spot by reading | `.github/workflows/sast.yml` (`docs` job) | Whether a doc's *claims* match the code — review only |
| Verify — dependency vulnerabilities | Trivy filesystem vulnerability scan | `.github/workflows/trivy.yml` (`scanners: vuln`) | License/ban policy — Rust repos already run `cargo deny`, stricter, on their own |
| Verify — secrets | Trivy secret scan, every file including Markdown | `.github/workflows/trivy.yml` (`scanners: secret`) | History before adoption; a secret merged before the scanner was wired in isn't retroactively caught |
| Verify — IaC misconfiguration | Trivy misconfig scan: Dockerfiles, compose files, Helm charts | `.github/workflows/trivy.yml` (`scanners: misconfig`) | What's actually deployed — this only sees what's committed |
| Verify — formatting | super-linter on Markdown/YAML/JSON/Dockerfile/shell/workflow, auto-fixed and pushed back to the branch | `.github/workflows/lint.yml` | Rust/JS/TS formatting — deliberately left to each repo's own clippy/biome |
| Verify — PR structure | A reusable PR-description check (Summary/Intent/Scope/Verification/Risk Assessment/AI Usage Declaration/Reviewer Focus) is described in the table above as landing "alongside this document" | not present in `.github/workflows/` as of this writing — checked by listing the directory, not assumed | Even once it lands: whether the content is *true* stays review-only, same as every other structural check here |
| Verify — tests | *(none org-wide)* — each adopting repo runs its own suite in its own CI (e.g. vsms's `ci.yml`) | — | Whether tests assert anything meaningful, not just pass — review only, in every repo |
| Release | *(none org-wide)* — each repo's own release pipeline owns build/publish/tag gating (e.g. vsms's `release.yml`) | — | No org-wide control over what gets published |
| Deploy | *(none org-wide)* — each repo owns its own deployment | — | No org-wide control over what gets deployed, or where |
| Operate / Monitor | *(none)* | — | No runtime security monitoring, alerting, or incident-response workflow exists anywhere in this org today |

Read the blank rows as the actual state of things, not a future promise. If
one of them matters enough to close, that's a workflow to build and a row
to update here — not a sentence to add first.

## Exemptions

`issue-governance.yml` skips validation entirely for an issue carrying any
of the labels in its `exempt-labels` input — the shipped default is
`question, discussion, meta, dependencies` (see the workflow file for the
current value; a caller repo can override it). That's a structural
exemption for issue *kinds* that were never work items in the framework's
sense, not a compliance waiver.

There is no automated exemption mechanism for a real work item that
genuinely can't meet a criterion — a ticket with a redacted source of truth,
an emergency hotfix PR with no time for the full template, and similar
cases. For those:

1. State plainly, in the issue or PR itself, which criterion isn't met and
   why.
2. Get a maintainer of the affected repo (or an org owner, for anything
   org-wide) to say so explicitly in a comment — not silence, not an
   assumption that nobody will notice.
3. The `governance:incomplete` label (or whatever label a repo configures)
   can be removed by a maintainer once that's recorded; the workflow itself
   only ever adds or clears it based on structure, never based on judgment.

An exemption is a documented decision, not an absence of one.

## Adopting this in a new repo

See `README.md` in this repo for the exact caller-workflow YAML and the
worked example. In short: each of the workflows above is `workflow_call`-
only — nothing runs until an adopting repo adds a small caller workflow that
references it by path and supplies the two `RELEASE_PLEASE_*`-named App
credentials described there.

## Related reading

- [`docs/ai-working-agreement.md`](docs/ai-working-agreement.md) — the rules
  contributors in this org are expected to follow.
- [`docs/definition-of-ready-and-done.md`](docs/definition-of-ready-and-done.md)
  — the checklists a ticket and a piece of work are measured against.
- [adorsys-gis/ai-governance](https://adorsys-gis.github.io/ai-governance/)
  — the framework itself. This org's documents adapt it; they don't replace
  it as the source of truth for the framework's own reasoning.
