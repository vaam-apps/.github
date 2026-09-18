# vaam-apps/.github

Org-wide reusable workflows. Four of them, each called from a small per-repo
caller rather than copied into it.

| workflow | what it does | trigger |
|---|---|---|
| `sast.yml` | CodeQL per language; link integrity for docs | PR |
| `lint.yml` | super-linter, gaps only, pushes fixes to the branch | PR |
| `trivy.yml` | deps, secrets, IaC misconfiguration → code scanning | PR |
| `issue-governance.yml` | issue structure vs. ai-governance templates | issue opened/edited |

## Required first: App permissions

Everything authenticates as the **vaam-apps** GitHub App, not `GITHUB_TOKEN`.
That is not style. A push made with `GITHUB_TOKEN` raises no workflow events, so
a lint auto-fix commit pushed with it lands on the branch and silently fails to
re-run CI — the same defect that made vsms `v0.3.2` publish nothing at all.

At the time these were written the App held only:

```
contents=write  pull_requests=write  issue_fields=read  issue_types=read  metadata=read
```

Three grants are needed on top, and each workflow fails loudly naming the one it
wants rather than degrading quietly:

| grant | needed by | without it |
|---|---|---|
| `security_events: write` | `sast.yml`, `trivy.yml` | SARIF upload fails; findings exist but reach nobody |
| `issues: write` | `issue-governance.yml` | cannot comment or label; validation runs and says nothing |
| `workflows: write` | `lint.yml` | a YAML fix touching `.github/workflows/**` cannot be pushed |

No app in this org held `security_events` when this was written — check before
assuming code scanning is covered.

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

## Known wart

The secrets are still named `RELEASE_PLEASE_*`, which is now a misnomer — they
authenticate lint, SAST, Trivy and issue governance too. Renaming them is a
coordinated change across every repo's `release-please.yml` at once; until
someone does that pass, the name is wrong and the value is right.
