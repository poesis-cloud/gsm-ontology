#!/usr/bin/env python3
"""Layering lint for gsm-ontology.

Enforces the layered ontology model as a machine-checkable invariant:

    gsm (upper) <- reference <- domain <- organization

Rules
    L1  Every ontology package declares a valid ``layer``.
  L2  A statement may reference (``$ref``/``$id`` targets under
    ``gsmarc://gsm-ontology/``) only: the gsm authority, its own ontology,
    or an ontology of strictly lower rank.
    Reference ontologies therefore never reference another ontology at all
      -- they are isolated, referencing only GSM and themselves.
  L3  ``composes`` (domain) / ``selects`` (organization) entries target only
    ontologies of strictly lower rank that exist in the catalogue.
  L4  Every element file parses as JSON and carries no catalogue metadata
      (``ontology``/``source``/``operationalizes``/``deploymentNotes`` live in
      the package, never in the statement).
  L5  Every governed non-Archetype element filename is prepended with its
      ontology's name in PascalCase (``gdpr`` -> ``Gdpr``). Archetype
      statements are exempt from the prefix: their namespace lives in the
      ``$id`` path (authority + folder path), not in ``title`` -- so an
      Archetype's ``title`` and final ``$id`` segment need only match the
      filename stem, unprefixed. An Archetype's ``$id`` path (between the
      ``gsmarc://gsm-ontology/`` authority and the trailing ``/{title}/v{n}``)
      must equal its actual folder path (ontology name + subfolders): the
      ``$id`` is not free-standing, it mirrors where the file lives.
  L6  No archetype statement declares top-level closure
      (``additionalProperties: false`` / ``unevaluatedProperties: false``):
      statement closure is applied by the DM on the resolved typing archetype
      at ascription time, and author-side closure breaks facet composition.
  L7  Composition satisfiability: sibling ``allOf`` facets must not define the
      same property name (flat-namespace conflation -- use the facet mount
      rule), and a host property must not redefine an inherited property
      (top-level ``$ref`` chain or composed facet) with a different ``type``
      (silently unsatisfiable intersection).
  L9  Norm applicability roots are exact ``ref("<$id>")`` calls whose target
      is a governed Archetype in this catalogue. Bare title roots, malformed
      calls, and unregistered targets are forbidden.

Exit code 0 = pass, 1 = violations (printed to stderr).
"""

import json
import re
import sys
from pathlib import Path

RANKS = {"reference": 1, "domain": 2, "organization": 3}
METADATA_KEYS = ("ontology", "source", "operationalizes", "deploymentNotes")
GSMARC_ID = re.compile(
    r"gsmarc://[a-z0-9]+(?:-[a-z0-9]+)*/"
    r"(?:[a-z0-9]+(?:-[a-z0-9]+)*/)*"
    r"[A-Z][A-Za-z0-9]*/v[1-9][0-9]*"
)
REF_CALL = re.compile(r"\bref\s*\(\s*(['\"])(gsmarc://[^'\"]+)\1\s*\)")
REF_CALL_START = re.compile(r"\bref\s*\(")
BARE_APPLICABILITY_ROOT = re.compile(r"(?<![A-Za-z0-9_])([A-Z][A-Za-z0-9]*)\s*\.")
GSMARC = re.compile(r'"gsmarc://gsm-ontology/([^"]+)"')

ROOT = Path(__file__).resolve().parent.parent


def pascal_prefix(name):
    return "".join(part.capitalize() for part in re.split(r"[-_]", name))


def load_packages():
    packages = {}
    for path in sorted(ROOT.glob("ontologies/*/ontology-package.json")):
        data = json.loads(path.read_text())
        packages[data["name"]] = {"dir": path.parent, "data": data}
    return packages


def build_id_owner_map(packages):
    """Map every gsm-ontology $id path segment -> owning ontology name."""
    owners = {}
    for name, info in packages.items():
        for element in info["data"].get("elements", []):
            file = info["dir"] / element["path"]
            schema_id = json.loads(file.read_text()).get("$id", "")
            prefix = "gsmarc://gsm-ontology/"
            if schema_id.startswith(prefix):
                owners[schema_id[len(prefix):]] = name
    return owners


def build_archetype_ids(packages):
    """Return exact L5-coherent Archetype identities declared by packages."""
    archetype_ids = set()
    for name, info in packages.items():
        for element in info["data"].get("elements", []):
            if not element["path"].endswith(".archetype.json"):
                continue
            statement = json.loads((info["dir"] / element["path"]).read_text())
            schema_id = statement.get("$id")
            title = statement.get("title")
            if is_l5_archetype_id(name, element["path"], title, schema_id):
                archetype_ids.add(schema_id)
    return archetype_ids


def is_l5_archetype_id(ontology, element_path, title, schema_id):
    if not isinstance(title, str) or not isinstance(schema_id, str):
        return False
    folder = Path(element_path).parent.as_posix()
    folder_segment = "" if folder == "." else f"{folder}/"
    expected = f"gsmarc://gsm-ontology/{ontology}/{folder_segment}{title}/v"
    return bool(
        GSMARC_ID.fullmatch(schema_id)
        and re.fullmatch(re.escape(expected) + r"[1-9][0-9]*", schema_id)
    )


def main():
    errors = []
    packages = load_packages()
    if not packages:
        errors.append("L1: no ontology packages found under ontologies/*/ontology-package.json")
    owners = build_id_owner_map(packages)
    archetype_ids = build_archetype_ids(packages)

    def resolve_owner(target_path):
        # Archetype $ids are exact; non-Archetype statements are addressed by
        # ontology-prefixed path, so fall back to the first path segment.
        owner = owners.get(target_path)
        if owner is None:
            segment = target_path.split("/", 1)[0]
            if segment in packages:
                owner = segment
        return owner

    for name, info in packages.items():
        layer = info["data"].get("layer")
        if layer not in RANKS:
            errors.append(f"L1 {name}: missing or invalid layer {layer!r}")
            continue
        rank = RANKS[layer]

        for field in ("composes", "selects"):
            for dep in info["data"].get(field, []):
                target = packages.get(dep["name"])
                if target is None:
                    errors.append(f"L3 {name}: {field} unknown ontology {dep['name']!r}")
                elif RANKS[target["data"]["layer"]] >= rank:
                    errors.append(
                        f"L3 {name} ({layer}): {field} {dep['name']} "
                        f"({target['data']['layer']}) violates rank order"
                    )

        for element in info["data"].get("elements", []):
            file = info["dir"] / element["path"]
            filename = file.name
            if not filename.endswith(".archetype.json"):
                prefix = pascal_prefix(name)
                if not filename.startswith(prefix):
                    errors.append(
                        f"L5 {name}: {element['path']}: filename must be prepended "
                        f"with the ontology name ({prefix!r})"
                    )
            try:
                statement = json.loads(file.read_text())
            except (OSError, json.JSONDecodeError) as exc:
                errors.append(f"L4 {name}: {element['path']}: {exc}")
                continue
            if filename.endswith(".archetype.json"):
                stem = filename.split(".")[0]
                if statement.get("title") != stem:
                    errors.append(
                        f"L5 {name}: {element['path']}: title "
                        f"{statement.get('title')!r} must equal filename stem {stem!r}"
                    )
                folder = Path(element["path"]).parent.as_posix()
                folder_segment = "" if folder == "." else f"{folder}/"
                expected_id = f"gsmarc://gsm-ontology/{name}/{folder_segment}{stem}/v"
                if not re.fullmatch(
                    re.escape(expected_id) + r"[1-9][0-9]*", statement.get("$id", "")
                ):
                    errors.append(
                        f"L5 {name}: {element['path']}: $id "
                        f"{statement.get('$id')!r} must equal its folder path "
                        f"({expected_id!r} + version)"
                    )
                for keyword in ("additionalProperties", "unevaluatedProperties"):
                    if statement.get(keyword) is False:
                        errors.append(
                            f"L6 {name}: {element['path']}: top-level "
                            f"{keyword}: false forbidden -- the DM applies "
                            f"statement closure at ascription time"
                        )
            for key in METADATA_KEYS:
                if key in statement:
                    errors.append(
                        f"L4 {name}: {element['path']}: catalogue metadata "
                        f"{key!r} belongs in the package, not the statement"
                    )
            check_applicability(name, element["path"], statement, archetype_ids, errors)
            for target_path in GSMARC.findall(file.read_text()):
                owner = resolve_owner(target_path)
                if owner is None:
                    errors.append(f"L2 {name}: {element['path']}: unresolved gsmarc target {target_path!r}")
                elif owner != name:
                    owner_rank = RANKS[packages[owner]["data"]["layer"]]
                    if owner_rank >= rank:
                        errors.append(
                            f"L2 {name} ({layer}): {element['path']} references "
                            f"{target_path} owned by {owner} "
                            f"({packages[owner]['data']['layer']}) -- rank order violated"
                        )

    check_composition(packages, errors)

    for error in errors:
        print(error, file=sys.stderr)
    print(f"lint-ontologies: {len(packages)} packages, {len(owners)} governed $ids, {len(errors)} violation(s)")
    return 1 if errors else 0


def check_applicability(ontology, path, statement, archetype_ids, errors):
    """L9: applicability roots are exact ref() calls to catalogue Archetypes."""
    expression = statement.get("applicability")
    if expression is None:
        return
    if not isinstance(expression, str):
        errors.append(f"L9 {ontology}: {path}: applicability must be a string")
        return

    bare_roots = sorted(set(BARE_APPLICABILITY_ROOT.findall(expression)))
    if bare_roots:
        errors.append(
            f"L9 {ontology}: {path}: bare applicability root(s) {bare_roots}; "
            'use ref("<$id>")'
        )

    calls = REF_CALL.findall(expression)
    call_count = len(REF_CALL_START.findall(expression))
    if len(calls) != call_count:
        errors.append(f"L9 {ontology}: {path}: malformed ref() call")

    for _, target in calls:
        if not GSMARC_ID.fullmatch(target):
            errors.append(
                f"L9 {ontology}: {path}: ref() target {target!r} does not "
                "match the Archetype URI grammar"
            )
        elif target not in archetype_ids:
            errors.append(
                f"L9 {ontology}: {path}: ref() target {target!r} is not a "
                "governed L5-coherent catalogue Archetype $id"
            )


def check_composition(packages, errors):
    """L7: static satisfiability of allOf/$ref composition (in-repo refs only)."""
    schemas = {}
    origins = {}
    for name, info in packages.items():
        for element in info["data"].get("elements", []):
            if not element["path"].endswith(".archetype.json"):
                continue
            doc = json.loads((info["dir"] / element["path"]).read_text())
            schemas[doc["$id"]] = doc
            origins[doc["$id"]] = f"{name}: {element['path']}"

    def chain_properties(schema_id, seen):
        """Properties visible through the top-level $ref chain (in-repo only)."""
        props = {}
        while schema_id in schemas and schema_id not in seen:
            seen.add(schema_id)
            schema = schemas[schema_id]
            for prop, sub in schema.get("properties", {}).items():
                props.setdefault(prop, sub)
            schema_id = schema.get("$ref")
        return props

    for schema_id, schema in schemas.items():
        origin = origins[schema_id]
        facets = [e["$ref"] for e in schema.get("allOf", []) if isinstance(e, dict) and "$ref" in e]

        # horizontal: sibling facets must not share property names (mount rule)
        seen_props = {}
        for facet_id in facets:
            for prop in schemas.get(facet_id, {}).get("properties", {}):
                if prop in seen_props and seen_props[prop] != facet_id:
                    errors.append(
                        f"L7 {origin}: sibling allOf facets {seen_props[prop]} and "
                        f"{facet_id} both define {prop!r} -- flat-namespace "
                        f"conflation; use the facet mount rule"
                    )
                seen_props[prop] = facet_id

        # vertical: host must not type-change an inherited/composed property
        inherited = {}
        if "$ref" in schema:
            inherited.update(chain_properties(schema["$ref"], {schema_id}))
        for facet_id in facets:
            for prop, sub in schemas.get(facet_id, {}).get("properties", {}).items():
                inherited.setdefault(prop, sub)
        for prop, sub in schema.get("properties", {}).items():
            other = inherited.get(prop)
            if other is None:
                continue
            host_type, other_type = sub.get("type"), other.get("type")
            if host_type and other_type and host_type != other_type:
                errors.append(
                    f"L7 {origin}: property {prop!r} redefines an inherited "
                    f"property with a different type ({host_type!r} vs "
                    f"{other_type!r}) -- unsatisfiable intersection"
                )


if __name__ == "__main__":
    sys.exit(main())
