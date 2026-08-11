# GSM Frameworks

Framework definitions built on the **Generative System Model (GSM)**, registered as governed
ascriptions in the SIE Definition Manager (DM), and assembled into organization-specific
framework stacks by consuming domain applications such as the IT Intelligence Platform (ITIP).

This repository is one half of the GSM solution: the normative model it is expressed against
lives in the sibling [`gsm-specifications`](https://github.com/poesis-cloud/gsm-specifications)
repository, and both are aggregated under the
[`gsm`](https://github.com/poesis-cloud/gsm) umbrella.

> This repository is in a design-time phase. It contains framework model statements and
> supporting sources, not runnable application code.

## Terminology and file conventions

### Framework

A framework is a named and versioned set of governed model elements. Its elements are
registered individually in DM. ITIP groups them as a framework and manages catalog
import, organization selection, composition, installation, and synchronization.

### Framework ascription statement

Every governed model element of a framework is an **ascription statement**: the JSON
content persisted as an Ascription statement in DM.

This includes all eight GSM subject types:

- Archetype
- Structure
- Mechanism
- Effector
- Receptor
- Interaction
- Directive
- Norm

Files use an explicit subject-type suffix:

| Convention | Meaning |
| --- | --- |
| `<Name>.archetype.json` | Archetype ascription statement (a JSON Schema document) |
| `<Name>.structure.json` | Structure ascription statement |
| `<Name>.mechanism.json` | Mechanism ascription statement |
| `<Name>.effector.json` | Effector ascription statement |
| `<Name>.receptor.json` | Receptor ascription statement |
| `<Name>.interaction.json` | Interaction ascription statement |
| `<Name>.directive.json` | Directive ascription statement |
| `<Name>.norm.json` | Norm ascription statement |
| `<name>.rule.star` | Supporting Mechanism rule source; not registered independently |
| `framework.json` | Portable framework aggregate descriptor; not a DM ascription |
| `README.md` | Documentation; not a framework element |

Examples under the convention:

```text
HttpRequest.archetype.json
HttpRequestEffector.archetype.json
HttpRequestInteraction.archetype.json
GdprProcessingPrinciple.archetype.json
ProcessingPrinciples.directive.json
Accountability.norm.json
DirectiveNormOperationalization.mechanism.json
directive-norm-operationalization.rule.star
```

An Archetype statement is named `.archetype.json`, rather than `.schema.json`, because
its role here is a governed Archetype ascription. Its statement content remains JSON
Schema.

For non-Archetype statements, the filename identifies the statement and GSM subject
type. The framework descriptor identifies the more specific Archetype used to type it.
This keeps three distinct concepts separate:

- statement identity: `ProcessingPrinciples`
- GSM subject type: `Directive`
- typing Archetype: `SourcedDirective`

PascalCase is used for governed statement filenames. Kebab-case is used for supporting
source files and directories.

This convention is fully applied across `frameworks/`.

## Framework membership

Every framework ascription statement declares the framework version that owns and
distributes it:

```json
{
  "framework": {
    "name": "gdpr",
    "version": "1.0.0"
  }
}
```

| Member | Required | Meaning |
| --- | --- | --- |
| `name` | yes | Stable canonical framework name, in lowercase kebab-case |
| `version` | yes | Version of the framework package owning the statement |

Framework membership is intrinsic to an ascription version. It means:

> This ascription statement is authored, governed, versioned, and distributed as an
> element of the named framework version.

It does not mean that the framework is selected in a particular organization's stack.
Imported statements retain their original framework membership when selected by an
organization framework.

### Archetype statements

`gsm/Archetype` is sealed, so there is no inheritable `itip/Archetype`. Framework
Archetype statements therefore declare `framework` directly at the top level:

```json
{
  "$schema": "gsmarc://gsm/Archetype/v1",
  "$id": "gsmarc://gsm-frameworks/gdpr/principles/GdprProcessingPrinciple/v1",
  "title": "GdprProcessingPrinciple",
  "framework": {
    "name": "gdpr",
    "version": "1.0.0"
  }
}
```

### Other ascription statements

The other seven GSM bases declare no properties beyond their own governance grammar,
so the typing Archetype must declare the `framework` property.

Every non-Archetype statement distributed by this repository MUST therefore be typed
by an framework base Archetype or one of its descendants, never directly by a GSM base.
The seven framework bases compose a rootless framework-membership facet that declares and
requires the object.

The same path carries authorship and future ITIP-wide statement concerns without adding
them to vendor-neutral GSM.

## Layered framework design

The framework architecture has four layers, from lowest and most general to highest and
organization-specific:

```text
GSM Archetype statements
            ↓
ITIP framework ascription statements
            ↓
Domain framework ascription statements
            ↓
Organization framework ascription statements
```

The arrows express framework dependency and construction order. Only Archetype
statements participate in schema inheritance and composition. Directive, Norm,
Structure, Mechanism, and other statements are instances typed by those Archetypes.

### Layer 1 — GSM Archetype statements

GSM defines the eight structural bases: Archetype, Structure, Mechanism, Effector,
Receptor, Interaction, Directive, and Norm.

These statements define what GSM ascriptions structurally are. GSM remains
vendor-neutral and carries no ITIP-specific framework, authorship, deployment, or
organization-stack semantics.

`gsm/Archetype` is sealed. The other seven GSM bases are extensible.

### Layer 2 — ITIP framework ascription statements

The ITIP framework binds GSM to the IT framework ecosystem.

It defines seven inheritable framework base Archetypes, corresponding to every extensible GSM
base. Each framework base:

1. inherits the corresponding GSM base through a top-level `$ref`;
2. composes ITIP-wide rootless facets through `allOf`.

```json
{
  "$schema": "gsmarc://gsm/Archetype/v1",
  "$id": "gsmarc://gsm-frameworks/Structure/v1",
  "title": "FrameworkStructure",
  "framework": {
    "name": "itip",
    "version": "1.0.0"
  },
  "$ref": "gsmarc://gsm/Structure/v1",
  "allOf": [
    {
      "$ref": "gsmarc://gsm-frameworks/Ascription/v1"
    }
  ]
}
```

The ITIP framework also contains rootless cross-cutting facets, shared data and
qualifier Archetypes, IT-wide vocabulary, and Directive, Norm, Structure, Mechanism,
Effector, Receptor, and Interaction statements governing or operationalizing ITIP.

`itip/Ascription` composes ITIP-wide statement concerns such as framework membership and
authorship. Framework Archetype statements carry the corresponding members directly at
the top level because `gsm/Archetype` is sealed.

Concepts required by several domain frameworks belong in the ITIP shared kernel. Domain
frameworks do not establish mandatory dependencies on one another; shared concepts are
promoted to ITIP.

### Layer 3 — Domain framework ascription statements

A domain framework translates an external standard, protocol, regulation, body of
knowledge, or IT discipline into ITIP-compatible ascription statements.

Current examples include HTTP, TOGAF, ISO 25000, GDPR, NIS2, and SCAP.

A domain framework may contain any GSM ascription statement type, including data,
qualifier, based, and rootless Archetypes; sourced Directives and Norms; and Structures,
Mechanisms, Effectors, Receptors, and Interactions.

Framework directories follow the source model's own taxonomy rather than GSM subject
type:

```text
frameworks/gdpr/
  principles/
  lawful-basis/
  data-subject-rights/
  controller-processor/
```

The filename and statement content identify the GSM type. The directory identifies the
source model's semantic domain.

Domain frameworks provide reusable vocabulary and governance content from which an
organization framework is built. Their based Archetypes inherit ITIP Archetypes through
`$ref`; they may also publish rootless facets intended for organization-level
composition. Domain frameworks do not directly inherit or compose other domain
frameworks.

### Layer 4 — Organization framework ascription statements

An organization framework assembles the ITIP and domain framework elements selected for
one organization and adds the organization's own vocabulary and governance.

A single organization framework may use both Archetype inheritance and composition.
They are mechanisms inside the same framework, not separate framework types.

#### Inheritance

A top-level `$ref` gives an Archetype one linear ancestry ending at exactly one GSM base:

```text
organization Archetype
        ↓ $ref
domain or ITIP Archetype
        ↓ $ref
framework base Archetype
        ↓ $ref
GSM base Archetype
```

```json
{
  "$schema": "gsmarc://gsm/Archetype/v1",
  "$id": "gsmarc://acme/PaymentApplication/v1",
  "title": "PaymentApplication",
  "framework": {
    "name": "acme-governance",
    "version": "1.0.0"
  },
  "$ref": "gsmarc://architecture/Application/v1",
  "properties": {
    "paymentCriticality": {
      "type": "string",
      "enum": ["standard", "important", "critical"]
    }
  }
}
```

#### Composition

An organization Archetype uses `allOf` to compose compatible rootless facets from its
selected frameworks:

```json
{
  "$schema": "gsmarc://gsm/Archetype/v1",
  "$id": "gsmarc://acme/PersonalDataApplication/v1",
  "title": "PersonalDataApplication",
  "framework": {
    "name": "acme-governance",
    "version": "1.0.0"
  },
  "$ref": "gsmarc://architecture/Application/v1",
  "allOf": [
    {
      "$ref": "gsmarc://gdpr/PersonalDataProcessing/v1"
    },
    {
      "$ref": "gsmarc://iso25000/ProductSecurity/v1"
    }
  ]
}
```

`$ref` defines what the Archetype is. `allOf` defines what the Archetype also carries.
Every external Archetype composed through `allOf` MUST be rootless; composition must not
be hidden multiple inheritance between based Archetypes.

An organization framework may also define its own rootless Archetypes, Directives,
Norms, Structures, Mechanisms, and other statements. Those statements carry the
organization framework's identity. Imported catalog statements retain their original
framework identity.

Except for the default full-stack organization framework, organization frameworks are
not statically maintained in this repository. Organizations create them at runtime
through ITIP, which registers their statements into DM and persists their tenant-scoped
framework aggregate.

## Default full-stack organization framework

ITIP publishes exactly one default full-stack organization framework. It is predefined
for organizations wanting a coherent default without assembling their own stack.

It is an organization framework, not an extra layer or a different framework kind. It
uses the same inheritance, composition, selection, registration, and validation
mechanisms as a runtime organization framework.

The only difference is origin: the default is defined and versioned in this repository;
custom organization frameworks are authored at runtime by organizations.

## ITIP framework catalog and persistence

Every framework distributed by this repository is imported into the ITIP framework
catalog, including the ITIP foundation, protocol and domain frameworks, and the default
full-stack organization framework.

For each repository framework, ITIP:

1. reads its `framework.json` descriptor;
2. persists its catalog metadata;
3. registers or synchronizes its framework statements in DM;
4. stores the resulting DM Definition and Ascription identifiers as framework members;
5. exposes it in the ITIP framework catalog UI.

The default full-stack framework uses the same catalog mechanism and may be selected
automatically when a new organization is provisioned.

DM remains authoritative for individual governed ascriptions. ITIP is authoritative for
framework aggregates, catalog metadata, and organization stack selection.

The ITIP backend requires tenant-aware persistence for:

- frameworks (`name`, `version`, tenant, catalog/runtime source metadata);
- framework dependencies and organization selections;
- framework members referencing DM Definition and Ascription identifiers.

Source metadata distinguishes repository catalog imports from tenant-authored runtime
frameworks. It is operational metadata, not a framework `kind`.

## Framework descriptor

`framework.json` is the portable representation used both for repository catalog
frameworks and exports of runtime organization frameworks. It is not itself a DM
ascription statement.

### Domain framework descriptor

```json
{
  "name": "gdpr",
  "version": "1.0.0",
  "description": "GDPR vocabulary and sourced governance statements.",
  "itipVersion": "1.0.0",
  "elements": [
    {
      "path": "principles/GdprProcessingPrinciple.archetype.json"
    },
    {
      "path": "principles/ProcessingPrinciples.directive.json",
      "archetype": "SourcedDirective"
    },
    {
      "path": "principles/Accountability.norm.json",
      "archetype": "SourcedNorm"
    }
  ]
}
```

Every domain framework depends on ITIP by invariant because its non-Archetype elements
are ITIP-typed and its based Archetypes inherit ITIP. `itipVersion` records the framework
version against which compatibility was validated.

### Organization framework descriptor

```json
{
  "name": "acme-governance",
  "version": "1.0.0",
  "description": "Acme organization governance framework.",
  "itipVersion": "1.0.0",
  "selects": [
    {
      "name": "architecture",
      "version": "2.1.0"
    },
    {
      "name": "gdpr",
      "version": "1.0.0"
    },
    {
      "name": "iso25000",
      "version": "1.3.0"
    }
  ],
  "elements": [
    {
      "path": "PaymentApplication.archetype.json"
    },
    {
      "path": "PersonalDataApplication.archetype.json"
    }
  ]
}
```

`selects` declares the catalog frameworks adopted into the organization's effective
stack. Much of that selection can be checked or suggested from inherited and composed
Archetype references, but it cannot always be completely derived: an organization may
select Directive or Norm content without schema references, or define new rootless
organization elements over a selected vocabulary. Selection is therefore explicit and
validated against actual references and members.

`elements` remains explicit for deterministic import, registration typing, atomic
validation, detection of unlisted files, and reproducible export.

No `kind` field is required. Architectural role follows from layer and persistence:
repository catalog frameworks are ITIP/domain frameworks, the one predefined default is
an organization framework supplied by ITIP, and tenant-owned records are runtime
organization frameworks.

## Namespacing

Each framework owns a `gsmarc://` authority or authority path. Existing paths include:

```text
gsmarc://gsm-frameworks/http/HttpRequest/v1
gsmarc://gsm-frameworks/gdpr/principles/GdprProcessingPrinciple/v1
```

The `framework` object is the authoritative package ownership marker; `$id` provides
globally unique schema identity. Archetype titles must be globally unique among in-effect
Archetypes because DM resolves them by title.

## Authorship and trust model

Authorship belongs to ITIP rather than GSM or DM:

```json
{
  "authorship": {
    "identity": "author-identity",
    "identityIssuer": "issuing-authority"
  }
}
```

| Member | Required | Meaning |
| --- | --- | --- |
| `identity` | yes | Human or system identity, unique within the issuer |
| `identityIssuer` | yes | OIDC issuer, client registry, or other issuing authority |

For human-authored statements, the ITIP application derives authorship from the
authenticated session. Users do not declare their identity; ITIP MUST reject or ignore
client-supplied authorship.

For system-authored statements, the registered system declares authorship. Its assertions
are **trusted by admission**: API gateway registration extends trust to data supplied by
that technical client. The caller may be the author or may legitimately submit content
authored by another system; ITIP does not infer or verify the distinction.

System authorship is suitable for provenance and audit context. It MUST NOT be treated as
non-repudiation evidence. Its assurance is exactly the rigour of technical-client
registration. No separate assurance field is defined.

The ITIP authorship base does not declare `$gsm:queryable` or `$gsm:dataProtection` on
`identity`. The framework or organization knowing whether its identity space denotes
natural persons applies the appropriate annotations.

## Installation and validation

Before registering or activating a framework, ITIP validates:

- descriptor name and version;
- each element's `framework` object;
- agreement between statement ownership and descriptor identity;
- availability of the declared `itipVersion` and every selected framework version;
- every non-Archetype statement's registration Archetype;
- use of ITIP-derived Archetypes by non-Archetype framework statements;
- convergence of every `$ref` chain to exactly one GSM base;
- rootlessness of every external `allOf` facet;
- absence of dangling references and dependency cycles;
- globally unique Archetype titles;
- compatibility of the resulting composed schemas;
- consistency between organization `selects`, statement members, and actual references.

Framework installation is managed as a unit by ITIP, while individual elements retain
the normal DM lifecycle.

## Foundation principles

1. GSM remains vendor-neutral.
2. Governed framework model elements are represented as ascription statements.
3. Framework aggregation and selection are managed by ITIP, not DM.
4. Framework ownership is intrinsic to each ascription version.
5. Organization selection never rewrites imported framework ownership.
6. Archetype inheritance is linear and expressed through `$ref`.
7. Archetype composition uses rootless facets through `allOf`.
8. Domain frameworks depend on ITIP, not directly on one another.
9. Organization frameworks may both inherit and compose domain elements.
10. ITIP imports every repository framework into one catalog mechanism.
11. ITIP provides exactly one predefined default full-stack organization framework.
12. Custom organization frameworks are tenant-scoped and authored at runtime.
13. Human authorship is application-derived.
14. System authorship is trusted by admission.

## Repository organization

Frameworks follow their own model-native taxonomy:

```text
frameworks/
  itip/
    base/
      Ascription.archetype.json
      Structure.archetype.json
      ...
    ...
    framework.json
  http/
    HttpRequest.archetype.json
    HttpRequestEffector.archetype.json
    HttpRequestReceptor.archetype.json
    HttpRequestInteraction.archetype.json
    framework.json
    README.md
  gdpr/
    principles/
      GdprProcessingPrinciple.archetype.json
      ProcessingPrinciples.directive.json
      Accountability.norm.json
    ...
    framework.json
    README.md
  default/
    framework.json
    ...
```

Only the predefined default full-stack organization framework belongs in this repository.
Other organization frameworks are created and persisted at runtime through ITIP.

See [`frameworks/README.md`](frameworks/README.md) for the current model inventory and inter-model
articulation analysis.

## Verified DM constraints

The design has been checked against the current DM implementation:

- `gsm/Archetype` is the only sealed GSM base;
- the other seven GSM bases accept inheritance through `$ref`;
- nested `$ref` chains resolve through multiple levels;
- non-`gsm` `gsmarc://` authorities are accepted;
- rootless facets may be composed through `allOf`;
- subject type is determined by the top-level `$ref` inheritance chain;
- non-Archetype statements are validated against their selected Archetype;
- GSM base closure requires ITIP-derived typing for ITIP-wide statement properties.

## Provenance

Framework statements contain derived vocabulary, structure, property names, and
governance grammar, not reproductions of source standards' normative text. See
[`CONTRIBUTING.md`](CONTRIBUTING.md) for sourcing and provenance requirements.

## References

- `poesis-cloud/gsm` — GSM solution umbrella (this repo's parent)
- `poesis-cloud/gsm-specifications` — Generative System Model specification
- `poesis-cloud/sie-definition-manager` — Definition Manager
- `poesis-cloud/sie-definition-manager/def/adr/authorship-not-a-gsm-concern.md`
- `poesis-cloud/sie-definition-manager/def/adr/uniform-polymorphic-ascription-api.md`

## License

GSM Frameworks is licensed under the **[Business Source License 1.1](LICENSE)**
(BUSL-1.1), with the same Additional Use Grant, 2030-07-01 Change Date, and
AGPL-3.0-or-later Change License as GSM and the other Poesis engine repositories.
