# PROJECT_BRIEF.md — gsm-frameworks

> Last updated: 2026-07-27 | Sprint 0 | Status: Design Phase

## 1. Project Overview

`gsm-frameworks` is the published, versioned repository of **sourced governance/compliance/architecture/regulatory framework schemas** for the IT Intelligence Platform (ITIP). It was extracted from the private `itip` repository's `def/frameworks/` directory (269 files at extraction) so that the sourced vocabulary can be distributed, versioned, and consumed independently of ITIP's private design-time IP.

It sits under the **GSM solution umbrella** (`gsm/`) alongside `gsm-specifications`, the normative model it is expressed against.

## 2. Concept / Product Description

Content here is **schema, not application logic**: JSON Schema archetypes and Directive/Norm ascription instances sourced from external standards (TOGAF, ISO/IEC 25000 series, GDPR, NIS2, SCAP, RFC 9110, aDRI-IRN, and reserved protocol quads for gRPC/GraphQL/Kafka/AMQP/WebSocket/JDBC). Each framework is organized by its **own taxonomy** (P9 — model-native organization, not GSM subject-type classification), and composes with other models exclusively through the GSM governance layer (Directives qualifying Subjects using archetypes from different models) — never through schema-level cross-references.

## 3. Tech Stack

- Plain JSON Schema (2020-12 draft, `gsmarc://` custom `$id` scheme)
- No build step, no runtime — consumed by the SIE Definition Manager at ascription-ingestion time
- Validated ad hoc with `python -m json.tool` / any JSON Schema validator; no CI configured yet

## 4. Architecture

This repo has no execution architecture of its own. It is a **content source** read by:

1. **ITIP** (`itip-definition-blackboard-repository-sourcer` or manual authoring) — posts Contributions referencing these archetypes.
2. **SIE Definition Manager** — validates ascription statements against these schemas at `POST /api/v1/ascriptions` time.

## 5. Key Files Map

| Area | Path | Contents |
| ------ | ------ | ---------- |
| Inter-model composition | `frameworks/README.md` | Composition principle, dynamic/static paradigm, articulation maps |
| ITIP domain archetypes | `frameworks/itip/` | SourcedDirective, SourcedNorm, meta-governance mechanisms |
| Sourced frameworks | `frameworks/{authority}/` | One folder per authority (togaf, iso25000, gdpr, nis2, scap, http, ...) |

## 6. Team Roles

This repo is content-only (no dev/QA sprint cycle in the application sense). Maintenance follows the same team pattern as sibling Poesis repos:

| Agent | Name | Role |
| ------- | ------ | ------ |
| Producer | **Remy** | Sourcing backlog, provenance review, GitHub Issues |
| Dev | **Nova / Sage / Milo** | Author/update schemas, maintain inter-model articulation docs |
| QA | **Ivy** | Schema validity checks, provenance citation review |

## 7. Sprint Status

| Sprint | Name | Status | Scope |
|--------|------|--------|-------|
| 0 | Extraction | Done | Repo scaffold, content moved from `itip/def/frameworks/` |

## 8. Current State (rewrite every sprint)

**What works:**

- Full sourced schema set for TOGAF, ISO 25000, NIS2, GDPR, SCAP, HTTP, ITIP domain archetypes; reserved README-only placeholders for aDRI-IRN, gRPC, GraphQL, Kafka, AMQP, WebSocket, JDBC.

**What does not work yet:**

- No CI/validation pipeline configured.
- No automated cross-check that `gsmarc://gsm-frameworks/...` `$id` values stay unique across the corpus.

**What is next:**

- Add a JSON Schema lint/validate CI job.

## 9. Security Rules

1. No secrets in this repo (schema/content only).
2. Do not reproduce copyrighted standards text verbatim beyond short quotation — see `CONTRIBUTING.md`.

## 10. How to Validate Locally

```bash
# Validate a single schema is well-formed JSON
python -m json.tool frameworks/togaf/governance/Driver.schema.json
```
