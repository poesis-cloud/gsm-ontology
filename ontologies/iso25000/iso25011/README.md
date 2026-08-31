# ISO 25011 Model — GSM Ascription Statements

**Source**: ISO/IEC TS 25011:2017 — Systems and software Quality Requirements and Evaluation (SQuaRE) — Service quality models
**Scope**: IT Service Quality characteristics (8)
**Status**: Published 2017, confirmed 2024. Under revision as ISO/IEC CD 25000-11.2.

## Model Organization

Schemas are organized by **ISO 25011's own quality model structure**:

```
iso25011/
  service-quality/     # 8 IT service quality characteristics
```

All schemas are **rootless archetypes** (`additionalProperties: false`, no top-level `$ref`). Service quality characteristics are transversal viability dimensions — they are used as qualifiers in Directives/Norms governing IT services (e.g., a TOGAF PlatformService governed by ServiceReliability).

**Title prefix convention**: All ISO 25011 schema titles use the `Service` prefix (e.g., `ServiceReliability`, `ServiceSecurity`) to disambiguate from ISO 25010 product quality (`Product` prefix) and ISO 25012 data quality (`Data` prefix) characteristics with similar names.

### Quality in Use

ISO 25011 explicitly reuses ISO 25010's Quality in Use model (Effectiveness, Efficiency, Satisfaction, Freedom from Risk, Context Coverage) without modification. Those schemas are sourced once in `iso25010/quality-in-use/` and apply to both products and services — they are NOT duplicated here.

## Schema Inventory

### service-quality/ (8 schemas)

| Schema | ISO 25011 Characteristic | Sub-characteristics covered |
|--------|-------------------------|---------------------------|
| ServiceSuitability | Suitability | Completeness, Correctness, Appropriateness, Consistency |
| ServiceUsability | Usability | Appropriateness Recognizability, Learnability, Operability, User Error Protection, Accessibility, Courtesy |
| ServiceSecurity | Security | Confidentiality, Integrity, Traceability |
| ServiceReliability | IT Service Reliability | Continuity, IT Service Recoverability, Availability |
| ServiceTangibility | Tangibility | Visibility, Professionalism, IT Service Interface Appearance |
| ServiceResponsiveness | Responsiveness | Timeliness, Reactiveness |
| ServiceAdaptability | IT Service Adaptability | Customizability, Initiative |
| ServiceMaintainability | IT Service Maintainability | Analysability, Modifiability, Testability |

### Characteristics unique to service quality

Three characteristics have no direct product-quality equivalent in ISO 25010:

| Characteristic | Why it's service-specific |
|---------------|--------------------------|
| **Tangibility** | Physical/visual evidence of service quality — reports, dashboards, communication materials. Products are tangible by nature; services must demonstrate tangibility explicitly. |
| **Responsiveness** | Timeliness and proactiveness of the service provider's reaction to user requests. Products respond via their interface; services involve human/organizational responsiveness. |
| **Courtesy** (sub-char of Usability) | Polite, respectful behavior by service providers. Not applicable to product interfaces. |

## GSM Concept Mapping

| ISO 25011 Term | GSM Mapping | Systemics Concept |
|---------------|-------------|-------------------|
| IT Service Quality | Rootless archetype (viability qualifier) | Viability dimension — requisite variety for service homeostasis |
| Suitability | Functional viability dimension | Functional closure — service provides what environment requires |
| Usability | Interaction viability dimension | Coupling quality — user-service interface effectiveness |
| Security | Constraint viability dimension | Boundary regulation — information access control |
| IT Service Reliability | Operational viability dimension | Homeostasis — maintaining function under perturbation |
| Tangibility | Evidence viability dimension | Observability — making internal state visible to environment |
| Responsiveness | Temporal viability dimension | Requisite variety in time — absorbing temporal demand variety |
| IT Service Adaptability | Evolutionary viability dimension | Adaptation — structural change to match environmental variety |
| IT Service Maintainability | Evolution viability dimension | Self-organization — capacity for internal reorganization |

## Inter-Model Articulation

### ISO 25011 × ISO 25010 (Product vs Service Quality)

**Relationship**: ISO 25010 governs **product/system quality** (software attributes); ISO 25011 governs **IT service quality** (service delivery attributes). Complementary, not overlapping — though some characteristics share names, they operate at different levels.

| ISO 25010 (Product) | Shared Name | ISO 25011 (Service) |
|---------------------|-------------|---------------------|
| ProductReliability (fault tolerance, maturity) | Reliability | ServiceReliability (continuity, SLA availability) |
| ProductSecurity (encryption, authentication) | Security | ServiceSecurity (service-level confidentiality, traceability) |
| ProductUsability (learnability, accessibility) | Usability | ServiceUsability (+ courtesy, service-level operability) |
| ProductMaintainability (modularity, testability) | Maintainability | ServiceMaintainability (service-level analysability, modifiability) |
| — | Tangibility | ServiceTangibility (no product equivalent) |
| — | Responsiveness | ServiceResponsiveness (no product equivalent) |
| ProductPortability | — | ServiceAdaptability (related but distinct scope) |

**Disambiguation rule**: When both apply to the same Subject (e.g., a SaaS application is both product AND service), ISO 25010 characteristics govern **the software artifact's intrinsic quality**, while ISO 25011 characteristics govern **the service delivery experience**. A product can be reliable (ISO 25010) while the service wrapping it is unresponsive (ISO 25011), or vice versa.

### ISO 25011 × ISO 25012 (Service vs Data Quality)

**Relationship**: ISO 25012 governs **data quality**; ISO 25011 governs **service quality**. A service may deliver data — the data quality is governed by ISO 25012, while the service delivery quality is governed by ISO 25011.

### ISO 25011 × TOGAF (Service Governance)

**Relationship**: TOGAF governance mechanisms (Directives, Norms) **reference** ISO 25011 characteristics as qualifiers for service-level governance.

| TOGAF Concept | Articulation | ISO 25011 Concept |
|---------------|-------------|-------------------|
| PlatformService (Structure) | governed by → | Any service-quality characteristic |
| ArchitecturePrinciple (Directive) | qualifies with → | Service quality dimension (e.g., ServiceReliability target) |
| ArchitectureRequirement (Directive) | qualifies with → | Specific service quality + measurable threshold |
| Standard (Directive) | constrains using → | Service quality standard compliance |

See [Model Composition](../../README.md) for full articulation map.

## Notes

### SaaS governance (product + service quality)

For SaaS and cloud-managed services, both ISO 25010 (product quality) and ISO 25011 (service quality) apply simultaneously. GSM handles this through multiple Ascriptions on the same Subject — a managed service receives both product-quality and service-quality governance definitions.

### ISO 25011 revision tracking

The standard is being revised as ISO/IEC CD 25000-11.2. Schema evolution will track standard revisions when adopted. Current schemas follow the 2017 edition vocabulary.
