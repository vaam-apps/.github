---
name: Epic
about: A large initiative spanning multiple user stories, representing a meaningful business or technical objective. Source of truth — https://adorsys-gis.github.io/ai-governance/01-epic-template
title: "Epic: "
labels: epic
---

<!--
Use this when the work is large, spans multiple tickets, and represents a
meaningful business or technical objective.

This template reproduces the ADORSYS-GIS ai-governance epic template
(https://adorsys-gis.github.io/ai-governance/01-epic-template). Read the
Working Agreement (https://adorsys-gis.github.io/ai-governance/12-ai-working-agreement)
and the Doctrine (https://adorsys-gis.github.io/ai-governance/13-doctrine)
before filling this in.

An epic exists to solve a real problem — not merely to produce code, tickets,
documentation, or AI-generated artifacts.

Delete this comment block before submitting.
-->

## 1. Executive Summary

We want to [describe the desired outcome] because [describe the business, user, operational, or technical reason].

This epic exists to solve: [describe the real problem].

It does not exist to merely produce code, tickets, documentation, or AI-generated artifacts.

---

## 2. Strategic Intent

The intent of this epic is:

> [Write the core intention in 1–3 sentences.]

A person must be able to explain this intent verbally without reading this document.

---

## 3. Problem Statement

Currently:

* [Current pain/problem 1]
* [Current pain/problem 2]
* [Current pain/problem 3]

This causes:

* [Impact on users/customers]
* [Impact on developers/operations]
* [Impact on business/security/compliance]

---

## 4. Desired Outcome

When this epic is complete:

* [Outcome 1]
* [Outcome 2]
* [Outcome 3]

Success means that [describe observable improvement].

---

## 5. Scope

### In Scope

* [Item clearly included]
* [Item clearly included]
* [Item clearly included]

### Out of Scope

* [Item explicitly excluded]
* [Item explicitly excluded]
* [Item explicitly excluded]

Anything not listed in scope must be clarified before implementation.

---

## 6. Source of Truth

The following sources define the real intent of this epic. Prefer the repository's own architecture document (one per repo) or an ADR over a chat log, a ticket restating itself, or an AI-generated summary — an architecture doc is reviewed and kept current; those are not:

* Architecture document / ADR: [link]
* Product decision: [link]
* Customer request / stakeholder input: [link]
* Incident / bug / operational evidence: [link]
* Design / mockup: [link]
* Compliance / security requirement: [link]

If no source of truth exists, this epic is not ready.

---

## 7. Stakeholders

| Role                  | Name   | Responsibility                            |
| --------------------- | ------ | ------------------------------------------ |
| Product Owner         | [Name] | Owns product intent and priority          |
| Technical Lead        | [Name] | Owns architecture and technical direction |
| Delivery Owner        | [Name] | Owns planning and coordination            |
| Security / Compliance | [Name] | Owns risk constraints                     |
| Engineering Team      | [Team] | Owns implementation and verification      |

---

## 8. Key Assumptions

We currently assume that:

* [Assumption 1]
* [Assumption 2]
* [Assumption 3]

Each assumption must be validated, rejected, or converted into a risk before delivery.

---

## 9. Constraints

arc42/CPSA groups constraints into technical, organizational, and conventions — state what applies to this epic:

* Technical: [technology, platform, integration, or security constraints]
* Organizational: [timeline, budget, team, or dependency constraints]
* Conventions: [compliance, coding, or architecture-decision constraints]

---

## 10. Risks

| Risk     |         Probability |              Impact | Mitigation   |
| -------- | -------------------: | -------------------: | ------------ |
| [Risk 1] | Low / Medium / High | Low / Medium / High | [Mitigation] |
| [Risk 2] | Low / Medium / High | Low / Medium / High | [Mitigation] |
| [Risk 3] | Low / Medium / High | Low / Medium / High | [Mitigation] |

SSDLC: does this epic open a new trust boundary, external interface, or store of PII/secrets? If so, a threat model (e.g. STRIDE) is required before implementation starts. [yes/no — link the threat model if yes]

---

## 11. Non-Functional Requirements (Quality Attributes)

This epic must consider these quality attributes (ISO/IEC 25010, per arc42/CPSA §10). Where a goal is measurable, state it as a quality scenario — stimulus, response, response measure:

* Performance efficiency: [expectation or scenario]
* Security: [expectation or scenario]
* Reliability: [expectation or scenario]
* Observability: [logs, metrics, traces]
* Maintainability: [expectation or scenario]
* Accessibility: [if applicable]
* Data privacy: [if applicable]

---

## 12. Success Metrics

We will know this epic succeeded if:

| Metric     | Current Value | Target Value | Measurement Source |
| ---------- | -------------: | -------------: | ------------------- |
| [Metric 1] |           [x] |          [y] | [source]           |
| [Metric 2] |           [x] |          [y] | [source]           |
| [Metric 3] |           [x] |          [y] | [source]           |

Avoid vanity metrics. Measure outcomes, not activity.

---

## 13. Child User Stories

* [ ] [Story 1]
* [ ] [Story 2]
* [ ] [Story 3]
* [ ] [Story 4]

Each child story must have its own acceptance criteria and verification evidence.

---

## 14. AI Usage Declaration

AI was used for:

* [ ] Drafting
* [ ] Summarization
* [ ] Research
* [ ] Ticket decomposition
* [ ] Technical proposal
* [ ] Not used

Human verification completed:

* [ ] Intent checked against source of truth
* [ ] Scope reviewed by Product Owner
* [ ] Technical feasibility reviewed by Technical Lead
* [ ] Risks reviewed
* [ ] Acceptance criteria reviewed
* [ ] No unverified AI claim remains

Human accountable owner: [Name]

---

## 15. Definition of Ready

This epic is ready only when:

* [ ] The strategic intent is clear
* [ ] Scope and out-of-scope are explicit
* [ ] Source of truth is linked
* [ ] Stakeholders are identified
* [ ] Major risks are documented
* [ ] Success metrics are defined
* [ ] Child stories are identified or planned
* [ ] Human owner has reviewed all AI-generated content

---

## 16. Definition of Done

This epic is done only when:

* [ ] All child stories are completed
* [ ] Acceptance criteria are satisfied
* [ ] Success metrics have been measured or scheduled for measurement
* [ ] Documentation is updated
* [ ] Operational impact is reviewed
* [ ] Security/compliance impact is reviewed
* [ ] Stakeholders have accepted the result
* [ ] Lessons learned are documented
