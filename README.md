# vaam-apps/.github

Org-wide reusable workflows, each called from a small per-repo caller rather
than copied into it. Five check something and annotate; one
(`sync-repo-settings.yml`) is what makes any of that annotation actually
required before a PR can merge — see "Making a check actually required"
below for why that used to not be true anywhere in this org.

| workflow | what it does | trigger |
|---|---|---|
| `sast.yml` | CodeQL per language; link integrity for docs | PR |
| `lint.yml` | super-linter, gaps only, pushes fixes to the branch | PR |
| `trivy.yml` | deps, secrets, IaC misconfiguration → code scanning | PR |
| `issue-governance.yml` | issue structure vs. ai-governance templates | issue opened/edited |
| `pr-governance.yml` | PR description structure vs. the ai-governance PR template | PR opened/edited |
| `sync-repo-settings.yml` | owns one repository ruleset per repo — PR requirement, review count, required checks, force-push/deletion | manual (see below) |

## Required first: App permissions

Everything authenticates as the **vaam-apps** GitHub App, not `GITHUB_TOKEN`.
That is not style. A push made with `GITHUB_TOKEN` raises no workflow events, so
a lint auto-fix commit pushed with it lands on the branch and silently fails to
re-run CI — the same defect that made vsms `v0.3.2` publish nothing at all.

At the time these were written the App held only:

```
contents=write  pull_requests=write  issue_fields=read  issue_types=read  metadata=read
```

Five grants are needed on top, and each workflow fails loudly naming the one it
wants rather than degrading quietly:

| grant | needed by | without it |
|---|---|---|
| `security_events: write` | `sast.yml`, `trivy.yml` | SARIF upload fails; findings exist but reach nobody |
| `issues: write` | `issue-governance.yml` | cannot comment or label; validation runs and says nothing |
| `pull_requests: write` | `pr-governance.yml` | cannot comment or label a non-conforming PR |
| `workflows: write` | `lint.yml` | a YAML fix touching `.github/workflows/**` cannot be pushed |
| `administration: read` (plan) / `write` (apply) | `sync-repo-settings.yml` | reading or writing a repository ruleset 403s; even `dry-run: true` needs read |

No app in this org held `security_events` when this was written — check before
assuming code scanning is covered. **The same is true of `administration`: at
the time `sync-repo-settings.yml` was added, `gh api
orgs/vaam-apps/installations` showed the vaam-apps App holding no
`administration` permission at all, on any repo.** That workflow will 403 on
every call, dry-run included, until this grant is added — this is expected,
not a bug in the workflow, and is why it hasn't been run against any repo yet.

## Adopting a repo

```yaml
# .github/workflows/quality.yml
name: quality
on:
  pull_request:
    branches: [main]
permissions: {}
concurrency:
  group: quality-${{ github.ref }}
  cancel-in-progress: true
jobs:
  changes: # gate with a per-job `if:`, never on.pull_request.paths — see below
    ...
  sast:
    needs: changes
    if: needs.changes.outputs.code == 'true'
    uses: vaam-apps/.github/.github/workflows/sast.yml@main
    with:
      codeql-languages: '["rust","javascript-typescript","actions"]'
    secrets:
      app-client-id: ${{ secrets.RELEASE_PLEASE_APP_CLIENT_ID }}
      app-private-key: ${{ secrets.RELEASE_PLEASE_APP_PRIVATE_KEY }}
```

`vsms/.github/workflows/quality.yml` is the worked example — it has the widest
surface in the org (Rust, TypeScript, Docker, Helm, docs) so it exercises every
path.

## Three decisions worth not re-litigating

**Gate with a per-job `if:`, never `on.pull_request.paths`.** Both look
equivalent today because this org has no required status checks. They stop being
equivalent the moment one is added: a *skipped job* still reports, satisfying the
check, while a workflow that never *triggers* reports nothing and leaves the PR
waiting forever on a check that will never arrive.

**Super-linter owns only the gaps.** Markdown, YAML, JSON, Dockerfile, shell,
and workflow security. Not Rust, not JS/TS — clippy and biome already own those,
are configured per repo, and are faster. Two auto-fixers on one file do not
converge; they argue, and the commit log records it.

**Fork PRs are linted in report-only mode.** A fork PR gets a read-only token and
no secrets, so no token capable of pushing to the fork's branch exists even in
principle. The workflow says so in its output rather than reporting a green
"fixed" that fixed nothing.

## Making a check actually required

Every workflow above can fail loudly. None of them, on their own, stop a red
PR from being merged — as of this PR, zero repos in this org had a single
required status check, and `vpay-skills`/`vsms-skills` had no branch
protection at all. `sync-repo-settings.yml` closes that: it owns one
repository ruleset per repo (named `sync-repo-settings` by default) and
requires explicit opt-in to change anything.

**Ruleset, not classic branch protection.** Rulesets accept the literal ref
pattern `~DEFAULT_BRANCH`, so one caller works whether a repo's default
branch is `main` (most of this org) or `master` (`vpay`) — no per-repo branch
lookup, and it keeps working if the branch is ever renamed. Classic
protection also doesn't work on a private repo on GitHub Free; this org is on
Enterprise so that never actually bit, but rulesets remain the more precise
mechanism (named, independently addressable, own exactly one object rather
than clobbering a single global per-branch config). Full reasoning, including
what was checked against GitHub's own OpenAPI description rather than
assumed, is in `sync-repo-settings.yml`'s own header comment.

**`dry-run: true` is the default, and means exactly that — no POST, PUT or
DELETE call is made.** It reads the repo's current ruleset (if any), computes
what would change, and prints the diff to the job summary. A caller sets
`dry-run: false` explicitly to apply anything.

**`required-checks` defaults to nothing, and that is deliberate, not an
oversight.** A required context that never reports on a given repo blocks
every PR there forever. Checked against real check-run data, not assumed
from reading a caller's YAML:

- CodeQL's own matrix produces language-dependent context names ("SAST /
  CodeQL (rust)"), and two of the four repos that have adopted `quality.yml`
  (`ui`, `flutter-sign-keypair`) don't call `sast.yml` at all.
- When the *caller* job wrapping a reusable-workflow call is skipped by its
  own `if:` (e.g. a docs-only PR skipping `trivy`), GitHub reports exactly
  one check run — the caller job's own bare name ("SAST"), conclusion
  `skipped` — not the sub-job names the matrix would have produced had it
  run. Confirmed live on vsms PR #407: `SAST | skipped`, with no
  "SAST / CodeQL (...)" entries at all on that same commit.
- The one context that *is* safe, verified live in all four current
  adopters (vsms, vpay, ui, flutter-sign-keypair): **`lint / Super-linter`**.
  Every adopter gates its `lint` job on `needs.changes.outputs.any ==
  'true'`, and `any`'s own filter is the bare glob `'**'` — matching every
  possible changed file, so in practice this job is unconditional. It is a
  per-repo opt-in for a repo that has confirmed its own `quality.yml` still
  uses that pattern, never an org-wide default baked into
  `sync-repo-settings.yml` itself.

### Which repos this is safe to run against today

Checked by listing every workflow file in every repo and grepping for a
`uses: vaam-apps/.github/.github/workflows/...` reference — not assumed from
this file's own "Adopting a repo" example.

| repo | default branch | has adopted | safe non-empty `required-checks` today |
|---|---|---|---|
| `vsms` | `main` | `sast`, `lint`, `trivy` | `lint / Super-linter` |
| `vpay` | `master` | `sast`, `lint`, `trivy` | `lint / Super-linter` |
| `ui` | `main` | `lint`, `trivy` (no `sast` — uses code-scanning default setup instead) | `lint / Super-linter` |
| `flutter-sign-keypair` | `main` | `lint`, `trivy` (no `sast` — default setup covers Swift) | `lint / Super-linter` |
| `vaam-apps` | `main` | none of the five; private, Code Security and Dependabot both disabled | none — `required-checks` must stay empty |
| `fyi` | `main` | none | none |
| `image-resizer` | `main` | none | none |
| `vpay-skills` | `main` | none at the time this was written (a caller PR was in flight separately) | none until that caller merges and is confirmed |
| `vsms-skills` | `main` | none at the time this was written (a caller PR was in flight separately) | none until that caller merges and is confirmed |

Re-verify this table before trusting it for a repo other than the four listed
as adopters — adoption is a per-repo fact that changes independently of this
file.

### Caller example

Unlike the other five, this workflow is destructive and admin-scoped, so the
example below triggers on `workflow_dispatch` rather than a PR event — a
human has to consciously choose to run it, every time, rather than it running
on every push. `dry-run` still defaults to `true` even here; `apply` has to be
flipped to `true` in the Actions "Run workflow" form to change anything.

```yaml
# .github/workflows/sync-settings.yml
name: sync repo settings
on:
  workflow_dispatch:
    inputs:
      apply:
        description: "Actually change the ruleset (default: plan only)."
        type: boolean
        default: false
permissions: {}
jobs:
  sync:
    uses: vaam-apps/.github/.github/workflows/sync-repo-settings.yml@main
    with:
      dry-run: ${{ inputs.apply != true }}
      # Empty until this repo's own quality.yml is confirmed to always
      # report "lint / Super-linter" — see the adoption table above.
      required-checks: ""
      required-approving-review-count: 1
    secrets:
      app-client-id: ${{ secrets.RELEASE_PLEASE_APP_CLIENT_ID }}
      app-private-key: ${{ secrets.RELEASE_PLEASE_APP_PRIVATE_KEY }}
```

Not added to any repo by this PR. The mechanism ships here; applying it to a
real repo — and granting the App `administration` first, since it holds
nothing there today — is the maintainer's call, on their own timeline.

## Releasing

Adopting these quality workflows is separate from adopting the release
tooling. For release-please — the config shape, the App-token requirement,
and the failure modes that report success while publishing nothing — see
[`docs/releasing.md`](docs/releasing.md). `vaam-apps/vsms` is the reference
implementation; copy from its real files rather than from any snippet.

## Known wart

The secrets are still named `RELEASE_PLEASE_*`, which is now a misnomer — they
authenticate lint, SAST, Trivy and issue governance too. Renaming them is a
coordinated change across every repo's `release-please.yml` at once; until
someone does that pass, the name is wrong and the value is right.
