# SCAP — Security Content Automation Protocol

## Model Identification

| Field | Value |
| ------- | ------- |
| **Model** | SCAP (Security Content Automation Protocol) |
| **Source Standards** | NIST SP 800-126 r3 (SCAP 1.3), NIST IR 7695 (CPE 2.3 Naming), NIST CCE List |
| **Authority** | National Institute of Standards and Technology (NIST), MITRE Corporation |
| **Sourced Components** | CPE (Common Platform Enumeration) 2.3, CCE (Common Configuration Enumeration) |
| **Not Yet Sourced Components** | OVAL, XCCDF, ARF, CVSS, CVE |
| **Schema Count** | 2 vocab schemas |

## Purpose

SCAP provides a **universal identification substrate** for IT security governance. CPE names technologies (what platform is this?), and CCE names configuration settings (what specific setting on that platform?). Together they form the identification layer that all technology-specific Norm frameworks (CIS Benchmarks, DISA STIGs, NIST 800-53 controls) reference.

**Why source CPE/CCE first**: Norm assertions in security frameworks check properties on identified platforms and settings. Without CPE, there is no standardized way to scope a Norm to "all Red Hat Enterprise Linux 8 servers." Without CCE, there is no standardized way to reference "the SSH PermitRootLogin setting." These identifiers must exist before technology-specific Norms can be authored.

## Model-Native Taxonomy

SCAP organizes itself into component specifications. Each sourced component gets its own domain folder:

| Domain Folder | SCAP Component | Purpose |
|---------------|----------------|---------|
| `cpe/` | Common Platform Enumeration (CPE) 2.3 | Structured naming scheme for IT systems, software, and packages |
| `cce/` | Common Configuration Enumeration (CCE) | Unique identifiers for system configuration guidance statements |

## Mapping Table

| Model Concept | GSM Subject Type | Domain Folder | Schema File | Notes |
| --------------- | ----------------- | --------------- | ------------- | ------- |
| Platform Identifier | rootless | cpe | `PlatformIdentifier.archetype.json` | Decomposes CPE 2.3 WFN attributes into typed properties. Cross-cutting: ascribable to any technology-typed subject. |
| Configuration Setting | rootless | cce | `ConfigurationSetting.archetype.json` | Uniquely identifies configuration guidance statements. Links to platform via CPE URI. |

## Excluded Concepts (with reason)

| SCAP Component | Reason |
| ---------------- | -------- |
| **OVAL** (Open Vulnerability and Assessment Language) | Assessment execution language — maps to Mechanism rules (Starlark), not vocabulary schemas. Candidate for future sourcing as Mechanism archetypes when OIP models assessment execution. |
| **XCCDF** (Extensible Configuration Checklist Description Format) | Checklist bundling format — analogous to a Norm collection/profile. Candidate when OIP models governance profile composition. |
| **ARF** (Asset Reporting Format) | Result reporting format — maps to Effector/Receptor payloads (observation data), not definition vocabulary. Candidate when OIP models compliance reporting. |
| **CVSS** (Common Vulnerability Scoring System) | Vulnerability severity scoring — orthogonal to configuration. Candidate as a standalone quality dimension (rootless) when OIP models vulnerability governance. |
| **CVE** (Common Vulnerabilities and Exposures) | Vulnerability identification — similar to CCE but for vulnerabilities, not configurations. Candidate as a rootless identification archetype. |

## Governance Usage Patterns

### Scoping Norms by technology platform (CPE)

CPE enables technology-specific Norm applicability expressions. Example:

```
Directive: "All Linux servers MUST ENSURE RiskManagementMeasure"
Norm applicability: self.PlatformIdentifier.part == 'OPERATING_SYSTEM'
            && self.PlatformIdentifier.vendor == 'redhat'
Norm assertion: <checks NIS2-sourced properties>
```

### Referencing specific configuration settings (CCE)

CCE enables Norm assertions that reference specific, universally identified settings:

```
Directive: "All servers MUST ENSURE secure SSH configuration"
Norm applicability: self.ConfigurationSetting.cceId == 'CCE-80214-3'
Norm assertion: self.ConfigurationSetting.parameters == 'no'
```

### Multi-layer Ascription pattern

A single technology subject can be simultaneously ascribed with:

- `TechnologyComponent` (TOGAF — structural role)
- `PlatformIdentifier` (SCAP — what technology it IS)
- `ConfigurationSetting` (SCAP — what settings it HAS)
- `ProductSecurity` (ISO 25010 — security quality measurement)
- `RiskManagementMeasure` (NIS2 — regulatory obligation)

This enables governance paths like: NIS2 Directive → Norm referencing ProductSecurity properties → scoped by PlatformIdentifier.part → on a TOGAF TechnologyComponent subject.

## Inter-Model Articulation

See `../README.md` for cross-model composition details:

- **SCAP × TOGAF**: CPE identifies TOGAF TechnologyComponent and PlatformService subjects. Enables technology-specific governance on architectural structures.
- **SCAP × NIS2**: SCAP provides the identification substrate for NIS2 Art 21 risk management compliance. CCE-identified settings are what NIS2 Norms ultimately check.
- **SCAP × ISO 25010**: CPE-scoped subjects can be measured against ProductSecurity, ProductReliability properties. CCE settings feed into ProductSecurity assessments.
- **SCAP × CIS Benchmarks / DISA STIGs** (future): These frameworks are distributed in SCAP format — every benchmark rule / STIG finding has a CCE ID targeting a CPE platform. SCAP/CPE/CCE is their identification prerequisite.
