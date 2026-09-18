# vaam-apps/.github

Org-wide reusable workflows. Four of them, each called from a small per-repo
caller rather than copied into it.

| workflow | what it does | trigger |
|---|---|---|
| `sast.yml` | CodeQL per language; link integrity for docs | PR |
| `lint.yml` | super-linter, gaps only, pushes fixes to the branch | PR |
| `trivy.yml` | deps, secrets, IaC misconfiguration → code scanning | PR |
| `issue-governance.yml` | issue structure vs. ai-governance templates | issue opened/edited |

## Which token, and why — it is not the same answer everywhere

The **vaam-apps** App is used where `GITHUB_TOKEN` is *structurally* incapable,
and nowhere else. That is one place:

| workflow | token | why |
|---|---|---|
| `lint.yml` | **App** | A push made with `GITHUB_TOKEN` raises no workflow events, so an auto-fix commit would land on the branch and silently fail to re-run CI — the defect that made vsms `v0.3.2` publish nothing. Needs `contents: write` + `workflows: write`. |
| `issue-governance.yml` | **App** | Comments post as the app rather than a generic bot. `GITHUB_TOKEN` would also work; this one is preference, not necessity. Needs `issues: write`. |
| `sast.yml` | `GITHUB_TOKEN` | Already holds `security-events: write` from the job's own `permissions:` block, scoped to one repository and one run, expiring with it. |
| `trivy.yml` | `GITHUB_TOKEN` | Same. |

An earlier revision routed SARIF upload through the App too, "for consistency".
That was wrong in the direction that matters: it demanded an org-wide credential
where an ephemeral, single-repo one already sufficed. Consistency is not a
security property.

So the only grants needed are `contents`, `workflows` and `issues` — all held.
Nothing requires **Code scanning alerts** (`security_events`), which is a
different permission from *Repository security advisories* and easy to confuse
with it.

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
