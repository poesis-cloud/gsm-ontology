# ══════════════════════════════════════════════════════════════════
# DD · Directive Coherence — 5 rules
# Mechanism: gsm:mechanisms/appraisal/directive-coherence
# D↔D: mutual non-contradiction and self-soundness of Directives.
# ══════════════════════════════════════════════════════════════════
#
# AppraisalTrigger.relatedAscriptions content by ruleType (BFF pre-fetched):
#
#   VERB_COMPATIBILITY
#     → co-scoped Directives (same qualifier + purpose)
#       [{definitionId, verb, modal, purpose, qualifier, framework}]
#
#   MODAL_COMPATIBILITY
#     → co-scoped Directives (same qualifier + purpose + verb)
#       [{definitionId, verb, modal, purpose, qualifier, framework}]
#
#   FRAMEWORK_SCOPE_EXCLUSIVITY
#     → Directives from OTHER frameworks with overlapping qualifier + purpose
#       [{definitionId, verb, modal, purpose, qualifier, framework}]
#
#   PURPOSE_TARGETING
#     → Ascriptions governed by the Directive's purpose Structure
#       [{definitionId, subjectType, status}]
#
#   OPERATIONAL_ALIGNMENT
#     → Mechanisms and Interactions on/around the Directive's purpose Structure
#       [{definitionId, subjectType, status}]

# ── Verb contradiction map ──────────────────────────────────────
CONTRADICTING_VERBS = {
    "ENSURE":   "PREVENT",
    "PREVENT":  "ENSURE",
    "MAXIMIZE": "MINIMIZE",
    "MINIMIZE": "MAXIMIZE",
}

# ── Modal contradiction map ─────────────────────────────────────
CONTRADICTING_MODALS = {
    "MUST":       "MUST_NOT",
    "MUST_NOT":   "MUST",
    "SHOULD":     "SHOULD_NOT",
    "SHOULD_NOT": "SHOULD",
}

# ── Helper: emit AppraisalMeasure ───────────────────────────────
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

# ── Helper: emit AppraisalFinding ───────────────────────────────
def emit_finding(rule, stype, sid, finding_type, severity, message):
    sys.effect("AppraisalFinding", {
        "ruleType": rule,
        "findingType": finding_type,
        "subjectType": stype,
        "subjectDefinitionId": sid,
        "severity": severity,
        "message": message,
    })

# ── Receive trigger ─────────────────────────────────────────────
evt = sys.receive("AppraisalTrigger")

rule    = evt["ruleType"]
stype   = evt["subjectType"]
sid     = evt["subjectDefinitionId"]
subject = evt["subject"]
related = evt["relatedAscriptions"]

# ── DIRECTIVE_VERB_COMPATIBILITY ────────────────────────────────
if rule == "gsm:rules/appraisal/directive/verb/compatibility":
    verb = subject["verb"]
    contradict = CONTRADICTING_VERBS.get(verb, "")
    conflicts = [d for d in related if d["verb"] == contradict]
    total = len(related)
    compatible = total - len(conflicts)
    pct = compatible * 100 // total if total > 0 else 100

    emit_measure(rule, stype, sid, pct, "percent",
        {"compatible": compatible, "conflicting": len(conflicts), "total": total},
        [{"definitionId": c["definitionId"], "verb": c["verb"]} for c in conflicts])

    for c in conflicts:
        emit_finding(rule, stype, sid, "CONFLICT", "HIGH",
            verb + " conflicts with " + c["verb"]
            + " (Directive " + c["definitionId"] + ")")

# ── DIRECTIVE_MODAL_COMPATIBILITY ───────────────────────────────
elif rule == "gsm:rules/appraisal/directive/modal/compatibility":
    modal = subject["modal"]
    contradict = CONTRADICTING_MODALS.get(modal, "")
    conflicts = [d for d in related if d["modal"] == contradict]
    total = len(related)
    compatible = total - len(conflicts)
    pct = compatible * 100 // total if total > 0 else 100

    emit_measure(rule, stype, sid, pct, "percent",
        {"compatible": compatible, "conflicting": len(conflicts), "total": total},
        [{"definitionId": c["definitionId"], "modal": c["modal"]} for c in conflicts])

    for c in conflicts:
        emit_finding(rule, stype, sid, "CONFLICT", "HIGH",
            modal + " conflicts with " + c["modal"]
            + " (Directive " + c["definitionId"] + ")")

# ── DIRECTIVE_FRAMEWORK_SCOPE_EXCLUSIVITY ───────────────────────
elif rule == "gsm:rules/appraisal/directive/framework-scope/exclusivity":
    overlaps = [d for d in related
        if d["qualifier"] == subject.get("qualifier", "")
        and d["purpose"] == subject.get("purpose", "")]
    total = len(related)
    exclusive = total - len(overlaps)
    pct = exclusive * 100 // total if total > 0 else 100

    emit_measure(rule, stype, sid, pct, "percent",
        {"exclusive": exclusive, "overlapping": len(overlaps), "total": total},
        [{"definitionId": o["definitionId"], "framework": o.get("framework", "")} for o in overlaps])

    if len(overlaps) > 0:
        frameworks = ", ".join([o.get("framework", "?") for o in overlaps])
        emit_finding(rule, stype, sid, "CONFLICT", "MEDIUM",
            "Scope overlap with " + str(len(overlaps))
            + " Directive(s) from framework(s): " + frameworks)

# ── DIRECTIVE_PURPOSE_TARGETING ─────────────────────────────────
elif rule == "gsm:rules/appraisal/directive/purpose/targeting":
    count = len(related)

    emit_measure(rule, stype, sid, count, "count",
        {"governedAscriptions": count},
        [{"definitionId": a["definitionId"], "subjectType": a.get("subjectType", "")} for a in related])

    if count == 0:
        purpose = subject.get("purpose", "(unknown)")
        emit_finding(rule, stype, sid, "GAP", "MEDIUM",
            "Purpose Structure '" + purpose
            + "' has no governed Ascriptions — governance intent with no target")

# ── DIRECTIVE_PURPOSE_OPERATIONAL_ALIGNMENT ─────────────────────
elif rule == "gsm:rules/appraisal/directive/purpose/operational-alignment":
    mechanisms = [a for a in related if a.get("subjectType", "") == "MECHANISM"]
    interactions = [a for a in related if a.get("subjectType", "") == "INTERACTION"]
    count = len(mechanisms) + len(interactions)

    emit_measure(rule, stype, sid, count, "count",
        {"mechanisms": len(mechanisms), "interactions": len(interactions), "total": count})

    if count == 0:
        purpose = subject.get("purpose", "(unknown)")
        emit_finding(rule, stype, sid, "GAP", "LOW",
            "Purpose Structure '" + purpose
            + "' has no active Mechanisms or Interactions"
            + " — governance scope misaligned with operational reality")
