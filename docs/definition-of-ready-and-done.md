# Definition of Ready & Definition of Done

Adapted for `vaam-apps` from adorsys-gis's
[06. Definition of Ready](https://adorsys-gis.github.io/ai-governance/06-definition-of-ready)
and
[07. Definition of Done](https://adorsys-gis.github.io/ai-governance/07-definition-of-done)
templates. Use these as the actual checklists — copy the relevant section
into a ticket or PR, tick what applies, leave the rest visibly unchecked
rather than deleting it.

Two definitions, two gates:

- **Definition of Ready** — the minimum quality a ticket must have *before*
  someone starts work on it.
- **Definition of Done** — the minimum quality the work must reach *before*
  it's accepted as finished.

Both are gates, not aspirations. A ticket or PR that fails one stays where
it is until it passes — see [`GOVERNANCE.md`](../GOVERNANCE.md) for which
parts of each are checked by `issue-governance.yml` versus left entirely to
a human.

## Definition of Ready

A ticket is Ready only when every mandatory criterion below is satisfied.

### Mandatory criteria

- [ ] The intent is clear.
- [ ] The source of truth is linked.
- [ ] Acceptance criteria are testable.
- [ ] Scope is explicit.
- [ ] Out-of-scope is explicit.
- [ ] Dependencies are identified.
- [ ] Risks are documented.
- [ ] Assumptions are documented.
- [ ] The ticket owner is identified.
- [ ] The assignee knows who to ask for clarification.
- [ ] AI-generated content has been reviewed by a human.

**"Linked" means linked to something real.** In order of preference: this
repo's own architecture document or an ADR, an external design doc or spec,
or a tracked issue that itself cites one of those — see
[`GOVERNANCE.md`](../GOVERNANCE.md#architecture-documentation-is-the-preferred-source-of-truth)
for the full ordering. `issue-governance.yml` can only confirm the section
holds something link-shaped, not that it points at the right thing — that
distinction is the triager's job, every time.

### Human understanding check

Before a ticket enters a sprint or is picked up as work, one human must be
able to explain, without re-reading the ticket to answer:

1. Why this work matters.
2. What must be delivered.
3. What must **not** be delivered.
4. How success will be verified.
5. What could go wrong.

If nobody can explain this, the ticket is not ready — regardless of how
complete it looks.

### AI-specific criteria

- [ ] AI-generated summaries include source links.
- [ ] AI-generated acceptance criteria were reviewed by a human.
- [ ] AI-generated implementation suggestions were checked by a technical
      person.
- [ ] No unverified AI claim remains in the ticket.
- [ ] A human owner has accepted accountability for the ticket.

### What `issue-governance.yml` actually checks here

For an epic, user story, or dev ticket, the workflow confirms these
sections exist and aren't empty: **Source of Truth**, **Intent**, **AI
Usage Declaration**, **Definition of Ready**, **Definition of Done**, and
(for stories/tickets, not epics) **Acceptance Criteria**. For **Source of
Truth** specifically, it also checks the content looks like a real
reference — a URL, an issue number, or a ticket id — not just non-blank
text. For **AI Usage Declaration**, it checks at least one checkbox is
ticked. Everything else on this checklist, including the entire "Human
understanding check" above, is unchecked by any workflow — it's read and
judged by whoever triages or picks up the ticket.

## Definition of Done

A ticket is Done only when every mandatory criterion below is satisfied.

### Delivery criteria

- [ ] Acceptance criteria are satisfied.
- [ ] Code is implemented.
- [ ] Code review is complete.
- [ ] Required tests are passing.
- [ ] Manual verification is documented.
- [ ] Documentation is updated, if needed.
- [ ] Monitoring/logging is updated, if needed.
- [ ] Security impact is reviewed, if needed.
- [ ] Performance impact is reviewed, if needed.
- [ ] No unresolved critical issue remains.

### Verification evidence

Done means evidence exists, not just a claim. Include:

- Test results: `[link or paste]`
- Manual verification: `[steps taken]`
- Screenshots/logs/metrics: `[links]`
- Known limitations: `[details, or "none found"]`

If verification evidence is missing, the work is not Done — a checked box
with no evidence behind it is the exact "polished artifact" the doctrine
warns about.

### AI-specific done criteria

- [ ] AI-generated code was reviewed as untrusted code.
- [ ] AI-generated tests were reviewed for meaningful coverage, not just
      passing.
- [ ] AI-generated documentation was checked against the actual
      implementation, not just for plausibility.
- [ ] AI-generated review comments were not accepted without independent
      judgment.
- [ ] A human owner accepts responsibility for the final result.

### What's checked mechanically at this gate today

`sast.yml`, `lint.yml`, and `trivy.yml` run on pull requests in any repo
that's adopted them, and cover their specific slice of "Required tests are
passing" / "Security impact is reviewed" above — CodeQL findings, dependency
and secret scanning, and lint/formatting gaps respectively. None of them
evaluates whether acceptance criteria are satisfied, whether test coverage
is *meaningful* rather than merely present, or whether documentation
matches reality — those stay review-only. A reusable pull-request structure
check (see `GOVERNANCE.md`) can confirm a PR's description carries the
right sections; it cannot confirm what's written in them is true.

## Using these together

A ticket should be measured against Ready before work starts and against
Done before it's closed. Neither is optional because the ticket "looks
small" or because AI produced most of the diff — the doctrine applies at
every size:

> AI may accelerate the work, but it must not launder ignorance into
> polished artifacts.
