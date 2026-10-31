# NIS2 — Directive (EU) 2022/2555

**Source**: Directive (EU) 2022/2555 of the European Parliament and of the Council of 14 December 2022 on measures for a high common level of cybersecurity across the Union (NIS2 Directive).

**Scope**: EU-wide cybersecurity risk management, incident reporting, supply chain security, and governance accountability for essential and important entities across 18 critical sectors.

**Transposition deadline**: 17 October 2024.

**Model type**: Regulatory — the first regulatory model in OIP. Unlike quality models (ISO 25010/25011/25012) and architecture models (TOGAF) which define **vocabularies only** (P8 Layer 2 — archetype schemas), NIS2 operates at **two P8 layers simultaneously**:

| Layer | What it produces | File extension |
| ------- | ----------------- | ---------------- |
| **P8 Layer 2 — Archetype schemas** | NIS2-specific vocabulary (entity classification, measure categories, reporting stages) | `.archetype.json` |
| **P8 Layer 3 — Sourced Directives** | Concrete legal mandates from NIS2 articles, expressed in GSM Directive grammar | `*SourcedDirective.json` |
| **P8 Layer 3 — Sourced Norms** | Concrete measurable requirements from NIS2 articles, expressed in GSM Norm grammar | `*SourcedNorm.json` |

This dual-layer pattern is the hallmark of **regulatory models**: the European Parliament acts as an authoritative governance Structure producing DNA (Directives and Norms) through its legislative Mechanisms. The articles of NIS2 ARE governance DNA output — pre-existing definitions sourced from legal authority.

## Model-Native Taxonomy

NIS2 is organized by its regulatory concerns (not by GSM subject type per P9):

| Folder | NIS2 Source | Purpose |
| -------- | ------------ | --------- |
| `entity-classification/` | Art 2–3, Annexes I/II | Who falls under NIS2 and at what obligation tier |
| `risk-management/` | Art 20–21 | Governance accountability + 10 mandatory cybersecurity measures |
| `incident-reporting/` | Art 23 | Multi-stage incident notification pipeline with temporal deadlines |
| `supply-chain/` | Art 21(2)(d), Art 21(3) | ICT supply chain security assessment and due diligence |

## Concept Mapping

### Vocabulary Schemas (archetype schemas)

| NIS2 Concept | GSM Subject Type | Folder | Schema Title | Source |
| ------------- | ----------------- | -------- | -------------- | -------- |
| Entity classification (essential/important) | Rootless | entity-classification/ | EntityClassification | Art 3 |
| Sector scope (Annex I/II sectors) | Rootless | entity-classification/ | SectorScope | Annexes I, II |
| Governance accountability | Rootless | risk-management/ | GovernanceAccountability | Art 20 |
| Risk management measure | Rootless | risk-management/ | RiskManagementMeasure | Art 21(2) |
| Incident reporting | Rootless | incident-reporting/ | IncidentReporting | Art 23 |
| Supply chain security | Rootless | supply-chain/ | SupplyChainSecurity | Art 21(2)(d) |

All schemas are **rootless** (no top-level `$ref` to a GSM base). NIS2 concepts are regulatory scoping/compliance dimensions — they qualify governance but are not Structures, Mechanisms, or Interactions.

### Sourced Directives (legal mandates)

| Directive | GSM Grammar | Source | Operationalized by |
| ----------- | ------------ | -------- | ------------------- |
| Art20-GovernanceAccountability | `MUST ENSURE GovernanceAccountability` | Art 20 | 3 Norms (approval, management training, employee training) |
| Art21-RiskManagement | `MUST ENSURE RiskManagementMeasure` | Art 21(1-2) | 10 Norms (one per measure category) |
| Art23-IncidentReporting | `MUST ENSURE IncidentReporting` | Art 23 | 4 Norms (24h, 72h, intermediate, 1mo deadlines) |
| Art21-2d-SupplyChainSecurity | `MUST ENSURE SupplyChainSecurity` | Art 21(2)(d) | 4 Norms (assessment, security posture, secure dev, vulnerability disclosure) |

**Symbolic references**: Sourced directives use `$nis2:regulatory-authority` (structure) and `$nis2:classified-entity` (purpose) — resolved at deployment when an entity adopts NIS2 governance.

### Sourced Norms (measurable requirements)

#### Governance Norms (operationalize Art 20 Directive)

| Norm | Assertion | Source |
| ------ | ----------- | -------- |
| Art20-1-ManagementApproval | `self.managementApproval == true` | Art 20(1) |
| Art20-2-ManagementTraining | `self.trainingCompleted == true` | Art 20(2) |
| Art20-3-EmployeeTraining | `employeeTrainingOffered == true` | Art 20(2) |

#### Risk Management Norms (operationalize Art 21 Directive)

| Norm | Guard (measure scope) | Assertion | Source |
| ------ | ---------------------- | ----------- | -------- |
| Art21-2a-RiskAnalysisPolicy | `measureCategory == 'RISK_ANALYSIS_AND_IS_SECURITY_POLICY'` | `implementationLevel != 'NOT_IMPLEMENTED'` | Art 21(2)(a) |
| Art21-2b-IncidentHandling | `measureCategory == 'INCIDENT_HANDLING'` | `implementationLevel != 'NOT_IMPLEMENTED'` | Art 21(2)(b) |
| Art21-2c-BusinessContinuity | `measureCategory == 'BUSINESS_CONTINUITY_AND_CRISIS_MANAGEMENT'` | `implementationLevel != 'NOT_IMPLEMENTED'` | Art 21(2)(c) |
| Art21-2d-SupplyChainSecurity | `measureCategory == 'SUPPLY_CHAIN_SECURITY'` | `implementationLevel != 'NOT_IMPLEMENTED'` | Art 21(2)(d) |
| Art21-2e-NetworkSecurity | `measureCategory == 'NETWORK_AND_IS_ACQUISITION_SECURITY'` | `implementationLevel != 'NOT_IMPLEMENTED'` | Art 21(2)(e) |
| Art21-2f-EffectivenessAssessment | `measureCategory == 'EFFECTIVENESS_ASSESSMENT'` | `implementationLevel != 'NOT_IMPLEMENTED'` | Art 21(2)(f) |
| Art21-2g-CyberHygiene | `measureCategory == 'CYBER_HYGIENE_AND_TRAINING'` | `implementationLevel != 'NOT_IMPLEMENTED'` | Art 21(2)(g) |
| Art21-2h-Cryptography | `measureCategory == 'CRYPTOGRAPHY_AND_ENCRYPTION'` | `implementationLevel != 'NOT_IMPLEMENTED'` | Art 21(2)(h) |
| Art21-2i-HumanResources | `measureCategory == 'HR_SECURITY_AND_ACCESS_CONTROL'` | `implementationLevel != 'NOT_IMPLEMENTED'` | Art 21(2)(i) |
| Art21-2j-MultiFactorAuth | `measureCategory == 'MULTI_FACTOR_AUTHENTICATION'` | `implementationLevel != 'NOT_IMPLEMENTED'` | Art 21(2)(j) |

All 10 norms use `toleranceMode: STRICT` — NIS2 mandates are non-negotiable for classified entities.

#### Incident Reporting Norms (operationalize Art 23 Directive)

| Norm | Guard (stage scope) | Assertion | Temporal Window | Source |
| ------ | -------------------- | ----------- | ----------------- | -------- |
| Art23-4a-EarlyWarning-24h | `significantIncident == true && reportingStage == 'EARLY_WARNING'` | `deadlineHours <= 24` | `PT24H` | Art 23(4)(a) |
| Art23-4b-Notification-72h | `significantIncident == true && reportingStage == 'INCIDENT_NOTIFICATION'` | `deadlineHours <= 72` | `PT72H` | Art 23(4)(b) |
| Art23-4c-IntermediateReport | `significantIncident == true && reportingStage == 'INTERMEDIATE_REPORT'` | `deadlineHours <= 720` | — | Art 23(4)(c) |
| Art23-4d-FinalReport-1m | `significantIncident == true && reportingStage == 'FINAL_REPORT'` | `deadlineHours <= 720` | `P1M` | Art 23(4)(d) |

Temporal norms encode `temporalWindow` in ISO 8601 — earliest GSM norm instances with legal deadline semantics.

#### Supply Chain Norms (operationalize Art 21(2)(d) Directive)

| Norm | Assertion | Source |
| ------ | ----------- | -------- |
| Art21-2d-SupplierAssessment | `supplierAssessmentCompleted == true` | Art 21(2)(d) |
| Art21-2d-SupplierSecurityPosture | `supplierSecurityLevel != 'NOT_ASSESSED' && supplierSecurityLevel != 'INADEQUATE'` | Art 21(2)(d) |
| Art21-2d-VulnerabilityDisclosure | `vulnerabilityManagementIncluded == true` | Art 21(2)(d) |
| Art21-3-SecureDevVerification | `secureDevProcedureVerified == true` | Art 21(3) |

Supply chain norms use chained applicability: `SupplierSecurityPosture` and `SecureDevVerification` require `supplierAssessmentCompleted == true` as a precondition (a supplier not yet assessed cannot fail security posture).

## Excluded NIS2 Concepts (with reason)

| NIS2 Concept | Articles | Reason for Exclusion |
| ------------- | ---------- | --------------------- |
| National CSIRT/authority organization | Art 8–13 | Member State institutional structure — not sourceable as entity-level governance |
| Cooperation Group / EU-CyCLONe | Art 14–16 | EU-level institutional coordination — outside entity governance scope |
| Peer reviews | Art 19 | Process between Member States — not entity-level |
| Voluntary notification | Art 30 | Optional mechanism — does not produce mandatory Directives/Norms |
| Jurisdiction rules | Art 26 | Meta-governance (which Member State governs which entity) — captured minimally in EntityClassification.memberState |
| Penalties framework | Art 34–36 | Enforcement consequence, not governance definition — not a Directive/Norm pattern |
| Certification schemes | Art 24 | Reference to EU cybersecurity certification (Regulation (EU) 2019/881) — orthogonal model |

## Governance Usage Patterns

### Pattern 1: Full NIS2 compliance governance chain

```
EntityClassification (scoping)          → "Is this entity in scope?"
  ↓
SectorScope (classification)            → "Which sector, which annex?"
  ↓
Art20-GovernanceAccountability (Directive)   → "Management MUST approve measures"
Art21-RiskManagement (Directive)             → "Entity MUST implement 10 measures"
Art23-IncidentReporting (Directive)          → "Entity MUST report incidents"
Art21-2d-SupplyChainSecurity (Directive)     → "Entity MUST secure supply chain"
  ↓
Art21-2a through Art21-2j (10 Norms)        → "Each measure category MUST be implemented"
Art20-1, Art20-2, Art20-3 (Governance Norms) → "Approval, training, employee training"
Art23-4a, Art23-4b, Art23-4c, Art23-4d (Temporal Norms) → "Reporting within 24h/72h/intermediate/1mo"
Art21-2d-*, Art21-3-* (Supply Chain Norms)  → "Supplier assessment, security posture, secure dev"
```

### Pattern 2: Three-model governance chain (NIS2 + ISO 25010 + TOGAF)

NIS2 mandates *what* must be secured (regulatory obligation). ISO 25010 defines *how* security is measured (quality vocabulary). TOGAF provides *where* the governance is architecturally place.

```
NIS2 Art21 Directive: "Entity MUST ENSURE RiskManagementMeasure"
  → NIS2 Art21-2h Norm: measureCategory == 'CRYPTOGRAPHY_AND_ENCRYPTION',
                        implementationLevel != 'NOT_IMPLEMENTED'

TOGAF Directive: "PaymentService MUST ENSURE ProductSecurity"
  → TOGAF Norm: ProductSecurity.encryptionAtRestEnabled == true
                ProductSecurity.minimumTlsVersion >= 'TLS_1_3'

ISO 25010 vocabulary on same Subject:
  → ProductSecurity: { tlsEnabled: true, minimumTlsVersion: 'TLS_1_3',
                        encryptionAtRestEnabled: true, dataClassification: 'CONFIDENTIAL' }
```

NIS2 Directive is the *why* (legal obligation). TOGAF Directive is the *what* (architecture decision). ISO 25010 is the *how* (measurable properties). All three compose on the same Subject via GSM multi-layer Ascription.

## Inter-Model Articulation

See `../README.md` for full articulation analysis including:

- NIS2 × ISO 25010 (Security overlap — F6)
- NIS2 × ISO 25011 (Service quality dimensions)
- NIS2 × ISO 25012 (Data quality governance)
- NIS2 × TOGAF (Architecture governance integration)

## Regulatory Model Sourcing Convention

NIS2 establishes the first **regulatory model sourcing** convention for OIP:

1. **Vocabulary schemas** (`.archetype.json`) define the regulation's domain-specific concepts — entity classification, compliance dimensions, reporting structures. Same conventions as quality/architecture models.

2. **Sourced Directives** (`*SourcedDirective.json`) encode the regulation's legal mandates in GSM Directive grammar (`$schema: Directive`, `statement: {modal, verb, qualifier, purpose}`). Each file traces to a specific article via `source`.

3. **Sourced Norms** (`*SourcedNorm.json`) encode the regulation's measurable requirements in GSM Norm grammar (`$schema: Norm`, `statement: {qualifier, applicability, assertion, toleranceMode, ...}`). Each file traces to a specific article via `source` and links to its parent Directive via `operationalizes`.

4. **Symbolic references** (`$nis2:regulatory-authority`, `$nis2:classified-entity`) mark parameters that are resolved at deployment when an entity adopts the regulation's governance. The regulatory authority is the authoring Structure; the classified entity is the governed purpose.

This convention is reusable for GDPR, DORA, CRA, SOX, PCI-DSS, and any other regulation that produces concrete Directives and Norms from legal text.

## File Inventory

| Type | Count | Files |
| ------ | ------- | ------- |
| Vocabulary schemas | 6 | EntityClassification, SectorScope, GovernanceAccountability, RiskManagementMeasure, IncidentReporting, SupplyChainSecurity |
| Sourced Directives | 4 | Art20-GovernanceAccountability, Art21-RiskManagement, Art23-IncidentReporting, Art21-2d-SupplyChainSecurity |
| Sourced Norms | 15 | 2 governance (Art20), 10 risk-management (Art21-2a through 2j), 3 incident-reporting (Art23-4a, 4b, 4d) |
| **Total** | **25** | |
