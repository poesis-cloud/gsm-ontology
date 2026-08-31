# OIDC — OpenID Connect Identity Vocabulary

## Model Identification

| Field | Value |
|-------|-------|
| **Model** | OpenID Connect Core 1.0 (OpenID Foundation) |
| **Source** | [OpenID Connect Core 1.0](https://openid.net/specs/openid-connect-core-1_0.html), §2 (ID Token claims: `iss`, `sub`) |
| **Layer** | reference |
| **Schema Count** | 1 |

## Purpose

Identity vocabulary for ascription statements, sourced from OIDC's own claim model —
and **only** what OIDC defines. OIDC Core 1.0 is an identity layer on top of the OAuth
2.0 protocol; it defines End-User authentication and identity claims. It does not
define authorship, ownership, or resource-access roles.

**Sourced now:**

| Concept | OIDC source | GSM mapping | File |
|---------|-------------|-------------|------|
| Subject identity | Core §2 — `sub` (Subject Identifier, locally unique and never reassigned within the Issuer) + `iss` (Issuer Identifier) | Rootless facet (object shape) | `id-token/Subject.archetype.json` |

**Candidates (not yet sourced):** ID Token (full claim set: `aud`, `exp`, `iat`,
`auth_time`, `acr`, `amr`, `azp`), Standard Claims (§5.1 profile/email/address/phone
scopes), UserInfo. Sourced on demand.

## Composition

`Subject` is a *shape* facet: it declares what an OIDC-identified subject looks
like, not where it appears. Placement is a composition decision made outside this
framework (see the catalogue composition documentation).
