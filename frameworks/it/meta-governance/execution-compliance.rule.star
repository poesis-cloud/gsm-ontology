# ────────────────────────────────────────────────────────────────
# NX · Execution Compliance (3 rules — 2 meta + 1 governance)
# Mechanism: gsm:mechanisms/appraisal/execution-compliance
# N↔Execution: observation infrastructure and runtime norm evaluation.
#
# Input  : AppraisalTrigger (one ruleType per invocation)
# Output : 1 AppraisalMeasure (always) + 0–N AppraisalFinding
#
# This mechanism spans both dimensions:
#   META-GOVERNANCE (2 rules):
#     observation/coverage   — are observation sources configured?
#     execution/trend-stability — is compliance trending up/down?
#   GOVERNANCE (1 rule):
#     execution/norm-compliance — do CEL assertions pass against
#       runtime observation data?
#     For governance rules, BFF pre-evaluates CEL assertions via
#     Norm Evaluator against execution observation payloads.
#
# relatedAscriptions content by ruleType:
#   norm/observation/coverage:
#     Observation sources (Receptors, telemetry) for governed Structure:
#     [{receptorId, type: "RECEPTOR"|"TELEMETRY", active: bool}]
#
#   ascription/execution/trend-stability:
#     Historical compliance data points (BFF pre-fetched from measure store):
#     [{timestamp: "ISO-8601", compliancePercent: int}]
#     Ordered chronologically, newest last.
#
#   ascription/execution/norm-compliance:
#     Pre-evaluated execution assertion results (BFF+Norm Evaluator):
#     [{normDefinitionId, assertion, satisfied: bool,
#       observedAt: "ISO-8601", observedValue: "..."}]
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

# ── META: NORM_OBSERVATION_COVERAGE ────────────────────────────
if rule == "gsm:rules/appraisal/norm/observation/coverage":
    # How many observation sources feed data for this Norm's governed
    # Structure?  More sources = better observation infrastructure.
    # Measure: count of active observation sources
    active = [r for r in related if r.get("active", False)]
    total = len(related)
    active_count = len(active)

    emit_measure(active_count, "count",
        {"activeSources": active_count, "totalSources": total,
         "byType": {
             "receptor": len([r for r in active if r.get("type", "") == "RECEPTOR"]),
             "telemetry": len([r for r in active if r.get("type", "") == "TELEMETRY"]),
         }})

    if active_count == 0:
        emit_finding("GAP", "HIGH",
            "No active observation sources for governed Structure " +
            "— execution compliance cannot be assessed")
    elif active_count < 2:
        emit_finding("METRIC", "LOW",
            "Only " + str(active_count) +
            " observation source — consider redundant coverage")

# ── META: ASCRIPTION_EXECUTION_TREND_STABILITY ─────────────────
elif rule == "gsm:rules/appraisal/ascription/execution/trend-stability":
    # Analyze trend of compliance metrics over the observation window.
    # Input: chronologically ordered data points [{timestamp, compliancePercent}].
    # Measure: trend direction as a score:
    #   100 = stable/improving, 50 = volatile, 0 = degrading
    points = related
    n = len(points)

    if n < 2:
        # Insufficient data for trend analysis
        emit_measure(100, "percent",
            {"dataPoints": n, "trend": "INSUFFICIENT_DATA",
             "direction": 0, "volatility": 0})
    else:
        # Simple trend: compare first-half average to second-half average
        mid = n // 2
        first_half = points[:mid]
        second_half = points[mid:]

        first_avg = sum([p.get("compliancePercent", 0) for p in first_half]) // len(first_half)
        second_avg = sum([p.get("compliancePercent", 0) for p in second_half]) // len(second_half)
        direction = second_avg - first_avg  # positive = improving

        # Volatility: average absolute delta between consecutive points
        deltas = []
        for i in range(1, n):
            d = points[i].get("compliancePercent", 0) - points[i-1].get("compliancePercent", 0)
            deltas.append(d if d >= 0 else -d)
        volatility = sum(deltas) // len(deltas) if len(deltas) > 0 else 0

        # Score: 100 if improving and stable, 0 if degrading and volatile
        if direction >= 0 and volatility < 10:
            score = 100
            trend = "STABLE"
        elif direction >= 0:
            score = 75
            trend = "IMPROVING_VOLATILE"
        elif direction > -10:
            score = 50
            trend = "SLIGHT_DEGRADATION"
        else:
            score = 25 if volatility < 10 else 0
            trend = "DEGRADING"

        emit_measure(score, "percent",
            {"dataPoints": n, "trend": trend,
             "direction": direction, "volatility": volatility,
             "firstHalfAvg": first_avg, "secondHalfAvg": second_avg})

        if score < 50:
            emit_finding("DRIFT", "HIGH" if score == 0 else "MEDIUM",
                "Compliance trend degrading (direction=" +
                str(direction) + "%, volatility=" + str(volatility) +
                "%) — sustained degradation may require attention")

# ── GOV: ASCRIPTION_EXECUTION_NORM_COMPLIANCE ──────────────────
elif rule == "gsm:rules/appraisal/ascription/execution/norm-compliance":
    # BFF + Norm Evaluator pre-evaluated Norm CEL assertions against
    # execution observation data.  Same aggregation pattern as NA-gov.
    # Measure: ratio of satisfied execution assertions
    satisfied = 0
    violated = 0
    details = []

    for norm in related:
        s = norm.get("satisfied", False)
        if s:
            satisfied = satisfied + 1
        else:
            violated = violated + 1
        details.append({
            "normDefinitionId": norm.get("normDefinitionId", ""),
            "assertion": norm.get("assertion", ""),
            "satisfied": s,
            "observedAt": norm.get("observedAt", ""),
        })

    total = satisfied + violated
    pct = satisfied * 100 // total if total > 0 else 100

    emit_measure(pct, "percent",
        {"satisfied": satisfied, "violated": violated, "total": total})

    for d in details:
        if not d["satisfied"]:
            emit_finding("VIOLATION", "HIGH",
                "Norm " + d["normDefinitionId"] +
                " execution assertion failed: " + d["assertion"] +
                " (observed at " + d["observedAt"] + ")")
