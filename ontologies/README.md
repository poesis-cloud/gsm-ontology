# Reference Ontology Composition

This document is the analytical companion to the inter-ontology composition of the catalogue's reference ontologies. Each reference ontology is sourced in isolation (P2 — no cross-ontology synthesis in schemas; it references only GSM); composition into a coherent governance whole is the exclusive role of the **domain layer**.

## Composition Principle

Reference ontologies are composed **through GSM**, not **within schemas**:

- Each reference ontology produces pure schemas in its own folder (`ontologies/{model}/`), inheriting the GSM bases directly through top-level `$ref`
- Cross-ontology references happen at the **governance layer**: Directives qualify Subjects using archetypes from different ontologies
- The GSM Ascription mechanism binds multiple Definition layers onto the same Subject
- Schema-level `allOf` composition of another ontology's rootless facet is reserved to the **domain layer** (e.g. `it/technology-architecture/PhysicalTechnologyComponent` composing `scap/PlatformIdentifier`)

**Example**: A TOGAF `LogicalApplicationComponent` (Structure) can be simultaneously governed by:

- A TOGAF `ArchitecturePrinciple` (Directive) qualifying ISO 25010 `ProductReliability` (quality dimension)
- An ISO 25012 `DataAccuracy` requirement on its data outputs
- An ISO 25011 `ServiceReliability` SLA target on the service it provides
- A TOGAF `Standard` (Directive) constraining its technology choices

## Dynamic/static paradigm (GSM §1)

When mapping ontology concepts to GSM, apply the dynamic/static distinction:

- **Dynamic** concepts (active systems with causal behavior — application components, services, teams, processes) map to **Structures** with Mechanisms.
- **Static** concepts (type definitions, schemas, code artifacts, templates, blueprints) map to **Archetypes**.
- A codebase is an Archetype (static structure), not a Structure. A software instance is a Structure (dynamic).
- Ontology "realizes" relationships (e.g., ArchiMate Artifact→ApplicationComponent) express the static-to-dynamic sourcing: Archetype content defines Structure behavior.

## Sourced Reference Ontologies

| Model | Source Standard | Scope | Schema Count |
| ------- | ---------------- | ------- | ------------- |
| **TOGAF** | TOGAF Standard, 10th Edition (The Open Group) | Enterprise Architecture — structures, behaviors, governance, ADM | 61 |
| **ISO 25000 (SQuaRE)** | ISO/IEC 25010:2011 + 25011:2017 + 25012:2008 | Quality Models — product quality (16), service quality (8), data quality (15) | 39 |
| **NIS2** | Directive (EU) 2022/2555 | EU Cybersecurity — entity classification, risk management, incident reporting, supply chain | 6 schemas + 4 directives + 21 norms |
| **GDPR** | Regulation (EU) 2016/679 | EU Data Protection — processing principles, lawful basis, data subject rights, controller/processor obligations, breach notification, impact assessment, transfers | 15 schemas + 26 directives + 53 norms |
| **SCAP** | NIST SP 800-126 r3 (SCAP 1.3) — CPE 2.3 + CCE | Security Identification — technology platform enumeration (CPE), configuration setting enumeration (CCE) | 2 |
| **aDRI-IRN** | aDRI-IRN framework (Alliance for Digital Resilience Initiative / International Resilience Network) | Open resilience standard — capability vocabulary, governance requirements, adherence Directives/Norms; composes with NIS2/DORA | 0 (Reserved — README only) |
| **HTTP** | RFC 9110 (HTTP Semantics, 2022) | HTTP protocol — direction-split archetype quad (Request/Response × Data/Effector/Receptor/Interaction). Migrated from sie-operator (Nov 2025); identity-bound on `method` + `targetUri`. The earlier per-verb-effectors-over-CRUD design is preserved as a future option in `/memories/repo/protocol-sourcing-patterns.md`. | 8 |
| **gRPC** | gRPC Core Concepts (CNCF) | Reserved (README only). Quad to be authored when first sourced. | 0 |
| **GraphQL** | GraphQL Spec (Lee Byron et al., 2015) | Reserved (README only). Quad to be authored when first sourced. | 0 |
| **Kafka** | Apache Kafka Protocol (ASF) | Reserved (README only). Quad to be authored when first sourced. | 0 |
| **AMQP** | OASIS AMQP 1.0 (2012) | Reserved (README only). Quad to be authored when first sourced. | 0 |
| **WebSocket** | RFC 6455 (WebSocket, 2011) | Reserved (README only). Quad to be authored when first sourced. | 0 |
| **JDBC** | JDBC API (JSR 221, Oracle) | Reserved (README only). Quad to be authored when first sourced. | 0 |
| **EIP** | Enterprise Integration Patterns (Hohpe & Woolf, 2003) | Data format — message type classification (event/document) | 1 |
| **CloudEvents** | CloudEvents 1.0.2 (CNCF, 2022) | Data format — cloud-native event envelope | 1 |
| **DDD** | Domain-Driven Design (Evans, 2003; Vernon, 2013) | Data format — domain/integration event classification | 1 |
| **OIDC** | OpenID Connect Core 1.0 (OpenID Foundation) | Identity vocabulary — Subject rootless facet (`sub`, `iss`): the shape of an OIDC-identified subject | 1 |
| **PROV** | W3C PROV-DM / PROV-O (W3C Recommendation, 2013) | Provenance vocabulary — Attribution rootless facet (`wasAttributedTo`): the standards-faithful authorship relation, agent identification left to the composing layer | 1 |
| **OAuth 2.0** | RFC 6749 (IETF) | Reserved (README only) — authorization roles (ResourceOwner, Client, AuthorizationServer, ResourceServer), tokens, grants; ResourceOwner is an access-granting role, not authorship | 0 |

## Domain Ontologies

| Ontology | Layer role | Composes | Contribution |
| ---------- | ----------- | --------- | ------------- |
| **IT** (`it/`) | Domain integrator for the IT domain, consumed by OIP | togaf, iso25000, gdpr, nis2, scap, http, oidc, prov | Typing archetypes per TOGAF architecture stratum (`application-architecture/`, `business-architecture/`, `data-architecture/`, `technology-architecture/`), each mounting the applicable ISO 25010/25011/25012 and PROV facets directly (the facet mount rule) |

## Model-Native Organization (P9)

Ontologies are organized by the **model's own taxonomy**, not by GSM subject type. The folder tells you what model domain owns the concept; the GSM subject type mapping is expressed in the schema content via top-level `$ref` to the corresponding ontology base Archetype (`gsmarc://gsm-ontology/Ontology{SubjectType}/v1`).

| TOGAF Taxonomy | NIS2 Taxonomy | ISO 25010 Taxonomy |
| --------------- | -------------- | ------------------- |
| `business-architecture/` | `entity-classification/` | `product-quality/` |
| `application-architecture/` | `risk-management/` | `quality-in-use/` |
| `data-architecture/` | `incident-reporting/` | |
| `technology-architecture/` | `supply-chain/` | |
| `governance/` | | |
| `adm/` | | |

### Quality vs Architecture vs Regulatory models

- **Quality models** (ISO 2501x): Define **measurement vocabularies** — transversal viability dimensions applicable to any governed entity. Produce vocabulary schemas only.
- **Architecture models** (TOGAF): Define **structural/behavioral/governance vocabularies** — entity types, functions, couplings, governance mechanisms. Produce vocabulary schemas only.
- **Regulatory models** (NIS2, GDPR, future DORA): Operate at **two layers simultaneously** — vocabulary schemas (regulation-specific concepts) AND sourced governance instances (concrete Directives/Norms from legal articles). Instances carry pure GSM grammar; their legal provenance (`source`: authority, regulation, article, verbatim text) is catalogue metadata on the ontology package's `elements[]` entries.

## Planned Ontologies

| Ontology | Contribution |
| ----------- | ------------- |
| **SAFe** | Agile governance dimensions (delivery cadence, flow metrics, PI objectives) |
| **ITIL** | Service management dimensions (SLA, incident, change, problem governance) |
| **DORA** | Digital operational resilience (ICT risk, incident classification, third-party) |

## Articulation Map

### TOGAF × ISO 25010 (Architecture Quality)

**Relationship**: TOGAF governance mechanisms (Directives, Norms) **reference** ISO 25010 quality characteristics as qualifiers.

| TOGAF Concept | Articulation | ISO 25010 Concept |
| --------------- | ------------- | ------------------- |
| ArchitecturePrinciple (Directive) | qualifies with → | Any product-quality characteristic (ProductReliability, ProductSecurity, etc.) |
| ArchitectureRequirement (Directive) | qualifies with → | Specific quality characteristic + measurable threshold |
| ArchitectureConstraint (Directive) | constrains using → | Quality bounds (e.g., min Availability, max latency) |
| Measure (Norm) | evaluates against → | Quality characteristic measurement properties |
| ArchitectureRequirementCompliance (Norm) | assesses → | Quality characteristic target vs actual |

**Governance pattern**: TOGAF Directives provide the **governance intent** ("this application must be reliable"); ISO 25010 archetypes provide the **measurement vocabulary** (faultToleranceLevel, circuitBreakerEnabled, retryPolicy).

### TOGAF × ISO 25012 (Data Governance)

**Relationship**: TOGAF data architecture concepts are **governed by** ISO 25012 data quality characteristics.

| TOGAF Concept | Articulation | ISO 25012 Concept |
| --------------- | ------------- | ------------------- |
| DataEntity (rootless) | governed by → | Any data quality characteristic |
| LogicalDataComponent (Structure) | governed by → | Inherent characteristics (Accuracy, Completeness, Consistency) |
| PhysicalDataComponent (Structure) | governed by → | System-dependent characteristics (DataAvailability, DataRecoverability) |
| ArchitecturePrinciple (Directive) | qualifies with → | Data quality dimension |
| Standard (Directive) | constrains using → | Data quality standard compliance |

**Governance pattern**: TOGAF defines **what data entities exist** and their architectural placement; ISO 25012 defines **how to measure and govern data quality** on those entities.

### ISO 25010 × ISO 25012 (Quality Complementarity)

**Relationship**: ISO 25010 governs **product/system quality**; ISO 25012 governs **data quality**. They are complementary, not overlapping.

| ISO 25010 | Overlap Area | ISO 25012 |
| ----------- | ------------- | ----------- |
| ProductAvailability (product uptime) | Related but distinct | DataAvailability (data accessible) |
| ProductSecurity (product security) | Related but distinct | DataConfidentiality (data protection) |
| ProductPortability (product portability) | Related but distinct | DataPortability (data portability) |
| ProductPerformanceEfficiency (product perf) | Related but distinct | DataEfficiency (data processing perf) |

**Disambiguation rule**: When both apply to the same Subject, ISO 25010 characteristics govern **the system's behavior**, while ISO 25012 characteristics govern **the data's intrinsic/systemic quality**. A system can be performant (ISO 25010) while serving low-quality data (ISO 25012), or vice versa.

### ISO 25010 × ISO 25011 (Product vs Service Quality)

**Relationship**: ISO 25010 governs **product/software quality** (intrinsic attributes of the artifact); ISO 25011 governs **IT service quality** (delivery experience around the artifact). Complementary, operating at different levels.

| ISO 25010 (Product) | Shared Name | ISO 25011 (Service) |
| --------------------- | ------------- | --------------------- |
| ProductReliability (fault tolerance, maturity) | Reliability | ServiceReliability (continuity, SLA availability) |
| ProductSecurity (encryption, authentication) | Security | ServiceSecurity (service-level confidentiality, traceability) |
| ProductUsability (learnability, accessibility) | Usability | ServiceUsability (+ courtesy, service-level operability) |
| ProductMaintainability (modularity, testability) | Maintainability | ServiceMaintainability (service-level analysability, modifiability) |
| — | Tangibility | ServiceTangibility (no product equivalent) |
| — | Responsiveness | ServiceResponsiveness (no product equivalent) |

**Disambiguation rule**: When both apply to the same Subject (e.g., a SaaS application), ISO 25010 governs **the software artifact's intrinsic quality**, while ISO 25011 governs **the service delivery experience**. A product can be reliable (ISO 25010) while the service wrapping it is unresponsive (ISO 25011), or vice versa.

**Quality in Use sharing**: ISO 25011 explicitly reuses ISO 25010's Quality in Use model. The `iso25000/iso25010/quality-in-use/` schemas apply to both products and services — they are not duplicated in `iso25000/iso25011/`.

### TOGAF × ISO 25011 (Service Governance)

**Relationship**: TOGAF governance mechanisms **reference** ISO 25011 characteristics as qualifiers for service-level governance.

| TOGAF Concept | Articulation | ISO 25011 Concept |
| --------------- | ------------- | ------------------- |
| PlatformService (Structure) | governed by → | Any service-quality characteristic |
| ArchitecturePrinciple (Directive) | qualifies with → | Service quality dimension (e.g., ServiceReliability target) |
| ArchitectureRequirement (Directive) | qualifies with → | Specific service quality + measurable threshold |
| Standard (Directive) | constrains using → | Service quality standard compliance |

**Governance pattern**: TOGAF defines **what services exist** and their architectural placement; ISO 25011 defines **how to measure and govern service delivery quality** on those services.

### ISO 25011 × ISO 25012 (Service vs Data Quality)

**Relationship**: ISO 25012 governs **data quality**; ISO 25011 governs **service quality**. A service may deliver data — the data quality is governed by ISO 25012, while the service delivery quality is governed by ISO 25011. Orthogonal dimensions.

### NIS2 × ISO 25010 (Regulatory Security vs Product Security)

**Relationship**: NIS2 mandates **what** must be secured (regulatory obligation with legal force); ISO 25010 defines **how** security is measured (quality vocabulary). NIS2 Directives qualify ISO 25010 archetypes — they compose, not conflict.

| NIS2 Concept | Articulation | ISO 25010 Concept |
| ------------- | ------------- | ------------------- |
| Art21 Risk Management (Directive) | mandates using → | ProductSecurity (encryption, auth, TLS) |
| Art21-2h Cryptography (Norm) | verifies through → | ProductSecurity.encryptionAtRestEnabled, .minimumTlsVersion |
| Art21-2j MFA (Norm) | verifies through → | ProductSecurity.authenticationMethod (OAUTH2, OIDC, MTLS) |
| GovernanceAccountability | orthogonal to | ProductFreedomFromRisk (economic/health/environmental) |
| IncidentReporting (temporal) | complements | ProductAvailability (uptime/recovery targets) |

**Governance pattern**: NIS2 Directive says *"Entity MUST ENSURE"* (regulatory obligation). The Norm checks implementation against ISO 25010 property vocabulary. NIS2 **creates the obligation**; ISO 25010 **provides the measurement vocabulary**.

### NIS2 × ISO 25011 (Regulatory vs Service Quality)

**Relationship**: NIS2 mandates service continuity and incident reporting; ISO 25011 defines service delivery quality dimensions. NIS2 temporal norms (24h/72h/1mo) have no ISO 25011 equivalent — they are legal deadlines, not SLA targets.

| NIS2 Concept | Articulation | ISO 25011 Concept |
| ------------- | ------------- | ------------------- |
| Art21-2c Business Continuity (Norm) | mandates capability of → | ServiceReliability (continuityLevel, recoverabilityTarget) |
| Art23 Incident Reporting (Directive) | complements | ServiceReliability (availabilityTarget) |
| IncidentReporting.deadlineHours | no equivalent (legal deadline) | ServiceResponsiveness (different semantic — user-facing) |

**Governance pattern**: NIS2 mandates continuity capability (Directive); ISO 25011 measures actual service quality delivery. A service can meet NIS2 continuity requirements while having poor ServiceResponsiveness, or vice versa.

### NIS2 × ISO 25012 (Regulatory vs Data Quality)

**Relationship**: NIS2 mandates data protection (confidentiality, integrity) as part of cybersecurity; ISO 25012 measures data quality dimensions independently.

| NIS2 Concept | Articulation | ISO 25012 Concept |
| ------------- | ------------- | ------------------- |
| Art21 Risk Management (security-related) | mandates protection of → | DataConfidentiality (classification, encryption, masking) |
| Art21-2c Business Continuity (Norm) | mandates recoverability of → | DataRecoverability (RPO, RTO, backup strategy) |
| GovernanceAccountability | governance layer for → | DataCompliance (applicableStandards includes 'NIS2') |
| SupplyChainSecurity | supply chain scope of → | DataAvailability (when data hosted by suppliers) |

**Governance pattern**: NIS2 Directives mandate security-level data governance. ISO 25012 provides the quality vocabulary for evaluating data handling. DataCompliance.applicableStandards can include "NIS2" to mark data assets under NIS2 scope.

### NIS2 × TOGAF (Regulatory vs Architecture Governance)

**Relationship**: NIS2 provides **regulatory governance** (legal mandates with penalties); TOGAF provides **architecture governance** (enterprise design principles and standards). Both produce Directives and Norms — they compose hierarchically.

| NIS2 Concept | Articulation | TOGAF Concept |
| ------------- | ------------- | --------------- |
| Art21 Risk Management (Directive) | regulatory driver for → | ArchitecturePrinciple (security principles derived from NIS2) |
| Art21-2d Supply Chain (Directive) | constrains → | Standard (technology standards for supplier integration) |
| EntityClassification | scoping input to → | Capability (organization-level capability mapping) |
| RiskManagementMeasure | maps to → | ArchitectureRequirement (technical requirements per measure category) |

**Governance pattern**: NIS2 Directives are the **legal root** of the governance chain. TOGAF Directives (ArchitecturePrinciples, Standards, Requirements) **derive from** NIS2 mandates, translating regulatory obligations into architecture decisions. The chain is: NIS2 Directive → TOGAF Principle/Standard → TOGAF Requirement → ISO 2501x quality target → Norm evaluation.

### GDPR × NIS2 (Dual EU Regulatory Ontology)

**Relationship**: GDPR and NIS2 are complementary EU regulations. NIS2 mandates **cybersecurity** measures; GDPR mandates **data protection** measures. Both produce Directives and Norms with legal force. Their scoping mechanisms differ (NIS2: entity tier classification; GDPR: controller/processor role), but many entities fall under both.

| GDPR Concept | Articulation | NIS2 Concept |
| ------------- | ------------- | ------------- |
| Art33 Breach Notification (72h to DPA) | parallel obligation with → | Art23 Incident Reporting (24h/72h/1mo to CSIRT) |
| Art5-1f Integrity & Confidentiality (principle) | complementary to → | Art21 Risk Management (10 security measures) |
| Art25 Data Protection by Design (Directive) | drives → | Art21-2h Cryptography (encryption mandate) |
| Art32 Security of Processing (not sourced) | overlaps with → | Art21 Risk Management (comprehensive overlap) |
| ControllerProcessorRole (scoping) | orthogonal to | EntityClassification (scoping) |

**Governance pattern**: Both regulations apply simultaneously to the same event (e.g., a data breach at an essential entity). NIS2 notifies the CSIRT; GDPR notifies the DPA + data subjects. The entity must satisfy both chains independently. Applicability expressions are orthogonal: NIS2 checks `entityTier`, GDPR checks `role`.

### GDPR × ISO 25010 (Data Protection vs Product Quality)

**Relationship**: GDPR mandates data protection (Art 5(1)(f) integrity/confidentiality, Art 25 data protection by design); ISO 25010 defines product security characteristics. GDPR **creates the obligation**; ISO 25010 **provides the measurement vocabulary**.

| GDPR Concept | Articulation | ISO 25010 Concept |
| ------------- | ------------- | ------------------- |
| Art5-1f Integrity & Confidentiality (Norm) | mandates using → | ProductSecurity (encryption, auth, TLS) |
| Art25 Data Protection by Design (Directive) | design-time driver for → | ProductSecurity + ProductMaintainability (modularity for privacy) |
| Art32 Security of Processing (not sourced) | evaluated through → | ProductSecurity (technical security measures) |
| Art22 Automated Decision-Making (Directive) | transparency driver for → | ProductFunctionalSuitability (explainability) |

**Governance pattern**: GDPR Art 5(1)(f) Norm says *"INTEGRITY_CONFIDENTIALITY principle compliant"*. ISO 25010 `ProductSecurity` provides the properties to measure (encryptionAtRestEnabled, minimumTlsVersion, authenticationMethod). Same composition pattern as NIS2 × ISO 25010.

### GDPR × ISO 25012 (Data Protection vs Data Quality)

**Relationship**: GDPR mandates data accuracy (Art 5(1)(d)), data minimisation (Art 5(1)(c)), and storage limitation (Art 5(1)(e)); ISO 25012 provides data quality measurement vocabulary. GDPR **creates the obligation**; ISO 25012 **provides the measurement properties**.

| GDPR Concept | Articulation | ISO 25012 Concept |
| ------------- | ------------- | ------------------- |
| Art5-1d Accuracy (Norm) | mandates → | DataAccuracy (syntacticAccuracy, semanticAccuracy) |
| Art5-1c Data Minimisation (Norm) | constrains → | DataRelevancy + DataCompleteness (minimum necessary data) |
| Art5-1e Storage Limitation (Norm) | constrains → | DataCurrentness (temporal relevance, retention limits) |
| Art5-1f Integrity & Confidentiality (Norm) | mandates → | DataConfidentiality (dataClassification, encryptionApplied) |
| Art17 Right to Erasure (Directive) | requires capability of → | DataRecoverability (deletion verification) |
| Art20 Portability (Directive) | requires capability of → | DataPortability (structured, machine-readable format) |

**Governance pattern**: GDPR principles create the **legal obligation** for data quality. ISO 25012 provides the **measurement vocabulary**. DataCompliance.applicableStandards can include "GDPR" to mark data assets under GDPR scope.

### GDPR × TOGAF (Regulatory vs Architecture Governance)

**Relationship**: GDPR provides **regulatory governance** for data protection; TOGAF provides **architecture governance** for enterprise design. GDPR mandates translate into architecture principles, requirements, and standards.

| GDPR Concept | Articulation | TOGAF Concept |
| ------------- | ------------- | --------------- |
| Art25 Data Protection by Design (Directive) | regulatory driver for → | ArchitecturePrinciple (privacy-by-design principles) |
| Art30 Records of Processing (Directive) | mandates → | InformationSystemService (data processing inventory) |
| ControllerProcessorRole | scoping input to → | Capability (data processing capability mapping) |
| TransferMechanism | constrains → | Standard (technology standards for cross-border data flows) |
| Art35 DPIA (Directive) | mandates assessment of → | ArchitectureRequirement (privacy requirements per processing activity) |

**Governance pattern**: GDPR Directives are the **legal root** for data protection governance. TOGAF translates them into architecture decisions. The chain is: GDPR Directive → TOGAF Principle/Standard → TOGAF Requirement → ISO 2501x quality target → Norm evaluation.

## SQuaRE Series — GSM Compatibility Trace

The sourced models (ISO 25010, 25011, 25012) belong to the **SQuaRE** (Systems and software Quality Requirements and Evaluation) series, a family of standards organized into divisions. This section traces how the full SQuaRE pipeline maps to GSM primitives, which SQuaRE divisions are sourced, and which remain candidates for future integration.

### SQuaRE division landscape

| Division | Standards | Purpose | Sourced? |
| ---------- | ----------- | --------- | ---------- |
| **2500n — Management** | 25000, 25001, 25002 | Common terms, planning guidance, quality model overview | No — process guidance, not a model |
| **2501n — Quality Models** | 25010, 25011, 25012, 25019 | Define quality characteristics and sub-characteristics | **Yes** — 25010 (16), 25011 (8), 25012 (15) = 39 archetype schemas |
| **2502n — Measurement** | 25020, 25022, 25023, 25024, 25025 | Define concrete measures (formulas, scales) for each quality characteristic | Not yet — candidate (see below) |
| **2503n — Requirements** | 25030 | Ontology for eliciting, defining, and governing quality requirements | Not sourceable as schemas — process standard (see below) |
| **2504n — Evaluation** | 25040 | Ontology for quality evaluation: process, rating modules, assessment | Partially sourceable (see below) |
| **25050–25099 — Extensions** | 25051, 25060–25069 | RUSP requirements, Common Industry Format for usability | Not yet relevant |

### Pipeline mapping: SQuaRE → GSM

The SQuaRE series forms a pipeline from quality definition through evaluation. Each stage maps to a specific GSM primitive:

```
SQuaRE Stage                         GSM Primitive
────────────                         ─────────────

2501n: Quality Models                Archetype schemas
  "what quality IS"                    iso25000/iso25010/, iso25000/iso25011/, iso25000/iso25012/
  characteristics + sub-chars          → property vocabularies
       │                                    │
       ▼                                    ▼
25030: Quality Requirements          Directive instances
  "what quality we REQUIRE"            modal × verb × qualifier × purpose
  stakeholder needs → constraints      → governance intent
       │                                    │
       ▼                                    ▼
2502n: Quality Measures              Norm assertions (CEL expressions)
  "how to MEASURE quality"             self.availabilityTarget != 'BEST_EFFORT'
  formulas, scales, thresholds         → executable constraint
       │                                    │
       ▼                                    ▼
25040: Quality Evaluation            Norm evaluation engine
  "how to JUDGE quality"               toleranceMode + temporalWindow + aggregation
  process, rating modules              → compliance determination
       │                                    │
       ▼                                    ▼
Result: pass / fail / score          Norm compliance status
                                       → Description-plane evidence
```

### Directive syntax ↔ ISO 25030 (Quality Requirements)

ISO 25030 defines *how to elicit, define, use, and govern quality requirements*. GSM's Directive grammar formalizes the same concepts into a machine-evaluable tuple.

| ISO 25030 Concept | GSM Directive Field | Correspondence |
| ------------------- | ------------------- | ---------------- |
| Stakeholder need / governed entity | `purpose` (Structure ref) | The Structure whose value/viability is governed |
| Quality characteristic (from 2501n models) | `qualifier` (Archetype ref) | Points to a quality archetype: `ProductReliability`, `ServiceResponsiveness`, `DataAccuracy`, etc. |
| Normative strength (mandatory / recommended / optional) | `modal` enum | `MUST` = mandatory, `SHOULD` = recommended, `MAY` = optional — formalizes the deontic strength 25030 describes in prose |
| Governance direction | `verb` enum | `ENSURE`, `PREVENT`, `MAINTAIN`, `OPTIMIZE`, etc. — makes the governance action explicit |
| Requirement type (QIU / product / service / data) | Implicit from `qualifier` archetype family | `qualifier → ProductReliability` = product quality req; `qualifier → ServiceReliability` = service quality req; `qualifier → DataAccuracy` = data quality req |
| Derivation (QIU → product → service → data) | Multiple Directives on same `purpose`, different qualifier families | Same Structure gets a Directive per quality model, derived from the same stakeholder need |
| Deployment (system → subsystem → component) | Multiple Directives on different `purpose` targets | Top-level Directive on an application → child Directives on its components; same grammar, narrower scope |
| Conflict / trade-off resolution (§6.5) | Modal precedence + contradiction detection | `MUST > SHOULD > MAY`; `MUST ENSURE X` + `MUST PREVENT X` on same purpose → contradiction error |

**Example** — *"The payment service must ensure high availability"* as a GSM Directive:

```json
{
  "modal": "MUST",
  "verb": "ENSURE",
  "qualifier": "<ServiceReliability archetype UUID>",
  "purpose": "<payment-service Structure UUID>"
}
```

The `qualifier` points to `ServiceReliability.archetype.json` (ISO 25011), which defines the property vocabulary (`availabilityTarget`, `continuityLevel`, `recoverabilityTarget`). The Directive declares **governance intent**; the archetype schema declares **what properties exist**; the Norm (below) makes it **measurable**.

### Norm syntax ↔ ISO 25040 (Quality Evaluation) + 2502n (Measures)

ISO 25040 defines the **Quality Rating Module (QRM)** as its central evaluation artifact: a bundle of quality measures + operational environment + measurement/rating methods. GSM's Norm is a formalized QRM.

| ISO 25040 / 2502n Concept | GSM Norm Field | Correspondence |
| --------------------------- | --------------- | ---------------- |
| Quality measure (from 2502n) | `assertion` (CEL expression) | The evaluable formula — `self.availabilityTarget != 'BEST_EFFORT'`. 2502n defines formulas in prose; GSM writes them as executable CEL. |
| Measurement source | `qualifier` (Archetype ref) | Points to the archetype whose properties the assertion evaluates — determines what data is needed |
| Operational environment (where/when applies) | `applicability` (CEL expression) | `DeploymentProperties.environment == "production"` — scopes the evaluation context |
| Rating method | `toleranceMode` enum | Maps the three evaluation paradigms: **INSTANTANEOUS** = binary pass/fail (design-time assertion), **AGGREGATED** = metric aggregation over time window (SLO), **SUSTAINED** = uptime ratio over window (SLA) |
| Temporal scope | `temporalWindow` (ISO 8601) | `PT5M`, `PT1H`, `P1D` — the observation window |
| Aggregation function | `temporalAggregation` enum | `AVG`, `P95`, `P99`, `MIN`, `MAX`, `COUNT`, etc. — how samples are aggregated |
| Sustained compliance threshold | `sustainedThreshold` (0–1) | Ratio for SLA-style evaluation — e.g., 0.999 for 99.9% availability |
| Quality Rating Module (QRM) — full bundle | Complete Norm instance | All fields together form one QRM |
| Template rating module (parameterized QRM) | Norm with `applicability: "true"` | Universally applicable, parameterizable per Subject |
| Implementation rating module (concrete QRM) | Norm with specific `applicability` | Scoped to a specific operational slice |

**Example** — *"In production, payment service availability ≥ 99.9% over any 5-minute window"* as a GSM Norm:

```json
{
  "qualifier": "<ServiceReliability archetype UUID>",
  "applicability": "DeploymentProperties.environment == \"production\"",
  "assertion": "self.availabilityTarget != 'BEST_EFFORT' && self.availabilityTarget != 'STANDARD_99'",
  "toleranceMode": "SUSTAINED",
  "temporalWindow": "PT5M",
  "temporalAggregation": "AVG",
  "sustainedThreshold": 0.999
}
```

### Unsourced SQuaRE divisions — integration assessment

#### 2502n (Quality Measurement) — candidate for future sourcing

**What it provides**: Concrete quality measures (formulas, scales, base/derived measures) for each 2501n characteristic. Standards: 25022 (quality in use measures), 25023 (product quality measures), 25024 (data quality measures), 25025 (IT service quality measures).

**GSM mapping**: 2502n measures would become **Norm assertion libraries** — pre-built CEL expressions that evaluate archetype properties according to standard formulas. They are the *content* that fills the Norm container.

**Integration shape**: Not archetype schemas (not quality characteristics). Would be expressed as **assertion catalogs** or **Norm templates** — reusable `(qualifier, assertion, toleranceMode)` tuples that operators can instantiate on specific Subjects.

**When**: When OIP builds Norm authoring UX and needs a library of standard assertions for each quality archetype.

#### 25030 (Quality Requirements) — not sourceable as schemas

**What it provides**: Process guidance for eliciting, defining, and governing quality requirements.

**GSM mapping**: 25030 is *already operationalized* by the Directive grammar. GSM Directives ARE the quality requirement format that 25030 describes in prose. There is nothing to source as schemas — the entire standard is embodied in `Directive.archetype.json`.

**Integration shape**: Architectural influence on OIP's Directive authoring workflow — derivation chains (QIU → product → service → data) and deployment chains (system → subsystem → component) could inform OIP's UX for Directive creation.

#### 25040 (Quality Evaluation) — partially sourceable

**What it provides**: Evaluation process ontology, Quality Rating Module (QRM) concept, four evaluation types (suitability, qualification, conformity, market fitness).

**GSM mapping**: The QRM is *already operationalized* by the Norm grammar. GSM Norms ARE QRMs. The four evaluation types (suitability to use / qualification to standard / conformity to requirements / market fitness) could be expressed as a classification enum on Directives or Norms.

**Integration shape**: Potentially one small classification schema (`EvaluationType` enum archetype) plus architectural influence on how Norm evaluation results are categorized and reported.

### Compatibility summary

| SQuaRE Division | GSM Compatibility | Status |
| ----------------- | ------------------ | -------- |
| 2501n (Models) | Quality characteristics → **Archetype schemas** (property vocabularies) | **Sourced** — 39 schemas across 3 models |
| 25030 (Requirements) | Quality requirement framework → **Directive grammar** (modal × verb × qualifier × purpose) | **Operationalized** — embodied in `Directive`, not separately sourceable |
| 2502n (Measurement) | Quality measures → **Norm assertions** (CEL expressions) | **Compatible** — future assertion catalogs |
| 25040 (Evaluation) | Quality evaluation → **Norm evaluation engine** (toleranceMode + temporalWindow + aggregation) | **Operationalized** — embodied in `Norm`, partially sourceable (evaluation types) |

## Composition Evaluation Checklist

When adding a new model, evaluate against all existing models:

1. **Overlap identification**: Which concepts in the new model have semantic overlap with existing model concepts?
2. **Boundary clarity**: For each overlap, is the boundary between models clear? (e.g., product quality vs data quality)
3. **Governance path coherence**: Can Directives from one model coherently qualify archetypes from another?
4. **Vocabulary collision**: Do any schema titles or property names collide within the same composition context? (Archetype titles are no longer globally unique — see "Terminology and file conventions" in the root `README.md` — but two colliding titles mounted as sibling facets in one composite would still conflate, so check the specific composition, not the whole catalogue)
5. **Ascription compatibility**: Can the same Subject receive Ascriptions from both models without contradiction?
6. **Measurement independence**: Can quality characteristics from different models be measured independently?

## Known Frictions

### F1: Observability (TOGAF) vs ISO 25010

Observability is an operational quality dimension sourced from TOGAF/SRE practices, kept in `togaf/technology-architecture/`. ISO 25010 does not formalize observability as a quality characteristic. If a future SRE/operational model is sourced, Observability could migrate there. For now it remains TOGAF-specific.

### F2: Scalability (ISO 25010) positioning

Scalability is kept in `iso25000/iso25010/product-quality/` as a standalone schema. In ISO 25010:2011 it maps closest to Performance Efficiency → Capacity. In ISO 25010:2023 it appears under Flexibility → Scalability. The current placement as a standalone product-quality schema works for both interpretations.

### F3: Data quality × Product quality on same Subject

A data-processing Structure (e.g., PhysicalDataComponent) may need BOTH ISO 25010 quality governance (system reliability) AND ISO 25012 quality governance (data accuracy). GSM handles this through **multiple Definitions** on the same Structure — each Definition typed by a different quality Archetype, each carrying its own in-effect Ascription. Governance priority between conflicting quality requirements must be resolved by TOGAF governance Directives (meta-governance).

### F4: Product quality × Service quality on same Subject (SaaS)

A SaaS application is simultaneously a software product (ISO 25010) and an IT service (ISO 25011). Both quality models apply. GSM handles this through multiple Definitions on the same Structure, each typed by the relevant quality Archetype (25010, 25011, 25012), each with its own governance lifecycle. Conflicts (e.g., ProductReliability says HIGH but ServiceReliability SLA says BEST_EFFORT) must be resolved by TOGAF governance Directives.

### F5: Tangibility (ISO 25011) vs Observability (TOGAF)

ServiceTangibility.visibility and TOGAF Observability both address "making internal state visible". ServiceTangibility is user-facing (reports, dashboards, communication quality) while TOGAF Observability is operations-facing (metrics, logs, traces). Related but distinct audiences. If they drift toward overlap, a boundary clarification in Directives may be needed.

### F6: NIS2 Security × ISO 25010 ProductSecurity (Regulatory vs Quality)

NIS2 mandates cybersecurity risk management (Art 21); ISO 25010 defines ProductSecurity as a quality characteristic (TLS, auth, encryption). The overlap is by design — NIS2 creates the **obligation** (Directive), ISO 25010 provides the **measurement vocabulary** (Archetype properties). But the boundary can blur: NIS2 Art 21(2)(h) mandates cryptography, while ProductSecurity.encryptionAtRestEnabled measures it. Resolution: NIS2 Norms should reference ISO 25010 property paths in their CEL assertions, keeping NIS2 as the governance driver and ISO 25010 as the quality vocabulary. No schema duplication — composition through Directive→Norm→Archetype chain.

### F7: Regulatory Scoping vs Universal Quality

Quality models (ISO 2501x) are **transversal** — any entity can have ProductReliability or DataAccuracy. NIS2 is **scoped** — only entities classified ESSENTIAL or IMPORTANT per EntityClassification are subject to NIS2 Directives. This introduces a new pattern: NIS2 Norms use `applicability: EntityClassification.entityTier in ['ESSENTIAL', 'IMPORTANT']` to scope their assertions. Quality model Norms typically use `applicability: "true"` (universal). When composing NIS2 + quality models on the same Subject, the NIS2 applicability acts as an additional activation condition — the quality dimension is always measurable, but the NIS2 obligation only activates for classified entities.

### F8: GDPR × NIS2 Breach Notification Overlap

Both GDPR (Art 33) and NIS2 (Art 23) mandate breach/incident notification with different timelines (GDPR: 72h to DPA; NIS2: 24h early warning + 72h notification to CSIRT) and different recipients (GDPR: supervisory authority + data subjects; NIS2: CSIRT). When both apply to the same event (personal data breach at an essential entity), norms from both regulations activate independently. Resolution: model them as orthogonal governance chains on the same Subject — both scope applicability on their own vocabulary (NIS2: entityTier; GDPR: role + breach risk level). No schema duplication needed; the breach event satisfies both vocabularies simultaneously through GSM multi-layer Ascription.

### F9: GDPR Compound Applicability vs Simple Applicability

GDPR introduces **compound applicability expressions** (role + specific condition, e.g., `ControllerProcessorRole.role in [...] && LawfulBasis.lawfulBasis == 'CONSENT'`) unlike NIS2's simple tier-based applicability. This means GDPR norms often reference multiple vocabulary schemas in their applicability expressions. The CEL evaluation engine must resolve cross-schema references within applicability expressions — this is architecturally consistent with GSM's multi-Ascription model but introduces higher applicability complexity than NIS2.

### F10: GDPR Data Accuracy × ISO 25012 DataAccuracy

GDPR Art 5(1)(d) mandates data accuracy as a legal obligation with enforcement consequences. ISO 25012 DataAccuracy measures accuracy as a quality dimension. The overlap is by design: GDPR creates the obligation; ISO 25012 provides the measurement vocabulary. But GDPR accuracy is broader (includes rectification and erasure rights) while ISO 25012 accuracy is narrower (syntactic/semantic accuracy of data values). Resolution: GDPR Norms should reference ISO 25012 property paths where applicable, but GDPR Directives/Norms also cover procedural obligations (right to rectification) that have no ISO 25012 equivalent.

### SCAP × TOGAF (Technology Platform Identification)

**Relationship**: SCAP CPE provides a standardized identification scheme for TOGAF technology-architecture subjects.

| TOGAF Concept | Articulation | SCAP Concept |
| --------------- | ------------- | --------------- |
| TechnologyComponent (Structure) | identified by → | PlatformIdentifier (CPE URI + decomposed attributes) |
| PlatformService (Structure) | identified by → | PlatformIdentifier |
| LogicalTechnologyComponent (Structure) | platform-scoped by → | PlatformIdentifier.part, .vendor, .product |
| PhysicalTechnologyComponent (Structure) | identified by → | PlatformIdentifier (specific version + hardware) |

**Governance pattern**: TOGAF defines **what technology subjects exist** and their architectural role; SCAP CPE identifies **what technology platform** each subject IS. CPE-decomposed properties (`part`, `vendor`, `product`, `version`) enable technology-specific Norm applicability expressions: `self.PlatformIdentifier.vendor == 'redhat'`.

### SCAP × NIS2 (Compliance Evidence Substrate)

**Relationship**: SCAP provides the identification substrate for NIS2 Art 21 risk management compliance.

| NIS2 Concept | Articulation | SCAP Concept |
| ------------- | ------------- | --------------- |
| RiskManagementMeasure (Art 21) | scoped to platforms via → | PlatformIdentifier |
| RiskManagementMeasure (Art 21) | verified at setting level via → | ConfigurationSetting (CCE ID) |

**Governance pattern**: NIS2 mandates security measures; SCAP identifies what technologies and settings those measures check. A NIS2 Norm applicability can scope to specific platform types (`PlatformIdentifier.part == 'OPERATING_SYSTEM'`), and predicates can reference specific CCE-identified configuration settings.

### SCAP × ISO 25010 (Security Quality Measurement)

**Relationship**: SCAP identifies the technology targets that ISO 25010 ProductSecurity measures are evaluated against.

| ISO 25010 Concept | Articulation | SCAP Concept |
| ------------------- | ------------- | --------------- |
| ProductSecurity (quality dimension) | measured on platform identified by → | PlatformIdentifier |
| ProductSecurity properties (encryption, auth) | checked against settings identified by → | ConfigurationSetting |

**Governance pattern**: ISO 25010 provides the quality vocabulary (what security properties mean); SCAP provides the identification substrate (what technology and what specific setting). ProductSecurity.encryptionAtRestEnabled, for example, is checked against a CCE-identified setting on a CPE-identified platform.

## Not Yet Sourced Ontologies (with justification)

OIP is designed to compose multiple ontologies through GSM. The sourced ontologies above were chosen because they form a **minimum coherent governance fabric**: architecture vocabulary (TOGAF), quality measurement (ISO 25000 SQuaRE), and regulatory compliance (NIS2 + GDPR). The following ontologies are known candidates but not yet sourced:

### Regulatory / Legal Ontologies

| Ontology | Full Name | Reason Not Yet Sourced |
| ----------- | ----------- | ------------------------ |
| **DORA** | Regulation (EU) 2022/2554 — Digital Operational Resilience Act | Overlaps significantly with NIS2 on ICT risk management; applies specifically to financial entities. Candidate for sourcing when OIP expands to financial sector governance. Many DORA obligations would articulate with existing NIS2 vocabulary (risk management, incident reporting, supply chain). |
| **CRA** | Regulation (EU) 2024/2847 — Cyber Resilience Act | Product-level cybersecurity requirements for hardware/software with digital elements. Orthogonal to NIS2 (entity-level) — CRA governs the product lifecycle. Candidate when OIP models product lifecycle governance. |
| **PCI-DSS** | Payment Card Industry Data Security Standard v4.0 | Industry standard (not EU regulation) for payment data security. Narrow sector scope — 12 requirements map well to GSM Directives/Norms but serve only payment-processing entities. |
| **SOX** | Sarbanes-Oxley Act (US) | US financial reporting and internal controls. Non-EU jurisdiction; narrow to publicly traded companies. Would require jurisdiction-scoping vocabulary beyond the current EU regulatory model. |
| **eIDAS 2.0** | Regulation (EU) 2024/1183 — European Digital Identity | Digital identity wallets and trust services. Complementary to GDPR (identity verification) but narrow scope — candidate when OIP models identity governance. |
| **AI Act** | Regulation (EU) 2024/1689 — Artificial Intelligence Act | Risk-based AI governance. Would introduce a new scoping dimension (AI risk classification) orthogonal to NIS2 entity tiers and GDPR controller/processor roles. High-priority candidate for future sourcing. |

### Architecture / Governance Ontologies

| Ontology | Full Name | Reason Not Yet Sourced |
| ----------- | ----------- | ------------------------ |
| **ITIL 4** | ITIL 4 Foundation (Axelos/PeopleCert) | IT Service Management practices. TOGAF already covers architecture governance; ITIL would add operational service management (incident, change, problem). Candidate when OIP expands to operational governance beyond architecture. |
| **COBIT 2019** | Control Objectives for Information and Related Technologies | IT governance and management ontology. Overlaps with TOGAF governance concepts (principles, requirements, controls). Candidate if OIP needs a distinct IT audit/control vocabulary. |
| **SAFe** | Scaled Agile Ontology | Agile delivery governance. Different governance paradigm (portfolio → program → team) — not a compliance or quality ontology. Candidate if OIP models delivery governance. |
| **ArchiMate** | ArchiMate 3.2 (The Open Group) | Enterprise Architecture modeling language. Overlaps significantly with TOGAF Content Metamodel (which is already sourced). ArchiMate adds viewpoint formalization but most entity concepts are already covered by TOGAF schemas. |

### Quality / Measurement Standards

| Ontology | Full Name | Reason Not Yet Sourced |
| ----------- | ----------- | ------------------------ |
| **ISO 25020–25025** | SQuaRE 2502n — Quality Measurement | Concrete quality measures (formulas, scales) for 2501n characteristics. Would become Norm assertion libraries — not archetype schemas. Candidate when OIP builds Norm authoring UX. |
| **ISO 27001/27002** | Information Security Management System | Security controls catalog. NIS2 Art 21 already mandates cybersecurity measures; ISO 27001 controls would provide finer-grained security vocabulary. Candidate when OIP needs control-level granularity beyond NIS2. |
| **ISO 22301** | Business Continuity Management | Business continuity ontology. NIS2 Art 21(2)(c) already mandates business continuity; ISO 22301 would add detailed BCM vocabulary. Candidate for BCM-heavy sectors. |
| **ISO 9001** | Quality Management Systems | Process-oriented quality management. Different paradigm from SQuaRE (process vs product/service/data quality). Not a quality model — a management system standard. |

## Candidate Ontologies

The following ontologies are evaluated as potential future sourcing targets. They are organized along the **DNA axis** — the same axis OIP users follow when governing their subjects:

```
Directive    — strategic direction definition (WHY / WHAT to govern)
    │ operationalized by
    ▼
Norm         — constraint definition (HOW — assertions referencing subject properties)
    │ constrains
    ▼
Ascription   — subject definition (ON WHAT — typed properties on governed subjects)
```

Every sourced ontology produces artifacts at all three DNA levels, but each ontology has a **primary contribution level** — the level where its sourced content is densest and most unique. The sections below group candidate ontologies by that primary level, from the highest (Directive-heavy) to the lowest (Ascription-heavy / vocabulary-heavy).

**Sourcing sequence principle**: Ascription-level ontologies (vocabulary / subject-typing) should generally be sourced before Norm-heavy ontologies, because Norm assertions reference typed properties that must already exist in the vocabulary. You cannot write `self.permitRootLogin == false` if no vocab schema defines `permitRootLogin` as a property on an OS-typed subject.

### Directive-primary ontologies (strategic direction)

Ontologies whose primary contribution is **Directives** — they define strategic governance postures, practice mandates, and governance structure that Norms then operationalize. They also produce vocab schemas and Norms, but the Directives are the irreducible core.

| Ontology | Full Name / Source | What It Provides | GSM Mapping | Est. Files | Articulation with Sourced Ontologies |
| ----------- | -------------------- | ------------------ | ------------- | ------------ | -------------------------------------- |
| **NIST CSF 2.0** | NIST Cybersecurity Ontology 2.0 | 6 Functions (Govern, Identify, Protect, Detect, Respond, Recover), 22 Categories, 106 Subcategories. Outcome-based — describes what to achieve, not how. Broader than pure security (includes Govern function for risk governance). | 6 vocab schemas (one per Function) + **22 Directives** (one per Category) + 106 Norms (one per Subcategory). | ~132 | **NIS2**: Informative References map CSF subcategories to NIS2 articles. **CIS Controls**: CIS provides the "how" for CSF's "what" — CSF Subcategory → CIS Control mapping is published by NIST. **TOGAF**: CSF Govern function articulates with TOGAF ArchitectureGovernance. |
| **ITIL 4** | ITIL 4 (Axelos/PeopleCert) | **34 practices** across 3 categories for full service operational lifecycle governance. General Management (14), Service Management (17), Technical Management (3). Each practice has properties, KPIs, and processes. | 34+ vocab schemas (one per practice area + core types) + **~34 Directives** (one per practice) + ~60–80 Norms (measurable process compliance). | ~120–140 | **ISO 25011** (strongest): ITIL SLA targets directly implement ServiceReliability, ServiceResponsiveness, ServiceUsability. **NIS2**: Incident → Art 23; Continuity → Art 21(2)(c); Security → Art 21 risk; Supplier → Art 21(2)(d). **GDPR**: Security → Art 32; Service Catalogue tracks Art 30. **TOGAF**: Services → PlatformService; CIs → TechnologyComponents. **SRE**: SLOs implement SLA targets. **DORA Metrics**: Change Enablement → Change Failure Rate. |
| **SAFe 6.0** | Scaled Agile Ontology 6.0 | Portfolio-to-team delivery governance: Value Streams, ARTs, PIs, Epics, WSJF, Lean Budget Guardrails, Flow Metrics. **The only ontology governing the organization of work itself** — portfolio economics, delivery flow, PI predictability, WIP governance. | 8+ vocab schemas (ValueStream, ART, PI, Epic, Feature, Enabler, LeanBudgetGuardrail, FlowMetrics) + **~15–20 Directives** (PI cadence, WIP limits, predictability targets, innovation allocation, WSJF) + ~25–35 Norms. | ~55–70 | **TOGAF**: Architectural Runway → ArchitectureRequirements; Enablers → Building Blocks. **DORA Metrics**: SAFe 6.0 incorporates DORA; flowVelocity ≈ Deployment Frequency. **ISO 25010**: Flow metrics → ProductMaintainability. **FinOps**: Lean Budget Guardrails articulate with FinOps. **NIS2**: Compliance Enablers track NIS2 implementation. |
| **FinOps Ontology** | FinOps Foundation (Linux Foundation) | Cloud financial management: 6 domains, 18 capabilities, 3 maturity phases (Crawl/Walk/Run), FOCUS™ billing standard. Key metrics: `costAllocationCoverage`, `forecastAccuracy`, `budgetVariance`, `unitCost`, `wastePercent`, `tagComplianceRate`. | 6+ vocab schemas (FinOpsCapabilityMaturity, CloudCostAllocation, CloudSpendOptimization, CloudBudget, CloudUnitEconomics, FOCUSBillingRecord) + **18 Directives** (one per capability) + ~10 Norms. | ~25–35 | **TOGAF**: FinOps governs cost dimension of TechnologyComponents and InfrastructureServices. **ISO 25010**: resourceUtilization ↔ waste/rightSizing. **GSF SCI**: carbon and cost coupled — both measure resource efficiency. **Well-Architected**: Cost Optimization pillar IS FinOps applied to a specific cloud. **SAFe**: Lean Budget Guardrails articulate at portfolio level. |
| **DMBOK** | DAMA Data Management Body of Knowledge (DAMA-DMBOK2, 2017) | 11 Knowledge Areas: Data Governance, Architecture, Modeling, Storage, Security, Integration, Content, Master Data, DW&BI, Metadata, Data Quality. Broader than ISO 25012 (quality-only). | 11 vocab schemas (one per KA) + **Directives per KA capability** + Norms per practice. | ~80–120 | **ISO 25012**: DMBOK KA11 (Data Quality) extends ISO 25012. DMBOK provides **management process** around ISO 25012's measurement vocabulary. **TOGAF**: Data Architecture (KA2) articulates with DataEntity, LogicalDataComponent. **GDPR**: Data Governance (KA1) + Data Security (KA5) articulate with controller/processor obligations. |
| **CMMI v2.0** | Capability Maturity Model Integration (ISACA) | 5 maturity levels, 20 Practice Areas (Doing, Managing, Enabling, Improving). Process maturity assessment with specific practices per area per level. | 4 vocab schemas (one per category) + **20 Directives** (one per Practice Area) + ~60 Norms (key practices at levels 2–4). | ~85 | **TOGAF**: Practice Areas → ArchitectureCapabilities and maturity assessment. **ISO 25010**: Enabling practices articulate with quality measurement. **SRE/DORA**: CMMI maturity levels correlate with DORA metric tiers. |

### Norm-primary ontologies (operational constraints)

Ontologies whose primary contribution is **Norms** — they define measurable constraints, control checks, practice rules, and compliance assertions. Their Directives are usually few (one per control domain/category), but the Norm catalog is the irreducible core. Norm assertions reference properties from vocab schemas (both their own and from Ascription-level ontologies).

#### Security

| Ontology | Full Name / Source | What It Provides | GSM Mapping | Est. Files | Articulation with Sourced Ontologies |
| ----------- | -------------------- | ------------------ | ------------- | ------------ | -------------------------------------- |
| **CIS Controls v8** | Center for Internet Security Controls v8 | 18 Controls, **153 Safeguards** organized by Implementation Group (IG1/IG2/IG3). Bridges regulatory mandates to actionable safeguards. | 2 vocab schemas (CISControlCategory, CISImplementationGroup) + 18 Directives + **153 Norms** (one per Safeguard). Applicability scopes by IG level. | ~173 | **NIS2**: Art 21 10 measures map 1:1 to CIS Control groups — CIS provides safeguard-level granularity. **ISO 25010**: Safeguard assertions reference ProductSecurity properties. **TOGAF**: Controls map to ArchitectureRequirements. **CIS Benchmarks / STIGs**: Controls → abstract requirement; Benchmarks/STIGs → technology-specific implementation. |
| **OWASP Top 10 (2021)** | OWASP Top 10 Web Application Security Risks | 10 risk categories (Broken Access Control, Cryptographic Failures, Injection, Insecure Design, etc.). Smallest security ontology — high signal, low effort. | 1 vocab schema (OWASPRiskCategory) + 10 Directives + **~30 Norms** (2–4 per category). | ~50 | **NIS2**: each Top 10 category maps to at least one Art 21 measure. **OWASP ASVS**: Top 10 is the summary; ASVS is the detail. **ISO 25010**: risk categories reference ProductSecurity properties. |
| **OWASP ASVS v4.0.3** | OWASP Application Security Verification Standard | **286 requirements** across 14 chapters at 3 verification levels (L1/L2/L3). | 14 vocab schemas + 14 Directives + **286 Norms**. Applicability scopes by verification level. | ~302 | **GDPR**: Art 25 Data Protection by Design → ASVS V8, V9. **NIS2**: Art 21 measures → ASVS chapters (V2 Auth, V6 Crypto). **ISO 25010**: assertions reference ProductSecurity properties. |
| **NIST SP 800-53 r5** | NIST Special Publication 800-53 Revision 5 | **1,189 controls** across 20 families. Most comprehensive security control catalog. Baselines: Low/Moderate/High. | 20 vocab schemas + 20 Directives + **1,189 Norms**. Baselines scope via guards. | ~1,211 | **NIST CSF**: CSF references 800-53 as informative references. **CIS Controls**: Safeguards map to 800-53 controls. **NIS2**: many Art 21 measures have 800-53 equivalents. Massive — sourced incrementally by family. |
| **NIST SSDF v1.1** | NIST Secure Software Development Ontology | **42 practices** across 4 groups (Prepare, Protect, Produce, Respond). Development lifecycle, not runtime. | 4 vocab schemas + 4 Directives + **42 Norms**. | ~48 | **OWASP ASVS**: SSDF operationalizes the development-side of ASVS. **CIS Controls**: Safeguard 16 maps to SSDF practices. **TOGAF**: practices constrain the application development process. |
| **CSA CCM v4** | Cloud Security Alliance Cloud Controls Matrix v4 | **197 controls** across 17 domains. Cloud-specific. | 17 vocab schemas + 17 Directives + **197 Norms**. | ~217 | **NIS2**: CCM domains → Art 21 measures. **ISO 27001**: CCM cross-references 27001 controls. **NIST CSF/800-53**: published mapping tables. Cloud-scoped overlay. |
| **DISA STIGs** | Defense Information Systems Agency — Security Technical Implementation Guides | Per-technology mandatory configuration rules. ~400+ individual STIGs, hundreds of findings each (CAT I/II/III). Distributed as **SCAP content** (XCCDF + OVAL). | Per-STIG: 1 vocab schema + 1 Directive + **N Norms** (one per finding, N = 70–350). Assertions check CIM/OpenConfig-sourced and SCAP-identified properties. | 3 + N per STIG | **SCAP/CPE/CCE**: STIGs are distributed as SCAP content — each finding has a CCE ID targeting a CPE platform. **CIM/Redfish + OpenConfig**: Norm assertions check infrastructure vocab properties. **CIS Benchmarks**: ~80% overlap; STIGs more prescriptive. **NIS2**: STIG compliance comprehensively satisfies Art 21. |
| **CIS Benchmarks** | Center for Internet Security Benchmarks | Per-technology hardening (OS, Cloud, Containers, Databases, Web servers, Middleware, Network, Desktop). 50–150 rules per benchmark, Profile levels (L1/L2). | Per-benchmark: 1 vocab schema + **N Norms** (one per rule). Assertions check CIM/OpenConfig-sourced and SCAP-identified properties. | 50–150 per benchmark | **SCAP/CPE/CCE**: Benchmarks reference CCE IDs and target CPE platforms. **CIM/Redfish + OpenConfig**: assertions check infrastructure vocab properties. **CIS Controls**: each Benchmark rule traces to a Safeguard (parent→child). **DISA STIGs**: ~80% overlap; Benchmarks less prescriptive, more accessible. |

#### Operational / Reliability

| Ontology | Full Name / Source | What It Provides | GSM Mapping | Est. Files | Articulation with Sourced Ontologies |
| ----------- | -------------------- | ------------------ | ------------- | ------------ | -------------------------------------- |
| **SRE Practices** | Google Site Reliability Engineering (O'Reilly, 2016 + 2018) | SLOs, Error Budgets, Toil Budgets, Incident Management, Capacity Planning. Defines **how** to set, measure, and enforce service reliability targets. | 3–4 vocab schemas (SLO, ErrorBudget, ToilBudget, IncidentSeverity) + Directives per practice + **Norms encoding SLO/burn-rate assertions**. | ~40–60 | **ISO 25010**: SLOs reference ProductReliability, ProductPerformanceEfficiency. **ISO 25011**: SLOs → ServiceReliability.availabilityTarget, ServiceResponsiveness.latencyTarget. **TOGAF**: SRE → ArchitectureRequirements for operational architecture. **NIS2**: incident management → Art 23 reporting. |
| **Twelve-Factor App** | 12factor.net (Heroku, 2011) | 12 factors for cloud-native applications (Codebase, Dependencies, Config, Backing Services, Build/Release/Run, Processes, Port Binding, Concurrency, Disposability, Dev/Prod Parity, Logs, Admin Processes). | 1 vocab schema (TwelveFactorCategory) + 12 Directives + **~24 Norms** (1–2 per factor). | ~37 | **TOGAF**: factors constrain LogicalApplicationComponent and TechnologyComponent design. **ISO 25010**: factors → ProductMaintainability, ProductPortability, ProductPerformanceEfficiency. **SRE**: Twelve-Factor is the app-design prerequisite for SRE practices. |
| **DORA Metrics** | DevOps Research and Assessment (Accelerate, 2018) — NOT EU DORA Regulation | 4 delivery metrics (Deployment Frequency, Lead Time, Change Failure Rate, MTTR) + 1 reliability metric (Availability). Elite/High/Medium/Low tiers. | 1 vocab schema (DORAMetricTier) + 1 Directive + **4–5 Norms** (one per metric threshold). | ~8–10 | **SRE**: MTTR ↔ SRE incident management and error budgets. **ISO 25010**: Deployment Frequency → ProductMaintainability; Change Failure Rate → ProductReliability. **TOGAF**: metrics govern CI/CD as a TechnologyService. **SAFe**: flowVelocity ≈ Deployment Frequency, flowTime ≈ Lead Time. |
| **Well-Architected Ontologies** | AWS Well-Architected, Azure WAF, GCP Architecture Ontology | Multi-pillar review checklists: Operational Excellence, Reliability, Security, Performance, Cost Optimization, Sustainability. Each pillar has best practices and review questions. | Per-pillar: 6 vocab schemas + Directives per design principle + **Norms per best-practice check**. Cloud-agnostic core or per-provider. | ~100–200 | **ISO 25010/25011**: Reliability, Performance pillars ↔ ProductReliability, ServiceReliability. **TOGAF**: pillars → Architecture Building Blocks, ArchitecturePrinciples. **FinOps**: Cost Optimization pillar. **SRE**: Reliability pillar. **GSF SCI**: Sustainability pillar. |

#### Sustainability

| Ontology | Full Name / Source | What It Provides | GSM Mapping | Est. Files | Articulation with Sourced Ontologies |
|-----------|--------------------|------------------|-------------|------------|--------------------------------------|
| **GSF SCI** | Green Software Foundation — Software Carbon Intensity Specification | SCI = (E × I) + M per functional unit. Defines Energy (E), Carbon Intensity (I), Embodied Emissions (M), Functional Unit (R). Single measurable rate (gCO₂eq/R). Increasingly relevant: EU CSRD + ESRS mandate ICT sustainability reporting. | 1 vocab schema (SoftwareCarbonIntensity with E, I, M, R) + 1 Directive (carbon reduction target) + **2–3 Norms** (SCI threshold, energy efficiency, embodied carbon). | ~5–8 | **ISO 25010**: SCI energy ↔ ProductPerformanceEfficiency.resourceUtilization. **Well-Architected**: Sustainability pillar references SCI. **TOGAF**: SCI as a governed metric on TechnologyComponents, InfrastructureServices. **FinOps**: waste reduction ↔ carbon reduction. **CIM/Redfish**: PowerMetrics.powerConsumedWatts → physical substrate for SCI's Energy (E). |

#### Process / Observability

| Ontology | Full Name / Source | What It Provides | GSM Mapping | Est. Files | Articulation with Sourced Ontologies |
|-----------|--------------------|------------------|-------------|------------|--------------------------------------|
| **OpenTelemetry Semantic Conventions** | OpenTelemetry Project (CNCF) | Standardized attribute naming for metrics, traces, logs (HTTP, DB, messaging, RPC, system resources). Defines **what** to observe and **how to name it**. | Vocab schemas per signal domain (HTTP, DB, messaging attributes) + **Norms verifying presence of required attributes**. | ~30–50 | **TOGAF**: Observability gets a standardized vocabulary. **ISO 25010**: OTel attributes → measurement substrate for ProductPerformanceEfficiency, ProductReliability. **SRE**: OTel enables SLO measurement. **CIM/Redfish**: OTel infrastructure metrics align with CIM properties. |

### Ascription-primary ontologies (subject-typing vocabulary)

Ontologies whose primary contribution is **vocab schemas** — they define typed properties on subjects (GSM archetypes / subject types). These are the schemas that Norm assertions reference. Directives and Norms also arise, but the vocabulary itself is the irreducible core. **These should generally be sourced first**, because Norm-primary ontologies above need these properties to exist before their assertions can reference them.

| Ontology | Full Name / Source | What It Provides | GSM Mapping | Est. Files | Articulation with Sourced Ontologies |
| ----------- | -------------------- | ------------------ | ------------- | ------------ | -------------------------------------- |
| **SCAP (remaining)** | NIST SCAP — OVAL + XCCDF + ARF + CVSS + CVE | **Assessment and reporting vocabulary.** CPE + CCE are now sourced (see Sourced Models). Remaining components: OVAL (executable checks → Mechanism rules), XCCDF (checklist bundling → Norm profiles), ARF (result reporting → Effector/Receptor payloads), CVSS (vulnerability scoring → rootless quality dimension), CVE (vulnerability identification → rootless identification). | OVAL → Mechanism; XCCDF → rootless (checklist profile); ARF → rootless (result record); CVSS → rootless (severity score); CVE → rootless (vulnerability identifier). | ~8–12 | **SCAP CPE/CCE** (sourced): identification substrate is in place. OVAL/XCCDF consume CPE/CCE identifiers. **CIS Benchmarks/STIGs**: distributed as XCCDF+OVAL content. **NIS2**: SCAP assessment results → Art 21 compliance evidence. |
| **DMTF CIM/Redfish** | Distributed Management Task Force — Common Information Model (CIM 2.x) + Redfish API (JSON Schema) | **Comprehensive infrastructure property vocabulary.** CIM defines ~1,080 classes with typed properties across 13 schema areas (Core, System, Device, Network, Storage, Application, Database, User/Security, Metrics, Physical, Event, Policy). Redfish exposes ~350 as modern JSON Schema resources. | **Curated subset (~40–60 key resources) as technology-specific extensions of TOGAF Structures.** 10–15 domain-area vocab schemas (Compute, Storage, Network, Physical, OS, Database, Application, Web/Middleware, Virtualization, Container). Each extends a TOGAF Structure with CIM-sourced typed properties (e.g., TechnologyComponent + ComputeSystem → `totalCores`, `memoryGiB`, `firmwareVersion`, `powerState`). + ~20 Directives + ~40 Norms. | ~75–90 | **TOGAF**: CIM/Redfish makes TOGAF Structures technology-specific — `TechnologyComponent` gains `totalCores`, `storageType`, `osVersion`; `PlatformService` gains `dbEngine`, `maxConnections`. **SCAP/CPE**: CPE identifies the technology; CIM defines its property schema. **CIS Benchmarks/STIGs**: Norm assertions check CIM-sourced properties. **ISO 25010**: CIM health/state properties feed ProductReliability, ProductAvailability. |
| **OpenConfig/YANG** | OpenConfig Consortium (Google, Microsoft, AT&T) + IETF YANG (RFC 7950) | **Vendor-neutral network device property vocabulary.** Typed properties for: interfaces (`mtu`, `speed`, `operStatus`), BGP (`peerAs`, `holdTime`), ACLs (`sourceAddress`, `action`), system (`hostname`, `ntpServers`), platform (`chassis`, `temperatures`), QoS (`classifiers`, `queues`). | **5–8 vocab schemas** (Interfaces, Routing/BGP, ACL/Firewall, System, Platform/Hardware, QoS) extending TOGAF InfrastructureService / TechnologyComponent for network devices. + Norms for network config compliance. | ~30–50 | **CIM/Redfish**: OpenConfig supersedes CIM Network classes for modern network devices. CIM covers compute/storage; OpenConfig covers network. Together = full infrastructure vocabulary. **CIS Benchmarks**: Cisco IOS, Juniper, Palo Alto rules check OpenConfig-defined properties. **NIS2**: Art 21(2)(e) network security → OpenConfig ACL/firewall properties. **TOGAF**: InfrastructureService gets standardized network properties. |

### Recommended Sourcing Priority

Based on the DNA principle (vocabulary schemas before Norm-heavy ontologies, because Norm assertions reference vocab properties) and governance coverage gaps:

| Priority | Ontology | DNA Level | Rationale |
| ---------- | ----------- | ----------- | ----------- |
| 1 | **CIM/Redfish** (curated) | Ascription (vocab) | **Infrastructure vocabulary**: makes TOGAF Structures technology-specific. Required before Norm-heavy ontologies can write property-referencing assertions. SCAP CPE/CCE (now sourced) provides identification; CIM provides the property schemas. |
| 2 | **CIS Controls v8** | Norm | Bridges the NIS2 Art 21 → safeguards gap. Highest articulation density with existing regulatory ontologies. |
| 3 | **GSF SCI** | Norm | Tiny (~8 files), critical in current political/regulatory context (EU CSRD, ESRS). First sustainability governance metric. |
| 4 | **OWASP Top 10** | Norm | Smallest security effort (~50 files), highest signal for application security. Quick win. |
| 5 | **SRE Practices** | Norm | Fills the operational reliability gap — articulates directly with ISO 25010/25011. |
| 6 | **Twelve-Factor App** | Norm | Very small (~37 files). Fills application design governance gap. |
| 7 | **DORA Metrics** | Norm | Tiny (~10 files) but high-value delivery performance measurement. |
| 8 | **FinOps Ontology** | Directive | Cloud cost governance — emerging mandatory domain. Articulates with GSF SCI. |
| 9 | **ITIL 4** | Directive | Full service operational lifecycle. Strongest articulation with ISO 25011. |
| 10 | **OWASP ASVS** | Norm | Deep application security verification — expands Top 10 to detail. |
| 11 | **OpenConfig/YANG** | Ascription (vocab) | Network-specific vocabulary. Source when network device governance is needed. |
| 12 | **SAFe 6.0** | Directive | Delivery governance — portfolio economics, delivery flow. Unique dimension. |
| 13 | **DMBOK** | Directive | Data management lifecycle beyond ISO 25012 quality-only. |
| 14 | **Well-Architected** | Norm | Large but multi-pillar. Sourced per-pillar incrementally. |
| 15 | **CIS Benchmarks** | Norm | Per-technology — sourced incrementally per benchmark. SCAP CPE/CCE (sourced) provides the identification substrate. |
| 16 | **DISA STIGs** | Norm | Per-technology — sourced incrementally per STIG. SCAP CPE/CCE (sourced) provides the identification substrate. |
| 17 | **SCAP (remaining)** | Ascription (vocab) | OVAL, XCCDF, ARF, CVSS, CVE — assessment/reporting components. CPE + CCE already sourced. |
| 18 | **CMMI v2.0** | Directive | Process maturity — less urgent than technical governance. |
| 19 | **OpenTelemetry** | Norm | Valuable but narrow (instrumentation convention, not governance). |
| 20 | **NIST CSF 2.0** | Directive | Meta-ontology if regulatory mapping needed beyond NIS2. |
| 21 | **NIST SP 800-53** | Norm | Massive scope — only if US federal compliance required. |
| 22 | **CSA CCM v4** | Norm | Cloud overlay — after CIS Controls if cloud-specific granularity needed. |
| 23 | **NIST SSDF** | Norm | Development lifecycle — if secure dev governance needed beyond OWASP. |
