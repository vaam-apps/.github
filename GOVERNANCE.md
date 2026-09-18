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

If a check above passes, read it as "the shape is there to review," not as
"reviewed." Automation gates format; it never gates judgment.

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
