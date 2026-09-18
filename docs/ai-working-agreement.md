# AI Working Agreement

Adapted for `vaam-apps` from
[adorsys-gis's 12. AI working agreement](https://adorsys-gis.github.io/ai-governance/12-ai-working-agreement).
Applies to every repo in this org, whether or not that repo has adopted
`issue-governance.yml` or the pull-request check yet — this is a rule for
people, not a thing a workflow enforces end to end. See
[`GOVERNANCE.md`](../GOVERNANCE.md) for exactly which parts of it a workflow
actually checks today.

## Principle

AI may produce artifacts. Humans own intent, verification, and
consequences. That ownership doesn't transfer to the model because the
model wrote the diff, and it doesn't transfer to a green CI check because
the check passed.

## Allowed uses

AI may be used for, among other things:

- Drafting tickets
- Summarizing documents
- Explaining code
- Generating tests
- Suggesting implementations
- Refactoring
- Drafting documentation
- Preparing reviews
- Debugging support
- Research assistance

Nothing here restricts *how much* AI a contributor uses. It restricts what
happens after: every one of those outputs is a draft until a human has done
the things below.

## Non-negotiable rules

1. AI output is not truth. Treat a model's confident answer the same way
   you'd treat a confident answer from a stranger — worth listening to, not
   worth acting on unverified.
2. AI-generated tickets must be reviewed by a human before they enter a
   sprint or backlog as real work items.
3. AI-generated code must be reviewed as untrusted code — the same scrutiny
   you'd give a first-time external contributor's PR, not less because a
   model wrote it and the diff looks clean.
4. AI-generated summaries must link to sources. A summary with no link back
   to what it summarizes is an opinion, not a citation.
5. AI-generated tests must be checked for meaningful coverage, not just for
   passing. A test that asserts nothing false-positives identically to no
   test at all.
6. AI-generated reviews do not replace human judgment. A model's review
   comment is an input to a human reviewer's decision, never the decision
   itself.
7. The person submitting work is accountable for it — issue, PR, review
   comment, or documentation — regardless of how much of it a model wrote.
8. If you cannot explain the work, you are not ready to submit it. "The
   agent explained it to me and I believed it" is not the same as being
   able to explain it yourself.
9. If the source of truth is missing, stop and clarify. Don't let an AI
   assistant invent one to fill the gap in a ticket or a PR description.
10. If AI gives you confidence without evidence, treat that as a risk
    signal, not a reason to move faster.

## Required disclosure

For issues, pull requests, documentation, and reviews, declare:

- Whether AI was used.
- What AI was used for, specifically (drafting, generating code, tests,
  docs, review — not just "yes").
- What was manually verified, and how.
- What remains uncertain.
- Who owns the final decision.

In this org, the pull-request template's **AI Usage Declaration** section is
where the PR-level version of this lives — fill it in for real, not as a
formality to get past a check. See `GOVERNANCE.md` for what, if anything, is
verified automatically about that section versus what's left to the
reviewer.

## Prohibited behavior

Do not:

- Submit AI-generated work you do not understand.
- Use an AI summary as a substitute for reading the actual source material.
- Create tickets with no source-of-truth evidence.
- Accept AI-generated acceptance criteria without review.
- Approve a PR using only AI-generated review comments — a bot's finding is
  an input, not an approval.
- Hide AI usage when it affects quality, risk, or how the work should be
  understood.
- Use AI to create the appearance of progress — a polished ticket or PR
  description is not itself evidence that the underlying work happened or
  is correct.

## Expected behavior

Do:

- Read the source material yourself, not just an AI's summary of it.
- Ask clarifying questions when intent is unclear, rather than letting an
  assistant guess and running with the guess.
- State assumptions explicitly, in the ticket or PR, where a reviewer can
  see and challenge them.
- Provide verification evidence — test output, logs, screenshots, a
  reproduction — not just an assertion that something works.
- Challenge AI output, including your own AI-generated review comments and
  including bot findings from CI (`sast.yml`, `trivy.yml`, `lint.yml`, and
  any repo's own review bots) — verify before acting, and rebut a false
  positive with the specific reason it's wrong.
- Prefer small, reviewable changes over large ones a reviewer can only skim.
- Keep a human accountable for every artifact that ships, in every repo,
  every time.

## How this connects to what's checked mechanically

This agreement is enforced by people, not by a workflow. Where mechanical
checks exist in this org — `issue-governance.yml` today, a pull-request
structure check landing alongside it — they check for the *presence* of the
sections this agreement asks contributors to fill in honestly, not for the
honesty itself. Read [`GOVERNANCE.md`](../GOVERNANCE.md)'s "What's enforced
automatically, and what's enforced by review" table before assuming a green
check means more than it does.
