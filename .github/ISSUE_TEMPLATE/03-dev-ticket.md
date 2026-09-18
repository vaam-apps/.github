---
name: Development Ticket
about: Implementation work, bugs, refactors, technical tasks, spikes, or operational work. Source of truth — https://adorsys-gis.github.io/ai-governance/03-dev-ticket-template
title: "Ticket: "
labels: ticket
---

<!--
Use this for implementation work, bugs, refactors, technical tasks, spikes, or
operational work.

This template reproduces the ADORSYS-GIS ai-governance development ticket
template (https://adorsys-gis.github.io/ai-governance/03-dev-ticket-template).
Read the Working Agreement
(https://adorsys-gis.github.io/ai-governance/12-ai-working-agreement) and the
Doctrine (https://adorsys-gis.github.io/ai-governance/13-doctrine) before
filling this in.

If the developer cannot explain the intent, the ticket is not ready.

Delete this comment block before submitting.
-->

## 1. Type

Select one:

* [ ] Feature
* [ ] Bug
* [ ] Refactor
* [ ] Technical debt
* [ ] Spike / Investigation
* [ ] Security
* [ ] Performance
* [ ] Documentation
* [ ] Operational task

---

## 2. Summary

We need to [do what] because [why].

Expected result:

> [Describe the expected result in plain but precise language.]

---

## 3. Intent

The real intention of this ticket is:

> [Explain the purpose behind the task.]

If the developer cannot explain this intent, the ticket is not ready.

---

## 4. Source of Truth

This ticket comes from:

* Epic / Story: [link]
* Product decision: [link]
* Bug report / incident: [link]
* Customer request: [link]
* Architecture decision: [link]
* Technical investigation: [link]
* Security requirement: [link]

No source of truth means this ticket must be challenged.

---

## 5. Current Behavior

Today, the system behaves like this:

* [Current behavior 1]
* [Current behavior 2]
* [Current behavior 3]

Evidence:

* Logs: [link]
* Screenshot: [link]
* Error message: [link]
* Metric: [link]
* User report: [link]

---

## 6. Expected Behavior

After this ticket is completed:

* [Expected behavior 1]
* [Expected behavior 2]
* [Expected behavior 3]

---

## 7. Acceptance Criteria

* [ ] Given [context], when [action], then [expected result].
* [ ] Given [context], when [action], then [expected result].
* [ ] Given [context], when [action], then [expected result].
* [ ] Error cases are handled safely.
* [ ] Existing behavior is not broken.
* [ ] Relevant tests are added or updated.
* [ ] Verification evidence is provided.

---

## 8. Out of Scope

This ticket does not include:

* [Excluded item 1]
* [Excluded item 2]
* [Excluded item 3]

Do not silently implement out-of-scope work.

---

## 9. Technical Context

Relevant files, services, modules, or systems:

* [File/service/module 1]
* [File/service/module 2]
* [File/service/module 3]

Important technical notes:

* [Note 1]
* [Note 2]
* [Note 3]

Known constraints:

* [Constraint 1]
* [Constraint 2]
* [Constraint 3]

---

## 10. Risks

Potential risks:

* [Risk 1]
* [Risk 2]
* [Risk 3]

Risk mitigation:

* [Mitigation 1]
* [Mitigation 2]
* [Mitigation 3]

---

## 11. Implementation Plan

Proposed steps:

1. [Step 1]
2. [Step 2]
3. [Step 3]
4. [Step 4]

Before coding, the assignee must confirm whether this plan is still valid.

---

## 12. Test Plan

Required checks:

* [ ] Unit tests
* [ ] Integration tests
* [ ] End-to-end tests
* [ ] Manual verification
* [ ] Regression verification
* [ ] Security verification
* [ ] Performance verification

Commands to run:

```bash
[command 1]
[command 2]
[command 3]
```

Expected result:

```text
[expected test result]
```

---

## 13. Verification Evidence

Before moving this ticket to Done, provide:

* Test output: [paste or link]
* Manual verification steps: [details]
* Screenshot / video: [link, if relevant]
* Logs checked: [details]
* Metrics checked: [details]
* Known remaining limitations: [details]

---

## 14. AI Usage Declaration

AI was used for:

* [ ] Drafting the ticket
* [ ] Understanding code
* [ ] Proposing implementation
* [ ] Generating code
* [ ] Refactoring
* [ ] Generating tests
* [ ] Reviewing the diff
* [ ] Writing documentation
* [ ] Not used

Human verification completed:

* [ ] I understood the intent
* [ ] I checked the source of truth
* [ ] I reviewed all AI-generated text/code
* [ ] I verified the implementation manually
* [ ] I verified the tests
* [ ] I checked for hallucinated assumptions
* [ ] I documented remaining risks

Human accountable owner: [Name]

---

## 15. Developer Pre-Flight Checklist

Before starting:

* [ ] I can explain the intent in my own words
* [ ] I know what is in scope
* [ ] I know what is out of scope
* [ ] I checked the source of truth
* [ ] I identified assumptions
* [ ] I know how to verify the work
* [ ] I know who to ask if intent is unclear

---

## 16. Reviewer Checklist

Reviewer must check:

* [ ] The implementation matches the intent
* [ ] The acceptance criteria are satisfied
* [ ] Tests are meaningful, not superficial
* [ ] AI-generated code was not blindly accepted
* [ ] Error handling is appropriate
* [ ] Security and privacy risks are considered
* [ ] The change is maintainable
* [ ] The verification evidence is credible
* [ ] The PR does not include unnecessary refactoring
* [ ] The work does not exceed the ticket scope

---

## 17. Definition of Ready

This ticket is ready only when:

* [ ] Intent is clear
* [ ] Source of truth is linked
* [ ] Acceptance criteria are testable
* [ ] Scope and out-of-scope are clear
* [ ] Dependencies are identified
* [ ] Risks are documented
* [ ] Assumptions are visible
* [ ] AI-generated content has been reviewed by a human

---

## 18. Definition of Done

This ticket is done only when:

* [ ] Acceptance criteria are met
* [ ] Tests pass
* [ ] Verification evidence is attached
* [ ] Code review is complete
* [ ] Documentation is updated, if needed
* [ ] Monitoring/logging is updated, if needed
* [ ] No unresolved blocker remains
* [ ] Human owner accepts responsibility for the final result
