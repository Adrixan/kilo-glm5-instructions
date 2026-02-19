# Analysis Template

> **CRITICAL**: Copy this structure exactly. Fill placeholders only. Do not regenerate template content.

---

## Analysis Summary

| Field | Value |
|-------|-------|
| **Subject** | [SUBJECT_NAME] |
| **Type** | [ANALYSIS_TYPE: Code Review | Performance | Security | Architecture | Root Cause] |
| **Date** | [DATE] |
| **Analyst** | [ANALYST_NAME] |
| **Status** | [STATUS: Draft | Complete | Needs Review] |

---

## Executive Summary

**Verdict**: [ONE_SENTENCE_VERDICT]

**Key Finding**: [PRIMARY_FINDING_IN_ONE_SENTENCE]

**Recommendation**: [PRIMARY_RECOMMENDATION_IN_ONE_SENTENCE]

---

## Scope & Context

### What Was Analyzed

- [ITEM_1]
- [ITEM_2]
- [ITEM_3]

### Methodology

[BRIEF_DESCRIPTION_OF_ANALYSIS_METHOD]

### Constraints & Assumptions

- **Assumption**: [ASSUMPTION_1]
- **Constraint**: [CONSTRAINT_1]
- **Out of Scope**: [EXCLUDED_ITEMS]

---

## Detailed Findings

### Finding 1: [FINDING_TITLE]

| Attribute | Value |
|-----------|-------|
| **Severity** | [Critical | High | Medium | Low | Info] |
| **Category** | [CATEGORY] |
| **Location** | [FILE:LINE or COMPONENT] |

**Description**: [DETAILED_DESCRIPTION]

**Evidence**:

```
[EVIDENCE_CODE_OR_DATA]
```

**Impact**: [IMPACT_DESCRIPTION]

**Recommendation**: [SPECIFIC_RECOMMENDATION]

---

### Finding 2: [FINDING_TITLE]

[REPEAT_STRUCTURE_ABOVE]

---

## Metrics & Data

| Metric | Value | Benchmark | Status |
|--------|-------|-----------|--------|
| [METRIC_1] | [VALUE] | [BENCHMARK] | [Pass/Fail/Warning] |
| [METRIC_2] | [VALUE] | [BENCHMARK] | [Pass/Fail/Warning] |

---

## Risk Assessment

| Risk | Likelihood | Impact | Priority |
|------|------------|--------|----------|
| [RISK_1] | [H/M/L] | [H/M/L] | [P1/P2/P3] |

---

## Recommendations Summary

### Immediate Actions (P1)

1. [ACTION_1] - [OWNER] - [DEADLINE]
2. [ACTION_2] - [OWNER] - [DEADLINE]

### Short-term Actions (P2)

1. [ACTION_1] - [OWNER] - [DEADLINE]

### Long-term Actions (P3)

1. [ACTION_1] - [OWNER] - [DEADLINE]

---

## Appendix

### Raw Data Location

Full analysis data stored at: `[FILE_PATH]`

### References

- [REFERENCE_1]
- [REFERENCE_2]

---

## Checklist (Complete Before Finalizing)

- [ ] All placeholders filled: `[PLACEHOLDER]` → actual values
- [ ] Executive summary is one paragraph max
- [ ] Each finding has severity, description, and recommendation
- [ ] Metrics table includes benchmarks for comparison
- [ ] Recommendations are actionable with owners and deadlines
- [ ] Raw data saved to file (not inline)

---

> **REMINDER**: This template follows U-shaped attention pattern. Critical sections are at TOP (summary, verdict) and BOTTOM (recommendations, checklist). Evidence and details go in MIDDLE.
