# PROV — W3C Provenance Vocabulary

## Model Identification

| Field | Value |
|-------|-------|
| **Model** | W3C PROV (PROV-DM / PROV-O) |
| **Source** | [PROV-DM: The PROV Data Model](https://www.w3.org/TR/prov-dm/) (W3C Recommendation, 2013-04-30); [PROV-O: The PROV Ontology](https://www.w3.org/TR/prov-o/) |
| **Layer** | reference |
| **Schema Count** | 11 |

## Purpose

Provenance vocabulary for ascription statements, sourced from the W3C PROV standard:
"provenance is a record that describes the people, institutions, entities, and
activities involved in producing, influencing, or delivering a piece of data or a
thing" (PROV-DM §1). PROV-DM is organized in six components; this sourcing follows
that taxonomy.

## Concept map

### Component 2 — Derivations (`derivations/`) — sourced

| Concept | PROV-DM | Relation | GSM mapping | File |
|---------|---------|----------|-------------|------|
| Derivation | §5.2.1 | `wasDerivedFrom` | Rootless facet | `Derivation.archetype.json` |
| Revision | §5.2.2 | `wasRevisionOf` (prov:Revision) | Rootless facet | `Revision.archetype.json` |
| Quotation | §5.2.3 | `wasQuotedFrom` (prov:Quotation) | Rootless facet | `Quotation.archetype.json` |
| Primary Source | §5.2.4 | `hadPrimarySource` (prov:PrimarySource) | Rootless facet | `PrimarySource.archetype.json` |

### Component 3 — Agents, Responsibility, and Influence (`agents-responsibility/`) — sourced

| Concept | PROV-DM | Relation / type | GSM mapping | File |
|---------|---------|-----------------|-------------|------|
| Agent | §5.3.1 | `agent(id, attrs)` | Rootless shape facet | `Agent.archetype.json` |
| Person | §5.3.1 | prov:Person | Rootless shape facet | `Person.archetype.json` |
| Organization | §5.3.1 | prov:Organization | Rootless shape facet | `Organization.archetype.json` |
| SoftwareAgent | §5.3.1 | prov:SoftwareAgent | Rootless shape facet | `SoftwareAgent.archetype.json` |
| Attribution | §5.3.2 | `wasAttributedTo` | Rootless facet | `Attribution.archetype.json` |
| Association | §5.3.3 | `wasAssociatedWith` | Rootless facet | `Association.archetype.json` |
| Delegation | §5.3.4 | `actedOnBehalfOf` | Rootless facet | `Delegation.archetype.json` |
| Influence | §5.3.5 | `wasInfluencedBy` | Reserved — the superrelation of all component-1/2/3 relations; PROV itself recommends adopting the more specific relations | — |

### Components 1, 4, 5, 6 — reserved (mapped, not yet sourced)

| Component | Concepts | PROV-DM | GSM mapping (planned) |
|-----------|----------|---------|------------------------|
| 1 — Entities and Activities | Entity, Activity, Generation (`wasGeneratedBy`), Usage (`used`), Communication (`wasInformedBy`), Start, End, Invalidation | §5.1 | Entity/Activity → rootless shapes; relations → rootless facets |
| 4 — Bundles | Bundle (provenance of provenance) | §5.4 | Rootless shape (prov:Bundle is an Entity subtype) |
| 5 — Alternate | Specialization (`specializationOf`), Alternate (`alternateOf`) | §5.5 | Rootless facets |
| 6 — Collections | Collection, Membership (`hadMember`) | §5.6 | Rootless shape + facet |

Reserved concepts are sourced on demand, following this concept map.

## Notes from the source standard

- Attribution is the standards term for what is colloquially called authorship: the
  spec's own Example 35 writes `wasAttributedTo(tr:WD-prov-dm-20111215, ex:Simon,
  [ prov:type="authorship" ])`.
- **Validation posture.** These schemas implement exactly the shape rules PROV-DM itself
  prescribes and nothing more: agents have a mandatory identifier (§5.7.1), an
  Association carries at least one of its optional members — id, agent, plan,
  attributes (§5.3.3, verbatim rule) — and relation targets must be non-empty
  (identifiable). Every relation facet renders the full PROV-DM expression: the
  optional relation identifier (§5.7.1) and the optional attribute set (attrs — PROV's
  extensibility point, §6, carrying reserved attributes such as `prov:label`,
  `prov:type`, and, where permitted, `prov:role`, §5.7.2). Expanded n-ary members are
  expressible where the spec defines them: Derivation's optional activity, generation,
  and usage (§5.2.1) and Delegation's optional activity (§5.3.4). PROV deliberately
  prescribes **no identification scheme** (identifiers are qualified names, mappable to
  IRIs, §5.7.5), so no pattern/format constraints are imposed here — concrete
  identification shapes are a composing-layer decision. PROV's deeper validation rules
  live in a separate specification,
  [PROV-CONSTRAINTS](https://www.w3.org/TR/prov-constraints/) (ordering/inference
  constraints such as generation-precedes-usage, or derivation's
  activity/generation/usage joint-presence rule): those are logical rules, not shapes,
  and are a sourcing candidate in their own right.
- Revision, Quotation, and Primary Source are subtypes of Derivation (§5.2), expressed
  in PROV as `wasDerivedFrom` with a `prov:type`; they are sourced as distinct facets
  per the strict 1:1 concept mapping, each carrying the same expression structure as
  Derivation (§5.2.1), since a subtype adds no members — PROV defines no attributes
  specific to Revision, Quotation, or Primary Source.
- In this composition model the host statement plays the relation's primary subject —
  Attribution's entity (e), Association's activity (a), Derivation's generated entity
  (e2) — which is why that mandatory member does not appear in the facet shape. All
  other mandatory members (Attribution's agent, Delegation's delegate and responsible,
  Derivation's usedEntity) are required by the schemas exactly as §5 requires them.
