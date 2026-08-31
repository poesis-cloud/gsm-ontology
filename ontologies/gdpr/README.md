# GDPR — Regulation (EU) 2016/679

**Source**: Regulation (EU) 2016/679 of the European Parliament and of the Council of 27 April 2016 on the protection of natural persons with regard to the processing of personal data and on the free movement of such data (General Data Protection Regulation).

**Scope**: EU-wide data protection: processing principles, lawful basis, data subject rights, controller/processor obligations, breach notification, impact assessment, and international transfers.

**Applicable since**: 25 May 2018.

**Model type**: Regulatory — the second regulatory model in ITIP (after NIS2). Like NIS2, GDPR operates at **two P8 layers simultaneously**:

| Layer | What it produces | File naming |
| ------- | ----------------- | ------------- |
| **P8 Layer 2 — Archetype schemas** | GDPR-specific vocabulary (processing principles, lawful bases, data subject rights, controller roles, breach types, transfer mechanisms) | `{Title}.archetype.json` |
| **P8 Layer 3 — Sourced Directives** | Concrete legal mandates from GDPR articles, expressed in GSM Directive grammar | `{ConceptName}SourcedDirective.json` |
| **P8 Layer 3 — Sourced Norms** | Concrete measurable requirements from GDPR articles, expressed in GSM Norm grammar | `{ConceptName}SourcedNorm.json` |

GDPR is the most comprehensive EU data protection regulation. It produces dense governance DNA: 7 foundational principles (Art 5), 6 lawful bases (Art 6), 7 data subject rights (Art 15–22), and extensive controller/processor obligations — all directly encodable as Directives and Norms.

## Model-Native Taxonomy

GDPR is organized by its regulatory concerns (not by GSM subject type per P9):

| Folder | GDPR Source | Purpose |
| -------- | ------------ | --------- |
| `principles/` | Art 5 | Seven foundational processing principles |
| `lawful-basis/` | Art 6–9 | Lawful bases for processing, consent conditions, special category restrictions |
| `data-subject-rights/` | Art 12–22 | Transparency obligations and individual rights (access, rectification, erasure, portability, objection, automated decisions) |
| `controller-processor/` | Art 24–39 | Controller/processor obligations: data protection by design, records of processing, DPO designation |
| `breach-notification/` | Art 33–34 | Personal data breach notification to authorities and data subjects |
| `impact-assessment/` | Art 35–36 | Data protection impact assessment and prior consultation |
| `transfers/` | Art 44–49 | International transfer mechanisms and safeguards |

## Concept Mapping

### Vocabulary Schemas (archetype schemas)

| GDPR Concept | GSM Subject Type | Folder | Schema Title | Source |
| ------------- | ----------------- | -------- | -------------- | -------- |
| Processing principles | Rootless | principles/ | ProcessingPrinciple | Art 5 |
| Lawful basis for processing | Rootless | lawful-basis/ | LawfulBasis | Art 6 |
| Consent conditions | Rootless | lawful-basis/ | Consent | Art 7–8 |
| Special category data | Rootless | lawful-basis/ | SpecialCategoryData | Art 9 |
| Data subject rights | Rootless | data-subject-rights/ | DataSubjectRight | Art 15–22 |
| Transparency obligations | Rootless | data-subject-rights/ | TransparencyObligation | Art 12–14 |
| Controller/processor role | Rootless | controller-processor/ | ControllerProcessorRole | Art 4(7), 26–28 |
| Processing activity records | Rootless | controller-processor/ | ProcessingActivity | Art 30 |
| Data protection by design | Rootless | controller-processor/ | DataProtectionByDesign | Art 25 |
| Data protection officer | Rootless | controller-processor/ | DataProtectionOfficer | Art 37–39 |
| Processor agreement | Rootless | controller-processor/ | ProcessorAgreement | Art 28 |
| Security of processing | Rootless | controller-processor/ | SecurityMeasure | Art 32 |
| Data breach | Rootless | breach-notification/ | DataBreach | Art 33–34 |
| Impact assessment | Rootless | impact-assessment/ | ImpactAssessment | Art 35–36 |
| Transfer mechanism | Rootless | transfers/ | TransferMechanism | Art 44–49 |

All schemas are **rootless** (no top-level `$ref` to a GSM base). GDPR concepts are regulatory compliance dimensions — they qualify governance but are not Structures, Mechanisms, or Interactions.

### Sourced Directives (legal mandates)

| Directive | GSM Grammar | Source | Operationalized by |
| ----------- | ------------ | -------- | ------------------- |
| Art5-ProcessingPrinciples | `MUST ENSURE ProcessingPrinciple` | Art 5 | 7 Norms (one per principle) |
| Art6-LawfulProcessing | `MUST ENSURE LawfulBasis` | Art 6 | 1 Norm (documented basis) |
| Art7-ConsentRequirements | `MUST ENSURE Consent` | Art 7 | 4 Norms (demonstrable, distinguishable, withdrawable, freely given) |
| Art8-ChildConsent | `MUST ENSURE Consent` | Art 8 | 1 Norm (parental consent verified) |
| Art9-SpecialCategoryRestriction | `MUST_NOT ENSURE SpecialCategoryData` | Art 9 | 1 Norm (processing condition met) |
| Art12-TransparentCommunication | `MUST ENSURE TransparencyObligation` | Art 12 | 2 Norms (response timeliness, request free) |
| Art13-InformationDirectCollection | `MUST ENSURE TransparencyObligation` | Art 13 | 2 Norms (information provided, contents complete) |
| Art14-InformationIndirectCollection | `MUST ENSURE TransparencyObligation` | Art 14 | 2 Norms (information within period, contents complete) |
| Art15-RightOfAccess | `MUST ENABLE DataSubjectRight` | Art 15 | 1 Norm (access provided) |
| Art16-RightToRectification | `MUST ENABLE DataSubjectRight` | Art 16 | 1 Norm (rectification completed) |
| Art17-RightToErasure | `MUST ENABLE DataSubjectRight` | Art 17 | 1 Norm (erasure completed) |
| Art18-RightToRestriction | `MUST ENABLE DataSubjectRight` | Art 18 | 1 Norm (restriction applied) |
| Art19-NotificationObligation | `MUST ENSURE TransparencyObligation` | Art 19 | 1 Norm (recipients notified) |
| Art20-RightToPortability | `MUST ENABLE DataSubjectRight` | Art 20 | 2 Norms (structured format, direct transfer) |
| Art21-RightToObject | `MUST ENABLE DataSubjectRight` | Art 21 | 1 Norm (objection handled) |
| Art22-AutomatedDecisionMaking | `MUST ENSURE DataSubjectRight` | Art 22 | 1 Norm (human intervention) |
| Art25-DataProtectionByDesign | `MUST ENSURE DataProtectionByDesign` | Art 25 | 2 Norms (design measures, default minimisation) |
| Art26-JointControllers | `MUST ENSURE ControllerProcessorRole` | Art 26 | 1 Norm (arrangement documented) |
| Art28-ProcessorObligations | `MUST ENSURE ProcessorAgreement` | Art 28 | 3 Norms (instructions bound, sub-processor authorized, contract complete) |
| Art30-RecordsOfProcessing | `MUST MAINTAIN ProcessingActivity` | Art 30 | 2 Norms (records maintained, contents complete) |
| Art32-SecurityOfProcessing | `MUST ENSURE SecurityMeasure` | Art 32 | 3 Norms (measures implemented, effectiveness tested, personnel authorized) |
| Art37-DpoDesignation | `MUST ENSURE DataProtectionOfficer` | Art 37 | 5 Norms (designated, qualified, independent, contact published, resources provided) |
| Art33-BreachNotificationAuthority | `MUST ENSURE DataBreach` | Art 33 | 3 Norms (72h notification, contents complete, breach documented) |
| Art34-BreachNotificationSubject | `MUST ENSURE DataBreach` | Art 34 | 1 Norm (high-risk notification) |
| Art35-DPIA | `MUST ENSURE ImpactAssessment` | Art 35 | 3 Norms (DPIA conducted, contents complete, prior consultation) |
| Art44-TransferRestriction | `MUST ENSURE TransferMechanism` | Art 44 | 5 Norms (safeguard, adequacy, appropriate safeguards, derogation, transfer impact assessed) |

**Symbolic references**: Sourced directives use `$gdpr:data-controller` (structure) and `$gdpr:data-subject` (purpose) — resolved at deployment when an entity adopts GDPR governance. `Art33-BreachNotificationAuthority` uses `$gdpr:supervisory-authority` as purpose (notification goes TO the authority).

### Sourced Norms (measurable requirements)

#### Principles Norms (operationalize Art 5 Directive)

| Norm | Assertion | Source |
| ------ | ----------- | -------- |
| Art5-1a-LawfulnessFairnessTransparency | `self.principleCompliant == true` | Art 5(1)(a) |
| Art5-1b-PurposeLimitation | `self.principleCompliant == true` | Art 5(1)(b) |
| Art5-1c-DataMinimisation | `self.principleCompliant == true` | Art 5(1)(c) |
| Art5-1d-Accuracy | `self.principleCompliant == true` | Art 5(1)(d) |
| Art5-1e-StorageLimitation | `self.principleCompliant == true` | Art 5(1)(e) |
| Art5-1f-IntegrityConfidentiality | `self.principleCompliant == true` | Art 5(1)(f) |
| Art5-2-Accountability | `self.principleCompliant == true` | Art 5(2) |

All 7 norms use applicability: `ControllerProcessorRole.role in ['CONTROLLER', 'JOINT_CONTROLLER'] && ProcessingPrinciple.principle == '{VALUE}'` — the principle type guard scopes which entities are evaluated; the assertion checks only compliance. `toleranceMode: INSTANTANEOUS`.

#### Lawful Basis Norms (operationalize Art 6, Art 7, Art 8, Art 9 Directives)

| Norm | Guard (scope) | Assertion | Source |
| ------ | -------------- | ----------- | -------- |
| Art6-1-LawfulBasisDocumented | controller role | `self.lawfulBasisDocumented == true` | Art 6(1) |
| Art7-1-ConsentDemonstrable | controller + `lawfulBasis == 'CONSENT'` | `self.consentDemonstrable == true` | Art 7(1) |
| Art7-2-ConsentDistinguishable | controller + `lawfulBasis == 'CONSENT'` | `self.consentDistinguishable == true` | Art 7(2) |
| Art7-3-ConsentWithdrawable | controller + `lawfulBasis == 'CONSENT'` | `self.withdrawalMechanismAvailable == true` | Art 7(3) |
| Art7-4-ConsentFreelyGiven | controller + `lawfulBasis == 'CONSENT'` | `self.freelyGiven == true` | Art 7(4) |
| Art8-1-ParentalConsentVerified | controller + `lawfulBasis == 'CONSENT'` + `childConsentApplicable == true` | `self.parentalConsentObtained == true` | Art 8(1) |
| Art9-1-SpecialCategoryProhibition | controller + `specialCategoryData == true` | `self.processingConditionMet == true` | Art 9(1)–(2) |

Consent norms use compound applicability expressions: controller role + lawful basis scoping. Art 8 adds a triple-compound guard (role + consent basis + child applicability). Special category norm guards on the presence of sensitive data.

#### Data Subject Rights Norms (operationalize Art 12–22 Directives)

| Norm | Guard (right scope) | Assertion | Temporal | Source |
| ------ | ------------------- | ----------- | ---------- | -------- |
| Art12-3-ResponseTimeliness | `requestReceived == true` | `self.responseTimeDays <= 30` | `P1M` | Art 12(3) |
| Art12-5-RequestFree | `requestReceived == true` | `self.exemptionApplied == false \|\| self.exemptionBasis != ''` | — | Art 12(5) |
| Art13-1-InformationProvidedAtCollection | controller role | `self.informationProvided == true && self.conciseTransparentIntelligible == true` | — | Art 13(1)–(2) |
| Art13-2-InformationContentsComplete | controller + `informationProvided == true` | `self.controllerIdentityDisclosed == true && self.purposesDisclosed == true && self.recipientsDisclosed == true && self.retentionPeriodDisclosed == true && self.rightsInformed == true` | — | Art 13(1)–(2) |
| Art14-1-InformationProvidedWithinPeriod | controller role | `self.informationProvided == true && self.conciseTransparentIntelligible == true` | `P1M` | Art 14(3) |
| Art14-2-InformationContentsComplete | controller + `informationProvided == true` | `self.controllerIdentityDisclosed == true && self.purposesDisclosed == true && self.recipientsDisclosed == true && self.retentionPeriodDisclosed == true && self.rightsInformed == true && self.dataSourceDisclosed == true` | — | Art 14(1)–(2) |
| Art15-1-AccessProvided | `rightType == 'ACCESS'` + identity verified | `self.responseProvided == true && self.dataCopyProvided == true` | — | Art 15(1) |
| Art16-1-RectificationCompleted | `rightType == 'RECTIFICATION'` + identity verified | `self.responseProvided == true && self.dataRectified == true` | — | Art 16 |
| Art17-1-ErasureCompleted | `rightType == 'ERASURE'` + identity verified | `self.responseProvided == true && self.dataErased == true` | — | Art 17(1) |
| Art18-1-RestrictionApplied | `rightType == 'RESTRICTION'` + identity verified | `self.responseProvided == true && self.processingRestricted == true` | — | Art 18(1) |
| Art19-1-RecipientsNotified | controller role | `self.recipientsNotified == true` | — | Art 19 |
| Art20-1-PortabilityStructuredFormat | `rightType == 'PORTABILITY'` + identity verified | `self.responseProvided == true && self.dataProvidedInStructuredFormat == true` | — | Art 20(1) |
| Art20-2-PortabilityDirectTransfer | `rightType == 'PORTABILITY'` + identity verified | `self.responseProvided == true && self.directTransferCompleted == true` | — | Art 20(2) |
| Art21-1-ObjectionHandled | `rightType == 'OBJECTION'` + identity verified | `self.responseProvided == true && self.processingCeased == true` | — | Art 21(1) |
| Art22-1-HumanIntervention | `rightType == 'AUTOMATED_DECISION_PROTECTION'` | `self.responseProvided == true && self.humanInterventionProvided == true` | — | Art 22(1) |

Art 12(3) is a temporal norm: response within 1 month (extendable by 2 months for complexity). Art 13 norms are cascaded: information provided first, then contents verified. Art 14(1) is a temporal norm: information within 1 month of obtaining data (P1M). Art 14(2) adds `dataSourceDisclosed` (required when data not from subject). Art 18 uses the existing `RESTRICTION` right type. Art 19 uses `toleranceMode: TOLERANT` (notification excused where impossible/disproportionate). Art 20(2) uses `toleranceMode: TOLERANT` (direct transfer conditioned on technical feasibility). Right-specific norms (Art 15–22) assert both generic `responseProvided` and right-specific compliance: `dataCopyProvided` (access), `dataRectified` (rectification), `dataErased` (erasure), `processingRestricted` (restriction), `dataProvidedInStructuredFormat`/`directTransferCompleted` (portability), `processingCeased` (objection), `humanInterventionProvided` (automated decisions).

#### Controller/Processor Norms (operationalize Art 25, Art 26, Art 28, Art 30, Art 32, Art 37 Directives)

| Norm | Guard (scope) | Assertion | Source |
| ------ | -------------- | ----------- | -------- |
| Art25-1-DesignMeasuresImplemented | controller role | `self.technicalMeasuresImplemented == true && self.organisationalMeasuresImplemented == true` | Art 25(1) |
| Art25-2-DefaultMinimalProcessing | controller role | `self.defaultDataMinimisation == true && self.processingLimitedByDefault == true` | Art 25(2) |
| Art26-1-ArrangementDocumented | `role == 'JOINT_CONTROLLER'` | `self.jointControllerArrangement == true` | Art 26(1) |
| Art28-1-ProcessorInstructionsBound | controller + `contractInPlace == true` | `self.instructionsBound == true` | Art 28(3)(a) |
| Art28-2-SubProcessorAuthorized | controller/processor | `self.subProcessorAuthorized == true` | Art 28(2) |
| Art28-3-ContractContentsComplete | controller + `contractInPlace == true` | `self.contractContentsComplete == true && self.contractInWriting == true` | Art 28(3) |
| Art30-1-RecordsMaintained | controller role | `self.recordsMaintained == true` | Art 30(1) |
| Art30-2-RecordContentsComplete | controller + `recordsMaintained == true` | `self.recordContentsComplete == true` | Art 30(1)(a-g) |
| Art32-1-SecurityMeasuresImplemented | controller/processor | `self.securityMeasuresImplemented == true && self.confidentialityEnsured == true && self.integrityEnsured == true && self.availabilityEnsured == true && self.resilienceEnsured == true && self.timelyRestorationCapable == true && self.riskAssessmentPerformed == true` | Art 32(1) |
| Art32-1d-EffectivenessRegularlyTested | controller/processor + `securityMeasuresImplemented == true` | `self.regularTestingPerformed == true` | Art 32(1)(d) |
| Art32-4-PersonnelAuthorized | controller/processor | `self.personnelAuthorisationEnforced == true` | Art 32(4) |
| Art37-1-DpoDesignated | controller/processor + `dpoRequired == true` | `self.dpoDesignated == true` | Art 37(1) |
| Art37-5-DpoQualified | controller/processor + `dpoDesignated == true` | `self.dpoQualified == true` | Art 37(5) |
| Art38-3-DpoIndependence | controller/processor + `dpoDesignated == true` | `self.dpoIndependent == true && self.dpoNoConflictOfInterest == true` | Art 38(3)(6) |
| Art37-7-DpoContactPublished | controller/processor + `dpoDesignated == true` | `self.dpoContactPublished == true` | Art 37(7) |
| Art38-2-DpoResourcesProvided | controller/processor + `dpoDesignated == true` | `self.dpoResourcesProvided == true` | Art 38(2) |

Art 26 norms apply only to joint controllers. Art 28 norms are cascaded: contract must first exist, then instructions binding and contents are verified. Art 28(2) includes PROCESSOR in applicability (sub-processor authorization obligation). Art 32 norms apply to both controllers and processors; security measures norms are cascaded (measures first, then testing); Art 32(1) assertion now includes resilience and timely restoration (Art 32(1)(b)-(c)). DPO norms include PROCESSOR in the applicability (Art 37 applies equally to processors); DPO norms are cascaded from designation (contact published, resources provided, qualification, and independence all require dpoDesignated == true). Art 30 norms are cascaded: records must first exist, then their contents are verified.

#### Breach Notification Norms (operationalize Art 33, Art 34 Directives)

| Norm | Guard | Assertion | Temporal | Source |
| ------ | ------- | ----------- | ---------- | -------- |
| Art33-1-AuthorityNotification72h | breach + risk != UNLIKELY | `self.authorityNotified == true && self.authorityNotificationHours <= 72` | `PT72H` | Art 33(1) |
| Art33-3-NotificationContentsComplete | breach + `authorityNotified == true` | `self.notificationContentsComplete == true` | — | Art 33(3) |
| Art33-5-BreachDocumented | breach occurred | `self.breachDocumented == true` | — | Art 33(5) |
| Art34-1-SubjectNotificationHighRisk | breach + risk == HIGH | `self.dataSubjectsNotified == true` | — | Art 34(1) |

Art 33(1) is a temporal norm: 72 hours from breach awareness (parallels NIS2 Art 23 but with different risk threshold). Art 33(5) requires breach documentation regardless of notification obligation (even UNLIKELY risk breaches must be documented). Art 34 triggers only at HIGH risk level — LIKELY alone does not require data subject notification.

#### Impact Assessment Norms (operationalize Art 35 Directive)

| Norm | Guard | Assertion | Source |
| ------ | ------- | ----------- | -------- |
| Art35-1-DpiaConducted | controller + `highRiskProcessing == true` | `self.dpiaConducted == true` | Art 35(1) |
| Art35-7-DpiaContentsComplete | controller + `dpiaConducted == true` | `self.dpiaContentsComplete == true` | Art 35(7) |
| Art36-1-PriorConsultation | controller + `residualHighRisk == true` | `self.priorConsultationCompleted == true` | Art 36(1) |

Cascaded: DPIA required → contents verified → prior consultation if residual risk remains high.

#### Transfer Norms (operationalize Art 44 Directive)

| Norm | Guard (mechanism scope) | Assertion | Source |
| ------ | ---------------------- | ----------- | -------- |
| Art44-1-TransferSafeguardInPlace | `internationalTransfer == true` | `self.transferSafeguardInPlace == true` | Art 44 |
| Art45-1-AdequacyDecision | mechanism == `ADEQUACY_DECISION` | `self.transferSafeguardInPlace == true` | Art 45(1) |
| Art46-1-AppropriateSafeguards | mechanism in SCCs/BCRs/codes/certs | `self.transferSafeguardInPlace == true && self.supplementaryMeasuresApplied == true` | Art 46(1-2) |
| EDPB-TransferImpactAssessed | mechanism in SCCs/BCRs/ad-hoc/admin | `self.transferImpactAssessmentPerformed == true` | EDPB 01/2020 Step 3 |
| Art49-1-DerogationConditionMet | mechanism == `DEROGATION` | `self.transferSafeguardInPlace == true` | Art 49(1) |

Art 46 norms require supplementary measures (Schrems II — CJEU C-311/18). EDPB Recommendations 01/2020 require transfer impact assessments for SCCs, BCRs, ad-hoc clauses, and administrative arrangements. Art 49 uses `toleranceMode: TOLERANT` (derogations are narrowly interpreted). Transfer norms include PROCESSOR in the applicability (Art 44 applies to both controller and processor).

## Excluded GDPR Concepts (with reason)

| GDPR Concept | Articles | Reason for Exclusion |
| ------------- | ---------- | --------------------- |
| Supervisory authority organization | Art 51–59 | Member State institutional structure — not sourceable as entity-level governance |
| Cooperation and consistency | Art 60–76 | EU-level institutional coordination (one-stop-shop, EDPB) — outside entity governance scope |
| Remedies and penalties | Art 77–84 | Enforcement consequence, not governance definition — not a Directive/Norm pattern |
| Specific processing situations | Art 85–91 | Member State derogations (press, research, religion, employment) — requires national transposition |
| Codes of conduct and certification | Art 40–43 | Voluntary accountability mechanisms — does not produce mandatory Directives/Norms |
| Controller general responsibility | Art 24 | Overarching accountability — fully decomposed into Art 25 (design), Art 30 (records), Art 32 (security) |
| Representative designation | Art 27 | Covered as property `representativeDesignated` in ControllerProcessorRole schema |
| Criminal conviction data | Art 10 | Narrow scope — processing under control of official authority only |
| Processing not requiring identification | Art 11 | Exemption mechanism — not a positive obligation |

## GDPR vs NIS2 Applicability Pattern Comparison

GDPR and NIS2 use fundamentally different scoping applicability:

| Dimension | NIS2 | GDPR |
| ----------- | ------ | ------ |
| **Scoping mechanism** | Entity tier classification (ESSENTIAL/IMPORTANT) | Controller/processor role classification |
| **Applicability expression** | `EntityClassification.entityTier in ['ESSENTIAL', 'IMPORTANT']` | `ControllerProcessorRole.role in ['CONTROLLER', 'JOINT_CONTROLLER']` |
| **Scope breadth** | 18 critical sectors (Annexes I/II) | Any entity processing personal data of EU residents |
| **Graduated obligations** | Yes (essential > important) | Minimal (controller > processor for most obligations) |
| **Compound applicability** | Rare (entity tier is primary axis) | Common (role + specific condition, e.g., `lawfulBasis == 'CONSENT'`) |

GDPR compound applicability expressions are a distinguishing feature: consent norms activate only when consent is the chosen lawful basis; special category norms activate only when sensitive data is involved; breach notification norms activate based on risk level assessment.

## Governance Usage Patterns

### Pattern 1: Full GDPR compliance governance chain

```
ControllerProcessorRole (scoping)          → "Is this entity a controller/processor?"
  ↓
ProcessingPrinciple (foundation)            → "Are all 7 principles satisfied?"
LawfulBasis (legal ground)                  → "Is there a documented lawful basis?"
  ↓ (conditional on lawful basis)
Consent (if basis = CONSENT)                → "Are all consent conditions met?"
SpecialCategoryData (if sensitive data)     → "Is a processing condition satisfied?"
  ↓
Art12 Transparency (Directive)                  → "Controller MUST provide transparent info"
Art15–22 Rights (7 Directives)                  → "Controller MUST enable each right"
Art25 DPbD (Directive)                          → "Controller MUST implement by design"
Art30 Records (Directive)                       → "Controller MUST maintain records"
Art37 DPO (Directive)                           → "Controller/processor MUST designate DPO"
  ↓
57 Norms checking individual obligations        → Each principle, right, and obligation measured
```

### Pattern 2: GDPR + NIS2 dual regulatory chain (breach notification overlap)

GDPR and NIS2 both mandate incident/breach notification but with different triggers, timelines, and recipients:

```
Event: Personal data breach at an essential entity
  ↓
NIS2 Art 23 Directive: "Entity MUST ENSURE IncidentReporting"
  → Art23-4a: Early warning to CSIRT within 24h
  → Art23-4b: Incident notification to CSIRT within 72h
  → Art23-4d: Final report to CSIRT within 1 month

GDPR Art 33 Directive: "Controller MUST ENSURE DataBreach"
  → Art33-1: Notification to supervisory authority within 72h
  → Art33-3: Notification contents complete
  → Art34-1: Notification to data subjects if risk is HIGH

Both chains apply simultaneously to the same event.
NIS2 notifies the CSIRT; GDPR notifies the DPA + data subjects.
```

### Pattern 3: GDPR + ISO 25010 + ISO 25012 data protection chain

```
GDPR Art5-1f Norm: "INTEGRITY_CONFIDENTIALITY principle compliant"
  ↓ qualifies
ISO 25010 ProductSecurity: { encryptionAtRestEnabled: true, minimumTlsVersion: 'TLS_1_3' }
ISO 25012 DataConfidentiality: { dataClassification: 'PERSONAL', encryptionApplied: true }

GDPR Art5-1d Norm: "ACCURACY principle compliant"
  ↓ qualifies
ISO 25012 DataAccuracy: { syntacticAccuracy: true, semanticAccuracy: true }
```

GDPR **creates the obligation** (legal mandate); ISO 25010/25012 **provide the measurement vocabulary**.

## Inter-Model Articulation

See `../README.md` for full articulation analysis including:

- GDPR × NIS2 (dual EU regulatory framework — breach notification overlap)
- GDPR × ISO 25010 (security/privacy overlap)
- GDPR × ISO 25012 (data quality governance)
- GDPR × TOGAF (architecture governance integration)

## File Inventory

| Type | Naming | Count | Files |
| ------ | -------- | ------- | ------- |
| Vocabulary schemas | `*.archetype.json` | 15 | ProcessingPrinciple, LawfulBasis, Consent, SpecialCategoryData, DataSubjectRight, TransparencyObligation, ControllerProcessorRole, ProcessingActivity, DataProtectionByDesign, DataProtectionOfficer, ProcessorAgreement, SecurityMeasure, DataBreach, ImpactAssessment, TransferMechanism |
| Sourced Directives | `*SourcedDirective.json` | 26 | ProcessingPrinciples, LawfulProcessing, ConsentRequirements, ChildConsent, SpecialCategoryRestriction, TransparentCommunication, InformationDirectCollection, InformationIndirectCollection, RightOfAccess, RightToRectification, RightToErasure, RightToRestriction, NotificationObligation, RightToPortability, RightToObject, AutomatedDecisionMaking, DataProtectionByDesign, JointControllers, ProcessorObligations, RecordsOfProcessing, SecurityOfProcessing, DpoDesignation, BreachNotificationAuthority, BreachNotificationSubject, DPIA, TransferRestriction |
| Sourced Norms | `*SourcedNorm.json` | 57 | 7 principles (Art5), 7 lawful-basis (Art6-9), 15 data-subject-rights (Art12-22), 16 controller-processor (Art25-39), 4 breach-notification (Art33-34), 3 impact-assessment (Art35-36), 5 transfers (Art44-49) |
| **Total** | | **98** | |
