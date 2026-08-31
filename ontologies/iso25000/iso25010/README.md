# ISO 25010 Model — GSM Ascription Statements

**Source**: ISO/IEC 25010:2011 — Systems and software Quality Requirements and Evaluation (SQuaRE) — System and software quality models
**Scope**: Product Quality characteristics (8) + Quality in Use characteristics (5)

## Model Organization

Schemas are organized by **ISO 25010's own quality model structure**: product quality and quality in use.

```
iso25010/
  product-quality/     # 8 main characteristics + standalone sub-characteristics
  quality-in-use/      # 5 quality-in-use characteristics
```

All schemas are **rootless archetypes** (`additionalProperties: false`, no top-level `$ref`). Quality characteristics are transversal viability dimensions — they are used as qualifiers in Directives/Norms from other models (e.g., TOGAF ArchitecturePrinciple qualifying ProductReliability).

**Title prefix convention**: All ISO 25010 schema titles use the `Product` prefix (e.g., `ProductReliability`, `ProductSecurity`) to disambiguate from ISO 25012 data quality characteristics with similar names.

## Schema Inventory

### product-quality/ (11 schemas)

**Main characteristics** (ISO 25010 §4.2):

| Schema | ISO 25010 Characteristic | Sub-characteristics covered |
|--------|-------------------------|---------------------------|
| ProductFunctionalSuitability | Functional Suitability | Completeness, correctness, appropriateness |
| ProductPerformanceEfficiency | Performance Efficiency | Time behaviour, resource utilization, capacity |
| ProductCompatibility | Compatibility | Co-existence, interoperability |
| ProductUsability | Usability | Recognizability, learnability, operability, error protection, aesthetics, accessibility |
| ProductReliability | Reliability | Maturity, availability, fault tolerance, recoverability |
| ProductSecurity | Security | Confidentiality, integrity, non-repudiation, accountability, authenticity |
| ProductMaintainability | Maintainability | Modularity, reusability, analysability, modifiability, testability |
| ProductPortability | Portability | Adaptability, installability, replaceability |

**Standalone sub-characteristics** (independently governable):

| Schema | Parent Characteristic | Rationale for standalone schema |
|--------|----------------------|-------------------------------|
| ProductAvailability | Reliability | Independently measured (uptime %, SLA), distinct governance (HA requirements) |
| ProductInteroperability | Compatibility | Independently measured (protocol support, API compatibility), distinct governance |
| ProductScalability | Performance Efficiency / Flexibility | Independently measured (scaling limits), distinct governance (capacity planning) |

### quality-in-use/ (5 schemas)

| Schema | ISO 25010 Characteristic | Sub-characteristics covered |
|--------|-------------------------|---------------------------|
| ProductEffectiveness | Effectiveness | Task completion rate, goal achievement accuracy |
| ProductEfficiency | Efficiency | Time efficiency, resource utilization per task |
| ProductSatisfaction | Satisfaction | Usefulness, trust, pleasure, comfort |
| ProductFreedomFromRisk | Freedom from Risk | Economic risk, health/safety risk, environmental risk mitigation |
| ProductContextCoverage | Context Coverage | Context completeness, flexibility |

## Inter-Model Articulation

ISO 25010 quality characteristics are **referenced by** governance models:

- **TOGAF**: ArchitecturePrinciple/ArchitectureRequirement (Directives) qualify with ISO 25010 characteristics
- **ISO 25012**: Complementary — ISO 25010 governs product/system quality, ISO 25012 governs data quality

See [Model Composition](../../README.md) for full articulation map.

## Notes

### ISO 25010:2023 revision

The 2023 revision renames some characteristics (Usability → Interaction Capability, Portability → Flexibility) and adds Safety. Current schemas follow the 2011 edition vocabulary. Schema evolution will track standard revisions when adopted.

### Scalability positioning

Scalability maps to Performance Efficiency → Capacity (2011) or Flexibility → Scalability (2023). Kept as standalone due to its independent governance significance in cloud-native architectures.

### Observability

Observability is NOT an ISO 25010 characteristic. It is kept in the TOGAF model (`togaf/technology-architecture/Observability`).
