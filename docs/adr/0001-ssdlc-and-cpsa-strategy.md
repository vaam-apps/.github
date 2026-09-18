# 0001. SSDLC and CPSA strategy for `vaam-apps`

- **Status:** Proposed
- **Date:** 2026-09-18
- **Deciders:** @stephane-segning
- **Supersedes:** nothing
- **Related:** [`GOVERNANCE.md`](../../GOVERNANCE.md) (org governance, adopted separately)

Format follows `vpay`'s existing ADRs (Nygard), plus Alternatives considered and
Open questions. Every count below was read from the GitHub API on 2026-09-18;
moving figures are dated inline.

## Context

### Seven repos, six documentation shapes

| Repo | Architecture doc | ADRs | Other `docs/` areas |
|---|---|---|---|
| `fyi` | `docs/arc42.md`, 344 lines, arc42 §§1–8 | none | 2 files (`index.md`, `README.md`) |
| `vsms` | `docs/architecture.md`, 2,947 lines, 16 bespoke sections | none in `docs/adr/`; one ADR and one RFC sit in `docs/design/` | `design/`, `legal/`, `runbooks/`, `pdf/`, `roadmap.md`, `integrating.md` |
| `vpay` | none | **22**, `docs/adr/`, Nygard format | `rfc/`, `plans/`, `api/`, `flows/`, `reference/`, `runbooks/`, `sdks/`, `status/`, `open-decisions.md`, `status.md` |
| `vaam-apps` | `docs/architecture.md`, 530 lines, bespoke | none | 25 top-level files + `backend/` (20), `mobile/` (13), `domain/` (6), `frontends/`, `examples/` |
| `image-resizer` | `docs/architecture/` (2 files) | **5**, at repo-root `/adr/` | 7 folders total under `docs/` |
| `ui` | none; `README.md` is 617 lines and does the job | none | `skills/vaam-ui/`, a packaged consumer-facing skill tree with its own test |
| `flutter-sign-keypair` | none; `README.md`, 374 lines | none | none |

Three observations that set the problem:

1. **`vpay` is the only repo with `docs/adr/`.** `image-resizer` has the practice
   but at a different path. Five repos have no ADR concept at all.
2. **`vpay`'s `docs/` is the sprawl case.** Ten top-level areas; `plans/` alone
   holds 15 files and roughly 60 dated experiment-log subdirectories; its own
   `docs/README.md` closes with "do not read this directory in order."
3. **No repo is at the target shape.** `fyi` is closest — arc42-numbered, one
   file — but it stops at §8 and misnumbers Glossary as §9 (arc42 puts it at
   §12). It has no §10 Quality Requirements, which is the section this ADR's
   central mechanism lives in.

### 60 open security alerts, org-wide, none triaged since 2026-09-04

| Repo | Code scanning (open) | Dependabot (open) | Oldest open |
|---|---|---|---|
| `vsms` | 47 | 0 | 2026-08-19 |
| `ui` | 3 | 0 | — |
| `fyi` | 0 | 9 | 2026-08-22 |
| `image-resizer` | 0 | 1 | — |

`vsms` has had 52 code-scanning alerts in total: 4 fixed, **1 ever dismissed with
a reason**, 47 open. Its open set is 31 critical `rust/hard-coded-cryptographic-value`
(20 of them in production source — `sms-auth/src/login.rs` and
`sms-core/src/password.rs` — and 11 in test files), 6 high `rust/cleartext-logging`,
2 high `js/polynomial-redos`, 1 high `js/missing-rate-limiting`, 7 medium
`actions/missing-workflow-permissions`.

The likely answer for most of the 31 is "false positive, and here is why" —
`login.rs` deliberately holds a constant dummy hash so that a
no-such-user response costs the same wall-clock time as a wrong-password one.
That does not weaken the argument; it is the argument. **The dismissal reason is
the deliverable.** Writing it converts an unread alert into a durable, dated
piece of evidence. Not writing it leaves 47 open questions that a reader cannot
distinguish from 47 real findings.

### The org already does this well in one place and badly in another

Both `vsms` and `fyi` suppress the same advisory, `RUSTSEC-2023-0071`, in their
own `deny.toml`. The two entries are not comparable:

| | `vsms/deny.toml` | `fyi/deny.toml` |
|---|---|---|
| Reason | Full reachability analysis: the Marvin Attack affects PKCS#1 v1.5 *decryption*; this graph's only `rsa` use is signing, verification and PEM parsing; no decrypt call is reachable | a bare URL |
| Re-verification | "Re-verified against authkestra 0.8.0" | none |
| Revisit date | 2026-12-04 | none |

Same decision, same advisory, two different qualities of evidence, and nothing
in the org propagates the better one. That gap — not the absence of scanners —
is what this ADR is about.

### What is already decided elsewhere

[`GOVERNANCE.md`](../../GOVERNANCE.md) (in flight, PR #1) already establishes the
one-architecture-document rule, the ADR format, and an SSDLC phase→control map
naming **six** phases with no control: Design, Develop (application code),
Verify (tests), Release, Deploy, Operate. This ADR does not restate any of that.
It records the rationale, and decides the five things that map leaves open.

## Decision

### 1. One architecture document per repo, plus ADRs. Nothing else.

`docs/architecture.md`, arc42-shaped, and `docs/adr/NNNN-slug.md`. There is no
third category.

| Existing shape | Becomes |
|---|---|
| An RFC | An ADR with `Status: Proposed` |
| `open-decisions.md` | The set of ADRs whose status is `Proposed` |
| `flows/`, `reference/` | A section of the architecture document, or generated output that is not checked in as prose |
| `plans/`, dated experiment logs | Not documentation. An issue, a PR body, or deleted |
| `design/`, `notes/` | Sections, or ADRs |

`runbooks/` is out of scope: an operational procedure is not architecture
documentation and keeps its own directory. Generated API reference is likewise
out of scope, provided it is generated.

`vsms` already demonstrates both halves of the first two rows: it carries
`docs/design/gdpr-engineering-readiness-adr.md` and a matching `-rfc.md`. Under
this rule they are one ADR at `docs/adr/`, and the RFC's undecided parts are
further ADRs with `Status: Proposed` — not a parallel `design/` directory.

### 2. Six mandatory arc42 sections. The other six are optional.

arc42 declares exactly one of its twelve sections non-optional — §5, the
Building Block View. Twelve mandatory sections *is* the overload this ADR guards
against, so the floor is set at six, not twelve and not one:

| § | Section | Why mandatory |
|---|---|---|
| 1 | Introduction and Goals | Includes the quality goals that §10's scenarios refine. Without it §10 has nothing to refine |
| 3 | Context and Scope | The trust boundary. Everything in §5 of the SSDLC map below is scoped by it |
| 5 | Building Block View — **level 1 only** | arc42's own mandatory section. Tip 5-3 notes level-1 "very often remains quite stable over time" with "little volatility"; deeper levels are optional because their maintenance cost is not stable |
| 8 | Crosscutting Concepts | Where the GDPR table (§5 below) and the extension-point contracts (§4 below) live |
| 10 | Quality Requirements | Scenarios, not adjectives. See §3 below |
| 11 | Risks and Technical Debt | Nearly free, and a known-broken, unfinished, or unverified thing left unstated is worse than one that is stated — the same reasoning decision 6 below applies to the 60 untriaged alerts this ADR opens with |

§9 Architecture Decisions is satisfied by the existence of `docs/adr/` and needs
no prose section — decision 1 above already makes that directory mandatory, so
a §9 that only points back at it would duplicate an artifact rather than add
one. §4 Solution Strategy stays optional: in a repo small enough for a one-page
architecture document it typically restates §1 and §5 rather than adding
content. See Open questions for the full reconciliation with `GOVERNANCE.md`,
which originally mandated §4 and §9 instead of §8 and §11.

Match the content a section carries, not its heading text. A repo whose whole
architecture fits on one page may satisfy §1/§3/§5 in three paragraphs; that is
a complete architecture document, not a stub.

### 3. Every quality scenario names its fitness function, or is marked review-only.

This is the load-bearing decision. Three bodies of practice meet here:

| Supplies | From |
|---|---|
| The scenario form: *stimulus → response → response measure* | iSAQB CPSA Foundation |
| The characteristic taxonomy the scenario is filed under | ISO/IEC 25010:2023 — nine characteristics (Functional Suitability, Performance Efficiency, Compatibility, Interaction Capability, Reliability, Security, Maintainability, Flexibility, Safety) |
| The measurement | The repo's own CI |

**ISO/IEC 25010, not 25001.** The two are adjacent standards in the same SQuaRE
family and are easy to confuse: 25010 is the quality *model* — the characteristic
taxonomy a scenario is tagged against, and the one this decision uses. 25001 is
SQuaRE's *planning and management* standard, governing how an organisation runs a
requirements-specification and evaluation function. That is an organisational
capability this org is not standing up, so 25001 is explicitly out of scope.
Recorded because the numbers are one digit apart and the question will be asked
again.

Each mandatory quality goal in §1 declares **3–5 scenarios** in §10. Each
scenario has a fourth column naming the automated check that enforces it, or
the literal value `review-only`.

> **A quality scenario without a fitness function is a claim. With one it is a
> control.**

`review-only` is a legitimate answer and must stay cheap to give — a rule that
forbids it produces scenarios chosen for measurability rather than importance.
What it must never be is blank.

This formalises existing practice rather than importing a new one. `vsms` already
runs fitness functions in all but name: of its sixteen `cargo xtask` subcommands,
eleven are pass/fail guards wired into three CI jobs — including `parity` (the
state diagrams and the transition tables must agree), `r6` (no CSS classes in a
view file) and `docs-drift` (every referenced path exists) — alongside 42
live-Postgres test files. What is missing is not the enforcement. It is the
column in §10 that says which quality goal each guard is enforcing. Naming them
costs a table, not a programme.

### 4. Extension seams are contracts, or they are not seams.

For any repo exposing a plugin, adapter, driver or provider interface:

| # | Requirement |
|---|---|
| 4.1 | The extension point is declared in §5. **An extension point that is not in the architecture document does not exist** — callers may not rely on it and it may be changed without notice |
| 4.2 | It is versioned independently of the host application, under semver |
| 4.3 | A conformance suite exists that a third-party implementor can run against their own implementation, without access to this org's private infrastructure |

The failure mode named here is an undocumented interface that moves: a seam real
enough that someone builds against it, unowned enough that nobody treats changing
it as breaking.

**This is the most expensive decision here, and nothing in the org satisfies it
today.** `vsms`'s `sms-provider` is the closest: a genuinely separate,
dependency-pure crate defining an `SmsProvider` trait with three adapters against
it. But its `Cargo.toml` reads `version.workspace = true` and inherits
`publish = false`, so it is versioned with the monorepo and never published —
4.2 is unmet. And no conformance suite exists anywhere in the org. `sms-fake-orange`
is sometimes mistaken for one; it is not. It is a fault-injecting fake of
*Orange's* external HTTP API, used to chaos-test vsms's own consuming code, and
its own module doc says so. A third-party implementing `SmsProvider` has nothing
to run. 4.2 and 4.3 are therefore new work wherever they apply, not
documentation of current practice — which is also why decision 4 binds only
repos that actually expose such a seam.

### 5. One GDPR table in §8, feeding three consumers.

Every repo processing personal data carries exactly one table in §8:

| Personal data item | Lawful basis | Retention | Cross-border |
|---|---|---|---|
| … | … | … | … |

It is the single source for three artifacts that otherwise drift apart: the
architecture document itself, the Article 30 Record of Processing Activities, and
any DPIA. One table, three readers — not three documents.

> **Evidence over artifacts.** Prefer compliance that falls out of something that
> had to be true anyway — an audit-anchoring hash chain, CI history, a dated ADR
> log, a `deny.toml` reason with a revisit date — over a document that is accurate
> on the day it is signed and decays from then on.

`vsms` is the worked example, and the reason this is a table rather than prose.
Every column's content already exists there — and in five different places, none
of them per data item:

| Column | Where it currently lives in `vsms` |
|---|---|
| Personal data item | Three `@pii` field markers in `schemas/vsms.cstack`, plus §2.5 |
| Lawful basis | §10, as prose: consent is opt-in and mandatory, and legitimate interest is not a recognised basis under Law No. 2024/017 |
| Retention | §10 and `backends/crates/sms-worker/src/jobs/purge_retention.rs` — 90 days, against Law No. 2010/012 Art. 25(1)'s ten years, a tension §10 records as resolved by decision, not by code |
| Cross-border | §10: all transfers require prior authorisation; host in Cameroon or obtain it |

The evidence is strong and the derivation is not written down. Answering a
regulator costs a re-reading of a 2,947-line document plus the schema plus a
worker job, every time, and no reader can tell whether the result is complete.
The closest existing artifact, `docs/legal/retention-briefing.md`, is a table of
the right shape but has gone stale: it still states that no purge job exists,
which stopped being true when `purge_retention` shipped. **The table is the
missing artifact, not the missing information** — and a stale table is the
failure mode to design against, which is why decision 5 puts it in §8 of the
architecture document rather than in a separate legal memo.

`vsms` reached the same conclusion independently on 2026-09-13: its
`docs/design/gdpr-engineering-readiness-adr.md` is accepted, and epic
[#377](https://github.com/vaam-apps/vsms/issues/377) opens six issues under it,
of which [#371](https://github.com/vaam-apps/vsms/issues/371) is exactly "define
personal-data inventory, purposes and retention map." All seven are open.
Decision 5 generalises that from one repo to the org and fixes where the output
lives; it does not invent it.

### 6. Close two SSDLC gaps. Accept three. Leave one to the repos.

Against `GOVERNANCE.md`'s six uncontrolled phases:

| Phase | Decision | Rationale |
|---|---|---|
| **Operate** | **Close — first.** Triage every open alert to fixed or dismissed-with-reason, then keep the open count at zero | 60 alerts across four repos; one dismissal reason written, ever. See below |
| **Design** | **Close.** A threat model per trust boundary (§3), triggered from the existing epic template rather than as a new ceremony | The boundary is already drawn in §3; the threat model is the paragraph that says what crosses it and what happens if something hostile does |
| Develop (application code) | Accept | Per-repo linters (clippy, biome) are correctly configured per repo. An org-wide secure-coding gate over seven languages would be weaker than what each repo already runs |
| Release, Deploy | Accept | Per-repo. `vsms` and `fyi` have real release pipelines with different shapes; a common gate would fit neither |
| Verify (tests) | Per-repo | Each repo runs its own suite. The org-level control is §3 above — that scenarios name checks — not a second test runner |

On Operate, plainly:

> **A scanner nobody reads is worse than no scanner. It manufactures a belief in
> coverage that does not exist.**

This is the only row with a deadline attached, because it is the only row whose
cost is hours rather than weeks.

### 7. Sequencing: cheapest real win first.

| Step | Work | Why here |
|---|---|---|
| a | **Triage the 60 open alerts.** No document, no template, no migration | The cheapest real security win available. It needs none of the rest of this ADR to start, and it is the only step whose value does not depend on the others landing |
| b | **`fyi` becomes the reference implementation** — add §10 with scenarios and fitness functions, add §11, renumber Glossary to §12 | Smallest delta to the target: already arc42-numbered, already one file, already carries four of the six mandatory sections. The missing two are §10 and §11, which is why the plan already adds both above |
| c | **`vpay`** — keep all 22 ADRs unchanged; fold `rfc/` and `open-decisions.md` into them as `Proposed`; fold `flows/` and `reference/` into `docs/architecture.md`; retire `plans/` | Highest sprawl, but also the most existing value. The ADRs are already in the target format; nothing about them changes |
| d | **`vsms`** — remap 16 bespoke sections onto arc42; move `docs/design/*-adr.md` into `docs/adr/`; coordinate the GDPR table with open epic #377 rather than duplicating it | Mostly a remap of an already-good document. §4 Security and §6 Provider abstraction become §8; §13 Risks becomes §11; §10 Compliance plus the stale `legal/retention-briefing.md` become the one §8 table, which is #371's deliverable |
| e | **`vaam-apps`, `image-resizer`, `ui`, `flutter-sign-keypair`** | Least ready, most work. For `ui` and `flutter-sign-keypair` a single page covering §1/§3/§5 may honestly be the whole architecture document, and that is a complete result, not a partial one |

`vsms` is deliberately not the reference implementation despite having the most
mature practice: its document is 2,947 lines, and a first example that long
teaches the wrong lesson.

## Consequences

### Costs

| Cost | Detail |
|---|---|
| **Migrating `vpay` is disruptive** | Ten doc areas collapse to two. Roughly 60 dated `plans/` subdirectories get deleted or demoted to issues, and someone has to decide which. Links break. `docs/README.md`, which is a router, stops having anything to route to |
| **A mandatory-section rule will be resisted** | Correctly, sometimes. The answer to "this section is empty" must be allowed to be "then the repo is small," not a filled-in stub. A rule whose result is six stub headings has made things worse |
| **Fitness functions are ongoing maintenance** | Each one is a check that can break, go stale, or be silently disabled. A scenario pointing at a check that no longer runs is worse than `review-only`, because it reads as coverage. This creates a recurring audit obligation the org does not have today |
| **The GDPR table is work nobody currently owns** | No repo has one. Filling it requires a lawful-basis determination per data item, which is a legal judgment, not an engineering one. Naming an owner per repo is a prerequisite, not a follow-up |
| **Decision 4 is new build, not documentation** | 4.2 and 4.3 are unmet everywhere. A published, independently versioned `sms-provider` means extracting a crate from a monorepo that currently versions everything in lockstep; a conformance suite means writing one from nothing. This is the decision most likely to be deferred, and deferring it silently is how the seam it protects stays undocumented |
| **Alert triage is not one-off** | Step (a) is hours. Keeping the count at zero is a standing cost, and the first week after adoption will produce a batch of `dismissed` decisions made under time pressure — exactly the conditions in which a bad dismissal reason gets written |
| **One document is not automatically a short document** | This rule bounds the *number* of documents, not their length. `vsms`'s single file is already 2,947 lines. Consolidating `vpay` into one file could produce something worse than the ten directories it replaced. §2's six-section floor is the only thing resisting that, and it is a floor, not a ceiling |

### Benefits

- A reader entering any repo knows where to look, and that it is one place.
- A quality goal with no check behind it becomes visible as such, instead of
  reading as covered.
- Triage produces dated, reasoned evidence usable in an audit, as a by-product of
  routine work — and an append-only ADR log replaces `open-decisions.md`,
  `status.md` and `plans/`.

### Explicitly not claimed

This ADR does not make the org compliant with anything. ISO/IEC 25010 is used as
a taxonomy, not a certification target. CPSA is a curriculum this org borrows a
technique from, not an accreditation anyone holds. GDPR compliance requires a
lawful-basis determination this document cannot make.

## Alternatives considered

**Adopt `GOVERNANCE.md`'s seven mandatory sections instead of this ADR's
original five.** The strongest alternative when this ADR was written, and the
one Open questions records as resolved rather than rejected outright:
`GOVERNANCE.md` originally mandated §1, §3, §4, §5, §9, §10, §11 and listed §8
as optional; this ADR originally mandated §1, §3, §5, §8, §10. The two agreed
on four and disagreed in both directions — §8 was not a detail, since decisions
4 and 5 of this ADR both place their content there, so mandating everything in
`GOVERNANCE.md`'s list while §8 stayed optional was incoherent. The resolution
did not split the difference: it adopted this ADR's own recommendation below in
full (§1, §3, §5, §8, §10, §11) — `GOVERNANCE.md`'s §4 and §9 stayed off the
mandatory list, and `GOVERNANCE.md` itself now defers to this ADR rather than
carrying a second copy. See Open questions for the full reasoning.

**Make `vsms` the reference implementation.** It has the most mature practice —
the xtask guards, the reasoned `deny.toml`, the correction-in-place discipline.
Rejected because its architecture document is 2,947 lines. An exemplar teaches
its length as much as its structure.

**Keep `vpay`'s structure and exempt it.** It is the org's most documented repo
and its shape may genuinely suit a payments domain with many surfaces.
`docs/api/` and `docs/sdks/` are reference material that is arguably not
architecture at all, and `flows/` — 26 files across six surfaces — may not
survive compression into one §6 without losing something. The counter-argument
is that an exemption for the largest repo makes the rule advisory everywhere.
This is the decision most likely to need revisiting after step (c) starts.

**Org-level RoPA instead of a table per repo.** Seven tables are seven things
that drift, and the Article 30 record is legally an org-level artifact, not a
per-repo one. Rejected because the lawful-basis and retention facts live with the
code that implements them; a central table decays faster because it is further
from the change that invalidates it. Weakly held.

**A threat model as its own ceremony rather than an epic-template field.**
Rejected as disproportionate. But the chosen option has a real weakness worth
stating: `issue-governance.yml` checks presence and non-emptiness only, so a
threat-model field is satisfied by the word "N/A". That is precisely the
manufactured-coverage failure decision 6 names, turned on this ADR's own
proposal. Mitigation is review, not automation, and review is what it was
already.

**Mandate a fitness function for every scenario, with no `review-only` escape.**
Rejected. It selects for scenarios that are cheap to measure over scenarios that
matter, and a quality model optimised for measurability drifts away from quality.
The cost of allowing `review-only` is that it can become the default; the §10
table makes that visible at a glance, which is the intended check.

**Do nothing org-wide; let each repo choose.** This is the status quo and it
produced six shapes across seven repos, the same advisory suppressed at two
different standards of evidence, and 60 unread alerts.

## Open questions

**1. Five mandatory sections, or seven? — Resolved.** This ADR and
`GOVERNANCE.md` (PR #1) disagreed while both were in flight. The table below
records what each originally proposed, kept for the record rather than deleted.

| § | This ADR (original proposal) | `GOVERNANCE.md` (original proposal) |
|---|---|---|
| 1 Introduction and Goals | mandatory | mandatory |
| 3 Context and Scope | mandatory | mandatory |
| 4 Solution Strategy | optional | mandatory |
| 5 Building Block View | mandatory (level 1) | mandatory |
| 8 Crosscutting Concepts | **mandatory** | **optional** |
| 9 Architecture Decisions | satisfied by `docs/adr/` | mandatory |
| 10 Quality Requirements | mandatory | mandatory |
| 11 Risks and Technical Debt | recommended | mandatory |

**Decision:** six mandatory sections — §1, §3, §5, §8, §10, §11 — matching this
ADR's own original recommendation in full, not a split of the two lists.
`GOVERNANCE.md` has been updated to stop restating the list and instead point
at decision 2 of this ADR as the single source of truth, so the two documents
cannot drift apart again the way they just did.

- **§8 Crosscutting Concepts became mandatory**, reversing `GOVERNANCE.md`'s
  original "optional": decisions 4 and 5 above both place their content there,
  so a repo could satisfy `GOVERNANCE.md`'s original seven-section list and
  still have nowhere to put the extension-point contracts or the GDPR table.
- **§11 Risks and Technical Debt became mandatory**, matching `GOVERNANCE.md`'s
  original list: it is nearly free, and `GOVERNANCE.md` is right that a known-
  broken, unfinished, or unverified thing left unstated is worse than one that
  is stated — the same reasoning behind triaging rather than hiding the 60 open
  alerts this ADR opens with.
- **§4 Solution Strategy stayed optional**, against `GOVERNANCE.md`'s original
  list: in a repo small enough for a one-page architecture document it
  typically restates §1 and §5 rather than adding content, and a mandatory
  section that is routinely a restatement produces exactly the stub-heading
  failure the Costs table above warns against.
- **§9 Architecture Decisions stayed satisfied by the existence of
  `docs/adr/`**, against `GOVERNANCE.md`'s original list: decision 1 above
  already makes that directory mandatory for every repo, so a prose §9 that
  only points back at it would duplicate an artifact instead of adding one —
  the same "evidence over artifacts" reasoning decision 5 states explicitly.

This is unchanged from the recommendation this ADR already recorded here
before either document merged: six sections, §9 satisfied by the directory
rather than duplicated as prose, §4 left optional. Whichever of this ADR and
PR #1 merged second was always going to need to reconcile the other; this
edit is that reconciliation, not a change of position.

**2. Who owns the GDPR table in each repo?** Unassigned. Lawful basis is a legal
determination, and under Law No. 2024/017 it is a narrow one — `vsms`'s §10
records that legitimate interest is not available, so nearly everything rests on
consent that must actually have been captured. Until an owner is named per repo,
decision 5 has no route to being executed, and naming that owner is a
prerequisite to step (b), not a follow-up to it.

**3. What is the target for `vsms`'s 47 alerts, and by when?** Decision 6 says
triage; it does not set a date. Proposed: all four repos to zero open alerts
before step (b) begins, so that the reference implementation is built in a repo
with a clean board.
