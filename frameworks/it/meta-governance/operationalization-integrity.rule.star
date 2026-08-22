# ══════════════════════════════════════════════════════════════════
# DN · Operationalization Integrity — 5 rules
# Mechanism: gsm:mechanisms/appraisal/operationalization-integrity
# D↔N: completeness of the D→N→S governance chain.
# ══════════════════════════════════════════════════════════════════
#
# Note: this mechanism supersedes the single-rule
# directive-norm-operationalization.rule.star (kept for history).
#
# AppraisalTrigger.relatedAscriptions content by ruleType (BFF pre-fetched):
#
#   DIRECTIVE_NORM_OPERATIONALIZATION (subjectType=DIRECTIVE)
#     → Norms where Norm.structure matches Directive.purpose
#       [{definitionId, structure, qualifier, assertion}]
#
#   DIRECTIVE_QUALIFIER_COVERAGE (subjectType=DIRECTIVE)
#     → {qualifierProperties: [str], coveredProperties: [str],
#        uncoveredProperties: [str], norms: [{definitionId, assertion}]}
#       BFF pre-computes property lists from qualifier Archetype schema
#       and scans Norm assertion expressions for property references.
#
#   NORM_DIRECTIVE_BACKING (subjectType=NORM)
#     → Directives where Directive.purpose = Norm.structure
#       [{definitionId, verb, modal, purpose, qualifier}]
#
#   STRUCTURE_GOVERNANCE_COVERAGE (subjectType=STRUCTURE)
#     → Directives and Norms targeting this Structure
#       [{definitionId, subjectType}]
#
#   ARCHETYPE_QUALIFIER_UTILIZATION (subjectType=ARCHETYPE)
#     → Directives and Norms referencing this Archetype as qualifier
#       [{definitionId, subjectType}]

def emit_measure(rule, stype, sid, value, unit, components, details = []):
    sys.effect("AppraisalMeasure", {
        "ruleType": rule,
        "subjectType": stype,
        "subjectDefinitionId": sid,
        "value": value,
        "unit": unit,
        "components": components,
        "details": details,
    })

def emit_finding(rule, stype, sid, finding_type, severity, message):
    sys.effect("AppraisalFinding", {
        "ruleType": rule,
        "findingType": finding_type,
        "subjectType": stype,
        "subjectDefinitionId": sid,
        "severity": severity,
        "message": message,
    })

evt = sys.receive("AppraisalTrigger")

rule    = evt["ruleType"]
stype   = evt["subjectType"]
sid     = evt["subjectDefinitionId"]
subject = evt["subject"]
related = evt["relatedAscriptions"]

# ── DIRECTIVE_NORM_OPERATIONALIZATION ───────────────────────────
if rule == "gsm:rules/appraisal/directive/norm/operationalization":
    count = len(related)

    emit_measure(rule, stype, sid, count, "count",
        {"norms": count},
        [{"definitionId": n["definitionId"]} for n in related])

    if count == 0:
        modal = subject["modal"]
        verb = subject["verb"]
        purpose = subject.get("purpose", "(unknown)")
        emit_finding(rule, stype, sid, "GAP", "HIGH",
            modal + " " + verb + " on '" + purpose
            + "' has no operationalizing Norms"
            + " — governance intent not translated into operational rules")

# ── DIRECTIVE_QUALIFIER_COVERAGE ────────────────────────────────
elif rule == "gsm:rules/appraisal/directive/qualifier/coverage":
    # BFF pre-computed property analysis in relatedAscriptions[0]
    analysis = related[0] if len(related) > 0 else {}
    total_props = len(analysis.get("qualifierProperties", []))
    covered_props = len(analysis.get("coveredProperties", []))
    uncovered = analysis.get("uncoveredProperties", [])
    pct = covered_props * 100 // total_props if total_props > 0 else 100

    emit_measure(rule, stype, sid, pct, "percent",
        {"covered": covered_props, "uncovered": len(uncovered), "total": total_props},
        [{"property": p, "covered": p not in uncovered}
         for p in analysis.get("qualifierProperties", [])])

    if len(uncovered) > 0:
        emit_finding(rule, stype, sid, "GAP", "MEDIUM",
            str(len(uncovered)) + "/" + str(total_props)
            + " qualifier properties uncovered by Norm assertions: "
            + ", ".join(uncovered))

# ── NORM_DIRECTIVE_BACKING ──────────────────────────────────────
elif rule == "gsm:rules/appraisal/norm/directive/backing":
    backing = [d for d in related
        if d.get("purpose", "") == subject.get("structure", "")]
    count = len(backing)

    emit_measure(rule, stype, sid, count, "count",
        {"backingDirectives": count},
        [{"definitionId": d["definitionId"], "verb": d.get("verb", "")} for d in backing])

    if count == 0:
        structure = subject.get("structure", "(unknown)")
        emit_finding(rule, stype, sid, "GAP", "HIGH",
            "Norm on '" + structure
            + "' has no backing Directive — operational rule without governance authority")

# ── STRUCTURE_GOVERNANCE_COVERAGE ───────────────────────────────
elif rule == "gsm:rules/appraisal/structure/governance/coverage":
    directives = [a for a in related if a.get("subjectType", "") == "DIRECTIVE"]
    norms = [a for a in related if a.get("subjectType", "") == "NORM"]
    count = len(directives) + len(norms)

    emit_measure(rule, stype, sid, count, "count",
        {"directives": len(directives), "norms": len(norms), "total": count})

    if count == 0:
        emit_finding(rule, stype, sid, "GAP", "MEDIUM",
            "Structure has no governing Directives or Norms"
            + " — entity operates outside governance fabric")

# ── ARCHETYPE_QUALIFIER_UTILIZATION ─────────────────────────────
elif rule == "gsm:rules/appraisal/archetype/qualifier/utilization":
    directives = [a for a in related if a.get("subjectType", "") == "DIRECTIVE"]
    norms = [a for a in related if a.get("subjectType", "") == "NORM"]
    count = len(directives) + len(norms)

    emit_measure(rule, stype, sid, count, "count",
        {"directives": len(directives), "norms": len(norms), "total": count})

    if count == 0:
        emit_finding(rule, stype, sid, "METRIC", "LOW",
            "Archetype is not used as qualifier by any Directive or Norm"
            + " — schema has no governance role")
