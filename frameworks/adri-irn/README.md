# aDRI-IRN — Alliance for Digital Resilience Initiative / International Resilience Network

**Source**: aDRI-IRN framework and governance specifications (<https://gitlab.com/digitalresilienceinitiative/adri-irn>).

**Scope**: Open multi-stakeholder standard for digital and operational resilience governance — capability requirements, maturity assessment, and adherence tracking across resilience domains (cyber, operational, supply chain, continuity/recovery).

**Model type**: Standard framework (vocabulary + governance requirements). Like NIS2/DORA, operates at two P8 layers:

| Layer | What it produces | File extension |
|-------|-----------------|----------------|
| **P8 Layer 2 — Archetype schemas** | IRN-specific vocabulary (capability types, maturity dimensions, measurement criteria) | `.archetype.json` |
| **P8 Layer 3 — Sourced Directives** | IRN governance mandates (adherence requirements for member organizations) | `*SourcedDirective.json` |
| **P8 Layer 3 — Sourced Norms** | IRN measurable requirements (capability-level targets, evidence criteria) | `*SourcedNorm.json` |

**Status**: Reserved — pending full sourcing (ST-4: Sourcing & compliance fabric). Partner entry registered in `strategy/partner-matrix.md` (Tier 2, Emerging).

**Strategic intent**: Poesis becomes the reference GSM implementation for aDRI-IRN adherence. Member organizations use SIE/ITIP to demonstrate and govern their IRN adherence, replacing spreadsheet-based compliance tracking with machine-evaluable governed Directive/Norm instances — the same pattern applied to NIS2 and DORA.

---

## Model-Native Taxonomy (preliminary — to be confirmed against the authoritative IRN specification)

aDRI-IRN organizes resilience governance around four capability domains and cross-cutting governance requirements. The folder structure will reflect aDRI-IRN's own taxonomy (per P9):

| Folder (planned) | aDRI-IRN Source | Purpose |
|---------|----------------|---------|
| `capability/` | IRN Capability Framework | Core resilience capabilities: anticipate, withstand, recover, adapt |
| `governance/` | IRN Governance Requirements | Oversight accountability, risk appetite definition, management reporting |
| `supply-chain/` | IRN Supply Chain Resilience | Third-party/supplier resilience requirements and assessment criteria |
| `continuity/` | IRN Continuity & Recovery | RTO/RPO targets, continuity plans, recovery testing obligations |

> ⚠ Folder structure above is provisional. When sourcing begins, map the authoritative IRN specification taxonomy first (P9) and revise accordingly.

---

## Concept Mapping (provisional skeleton)

### Vocabulary Schemas (archetype schemas)

| IRN Concept | GSM Subject Type | Folder (planned) | Schema Title (planned) |
|------------|-----------------|------------------|------------------------|
| Resilience capability (anticipate/withstand/recover/adapt) | Rootless | capability/ | IrnResilienceCapability |
| Capability maturity level | Rootless | capability/ | IrnCapabilityMaturityLevel |
| Resilience governance requirement | Rootless | governance/ | IrnGovernanceRequirement |
| Supply chain resilience assessment | Rootless | supply-chain/ | IrnSupplyChainAssessment |
| Continuity / recovery objective | Rootless | continuity/ | IrnContinuityObjective |

### Sourced Governance Instances (provisional)

IRN adherence requirements will be sourced as Directive/Norm instances in pure GSM grammar, with legal provenance carried on the framework descriptor's `elements[]` entries (per the NIS2/GDPR regulatory pattern):

| IRN Requirement | GSM Instance Type | Folder (planned) |
|----------------|-------------------|-----------------|
| Member adherence declaration | SourcedDirective | governance/ |
| Capability-level measurement norm | SourcedNorm | capability/ |
| Supply chain due diligence obligation | SourcedNorm | supply-chain/ |
| Recovery testing frequency requirement | SourcedNorm | continuity/ |

---

## Articulation with Existing Models

### aDRI-IRN × NIS2 (Resilience Complementarity)

**Relationship**: NIS2 Art 21 risk-management measures (backup/recovery, business continuity, supply chain security) map onto IRN capability domains. NIS2 provides the **legal mandate**; aDRI-IRN provides the **operational capability measurement vocabulary**.

| NIS2 Concept | Articulation | aDRI-IRN Concept |
|--------------|-------------|-----------------|
| Risk management measures (Art 21(2)) | operationalized by → | IrnResilienceCapability (withstand/recover) |
| Business continuity (Art 21(2)(c)) | measured using → | IrnContinuityObjective (RTO/RPO targets) |
| Supply chain security (Art 21(2)(d)) | assessed via → | IrnSupplyChainAssessment |
| Governance accountability (Art 20) | complemented by → | IrnGovernanceRequirement |

**Governance pattern**: A NIS2 `Nis2RiskManagementMeasure` Directive qualifies structures using `IrnResilienceCapability` as the measurement archetype — the Directive provides the legal obligation, the IRN archetype provides the structured vocabulary for evidence collection.

### aDRI-IRN × DORA (Digital Operational Resilience — planned)

DORA (Regulation (EU) 2022/2554) targets financial-sector digital operational resilience. IRN capability domains map directly onto DORA requirements (ICT risk management, incident classification, TLPT, supply chain oversight). Articulation to be documented when DORA is sourced.

### aDRI-IRN × TOGAF (Architecture Resilience Overlay)

IRN resilience governance overlays on TOGAF Application and Technology Architecture Structures. A TOGAF `LogicalApplicationComponent` can be simultaneously governed by:

- A NIS2 `Nis2RiskManagementMeasure` Directive (legal obligation)
- An aDRI-IRN `IrnResilienceCapability` Norm (capability target and evidence criteria)

This creates a coherent, multi-layer governance pattern: architecture-level description (TOGAF) + legal mandate (NIS2) + resilience measurement (aDRI-IRN).
