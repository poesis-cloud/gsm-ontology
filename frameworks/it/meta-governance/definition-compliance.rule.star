# ────────────────────────────────────────────────────────────────
# NA · Definition Compliance (2 rules — 1 meta + 1 governance)
# Mechanism: gsm:mechanisms/appraisal/definition-compliance
# N↔Ascription: Norm assertion evaluation at definition-time.
#
# Input  : AppraisalTrigger (one ruleType per invocation)
# Output : 1 AppraisalMeasure (always) + 0–N AppraisalFinding
#
# This mechanism spans both dimensions:
#   META-GOVERNANCE:
#     compliance-evaluability — can the Norm assertions be evaluated at all?
#     (structural check: are the referenced properties present in the statement?)
#   GOVERNANCE (first-order):
#     norm-compliance — do the CEL assertions evaluate to true?
#     For governance rules, BFF pre-evaluates CEL assertions via the Norm
#     Evaluator service and passes results in relatedAscriptions.
#
# relatedAscriptions content by ruleType:
#   ascription/statement/compliance-evaluability:
#     Per-Norm evaluability analysis (BFF extracts properties from CEL
#     assertion expression and checks statement JSONB for presence):
#     [{normDefinitionId, assertion, requiredProperties: [str],
#       presentProperties: [str], missingProperties: [str]}]
#
#   ascription/statement/norm-compliance:
#     Pre-evaluated assertion results (BFF+Norm Evaluator):
#     [{normDefinitionId, assertion, satisfied: bool,
#       evaluatedAt: "ISO-8601", detail: "..."}]
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

# ── META: ASCRIPTION_STATEMENT_COMPLIANCE_EVALUABILITY ─────────
if rule == "gsm:rules/appraisal/ascription/statement/compliance-evaluability":
    # For each applicable Norm, BFF extracted required properties from CEL
    # assertion and checked which ones are present in the statement JSONB.
    # Measure: percentage of required properties that are present
    total_required = 0
    total_present = 0
    details = []

    for norm in related:
        required = norm.get("requiredProperties", [])
        present = norm.get("presentProperties", [])
        missing = norm.get("missingProperties", [])
        total_required = total_required + len(required)
        total_present = total_present + len(present)
        details.append({
            "normDefinitionId": norm.get("normDefinitionId", ""),
            "required": len(required),
            "present": len(present),
            "missing": missing,
        })

    pct = total_present * 100 // total_required if total_required > 0 else 100

    emit_measure(pct, "percent",
        {"totalRequired": total_required, "totalPresent": total_present,
         "totalMissing": total_required - total_present,
         "normsEvaluated": len(related)})

    # Emit per-Norm findings for incomplete evaluability
    for d in details:
        if len(d["missing"]) > 0:
            emit_finding("GAP", "MEDIUM",
                "Norm " + d["normDefinitionId"] + ": " +
                str(len(d["missing"])) + "/" + str(d["required"]) +
                " required properties missing from statement: " +
                ", ".join(d["missing"]))

# ── GOV: ASCRIPTION_STATEMENT_NORM_COMPLIANCE ──────────────────
elif rule == "gsm:rules/appraisal/ascription/statement/norm-compliance":
    # BFF + Norm Evaluator pre-evaluated each Norm's CEL assertion
    # against the statement JSONB.  Results arrive in relatedAscriptions.
    # Measure: ratio of satisfied assertions (governance compliance rate)
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
        })

    total = satisfied + violated
    pct = satisfied * 100 // total if total > 0 else 100

    emit_measure(pct, "percent",
        {"satisfied": satisfied, "violated": violated, "total": total})

    # Emit per-violation findings
    for d in details:
        if not d["satisfied"]:
            emit_finding("VIOLATION", "HIGH",
                "Norm " + d["normDefinitionId"] +
                " assertion failed: " + d["assertion"])
