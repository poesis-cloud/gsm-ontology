# Copilot Instructions — gsm-ontology

This repository is the **published, versioned source of sourced governance/compliance/architecture/regulatory
ontology schemas** for the Organizational Intelligence Platform (OIP). It contains no runnable application code — only
JSON Schema archetypes and Directive/Norm ascription instances. Read `PROJECT_BRIEF.md` before starting work.

---

## Team

| Agent | Name | Role | Key Skills |
|-------|------|------|------------|
| Producer | **Remy** | Sourcing backlog, provenance review, GitHub Issues, PR merges | `product-manager`, `create-pr`, `update-pr`, `sync`, `commit`, `chronicle` |
| Dev | **Nova / Sage / Milo** | Author/update schemas, maintain inter-model articulation docs | `gsm-knowledge`, `oip-ontology-sourcing`, `agent-customization`, `commit`, `create-pr`, `context-map`, `refactor-plan` |
| QA | **Ivy** | Schema validity checks, provenance citation review | `code-review`, `commit` |

Remy **never writes schema content**. Dev team **never merges to main directly** — always via PR.

---

## Domain Rules (mandatory for all agents)

### Model-native organization (P9)
Each ontology is organized by **its own taxonomy**, not by GSM subject type. The folder tells you what model
domain owns the concept; the GSM subject-type mapping is expressed in the schema content via top-level `$ref`.

### Composition through GSM only
Models compose **through the GSM governance layer** (Directives qualifying Subjects using archetypes from
different models), never through schema-level cross-references between ontology folders. Do not add
filesystem-relative `$ref` paths that cross from one ontology's folder into another's — cross-model
articulation is documented in `ontologies/README.md`, not encoded in schema `$ref`.

### `$id` namespace stability
Every archetype schema's `$id` uses the `gsmarc://gsm-ontology/{authority}/{taxonomy}/{Title}/v1` scheme.
This is a **logical identifier**, independent of which repository or filesystem path physically hosts the
file — never change an existing `$id` without a deliberate, documented versioning decision (bump the trailing
`/v1` → `/v2`, do not mutate v1 in place once published).

### Provenance requirement
Every sourced Directive/Norm/Archetype MUST cite the source clause/section it derives from (see each
ontology's `README.md` for the expected citation format). Do not reproduce copyrighted normative text
verbatim beyond short quotation — only the derived GSM-compatible vocabulary.

### Statement file naming convention
See the "Terminology and file conventions" section of `README.md` (authoritative for this repository):
- Archetype statements (`$schema: gsmarc://gsm/Archetype/v1`): filename = `{Title}.archetype.json`.
- Other ascription statements: filename = `{StatementIdentity}.{gsmSubjectType}.json`, e.g.
  `ProcessingPrinciples.directive.json`, `Accountability.norm.json`.
- The typing Archetype is declared by the ontology package's `elements[].archetype`,
  never by the filename.

---

## Engineering Rules

### Root-cause-first
Fix the actual cause of schema validation issues before suppressing/ignoring them. There is no suppression
mechanism in plain JSON Schema — if a schema is wrong, fix it.

### Git history preservation
Use `git mv` / `git rm` for tracked file moves and deletes. Never use plain OS-level `mv`/`rm`.

### Archive folders are read-only
`archives/` and `archive/` folders (if present) contain superseded historical content. Never edit, update, or
delete files inside them.

### Commit trailer (required on every commit)
```
Co-authored-by: Copilot <223556219+Copilot@users.noreply.github.com>
```

### DCO sign-off (required on every commit)
```bash
git commit -s -m "..."
```

---

## SE Plugin Agents (global — invoke by name)

These agents are installed globally via the `software-engineering-team` plugin. Invoke them by name in any chat.

| When | Invoke |
|---|---|
| Security review before any merge | `SE: Security` |
| Architecture decision or structurant PR | `SE: Architect` |
| Writing/updating API docs, ADRs, README | `SE: Technical Writer` |
| Authoring GitHub Issues or backlog items | `SE: Product Manager Advisor` |
