# ────────────────────────────────────────────────────────────────
# AA · Source Fidelity (4 rules)
# Mechanism: gsm:mechanisms/appraisal/source-fidelity
# Ascription↔Artifact: sourced artifacts aligned with external authorities.
#
# Subject type : DIRECTIVE | NORM | ARCHETYPE (any sourced definition)
# Input        : AppraisalTrigger (one ruleType per invocation)
# Output       : 1 AppraisalMeasure (always) + 0–1 AppraisalFinding
#
# relatedAscriptions content by ruleType (BFF pre-fetched from sync pipeline):
#   sourced/content/alignment   — [{localHash, remoteHash, matchPercent: 0–100}]
#   sourced/sync/freshness      — [{lastSyncTimestamp, elapsedDays: int}]
#   sourced/mapping/integrity   — [{externalRef, exists: bool, externalSystem}]
#   sourced/sync/divergence     — [{localChanged: bool, remoteChanged: bool,
#       localVersion, remoteVersion}]
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

# ── SOURCED_CONTENT_ALIGNMENT ──────────────────────────────────
if rule == "gsm:rules/appraisal/sourced/content/alignment":
    # BFF computes content hash comparison with external authority.
    # Measure: match percentage (100 = identical, 0 = fully diverged)
    info = related[0] if len(related) > 0 else {}
    match_pct = info.get("matchPercent", 100)
    local_hash = info.get("localHash", "")
    remote_hash = info.get("remoteHash", "")

    emit_measure(match_pct, "percent",
        {"matchPercent": match_pct,
         "localHash": local_hash, "remoteHash": remote_hash})

    if match_pct < 100:
        emit_finding("DRIFT", "HIGH" if match_pct < 50 else "MEDIUM",
            "Sourced content diverged from authority (" +
            str(match_pct) + "% match)")

# ── SOURCED_SYNC_FRESHNESS ─────────────────────────────────────
elif rule == "gsm:rules/appraisal/sourced/sync/freshness":
    # BFF computes elapsed days since last successful sync.
    # Measure: elapsed days (lower = fresher)
    info = related[0] if len(related) > 0 else {}
    elapsed = info.get("elapsedDays", 0)

    emit_measure(elapsed, "days",
        {"elapsedDays": elapsed,
         "lastSync": info.get("lastSyncTimestamp", "")})

    # Thresholds: >30 days = MEDIUM, >90 days = HIGH
    if elapsed > 90:
        emit_finding("DRIFT", "HIGH",
            "Last sync was " + str(elapsed) +
            " days ago — sync pipeline may be broken or abandoned")
    elif elapsed > 30:
        emit_finding("DRIFT", "MEDIUM",
            "Last sync was " + str(elapsed) +
            " days ago — approaching staleness threshold")

# ── SOURCED_MAPPING_INTEGRITY ──────────────────────────────────
elif rule == "gsm:rules/appraisal/sourced/mapping/integrity":
    # BFF checks whether the external reference still resolves.
    # Measure: 100 if mapping intact, 0 if broken
    info = related[0] if len(related) > 0 else {}
    exists = info.get("exists", True)
    value = 100 if exists else 0

    emit_measure(value, "percent",
        {"mappingIntact": exists,
         "externalRef": info.get("externalRef", ""),
         "externalSystem": info.get("externalSystem", "")})

    if not exists:
        ref = info.get("externalRef", "(unknown)")
        emit_finding("DRIFT", "HIGH",
            "External reference '" + ref +
            "' no longer resolves — orphaned local artifact")

# ── SOURCED_SYNC_DIVERGENCE ────────────────────────────────────
elif rule == "gsm:rules/appraisal/sourced/sync/divergence":
    # BFF detects bilateral change: both local and remote modified since
    # last sync.  Bilateral divergence requires manual reconciliation.
    # Measure: 0 = no divergence, 1 = unilateral, 2 = bilateral
    info = related[0] if len(related) > 0 else {}
    local_changed = info.get("localChanged", False)
    remote_changed = info.get("remoteChanged", False)

    if local_changed and remote_changed:
        divergence = 2
    elif local_changed or remote_changed:
        divergence = 1
    else:
        divergence = 0

    emit_measure(divergence, "count",
        {"localChanged": local_changed, "remoteChanged": remote_changed,
         "divergenceLevel": divergence})

    if divergence == 2:
        emit_finding("CONFLICT", "HIGH",
            "Bilateral divergence detected — both local and remote " +
            "changed since last sync, requires manual reconciliation")
    elif divergence == 1 and remote_changed:
        emit_finding("DRIFT", "MEDIUM",
            "Remote authority updated since last sync — " +
            "local artifact pending refresh")
