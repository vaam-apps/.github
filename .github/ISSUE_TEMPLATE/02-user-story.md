---
name: User Story
about: A user need or a valuable capability, with testable acceptance criteria. Source of truth — https://adorsys-gis.github.io/ai-governance/02-user-story-template
title: "User Story: "
labels: story
---

<!--
Use this when the work describes a user need or a valuable capability.

This template reproduces the ADORSYS-GIS ai-governance user story template
(https://adorsys-gis.github.io/ai-governance/02-user-story-template). Read the
Working Agreement (https://adorsys-gis.github.io/ai-governance/12-ai-working-agreement)
and the Doctrine (https://adorsys-gis.github.io/ai-governance/13-doctrine)
before filling this in.

This story is not ready if the intention is only copied from an AI-generated
summary.

Delete this comment block before submitting.
-->

## 1. Story Statement

As a [type of user / actor],
I want [capability / action],
so that [benefit / outcome].

---

## 2. Real Intent

The real intention behind this story is:

> [Explain why this story matters.]

This story is not ready if the intention is only copied from an AI-generated summary.

---

## 3. Background and Context

Currently:

* [Current behavior]
* [Current limitation]
* [Current pain]

We need to change this because:

* [Reason 1]
* [Reason 2]
* [Reason 3]

---

## 4. Source of Truth

This story is based on — prefer the repository's own architecture document (one per repo) or an ADR over a chat log, a ticket restating itself, or an AI-generated summary:

* Architecture document / ADR: [link]
* Customer / user request: [link]
* Product decision: [link]
* Design: [link]
* Incident / bug report: [link]
* Data / metric: [link]

If the source of truth is missing, the story must not enter sprint planning.

---

## 5. Acceptance Criteria

### Functional Criteria

* [ ] Given [context], when [action], then [expected result].
* [ ] Given [context], when [action], then [expected result].
* [ ] Given [context], when [action], then [expected result].

### Negative / Edge Cases

* [ ] Given [invalid/unusual condition], when [action], then [safe expected result].
* [ ] Given [failure condition], when [action], then [error handling behavior].
* [ ] Given [permission/security condition], when [action], then [access behavior].

### Non-Functional Criteria (Quality Attributes)

* [ ] Performance efficiency, as a quality scenario where measurable (stimulus → response → response measure): [details]
* [ ] Security — does this touch authn/authz, secrets, PII, or an external interface?: [details]
* [ ] Logging / observability expectation: [details]
* [ ] Accessibility expectation: [details, if applicable]
* [ ] Compatibility expectation: [details]

---

## 6. Out of Scope

This story does not include:

* [Excluded item 1]
* [Excluded item 2]
* [Excluded item 3]

If someone wants these items, they must create a separate story.

---

## 7. Dependencies

This story depends on:

* [Dependency 1]
* [Dependency 2]
* [Dependency 3]

Blocked by:

* [Blocker 1]
* [Blocker 2]

---

## 8. Assumptions

We assume that:

* [Assumption 1]
* [Assumption 2]
* [Assumption 3]

Before implementation, the developer must decide whether each assumption is acceptable or needs clarification.

---

## 9. Implementation Notes

Suggested approach:

* [Technical note 1]
* [Technical note 2]
* [Technical note 3]

Constraints this approach must respect (arc42/CPSA §2 — technical, organizational, conventions): [details]

These notes are guidance, not unquestionable truth.

The developer may challenge this implementation approach if there is a safer, simpler, or more maintainable option.

---

## 10. Test Expectations

The implementation should include:

* [ ] Unit tests
* [ ] Integration tests
* [ ] End-to-end tests
* [ ] Manual verification
* [ ] Regression tests
* [ ] Security tests
* [ ] Performance checks

Required test cases:

* [Test case 1]
* [Test case 2]
* [Test case 3]

---

## 11. Verification Evidence

Before closing this story, provide:

* Test results: [link / command / screenshot]
* Manual verification notes: [details]
* Logs / metrics checked: [details]
* Screenshots or recordings: [link, if relevant]
* Reviewer focus areas: [details]

No verification evidence means the story is not done.

---

## 12. AI Usage Declaration

AI was used for:

* [ ] Drafting this story
* [ ] Refining acceptance criteria
* [ ] Suggesting implementation
* [ ] Generating code
* [ ] Generating tests
* [ ] Reviewing code
* [ ] Not used

Human verification completed:

* [ ] I checked the story against the source of truth
* [ ] I confirmed the acceptance criteria
* [ ] I reviewed the implementation approach
* [ ] I verified generated code manually
* [ ] I verified generated tests manually
* [ ] I removed or corrected unsupported AI claims

Human accountable owner: [Name]

---

## 13. Definition of Ready

This story is ready only when:

* [ ] The user, need, and benefit are clear
* [ ] The real intent is documented
* [ ] Source of truth is linked
* [ ] Acceptance criteria are testable
* [ ] Out-of-scope is explicit
* [ ] Dependencies are identified
* [ ] Assumptions are documented
* [ ] Product Owner has reviewed the story
* [ ] Technical Lead has reviewed risky implementation notes, if needed
* [ ] AI-generated content has been reviewed by a human

---

## 14. Definition of Done

This story is done only when:

* [ ] All acceptance criteria are satisfied
* [ ] Required tests are implemented and passing
* [ ] Manual verification is documented
* [ ] Code review is completed
* [ ] Security impact is considered
* [ ] Documentation is updated, if needed
* [ ] Observability is added or confirmed, if needed
* [ ] No unresolved assumptions remain
* [ ] Product Owner accepts the result
