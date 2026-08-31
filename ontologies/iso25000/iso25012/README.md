# ISO 25012 Model — GSM Ascription Statements

**Source**: ISO/IEC 25012:2008 — Software engineering — Software product Quality Requirements and Evaluation (SQuaRE) — Data quality model
**Scope**: 15 Data Quality characteristics organized by viewpoint

## Model Organization

Schemas are organized by **ISO 25012's own data quality viewpoints**:

```
iso25012/
  inherent-quality/              # 5 characteristics — intrinsic to data values themselves
  inherent-and-system-quality/   # 7 characteristics — depend on both data and system
  system-dependent-quality/      # 3 characteristics — depend on the system hosting the data
```

All schemas are **rootless archetypes** (`additionalProperties: false`, no top-level `$ref`). Data quality characteristics are used as qualifiers in Directives/Norms governing data entities (e.g., TOGAF DataEntity governed by DataAccuracy).

**Title prefix convention**: All ISO 25012 schema titles use the `Data` prefix (e.g., `DataAccuracy`, `DataAvailability`) to disambiguate from ISO 25010 characteristics with similar names.

## Schema Inventory

### inherent-quality/ (5 schemas)

Inherent data quality characteristics are those that refer to the degree to which quality characteristics have the intrinsic potential to satisfy stated and implied needs when data is used under specified conditions.

| Schema | Title | Description |
|--------|-------|-------------|
| DataAccuracy | DataAccuracy | Degree to which data correctly represents the true value |
| DataCompleteness | DataCompleteness | Degree to which data has values for all expected attributes |
| DataConsistency | DataConsistency | Degree to which data is free from contradiction and coherent |
| DataCredibility | DataCredibility | Degree to which data is regarded as true and believable |
| DataCurrentness | DataCurrentness | Degree to which data is of the right age |

### inherent-and-system-quality/ (7 schemas)

These characteristics depend on both the inherent quality of the data and the system that stores/processes it.

| Schema | Title | Description |
|--------|-------|-------------|
| DataAccessibility | DataAccessibility | Degree to which data can be accessed by authorized users |
| DataCompliance | DataCompliance | Degree to which data adheres to standards/regulations |
| DataConfidentiality | DataConfidentiality | Degree to which data is only accessible to authorized users |
| DataEfficiency | DataEfficiency | Degree to which data can be processed with appropriate resources |
| DataPrecision | DataPrecision | Degree to which data provides discrimination/exactness |
| DataTraceability | DataTraceability | Degree to which data provides an audit trail |
| DataUnderstandability | DataUnderstandability | Degree to which data can be read and interpreted by users |

### system-dependent-quality/ (3 schemas)

System-dependent data quality characteristics are those that can only be achieved by means of the computer system in which data is stored and processed.

| Schema | Title | Description |
|--------|-------|-------------|
| DataAvailability | DataAvailability | Degree to which data can be retrieved by authorized users |
| DataPortability | DataPortability | Degree to which data can be moved between systems preserving quality |
| DataRecoverability | DataRecoverability | Degree to which data maintains quality even in event of failure |

## Inter-Model Articulation

ISO 25012 data quality characteristics are **referenced by** governance models:

- **TOGAF**: ArchitecturePrinciple/Standard (Directives) qualify data entities with ISO 25012 dimensions
- **ISO 25010**: Complementary — ISO 25012 governs data quality, ISO 25010 governs product/system quality

### ISO 25010 × ISO 25012 disambiguation

| ISO 25012 (Data) | vs | ISO 25010 (Product) |
|-------------------|-----|---------------------|
| DataAvailability — data is retrievable | ≠ | ProductAvailability — system is operational |
| DataConfidentiality — data is protected | ≠ | ProductSecurity — system is secure |
| DataPortability — data is movable | ≠ | ProductPortability — system is portable |
| DataEfficiency — data processing is efficient | ≠ | ProductPerformanceEfficiency — system performs well |

See [Model Composition](../../README.md) for full articulation map.
