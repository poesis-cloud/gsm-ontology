#!/usr/bin/env python3
"""Layering lint for gsm-frameworks.

Enforces the layered framework model as a machine-checkable invariant:

    gsm (upper) <- reference <- domain <- organization

Rules
  L1  Every descriptor declares a valid ``layer``.
  L2  A statement may reference (``$ref``/``$id`` targets under
      ``gsmarc://gsm-frameworks/``) only: the gsm authority, its own framework,
      or a framework of strictly lower rank.
      Reference frameworks therefore never reference another framework at all
      -- they are isolated, referencing only GSM and themselves.
  L3  ``composes`` (domain) / ``selects`` (organization) entries target only
      frameworks of strictly lower rank that exist in the catalogue.
  L4  Every element file parses as JSON and carries no catalogue metadata
      (``framework``/``source``/``operationalizes``/``deploymentNotes`` live in
      the descriptor, never in the statement).
  L5  Every governed element filename is prepended with its framework's name in
      PascalCase (``gdpr`` -> ``Gdpr``); for Archetype statements the ``title``
      and final ``$id`` segment match the filename stem.
  L6  A domain framework's ontology (descriptor ``ontology`` key) stays coherent:
      every registry ``$id`` resolves to a governed element ``$id``, and every
      concept referenced by dimensions, axes, or correspondences is in the
      registry.
  L7  No archetype statement declares top-level closure
      (``additionalProperties: false`` / ``unevaluatedProperties: false``):
      statement closure is applied by the DM on the resolved typing archetype
      at ascription time, and author-side closure breaks facet composition.
  L8  Composition satisfiability: sibling ``allOf`` facets must not define the
      same property name (flat-namespace conflation -- use the facet mount
      rule), and a host property must not redefine an inherited property
      (top-level ``$ref`` chain or composed facet) with a different ``type``
      (silently unsatisfiable intersection).

Exit code 0 = pass, 1 = violations (printed to stderr).
"""

import json
import re
import sys
from pathlib import Path

RANKS = {"reference": 1, "domain": 2, "organization": 3}
METADATA_KEYS = ("framework", "source", "operationalizes", "deploymentNotes")
GSMARC = re.compile(r'"gsmarc://gsm-frameworks/([^"]+)"')

ROOT = Path(__file__).resolve().parent.parent


def pascal_prefix(name):
    return "".join(part.capitalize() for part in re.split(r"[-_]", name))


def load_descriptors():
    descriptors = {}
    for path in sorted(ROOT.glob("frameworks/*/framework.json")):
        data = json.loads(path.read_text())
        descriptors[data["name"]] = {"dir": path.parent, "data": data}
    return descriptors


def build_id_owner_map(descriptors):
    """Map every gsm-frameworks $id path segment -> owning framework name."""
    owners = {}
    for name, info in descriptors.items():
        for element in info["data"].get("elements", []):
            file = info["dir"] / element["path"]
            schema_id = json.loads(file.read_text()).get("$id", "")
            prefix = "gsmarc://gsm-frameworks/"
            if schema_id.startswith(prefix):
                owners[schema_id[len(prefix):]] = name
    return owners


def main():
    errors = []
    descriptors = load_descriptors()
    owners = build_id_owner_map(descriptors)

    def resolve_owner(target_path):
        # Archetype $ids are exact; non-Archetype statements are addressed by
        # framework-prefixed path, so fall back to the first path segment.
        owner = owners.get(target_path)
        if owner is None:
            segment = target_path.split("/", 1)[0]
            if segment in descriptors:
                owner = segment
        return owner

    for name, info in descriptors.items():
        layer = info["data"].get("layer")
        if layer not in RANKS:
            errors.append(f"L1 {name}: missing or invalid layer {layer!r}")
            continue
        rank = RANKS[layer]

        for field in ("composes", "selects"):
            for dep in info["data"].get(field, []):
                target = descriptors.get(dep["name"])
                if target is None:
                    errors.append(f"L3 {name}: {field} unknown framework {dep['name']!r}")
                elif RANKS[target["data"]["layer"]] >= rank:
                    errors.append(
                        f"L3 {name} ({layer}): {field} {dep['name']} "
                        f"({target['data']['layer']}) violates rank order"
                    )

        for element in info["data"].get("elements", []):
            file = info["dir"] / element["path"]
            filename = file.name
            prefix = pascal_prefix(name)
            if not filename.startswith(prefix):
                errors.append(
                    f"L5 {name}: {element['path']}: filename must be prepended "
                    f"with the framework name ({prefix!r})"
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
                if not re.fullmatch(
                    rf"\S+/{re.escape(stem)}/v[1-9][0-9]*", statement.get("$id", "")
                ):
                    errors.append(
                        f"L5 {name}: {element['path']}: $id "
                        f"{statement.get('$id')!r} must end in '/{stem}/v{{n}}'"
                    )
                for keyword in ("additionalProperties", "unevaluatedProperties"):
                    if statement.get(keyword) is False:
                        errors.append(
                            f"L7 {name}: {element['path']}: top-level "
                            f"{keyword}: false forbidden -- the DM applies "
                            f"statement closure at ascription time"
                        )
            for key in METADATA_KEYS:
                if key in statement:
                    errors.append(
                        f"L4 {name}: {element['path']}: catalogue metadata "
                        f"{key!r} belongs in the descriptor, not the statement"
                    )
            for target_path in GSMARC.findall(file.read_text()):
                owner = resolve_owner(target_path)
                if owner is None:
                    errors.append(f"L2 {name}: {element['path']}: unresolved gsmarc target {target_path!r}")
                elif owner != name:
                    owner_rank = RANKS[descriptors[owner]["data"]["layer"]]
                    if owner_rank >= rank:
                        errors.append(
                            f"L2 {name} ({layer}): {element['path']} references "
                            f"{target_path} owned by {owner} "
                            f"({descriptors[owner]['data']['layer']}) -- rank order violated"
                        )

    governed_ids = {"gsmarc://gsm-frameworks/" + path for path in owners}
    for name, info in descriptors.items():
        if "ontology" in info["data"]:
            check_ontology(name, info, governed_ids, errors)

    check_composition(descriptors, errors)

    for error in errors:
        print(error, file=sys.stderr)
    print(f"lint-layers: {len(descriptors)} descriptors, {len(owners)} governed $ids, {len(errors)} violation(s)")
    return 1 if errors else 0


def check_composition(descriptors, errors):
    """L8: static satisfiability of allOf/$ref composition (in-repo refs only)."""
    schemas = {}
    origins = {}
    for name, info in descriptors.items():
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
                        f"L8 {origin}: sibling allOf facets {seen_props[prop]} and "
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
                    f"L8 {origin}: property {prop!r} redefines an inherited "
                    f"property with a different type ({host_type!r} vs "
                    f"{other_type!r}) -- unsatisfiable intersection"
                )


def check_ontology(name, info, governed_ids, errors):
    path = info["dir"] / info["data"]["ontology"]
    try:
        ontology = json.loads(path.read_text())
    except (OSError, json.JSONDecodeError) as exc:
        errors.append(f"L6 {name}: {path.name}: {exc}")
        return
    registry = ontology.get("coverage", {}).get("registry", {})
    for title, schema_id in registry.items():
        if schema_id not in governed_ids:
            errors.append(f"L6 {name}: ontology registry {title!r} -> unresolved $id {schema_id}")
    referenced = set()
    for dim in ontology.get("dimensions", []):
        for stratum in dim.get("strata", []):
            referenced.update(stratum.get("concepts", []))
    for axis in ontology.get("axes", []):
        referenced.update(axis.get("from", []))
        referenced.update(axis.get("to", []))
    for corr in ontology.get("correspondences", []):
        referenced.update((corr["concept"], corr["correspondsTo"]))
    for concept in sorted(referenced - set(registry)):
        errors.append(f"L6 {name}: ontology references {concept!r} absent from the registry")


if __name__ == "__main__":
    sys.exit(main())
