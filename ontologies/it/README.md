# IT — Domain Ontology

## Ontology Identification

| Field | Value |
|-------|-------|
| **Ontology** | IT domain ontology (`it`) |
| **Layer** | domain |
| **Composes** | togaf, iso25000, gdpr, nis2, scap, http, oidc, prov |
| **Consumed by** | Organizational Intelligence Platform (OIP) |

## Purpose

The IT domain ontology is the **integrator for the IT domain**. Reference ontologies
are isolated — they reference only GSM — so composing them into a
coherent governance fabric is this ontology's job:

1. **Composition** — `ontology-package.json#composes` declares the reference ontologies
   integrated for the IT domain.
2. **Materialization** — each TOGAF architecture-stratum concept is composed directly
   as an IT domain archetype: it `$ref`s the TOGAF concept and mounts every applicable
   facet from the other composed reference ontologies as an optional named property
   (the facet mount rule — see the root README), so a subject's full qualification
   surface is readable from its typing archetype alone.
3. **Domain vocabulary** — IT-native concepts that belong to no single external
   authority.

## v1 Scope

v1 materializes the **application, business, data, and technology architecture**
strata only (33 composites, 1:1 with the corresponding `togaf/*-architecture/`
folders). ADM and Governance are out of scope for v1 and are not materialized here;
the underlying `togaf/adm/` and `togaf/governance/` reference archetypes are
unaffected and remain directly usable as qualifiers/typing archetypes.

## Materialized Composites

Each composite under `it/{stratum}/{Concept}.archetype.json`:

- `$ref`s its TOGAF concept (based concepts keep their GSM-base chain; rootless ones
  stay rootless — qualifier/data roles only);
- mounts every applicable facet as **optional named properties** keyed by
  lowerCamelCase of the facet's title (the catalogue's facet mount rule): identity
  (`platformIdentifier`, `configurationSetting`), quality (matching ISO 2501x family),
  provenance (`attribution` universally; `association`/`delegation` on agent-bearing
  subjects).

DM closure then *enforces composition at runtime*: an unmounted facet on an instance is
rejected as an unevaluated property. The files are hand-authored today; multi-layer
ascription remains available where an independent per-dimension lifecycle matters.

Schema-level `allOf` composition stays a per-need decision at this layer.

## Domain-Native Taxonomy

```text
it/
  application-architecture/   # 7 composites, 1:1 with togaf/application-architecture/
  business-architecture/      # 13 composites, 1:1 with togaf/business-architecture/
  data-architecture/          # 3 composites, 1:1 with togaf/data-architecture/
  technology-architecture/    # 10 composites, 1:1 with togaf/technology-architecture/
```

> The former `meta-governance/` appraisal vocabulary and mechanisms have been archived
> (unused, out of v1 scope) to `gsm/archive/meta-governance/` in the parent `gsm`
> umbrella repository. The former `technology/SoftwareTechnology` self-defined
> technology-type taxonomy has been dropped; technology identification relies on the
> standards-based `scap/PlatformIdentifier` (NIST CPE) directly, mounted where
> applicable (e.g. `technology-architecture/TechnologyComponent`).

## Layering Rules Applied Here

- This ontology may reference GSM and any composed reference
  ontology — never a sibling domain ontology.
- It never mutates or shadows reference concepts; it qualifies, composes, and maps them.
- Checked by `scripts/lint_layers.py`.
