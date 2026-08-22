# GSM Frameworks

[![Release](https://img.shields.io/github/v/release/poesis-cloud/gsm-frameworks)](https://github.com/poesis-cloud/gsm-frameworks/releases/latest)
[![License: BUSL-1.1](https://img.shields.io/badge/license-BUSL--1.1-blue)](LICENSE)

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
GdprProcessingPrinciples.directive.json
GdprAccountability.norm.json
ItDirectiveNormOperationalization.mechanism.json
directive-norm-operationalization.rule.star
```

An Archetype statement is named `.archetype.json`, rather than `.schema.json`, because
its role here is a governed Archetype ascription. Its statement content remains JSON
Schema.

For non-Archetype statements, the filename identifies the statement and GSM subject
type. Statements carry only their GSM governance grammar; everything the catalogue
knows *about* a statement (membership, provenance) lives in the framework descriptor.
This keeps three distinct concepts separate:

- statement identity: `ProcessingPrinciples`
- GSM subject type: `Directive` (from the filename suffix, typed by the GSM base)
- catalogue metadata: the descriptor's `elements[]` entry (`source`, etc.)

PascalCase is used for governed statement filenames. Kebab-case is used for supporting
source files and directories.

Every governed statement filename is **prepended with its framework's name** in
PascalCase (`gdpr` → `Gdpr`, `iso25000` → `Iso25000`, `it` → `It`): the `http`
framework's request archetype is `HttpRequest.archetype.json`, the `gdpr` framework's
accountability norm is `GdprAccountability.norm.json`. For Archetype statements the
prefix carries through to the `title` and the final `$id` segment, since
filename = `{Title}.archetype.json` and `$id` ends in `/{Title}/v1`. This makes every
statement identity globally unambiguous even outside its folder, and is enforced by
`scripts/lint_layers.py` (rule L5).

### Facet composition: the mount rule and statement closure

JSON Schema namespaces *schemas* (`$id`) but **not instance properties**: `allOf`
merges facet constraints over one flat property namespace. Two facets defining the
same property name conflate data — or produce an unsatisfiable intersection when the
types diverge (real case: `availabilityTarget` is a string enum in
`Iso25000ServiceReliability` and a number in `Iso25000DataAvailability`). The
catalogue therefore defines its own instance-level namespacing:

- **Facet mount rule** — a composite archetype mounts each facet under an *optional*
  property whose key is the **lowerCamelCase of the facet's globally-unique title**
  (`iso25000ServiceReliability`, `provAttribution`, `scapPlatformIdentifier`).
  Collision-free by the filename-prefix rule; optional-by-construction — the facet's
  internal `required` members apply only when the mount is present. CEL reads
  unambiguously: `ItApplicationService.iso25000ServiceReliability.availabilityTarget`.
  Bare `allOf` remains legal only for a single *open* facet intrinsic to the subject's
  identity (exemplar: `ItSoftwareTechnology` composing `ScapPlatformIdentifier`).
- **Statement closure belongs to the DM** — archetype statements MUST NOT declare
  top-level `additionalProperties: false` / `unevaluatedProperties: false` (lint rule
  L7). The DM applies `unevaluatedProperties: false` at the root of the *resolved*
  typing archetype at ascription time (GSM §5 "Statement closure" — the same decision
  that removed author-side closure from the GSM base schemas). Author-side top-level
  closure is redundant at best and breaks facet composition at worst. Nested closures
  (inside array items, sub-objects) are unaffected and remain legitimate.

This convention is fully applied across `frameworks/`.

## Framework membership and catalogue metadata

Statements do **not** declare their framework. Membership is declared exactly once, by
placement: the framework descriptor's `elements[]` list is the package manifest, and at
runtime the consuming platform's catalogue persistence records member → DM identifier
mappings. The descriptor entry also carries the statement's catalogue metadata —
provenance (`source`), governance links (`operationalizes`), deployment guidance
(`deploymentNotes`):

```json
{
  "path": "principles/GdprProcessingPrinciples.directive.json",
  "source": {
    "authority": "European Parliament and Council of the European Union",
    "regulation": "Regulation (EU) 2016/679 (GDPR)",
    "article": "Article 5",
    "text": "Personal data shall be: (a) processed lawfully, ..."
  }
}
```

Membership means:

> This ascription statement is authored, governed, versioned, and distributed as an
> element of the framework whose descriptor lists it.

It does not mean that the framework is selected in a particular organization's stack.
Imported statements retain their original framework membership (the catalogue record)
when selected by an organization framework.

### Archetype statements

Archetype statements are governed JSON Schema documents. Their identity is the `$id`
under the framework's `gsmarc://` namespace path; their membership is their descriptor
entry, like every other statement:

```json
{
  "$schema": "gsmarc://gsm/Archetype/v1",
  "$id": "gsmarc://gsm-frameworks/gdpr/principles/GdprProcessingPrinciple/v1",
  "title": "GdprProcessingPrinciple"
}
```

### Other ascription statements

Non-Archetype statements carry **only** their GSM governance grammar and are typed
directly by the corresponding GSM base (or by a framework Archetype where one exists,
e.g. a rootless facet composition at the domain layer). The GSM bases stay closed:
no catalogue concern is ever added to a statement payload. Authorship is not a
catalogue concern either: it is the PROV Attribution relation with OIDC-identified
agents, borne by the `prov` and `oidc` reference frameworks and composed at the domain
or organization layer (see *Authorship and trust model*).

> **DM verification pending**: the design assumes DM accepts non-Archetype statements
> typed directly by a GSM base. Previously statements were typed via wrapper Archetypes
> solely to carry the now-removed membership property.

## Layered framework design

The framework architecture is a strict rank-ordered stack. GSM is the upper ontology;
three framework layers build on it, from most general to organization-specific:

```text
GSM Archetype statements            (upper ontology — vendor-neutral)
            ↑
Reference frameworks                (isolated; one external authority each)
            ↑
Domain frameworks                   (integrate reference frameworks for a domain, e.g. IT)
            ↑
Organization frameworks             (tenant-authored at runtime; never in this repository)
```

**Rank rule (machine-checked)**: a framework may reference only GSM,
itself, and frameworks of strictly lower layer rank. In particular, reference frameworks
are **isolated** — they reference only GSM and themselves. Composition across reference
frameworks is the exclusive role of domain frameworks and happens through GSM governance
(Directives and Norms qualifying subjects across frameworks) plus declared articulation,
never through schema-level `$ref` between reference folders. The rule is enforced by
`scripts/lint_layers.py`.

Only Archetype statements participate in schema inheritance and composition. Directive,
Norm, Structure, Mechanism, and other statements are instances typed by those
Archetypes.

This stratification mirrors established ontology-engineering practice (upper ontology →
reference ontologies → domain ontologies → application ontologies, as proven at scale by
the OBO Foundry federation), while remaining generative rather than descriptive.

### Upper layer — GSM Archetype statements

GSM defines the eight structural bases: Archetype, Structure, Mechanism, Effector,
Receptor, Interaction, Directive, and Norm.

These statements define what GSM ascriptions structurally are. GSM remains
vendor-neutral and carries no catalogue-specific framework, authorship, deployment, or
organization-stack semantics.

`gsm/Archetype` is sealed. The other seven GSM bases are extensible.

### Layer 2 — Reference framework ascription statements

A **reference framework** translates exactly one external authority — a standard,
protocol, regulation, or body of knowledge — into GSM-compatible ascription statements.
Current examples: TOGAF, ISO 25000, GDPR, NIS2, SCAP, and HTTP.

Reference frameworks are **isolated**: they reference only GSM,
never another framework. Cross-authority citations inside a source text
(e.g. NIS2 citing ISO 27001) are re-expressed at the domain layer, not encoded in
reference schemas. Provenance of a sourced statement (the legal clause it derives from)
is catalogue metadata on the descriptor's `elements[]` entry, not statement content.
This isolation is what lets the catalogue scale: sourcing a new law
or standard never touches an existing framework, and a standard revision is contained
by `$id` versioning (`/v1 → /v2`).

A reference framework may contain any GSM ascription statement type, including data,
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

### Layer 3 — Domain framework ascription statements

A **domain framework** integrates the reference frameworks relevant to one domain into
a coherent governance fabric and adds domain-native vocabulary. The current example is
`it` — the IT domain framework consumed by the IT Intelligence Platform (ITIP).

A domain framework:

- declares the reference frameworks it integrates in its descriptor's `composes` list;
- **owns the domain ontology** in a machine-readable `ontology.json` (descriptor
  `ontology` key): the integrated view of the composed reference frameworks as one
  subject taxonomy under orthogonal dimensions connected by typed axes (the `it`
  ontology v1 covers all togaf, scap, iso25000, and prov concepts — structure,
  identity, quality, and provenance dimensions — coherence enforced by lint rule L6);
- **owns the inter-framework articulation** in a machine-readable `articulations.json`
  (concept-level mappings such as *TOGAF ArchitecturePrinciple qualifies-with ISO 25010
  ProductReliability*), so composition is traversable by tooling and AI, not only
  documented in prose;
- may reference archetypes of any reference framework (as qualifiers, `$ref` bases, or
  rootless facets) and contribute its own statements — but never mutates or shadows
  reference concepts;
- never references a sibling domain framework. Cross-domain needs compose at the
  organization layer or justify promoting the shared concept to a new reference
  framework.

The domain layer does **not** partition the world: several domain frameworks may
integrate the same reference framework (GDPR concerns IT, HR, and marketing domains
alike) without coordination, and one organization may select several domain frameworks.

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
domain or reference Archetype
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

Organization frameworks are **never** maintained in this repository. The layer boundary
is a publication boundary: this repository publishes the reference and
domain layers — the shareable world ontology — while organization frameworks are
tenant-scoped, often confidential, and authored at runtime through the consuming
platform (e.g. ITIP), which registers their statements into DM and persists their
tenant-scoped framework aggregate. An organization wanting a coherent default without
assembling its own stack selects a domain framework wholesale.

## ITIP framework catalog and persistence

Every framework distributed by this repository is imported into the ITIP framework
catalog, including the reference frameworks and the domain frameworks.

For each repository framework, ITIP:

1. reads its `framework.json` descriptor;
2. persists its catalog metadata;
3. registers or synchronizes its framework statements in DM;
4. stores the resulting DM Definition and Ascription identifiers as framework members;
5. exposes it in the ITIP framework catalog UI.

A domain framework may be selected wholesale when a new organization is provisioned,
serving as the coherent default stack for that domain.

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

### Reference framework descriptor

```json
{
  "name": "gdpr",
  "version": "1.0.0",
  "description": "GDPR vocabulary and sourced governance statements.",
  "layer": "reference",
  "elements": [
    {
      "path": "principles/GdprProcessingPrinciple.archetype.json"
    },
    {
      "path": "principles/GdprProcessingPrinciples.directive.json",
      "source": {
        "authority": "European Parliament and Council of the European Union",
        "regulation": "Regulation (EU) 2016/679 (GDPR)",
        "article": "Article 5",
        "text": "Personal data shall be: ..."
      }
    }
  ]
}
```

The `elements[]` entry is the statement's catalogue record: membership by placement,
plus provenance (`source`), governance links (`operationalizes`), and deployment
guidance (`deploymentNotes`) where applicable. Statements themselves carry only GSM
grammar.

### Domain framework descriptor

```json
{
  "name": "it",
  "version": "1.0.0",
  "description": "IT domain framework.",
  "layer": "domain",
  "composes": [
    {
      "name": "togaf",
      "version": "1.0.0"
    },
    {
      "name": "iso25000",
      "version": "1.0.0"
    }
  ],
  "ontology": "ontology.json",
  "articulations": "articulations.json",
  "elements": [
    {
      "path": "technology/ItSoftwareTechnology.archetype.json"
    }
  ]
}
```

`composes` declares the reference frameworks the domain framework integrates — every
entry must be a reference framework. `articulations` points to the machine-readable
inter-framework articulation map owned by the domain framework.

### Organization framework descriptor

```json
{
  "name": "acme-governance",
  "version": "1.0.0",
  "description": "Acme organization governance framework.",
  "layer": "organization",
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

Architectural role is declared explicitly by the `layer` field —
`reference`, `domain`, or `organization` — and enforced as a rank-order invariant by
`scripts/lint_layers.py`. `selects` may target multiple domain frameworks: real
organizations are multi-domain.

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

Authorship belongs to the consuming platform rather than GSM or DM, and in standards
terms it is **provenance attribution**, not identity: W3C PROV-DM defines Attribution as
"the ascribing of an entity to an agent". It is therefore expressed by two reference
frameworks composed at the domain layer:

- **`prov` — `ProvAttribution`** rootless facet (`wasAttributedTo`), the authorship
  relation itself. PROV mandates no agent identification scheme, so `agent` is open.
- **`oidc` — `OidcSubject`** rootless facet (`sub`, `iss`), the identity vocabulary the
  composing domain archetype uses to tighten `wasAttributedTo.agent`.

(OAuth 2.0's Resource Owner is deliberately **not** used: RFC 6749 defines it as an
access-granting role, not attribution — see `frameworks/oauth2/README.md`.)

```json
{
  "wasAttributedTo": {
    "agent": {
      "sub": "author-subject-identifier",
      "iss": "issuing-authority"
    }
  }
}
```

Catalogue statements do not carry attribution: their author is the publishing framework,
which the descriptor membership already records.

For human-authored statements, the platform derives the agent from the authenticated
session. Users do not declare their identity; the platform MUST reject or ignore
client-supplied attribution. DM persists the value agnostic, like any other non-GSM
property; ownership-based access rules (e.g. "users only see their own ascriptions")
compare the current session identity against it — safe precisely because only the
platform ever writes it.

For system-authored statements, the registered system declares attribution. Its assertions
are **trusted by admission**: API gateway registration extends trust to data supplied by
that technical client. The caller may be the author or may legitimately submit content
authored by another system; the platform does not infer or verify the distinction.

System attribution is suitable for provenance and audit context. It MUST NOT be treated as
non-repudiation evidence. Its assurance is exactly the rigour of technical-client
registration. No separate assurance field is defined.

Neither facet declares `$gsm:queryable` or `$gsm:dataProtection` on `sub`. The framework
or organization knowing whether its identity space denotes natural persons applies the
appropriate annotations.

## Installation and validation

Before registering or activating a framework, ITIP validates:

- descriptor name, version, and `layer`;
- each element's `framework` object;
- agreement between statement ownership and descriptor identity;
- availability of every composed/selected framework version;
- layer rank order of every cross-framework reference (`scripts/lint_layers.py`);
- every non-Archetype statement's registration typing;
- absence of catalogue metadata inside statement payloads;
- convergence of every `$ref` chain to exactly one GSM base;
- rootlessness of every external `allOf` facet;
- absence of dangling references and dependency cycles;
- globally unique Archetype titles;
- compatibility of the resulting composed schemas;
- consistency between organization `selects`, statement members, and actual references.

Framework installation is managed as a unit by ITIP, while individual elements retain
the normal DM lifecycle.

## Foundation principles

1. GSM remains vendor-neutral; statements carry only GSM grammar.
2. Governed framework model elements are represented as ascription statements.
3. Framework aggregation and selection are managed by the consuming platform, not DM.
4. Framework membership and provenance are catalogue metadata: descriptor `elements[]` entries, never statement content.
5. Organization selection never rewrites imported framework ownership.
6. Archetype inheritance is linear and expressed through `$ref`.
7. Archetype composition uses rootless facets through `allOf`.
8. Reference frameworks are isolated: they reference only GSM, never one another.
9. Domain frameworks compose reference frameworks and own the machine-readable articulation between them.
10. A framework references only frameworks of strictly lower layer rank (enforced by `scripts/lint_layers.py`).
11. The domain layer does not partition the world: reference frameworks are shared across domains, and organizations may select several domain frameworks.
12. Organization frameworks are tenant-scoped, authored at runtime, and never published in this repository.
13. Human authorship is application-derived.
14. System authorship is trusted by admission.

## Repository organization

Frameworks follow their own model-native taxonomy under `frameworks/`:

```text
frameworks/
  http/                          # reference framework
    HttpRequest.archetype.json
    framework.json               # layer: reference
    README.md
  oidc/                          # reference framework (identity vocabulary)
    id-token/
      OidcSubject.archetype.json
    framework.json               # layer: reference
    README.md
  prov/                          # reference framework (provenance vocabulary)
    agents-responsibility/
      ProvAttribution.archetype.json
      ...
    derivations/
      ProvPrimarySource.archetype.json
      ...
    framework.json               # layer: reference
    README.md
  gdpr/                          # reference framework
    principles/
      GdprProcessingPrinciple.archetype.json
      GdprProcessingPrinciples.directive.json
      GdprAccountability.norm.json
    ...
    framework.json               # layer: reference — elements[] carry source provenance
    README.md
  it/                            # domain framework (IT)
    meta-governance/
    technology/
    ontology.json                # IT ontology v1 — four dimensions over one subject taxonomy
    articulations.json           # machine-readable inter-framework articulation
    framework.json               # layer: domain — composes the reference frameworks
scripts/
  lint_layers.py                 # rank-order + isolation + metadata-purity + ontology + composition lint
```

No organization framework belongs in this repository. Organization frameworks are
created and persisted at runtime through the consuming platform.

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
- GSM base closure means statements carry only GSM grammar; catalogue metadata lives in the descriptor (direct GSM-base typing of non-Archetype statements is pending DM verification).

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
