# IT — Domain Framework

## Framework Identification

| Field | Value |
|-------|-------|
| **Framework** | IT domain framework (`it`) |
| **Layer** | domain |
| **Composes** | togaf, iso25000, gdpr, nis2, scap, http, oidc, prov |
| **Consumed by** | IT Intelligence Platform (ITIP) |

## Purpose

The IT domain framework is the **integrator for the IT domain**. Reference frameworks
are isolated — they reference only GSM — so composing them into a
coherent governance fabric is this framework's job:

1. **Composition** — `framework.json#composes` declares the reference frameworks
   integrated for the IT domain.
2. **Ontology** — [`ontology.json`](ontology.json) is the IT ontology (v1): the
   integrated view of **all** togaf, scap, iso25000, and prov concepts as one subject
   taxonomy articulated along four orthogonal dimensions (see below).
3. **Articulation** — [`articulations.json`](articulations.json) is the machine-readable
   pairwise articulation map (concept-level mappings such as *TOGAF
   ArchitecturePrinciple qualifies-with ISO 25010 ProductReliability*), including the
   regulatory overlays (gdpr, nis2) that sit on top of the ontology. Reference
   frameworks never encode these relations; tooling and AI traverse them here.
4. **Domain vocabulary** — IT-native concepts that belong to no single external
   authority.

## IT Ontology (v1)

The ontology organizes the 110 concepts of the four priority reference frameworks as
**one subject taxonomy under four orthogonal dimensions**:

| Dimension | Framework | Question it answers |
|-----------|-----------|---------------------|
| **structure** | togaf (58) | What is the IT landscape made of? — the subject taxonomy |
| **identity** | scap (2) | How is a subject named and configured? — CPE / CCE |
| **quality** | iso25000 (39) | How well does a subject perform? — 25010 / 25011 / 25012 |
| **provenance** | prov (11) | Who bears responsibility, whence does it derive? — PROV |

Dimensions are connected by **typed axes** (12 in v1), each mapping structure-dimension
subjects to the facets that apply to them:

- `identified-by` / `configured-by` — technology-bearing subjects → CPE identity and
  CCE settings (exemplar composition: `ItSoftwareTechnology`);
- `measured-by-product-quality` / `-quality-in-use` / `-service-quality` /
  `-data-quality` — each TOGAF stratum → its matching ISO 2501x family;
- `operationalized-by-measure` — ISO characteristics become observable through
  `TogafMeasure` read from `TogafObservability`;
- `attributed-to` — universal: every structure-dimension definition is ascribable to a
  PROV agent (the catalogue's authorship model);
- `responsibility-of` — actors/roles/organizations → PROV association and delegation;
- `derived-as` — ADM and governance artifacts → PROV derivation/revision/quotation/
  primary-source lineage;
- `measurement-attributed-to` and `identity-attributed-to` — quality measurements and
  CPE/CCE assignments are themselves attributable acts, closing the audit loop.

**Correspondences** capture concept identity across dimensions (e.g. `TogafActor` ≅
`ProvAgent`, `TogafServiceQuality` ≅ the ISO 25011 family).

Coverage is total by construction: the generator asserts that every concept of the four
frameworks belongs to exactly one dimension stratum and is articulated by at least one
axis. Concepts are referenced by title — globally unambiguous under the catalogue's
framework-prefix naming rule — and resolved to `$id` via `coverage.registry`.

### Materialized composites (`ontology/`)

The ontology's structure dimension is **materialized** as 58 static composite
archetypes under `ontology/{togaf-stratum}/It{Concept}.archetype.json`, so the DM can
read a subject's full qualification surface from its typing archetype alone. Each
composite:

- `$ref`s its TOGAF concept (based concepts keep their GSM-base chain; rootless ones
  stay rootless — qualifier/data roles only);
- mounts every facet the ontology's axes make applicable, as **optional named
  properties** keyed by lowerCamelCase of the facet's title (the catalogue's facet
  mount rule — see the root README): identity (`scapPlatformIdentifier`,
  `scapConfigurationSetting`), quality (matching ISO 2501x family), provenance
  (`provAttribution` universally; `provAssociation`/`provDelegation` on agent-bearing
  subjects; the derivation family on lifecycle-bearing artifacts).

DM closure then *enforces the ontology at runtime*: an unmounted facet on an instance
is rejected as an unevaluated property. The files are statically authored today,
derived from `ontology.json` (a maintenance generator is planned); multi-layer
ascription remains available where an independent per-dimension lifecycle matters.

Schema-level `allOf` composition stays a per-need decision at this layer;
the ontology declares which compositions are meaningful.

## Domain-Native Taxonomy

```text
it/
  meta-governance/       # Appraisal vocabulary and mechanisms
  technology/            # Shared IT technology identification
  ontology/              # 58 materialized composites (It{Concept}, facet mounts)
  ontology.json          # IT ontology v1 — four dimensions over one subject taxonomy
  articulations.json     # Machine-readable pairwise articulation (incl. regulatory overlays)
```

## Element Inventory

### meta-governance/

Appraisal vocabulary and mechanisms for governance-coverage evaluation. Rootless data
archetypes plus the appraisal Mechanism statements and their Starlark rules.

| Element | GSM type | $id |
|---------|----------|-----|
| ItAppraisalTrigger | Archetype (rootless data) | `gsmarc://gsm-frameworks/it/meta-governance/ItAppraisalTrigger/v1` |
| ItAppraisalMeasure | Archetype (rootless data) | `gsmarc://gsm-frameworks/it/meta-governance/ItAppraisalMeasure/v1` |
| ItAppraisalFinding | Archetype (rootless data) | `gsmarc://gsm-frameworks/it/meta-governance/ItAppraisalFinding/v1` |
| ItDirectiveNormOperationalization | Mechanism (typed by the GSM base) | — |

### technology/

| Element | Extends / composes | $id |
|---------|--------------------|-----|
| ItSoftwareTechnology | extends `gsm:Structure` + composes `scap/ScapPlatformIdentifier` facet | `gsmarc://gsm-frameworks/it/technology/ItSoftwareTechnology/v1` |

`ItSoftwareTechnology` is the domain-layer composition example: a based Structure
archetype composing a reference framework's rootless facet through `allOf` — the
schema-level cross-framework mechanism reserved to the domain layer.

## Layering Rules Applied Here

- This framework may reference GSM and any composed reference
  framework — never a sibling domain framework.
- It never mutates or shadows reference concepts; it qualifies, composes, and maps them.
- Checked by `scripts/lint_layers.py`.
