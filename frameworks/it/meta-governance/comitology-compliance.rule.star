# ────────────────────────────────────────────────────────────────
# AC · Comitology Compliance (5 rules)
# Mechanism: gsm:mechanisms/appraisal/comitology-compliance
# Ascription↔Comitology: lifecycle progression through governance process.
#
# Subject type : any (Ascription lifecycle applies to all 8 primitives)
# Input        : AppraisalTrigger (one ruleType per invocation)
# Output       : 1 AppraisalMeasure (always) + 0–1 AppraisalFinding
#
# These rules use subjectMetadata (Ascription-level lifecycle fields
# BFF provides outside the statement JSONB):
#   subjectMetadata.status
#   subjectMetadata.statusDurationDays   (BFF pre-computed)
#   subjectMetadata.createdAt
#   subjectMetadata.statusChangedAt
#
# relatedAscriptions content by ruleType:
#   ascription/draft/progression       — (not needed, uses subjectMetadata)
#   ascription/review/timeliness       — (not needed, uses subjectMetadata)
#   ascription/deprecation/succession  — other Ascriptions for same Definition:
#       [{definitionId, status, version}]
#   ascription/suspension/resolution   — (not needed, uses subjectMetadata)
#   ascription/activation/throughput   — all APPROVED Ascriptions tenant-wide:
#       [{definitionId, subjectType, statusDurationDays}]
# ────────────────────────────────────────────────────────────────

def emit_measure(value, unit, components):
    sys.effect("AppraisalMeasure", {
        "ruleType": rule,
        "subjectType": stype,
        "subjectDefinitionId": sid,
        "value": value,
        "unit": unit,
        "components": components,
    })

def emit_finding(finding_type, severity, message):
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
meta    = evt.get("subjectMetadata", {})

# ── ASCRIPTION_DRAFT_PROGRESSION ───────────────────────────────
if rule == "gsm:rules/appraisal/ascription/draft/progression":
    # How long has the Ascription remained in DRAFT?
    # Measure: elapsed days in DRAFT (lower = healthier)
    days = meta.get("statusDurationDays", 0)

    emit_measure(days, "days",
        {"statusDurationDays": days, "status": meta.get("status", "DRAFT")})

    if days > 30:
        emit_finding("DRIFT", "HIGH" if days > 90 else "MEDIUM",
            "Ascription has been in DRAFT for " + str(days) +
            " days — possible abandoned work or blocked workflow")

# ── ASCRIPTION_REVIEW_TIMELINESS ───────────────────────────────
elif rule == "gsm:rules/appraisal/ascription/review/timeliness":
    # How long awaiting review in PROPOSED status?
    # Measure: elapsed days in PROPOSED (lower = better)
    days = meta.get("statusDurationDays", 0)

    emit_measure(days, "days",
        {"statusDurationDays": days, "status": meta.get("status", "PROPOSED")})

    if days > 14:
        emit_finding("DRIFT", "HIGH" if days > 30 else "MEDIUM",
            "Ascription awaiting review for " + str(days) +
            " days — governance progression stalled")

# ── ASCRIPTION_DEPRECATION_SUCCESSION ──────────────────────────
elif rule == "gsm:rules/appraisal/ascription/deprecation/succession":
    # Does the deprecated Ascription have a non-terminal successor?
    # Related: other Ascriptions for the same Definition
    non_terminal = [a for a in related
        if a.get("status", "") not in ["RETIRED", "REJECTED", "DEPRECATED"]]
    has_successor = len(non_terminal) > 0

    emit_measure(100 if has_successor else 0, "percent",
        {"hasSuccessor": has_successor,
         "candidates": len(non_terminal), "total": len(related)})

    if not has_successor:
        emit_finding("GAP", "HIGH",
            "Deprecated Ascription has no successor in non-terminal state " +
            "— governance continuity gap for Definition " + sid)

# ── ASCRIPTION_SUSPENSION_RESOLUTION ───────────────────────────
elif rule == "gsm:rules/appraisal/ascription/suspension/resolution":
    # How long suspended?
    # Measure: elapsed days in suspended status (lower = healthier)
    days = meta.get("statusDurationDays", 0)

    emit_measure(days, "days",
        {"statusDurationDays": days, "status": meta.get("status", "SUSPENDED")})

    if days > 14:
        emit_finding("DRIFT", "HIGH" if days > 30 else "MEDIUM",
            "Ascription suspended for " + str(days) +
            " days — may require escalation")

# ── ASCRIPTION_ACTIVATION_THROUGHPUT ───────────────────────────
elif rule == "gsm:rules/appraisal/ascription/activation/throughput":
    # Backlog: how many approved Ascriptions await activation tenant-wide?
    # Measure: count of pending activations (lower = better throughput)
    count = len(related)
    stale = [a for a in related
        if a.get("statusDurationDays", 0) > 7]

    emit_measure(count, "count",
        {"pendingActivations": count, "stale": len(stale)})

    if count > 10:
        emit_finding("METRIC", "HIGH" if count > 50 else "MEDIUM",
            str(count) + " approved Ascriptions awaiting activation " +
            "(" + str(len(stale)) + " stale >7d) — deployment throughput " +
            "lagging governance demand")
