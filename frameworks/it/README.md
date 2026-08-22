# ITIP — IT Intelligence Platform Domain Vocabulary

## Model Identification

| Field | Value |
|-------|-------|
| **Model** | ITIP (IT Intelligence Platform) |
| **Source Standards** | CRUD (James Martin, 1983); SCAP CPE 2.3 (NIST) |
| **Scope** | ITIP's own universal vocabulary — effector operation semantics (CRUD), technology identification, governance sourcing infrastructure |
| **Schema Count** | 7 |

## Purpose

ITIP is the **domain-native model** for IT software governance. This framework contains ITIP's **own universal vocabulary** — concepts that are not sourced from a single external protocol or standard but form the cross-cutting vocabulary that protocol-specific frameworks reference.

Protocol-specific schemas (HTTP, gRPC, GraphQL, Kafka, AMQP, WebSocket, JDBC) have been moved to their own dedicated frameworks. Data format schemas (EIP, CloudEvents, DDD) likewise reside in their own frameworks.

## What Stays Here

| Category | Schemas | Why here (not in a protocol framework) |
|----------|---------|---------------------------------------|
| **CRUD Effector Semantics** | CreateEffector, ReadEffector, UpdateEffector, DeleteEffector | Universal operation taxonomy — not owned by any single protocol. HTTP verbs, JDBC statement types, Kafka operations all reference these as supertype. |
| **Technology Identification** | SoftwareTechnology | Cross-cutting technology classification (31-type enum), not specific to any protocol. |
| **Governance Sourcing** | SourcedDirective, SourcedNorm | Templates for sourcing governance from external authorities — framework-independent. |

## Model-Native Taxonomy

```
itip/
  effector-semantics/      # Unitary CRUD operation archetypes
  technology/              # Technology platform identification
  governance/              # Governance sourcing infrastructure
```

## Schema Inventory

### effector-semantics/ (4 schemas)

Unitary CRUD operations. Each archetype extends Effector with **no additional properties** — the archetype title IS the operation classification.

| Schema | Extends | $id | Source |
|--------|---------|-----|--------|
| CreateEffector | Effector | `gsmarc://gsm-frameworks/CreateEffector/v1` | CRUD (James Martin, 1983) |
| ReadEffector | Effector | `gsmarc://gsm-frameworks/ReadEffector/v1` | CRUD (James Martin, 1983) |
| UpdateEffector | Effector | `gsmarc://gsm-frameworks/UpdateEffector/v1` | CRUD (James Martin, 1983) |
| DeleteEffector | Effector | `gsmarc://gsm-frameworks/DeleteEffector/v1` | CRUD (James Martin, 1983) |

**Cross-referenced by protocol frameworks:**

- HTTP per-verb effectors extend these via `$ref` (e.g., HTTPPostRequestEffector → CreateEffector)
- JDBC JDBCQueryRequestEffector extends ReadEffector
- Other protocols reference via multi-Ascription

### technology/ (1 schema)

| Schema | Extends | $id | Source |
|--------|---------|-----|--------|
| SoftwareTechnology | ScapPlatformIdentifier (rootless) | `gsmarc://gsm-frameworks/SoftwareTechnology/v1` | SCAP CPE 2.3 (NIST) + ITIP |

### governance/ (2 schemas)

| Schema | Extends | $id | Purpose |
|--------|---------|-----|---------|
| SourcedDirective | Directive | `gsmarc://gsm-frameworks/SourcedDirective/v1` | Template for directives sourced from external authorities |
| SourcedNorm | Norm | `gsmarc://gsm-frameworks/SourcedNorm/v1` | Template for norms sourced from external authorities |

## Cross-Framework Articulation

| ITIP Concept | Referenced By | Pattern |
|--------------|--------------|---------|
| CRUD effectors | HTTP, JDBC, Kafka, AMQP, gRPC, GraphQL frameworks | `$ref` extension or multi-Ascription |
| SoftwareTechnology | TOGAF TechnologyComponent, SCAP CPE | Technology classification for any Structure |
| SourcedDirective / SourcedNorm | GDPR, NIS2, ISO frameworks | Concrete governance instances extend these templates |
