# DIRECTIVE_NORM_OPERATIONALIZATION — Governance Coverage appraisal rule
#
# Subject: Directive ascription
# Check:   Directive must be operationalized by at least one Norm
# Finding: GAP if no Norms found for the governed Structure
#
# Trigger payload (AppraisalTrigger):
#   ruleType            — "DIRECTIVE_NORM_OPERATIONALIZATION"
#   subjectType         — "DIRECTIVE"
#   subjectDefinitionId — UUID of the Directive definition
#   subject             — Directive statement {structure, modal, verb, qualifier, purpose}
#   relatedAscriptions  — List of Norm ascriptions where Norm.structure matches the
#                          governed Structure (resolved from Directive.purpose)

evt = sys.receive("AppraisalTrigger")
directive = evt["subject"]
norms = evt["relatedAscriptions"]

if len(norms) == 0:
    modal = directive["modal"]
    verb = directive["verb"]
    purpose = directive["purpose"]
    sys.effect("AppraisalFinding", {
        "ruleType": evt["ruleType"],
        "findingType": "GAP",
        "subjectType": evt["subjectType"],
        "subjectDefinitionId": evt["subjectDefinitionId"],
        "severity": "HIGH",
        "message": modal + " " + verb + " on '" + purpose + "' has no operationalizing Norms — governance intent is not translated into operational rules",
    })
