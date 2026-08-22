# ══════════════════════════════════════════════════════════════════
# NN · Norm Coherence — 5 rules
# Mechanism: gsm:mechanisms/appraisal/norm-coherence
# N↔N: mutual non-contradiction, specificity, operational readiness.
# ══════════════════════════════════════════════════════════════════
#
# AppraisalTrigger.relatedAscriptions content by ruleType (BFF pre-fetched):
#
#   NORM_ASSERTION_COMPATIBILITY (subjectType=NORM)
#     → Co-scoped Norms (same structure + overlapping qualifier lineage).
#       Each carries BFF-pre-analyzed compatibility flag.
#       [{definitionId, assertion, qualifier, compatible: bool, conflictReason: str|None}]
#
#   NORM_QUALIFIER_SPECIFICITY (subjectType=NORM)
#     → [{qualifierDepth: int, maxDepth: int, qualifierPath: [str]}]
#       BFF resolves the qualifier Archetype's position in the hierarchy.
#
#   STRUCTURE_GOVERNANCE_PROPORTIONALITY (subjectType=STRUCTURE)
#     → Norms bound to Structure + tenant baseline stats.
#       [{boundNormCount: int, tenantMedianNorms: int, tenantMaxNorms: int}]
#
#   NORM_ASCRIPTION_BINDING (subjectType=NORM)
#     → Ascriptions currently bound to this Norm.
#       [{definitionId, status}]
#
#   NORM_APPLICABILITY_TARGET_MATCH (subjectType=NORM)
#     → In-effect Ascriptions matching the Norm's applicability filter.
#       BFF pre-applies the CEL filter.
#       [{definitionId, subjectType, status}]

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

# ── NORM_ASSERTION_COMPATIBILITY ────────────────────────────────
if rule == "gsm:rules/appraisal/norm/assertion/compatibility":
    conflicts = [n for n in related if not n.get("compatible", True)]
    total = len(related)
    compatible = total - len(conflicts)
    pct = compatible * 100 // total if total > 0 else 100

    emit_measure(rule, stype, sid, pct, "percent",
        {"compatible": compatible, "conflicting": len(conflicts), "total": total},
        [{"definitionId": c["definitionId"],
          "reason": c.get("conflictReason", "")} for c in conflicts])

    for c in conflicts:
        emit_finding(rule, stype, sid, "CONFLICT", "HIGH",
            "Assertion conflicts with Norm " + c["definitionId"]
            + ": " + c.get("conflictReason", "incompatible assertions"))

# ── NORM_QUALIFIER_SPECIFICITY ──────────────────────────────────
elif rule == "gsm:rules/appraisal/norm/qualifier/specificity":
    info = related[0] if len(related) > 0 else {}
    depth = info.get("qualifierDepth", 0)
    max_depth = info.get("maxDepth", 1)
    path = info.get("qualifierPath", [])
    # Specificity = depth / maxDepth * 100 — deeper qualifier = more specific
    pct = depth * 100 // max_depth if max_depth > 0 else 0

    emit_measure(rule, stype, sid, pct, "percent",
        {"depth": depth, "maxDepth": max_depth},
        [{"level": i, "archetype": p} for i, p in enumerate(path)])

    if depth == 0:
        emit_finding(rule, stype, sid, "METRIC", "LOW",
            "Norm uses root-level qualifier — imprecise governance targeting")

# ── STRUCTURE_GOVERNANCE_PROPORTIONALITY ────────────────────────
elif rule == "gsm:rules/appraisal/structure/governance/proportionality":
    info = related[0] if len(related) > 0 else {}
    bound = info.get("boundNormCount", 0)
    median = info.get("tenantMedianNorms", 1)
    max_norms = info.get("tenantMaxNorms", 1)
    # Ratio vs median: 100 = at median, >100 = above, <100 = below
    ratio = bound * 100 // median if median > 0 else 0

    emit_measure(rule, stype, sid, ratio, "ratio",
        {"boundNorms": bound, "tenantMedian": median, "tenantMax": max_norms})

    if ratio > 300:
        emit_finding(rule, stype, sid, "METRIC", "MEDIUM",
            "Structure has " + str(bound) + " bound Norms (median: "
            + str(median) + ") — disproportionate governance concentration")

# ── NORM_ASCRIPTION_BINDING ─────────────────────────────────────
elif rule == "gsm:rules/appraisal/norm/ascription/binding":
    active = [a for a in related
        if a.get("status", "") in ["IN_EFFECT", "APPROVED", "PROPOSED"]]
    count = len(active)

    emit_measure(rule, stype, sid, count, "count",
        {"boundAscriptions": count, "total": len(related)},
        [{"definitionId": a["definitionId"], "status": a.get("status", "")} for a in related])

    if count == 0:
        emit_finding(rule, stype, sid, "GAP", "MEDIUM",
            "Norm has no bound Ascriptions — operational rule with no governed instances")

# ── NORM_APPLICABILITY_TARGET_MATCH ─────────────────────────────
elif rule == "gsm:rules/appraisal/norm/applicability/target-match":
    count = len(related)

    emit_measure(rule, stype, sid, count, "count",
        {"matchingAscriptions": count},
        [{"definitionId": a["definitionId"], "subjectType": a.get("subjectType", "")} for a in related])

    if count == 0:
        emit_finding(rule, stype, sid, "GAP", "MEDIUM",
            "No in-effect Ascriptions match this Norm's applicability filter"
            + " — rule has no applicable targets")
