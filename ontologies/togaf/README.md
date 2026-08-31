# TOGAF Model — GSM Ascription Statements

**Source**: TOGAF Standard, 10th Edition (The Open Group)
**Scope**: Enterprise Architecture — Content Metamodel entities, ADM lifecycle, governance

## Model Organization

Schemas are organized by **TOGAF's own architecture domain taxonomy**, not by GSM subject type. GSM subject type mapping (Structure, Mechanism, etc.) is expressed in each schema's content (top-level `$ref` or description).

```
togaf/
  business-architecture/     # Business entities, services, functions, capabilities
  application-architecture/  # Application components, services, functions, interfaces
  data-architecture/         # Data entities and data components
  technology-architecture/   # Technology components, platforms, infrastructure
  governance/                # Cross-domain governance: directives, norms, rationale
  adm/                       # Architecture Development Method lifecycle artifacts
  .archive/                  # Superseded schemas (kept for history)
```

## Schema Inventory

### business-architecture/ (13 schemas)

| Schema | GSM Subject Type | TOGAF Source |
|--------|-----------------|-------------|
| Actor | Structure | Business Architecture — People/Organizations |
| OrganizationUnit | Structure | Business Architecture — Organizations |
| Stakeholder | Structure | Business Architecture — Stakeholder Management |
| BusinessService | Structure | Business Architecture — Services |
| BusinessFunction | Mechanism | Business Architecture — Functions |
| BusinessCapability | Rootless | Business Architecture — Capabilities |
| BusinessProcess | Rootless | Business Architecture — Processes |
| BusinessEvent | Rootless | Business Architecture — Events |
| ValueStream | Rootless | Business Architecture — Value Streams |
| Product | Rootless | Business Architecture — Products |
| Contract | Interaction | Business Architecture — Agreements |
| Role | Rootless | Business Architecture — Actor Responsibilities |
| Location | Rootless | Business Architecture / Cross-domain — Places |

### application-architecture/ (7 schemas)

| Schema | GSM Subject Type | TOGAF Source |
|--------|-----------------|-------------|
| LogicalApplicationComponent | Structure | Application Architecture — Logical Components |
| PhysicalApplicationComponent | Structure | Application Architecture — Physical Components |
| ApplicationService | Structure | Application Architecture — Services |
| ApplicationFunction | Mechanism | Application Architecture — Functions |
| ApplicationInterface | Effector | Application Architecture — Interfaces |
| ApplicationCollaboration | Rootless | Application Architecture — Collaborations |
| InformationExchange | Interaction | Application Architecture — Data Flows |

### data-architecture/ (3 schemas)

| Schema | GSM Subject Type | TOGAF Source |
|--------|-----------------|-------------|
| DataEntity | Rootless | Data Architecture — Entities |
| LogicalDataComponent | Structure | Data Architecture — Logical Components |
| PhysicalDataComponent | Structure | Data Architecture — Physical Components |

### technology-architecture/ (10 schemas)

| Schema | GSM Subject Type | TOGAF Source |
|--------|-----------------|-------------|
| TechnologyComponent | Structure | Technology Architecture — Components |
| LogicalTechnologyComponent | Structure | Technology Architecture — Logical Components |
| PhysicalTechnologyComponent | Structure | Technology Architecture — Physical Components |
| TechnologyService | Structure | Technology Architecture — Services |
| PlatformService | Structure | Technology Architecture — Platforms |
| Node | Structure | Technology Architecture — Infrastructure |
| TechnologyInterface | Receptor | Technology Architecture — Interfaces |
| TechnologyFunction | Mechanism | Technology Architecture — Functions |
| CommunicationPath | Interaction | Technology Architecture — Communication |
| Observability | Rootless | Technology Architecture — Operational Monitoring |

### governance/ (18 schemas)

| Schema | GSM Subject Type | TOGAF Source |
|--------|-----------------|-------------|
| ArchitecturePrinciple | Directive | Governance — Principles |
| ArchitectureRequirement | Directive | Governance — Requirements |
| ArchitectureConstraint | Directive | Governance — Constraints |
| ArchitectureContract | Directive | Governance — Contracts |
| Standard | Directive | Governance — Standards |
| ArchitectureRequirementCompliance | Norm | Governance — Requirement Compliance |
| ArchitectureConstraintCompliance | Norm | Governance — Constraint Compliance |
| Measure | Norm | Governance — Measures |
| Concern | Rootless | Governance — Stakeholder Concerns |
| ArchitectureDecision | Rootless | Governance — Decision Records |
| GapAssessment | Rootless | Governance — Gap Analysis |
| Assumption | Rootless | Governance — Planning Assumptions |
| CourseOfAction | Rootless | Governance — Response Options |
| Viewpoint | Rootless | Governance — Architecture Viewpoints |
| ServiceQuality | Rootless | Governance — Service Quality |
| Driver | Rootless | Motivation Extension — Change Drivers |
| Goal | Rootless | Motivation Extension — Strategic Intent |
| Objective | Rootless | Motivation Extension — Measurable Targets |

### adm/ (7 schemas)

| Schema | GSM Subject Type | TOGAF Source |
|--------|-----------------|-------------|
| WorkPackage | Rootless | ADM — Implementation Planning |
| ArchitectureRoadmap | Rootless | ADM — Roadmap |
| MigrationPlan | Rootless | ADM — Migration |
| AdmPhaseRecord | Rootless | ADM — Phase Records |
| Deliverable | Rootless | ADM — Deliverables |
| Artifact | Rootless | ADM — Artifacts |
| TransitionArchitecture | Rootless | ADM — Transition Architectures |

## Inter-Model Articulation

TOGAF governance concepts (Directives, Norms) **reference** quality characteristics from other models:

- **ISO 25010**: ArchitecturePrinciple qualifies with ProductReliability, ProductSecurity, etc.
- **ISO 25012**: ArchitecturePrinciple qualifies with DataAccuracy, DataCompleteness, etc.

See [Model Composition](../README.md) for full articulation map.

## GSM×TOGAF Frictions

### F1: Active vs Passive entities

TOGAF Content Metamodel doesn't distinguish active systems (with Mechanisms) from passive governed things. GSM does: Structures are constituted of Mechanisms. Passive entities (DataEntity, BusinessEvent, BusinessCapability) map as rootless archetypes.

### F2: Function vs Service

TOGAF has both Function (internal behavior) and Service (exposed behavior). In GSM, both relate to Mechanisms but at different granularity. Functions → Mechanism. Services → Structure (they are the externally-visible system).

### F3: Interface directionality

TOGAF interfaces are bidirectional. GSM separates Effectors (output) and Receptors (input). ApplicationInterface → Effector (publishes API), TechnologyInterface → Receptor (consumes infrastructure).

### F4: Governance concept density

TOGAF has many governance concepts (Principles, Requirements, Constraints, Standards) mapping to only 2 GSM base types (Directive, Norm). All are accommodated through Directive/Norm extensions with distinct property vocabularies.

### F5: ADM as lifecycle vs governance

TOGAF ADM phases are a methodology lifecycle, not GSM governance. ADM concepts (WorkPackage, Roadmap, MigrationPlan) map as rootless archetypes — they are governance artifacts, not governance primitives.

### F6: Observability origin

Observability is not a native TOGAF concept — it originates from SRE/DevOps practices. It is kept in technology-architecture/ as a cross-domain operational quality. May migrate to a future SRE model.

### F7: Quality dimension sourcing

Quality characteristics (ProductAvailability, ProductReliability, ProductSecurity, etc.) are ISO 25010 vocabulary, not TOGAF-native. They have been extracted to the `iso25000` model (SQuaRE framework). TOGAF references them through governance Directives.

## Excluded TOGAF Concepts (with justification)

| TOGAF Concept | Source | Reason for Exclusion |
|---------------|--------|---------------------|
| Architecture Repository | §44 Architecture Repository | Container/registry concept — maps to the SIE platform itself, not to a governed archetype |
| Architecture Landscape (Strategic/Segment/Capability) | §44.3 Architecture Landscape | Classification of architecture scope levels — captured implicitly by Directive scoping, not a standalone archetype |
| Architecture Vision | Phase A | Process output (statement of intent for an ADM cycle) — captured by Goal/Objective archetypes already sourced |
| Baseline/Target Architecture | Phases B–D | ADM state markers — captured by TransitionArchitecture and GapAssessment already sourced |
| Building Block (ABB/SBB) | §42 Building Blocks | Abstract/Solution categorization — overlaps with LogicalApplicationComponent/PhysicalApplicationComponent distinction already modeled |
| Architecture Board | §47 Governance Bodies | Organizational governance body — not an architecture artifact; maps to TOGAF Actor/Role + governance Directives |
| Compliance Assessment (method) | §47.4 Compliance Reviews | Process/methodology for compliance — already operationalized by ArchitectureRequirementCompliance and ArchitectureConstraintCompliance Norms |
| Architecture Principles (catalog format) | §21 Architecture Principles | TOGAF prescribes a catalog format (Name, Statement, Rationale, Implications) — GSM Directive grammar supersedes this; ArchitecturePrinciple archetype captures the substance |
