# ISO/IEC 25000 SQuaRE — Systems and Software Quality Requirements and Evaluation

**Source**: ISO/IEC 25000 series (SQuaRE) — a family of standards for quality requirements and evaluation of systems, software, and data.

**Scope**: Quality models for products (ISO 25010), IT services (ISO 25011), and data (ISO 25012) — the **2501n Quality Models division** of SQuaRE.

**Why one framework**: ISO 25010, 25011, and 25012 all belong to the same ISO/IEC 25000 SQuaRE series. They share a common conceptual foundation (quality characteristics → sub-characteristics → measurable properties), use each other by reference (ISO 25011 reuses ISO 25010 Quality in Use), and are governed by the same meta-standards (25000 management, 25030 requirements, 25040 evaluation). Sourcing them as one framework reflects their actual standard lineage.

## Model Organization

```
iso25000/
  iso25010/                        # Product/system quality (16 schemas)
    product-quality/               #   8 main + 3 standalone sub-characteristics
    quality-in-use/                #   5 quality-in-use characteristics
  iso25011/                        # IT service quality (8 schemas)
    service-quality/               #   8 service-quality characteristics
  iso25012/                        # Data quality (15 schemas)
    inherent-quality/              #   5 inherent data quality
    inherent-and-system-quality/   #   7 dual-viewpoint characteristics
    system-dependent-quality/      #   3 system-dependent characteristics
```

Each sub-standard retains its own directory and internal README. Quality characteristics are **rootless archetypes** — transversal viability dimensions used as qualifiers in Directives/Norms from governance models (TOGAF, NIS2, GDPR).

**Title prefix convention**: `Product` (25010), `Service` (25011), `Data` (25012) — disambiguates characteristics with similar names across standards (e.g., ProductAvailability vs DataAvailability vs ServiceReliability).

## Sourced Standards

| Standard | Edition | Scope | Schemas |
| ---------- | --------- | ------- | --------- |
| **ISO 25010** | ISO/IEC 25010:2011 | Product Quality (8 chars) + Quality in Use (5 chars) | 16 |
| **ISO 25011** | ISO/IEC TS 25011:2017 | IT Service Quality (8 chars); reuses 25010 Quality in Use | 8 |
| **ISO 25012** | ISO/IEC 25012:2008 | Data Quality (15 chars across 3 viewpoints) | 15 |
| **Total** | | 3 quality models, 39 quality dimensions | **39** |

See each sub-standard's README for detailed schema inventory, inter-model disambiguation, and GSM concept mapping:

- [ISO 25010 README](iso25010/README.md) — product quality + quality in use
- [ISO 25011 README](iso25011/README.md) — IT service quality
- [ISO 25012 README](iso25012/README.md) — data quality

## Quality in Use Sharing

ISO 25011 explicitly reuses ISO 25010's Quality in Use model (Effectiveness, Efficiency, Satisfaction, Freedom from Risk, Context Coverage). These 5 schemas live in `iso25010/quality-in-use/` and apply to both products and services — they are NOT duplicated in `iso25011/`.

## Inter-Standard Disambiguation

| ISO 25010 (Product) | vs | ISO 25012 (Data) | vs | ISO 25011 (Service) |
| --------------------- | ---- | ------------------- | ---- | --------------------- |
| ProductAvailability — system uptime | ≠ | DataAvailability — data retrievable | ≠ | ServiceReliability — service continuity |
| ProductSecurity — system secure | ≠ | DataConfidentiality — data protected | ≠ | ServiceSecurity — service-level security |
| ProductPortability — system portable | ≠ | DataPortability — data movable | ≠ | ServiceAdaptability — service customizable |
| ProductPerformanceEfficiency — system performs | ≠ | DataEfficiency — data processing efficient | ≠ | ServiceResponsiveness — service reacts timely |
| ProductMaintainability — system modifiable | ≠ | — | ≠ | ServiceMaintainability — service modifiable |
| ProductUsability — system learnable | ≠ | DataUnderstandability — data interpretable | ≠ | ServiceUsability — service operable + courteous |

**Rule**: When multiple quality models apply to the same Subject (e.g., a SaaS platform), each model governs a different quality dimension. Conflicts are resolved by TOGAF governance Directives (meta-governance).

## Excluded SQuaRE Divisions (with justification)

| SQuaRE Division | Standards | Reason for Exclusion |
| ----------------- | ----------- | --------------------- |
| **2500n — Management** | 25000, 25001, 25002 | Process guidance, common terminology, planning overview — not a quality model; no characteristics to source as archetypes |
| **2502n — Measurement** | 25020, 25022–25025 | Concrete quality measures (formulas, scales, thresholds) — would become Norm assertion libraries, not archetype schemas; candidate for future sourcing when ITIP builds Norm authoring UX |
| **25030 — Requirements** | 25030 | Process standard for quality requirements elicitation — already operationalized by GSM's Directive grammar (`modal × verb × qualifier × purpose`); nothing to source as schemas |
| **25040 — Evaluation** | 25040 | Evaluation process framework and Quality Rating Modules — already operationalized by GSM's Norm grammar (`toleranceMode + temporalWindow + aggregation`); partially sourceable (evaluation type classification) but low priority |
| **25050–25099 — Extensions** | 25051, 25060–25069 | RUSP requirements, Common Industry Format for usability — narrow scope, not yet relevant to ITIP governance |

See the [SQuaRE Series — GSM Compatibility Trace](../README.md#square-series--gsm-compatibility-trace) section in `../README.md` for a detailed pipeline mapping of all SQuaRE divisions to GSM primitives.

## File Inventory

| Type | Naming | Count | Standards |
| ------ | -------- | ------- | ----------- |
| Archetype schemas | `*.archetype.json` | 39 | 16 (ISO 25010) + 8 (ISO 25011) + 15 (ISO 25012) |
| READMEs | `README.md` | 4 | 1 unified + 3 per-standard |
| **Total** | | **43** | |
