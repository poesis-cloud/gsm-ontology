# OAuth 2.0 — Authorization Framework (Reserved)

## Model Identification

| Field | Value |
|-------|-------|
| **Model** | OAuth 2.0 Authorization Framework (IETF) |
| **Source** | [RFC 6749](https://www.rfc-editor.org/rfc/rfc6749) (+ RFC 6750 Bearer Token Usage) |
| **Layer** | reference |
| **Schema Count** | 0 — **Reserved (README only)**. Schemas authored when first sourced. |

## Concept map (planned)

| OAuth 2.0 concept | RFC 6749 | GSM mapping (planned) |
|-------------------|----------|------------------------|
| Resource Owner | §1.1 | Structure — "an entity capable of **granting access** to a protected resource; when the resource owner is a person, it is referred to as an end-user". An access-delegation role |
| Client | §1.1 | Structure |
| Authorization Server | §1.1 | Structure |
| Resource Server | §1.1 | Structure |
| Access Token | §1.4 | Data archetype |
| Refresh Token | §1.5 | Data archetype |
| Authorization Grant (code, implicit, password, client credentials) | §1.3 | Interaction patterns / data archetypes |
| Scope | §3.3 | Rootless qualifier facet |

## Relation to OIDC

OpenID Connect Core 1.0 describes itself as "a simple identity layer on top of the
OAuth 2.0 protocol". Per reference isolation, neither framework's schemas reference
the other's; their articulation is declared at the composing layer.
