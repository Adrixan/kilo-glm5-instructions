# Subagent Task Template

> **CRITICAL**: Copy this structure exactly. Fill placeholders only. Do not regenerate template content.

---

## Task Header

| Field | Value |
|-------|-------|
| **Task ID** | `[TASK_ID]` |
| **Task Type** | `[TYPE: Analysis | Code | Test | Review | Research]` |
| **Priority** | `[PRIORITY: P1 | P2 | P3]` |
| **Created** | `[DATE]` |
| **Delegator** | `[DELEGATOR_NAME]` |
| **Assignee** | `[SUBAGENT_ID_OR_ROLE]` |
| **Deadline** | `[DEADLINE]` |

---

## Task Summary

**Objective**: [ONE_SENTENCE_OBJECTIVE]

**Expected Output**: [OUTPUT_FORMAT: File | Report | Code | Decision]

**Success Criteria**: [MEASURABLE_SUCCESS_CRITERIA]

---

## Context & Background

### Why This Task

[BRIEF_EXPLANATION_OF_TASK_ORIGIN_AND_IMPORTANCE]

### Related Work

| Reference | Type | Location |
|-----------|------|----------|
| [REFERENCE_1] | [TYPE] | [PATH_OR_URL] |
| [REFERENCE_2] | [TYPE] | [PATH_OR_URL] |

### Constraints

- **Time Budget**: [MAX_TIME_OR_TOKENS]
- **Scope Limit**: [WHAT_IS_OUT_OF_SCOPE]
- **Dependencies**: [BLOCKERS_OR_PREREQUISITES]

---

## Detailed Instructions

### Input Data

```
[INPUT_DATA_OR_REFERENCE_TO_INPUT_LOCATION]
```

### Processing Steps

1. **Step 1**: [FIRST_STEP_DESCRIPTION]
   - Input: [STEP_1_INPUT]
   - Expected Output: [STEP_1_OUTPUT]

2. **Step 2**: [SECOND_STEP_DESCRIPTION]
   - Input: [STEP_2_INPUT]
   - Expected Output: [STEP_2_OUTPUT]

3. **Step 3**: [THIRD_STEP_DESCRIPTION]
   - Input: [STEP_3_INPUT]
   - Expected Output: [STEP_3_OUTPUT]

### Decision Points

| Decision | Condition | Action |
|----------|-----------|--------|
| [DECISION_1] | [IF_CONDITION] | [THEN_ACTION] |
| [DECISION_2] | [IF_CONDITION] | [THEN_ACTION] |

---

## Output Requirements

### Deliverable Format

```[FORMAT]
[TEMPLATE_OR_STRUCTURE_FOR_OUTPUT]
```

### Output Location

- **Primary Output**: `[OUTPUT_FILE_PATH]`
- **Supporting Files**: `[ADDITIONAL_FILES_PATH]`

### Quality Gates

- [ ] Output matches expected format
- [ ] All required sections completed
- [ ] No placeholder values remaining
- [ ] Quality check passed

---

## Communication Protocol

### Progress Updates

| Trigger | Action |
|---------|--------|
| Task Started | Report begin timestamp |
| Checkpoint Reached | Report progress percentage |
| Blocker Encountered | Request guidance immediately |
| Task Complete | Report completion with summary |

### Escalation Criteria

Escalate to delegator if:

- [ESCALATION_CONDITION_1]
- [ESCALATION_CONDITION_2]
- [ESCALATION_CONDITION_3]

---

## Completion Report

### Summary

| Field | Value |
|-------|-------|
| **Status** | [STATUS: Complete | Partial | Failed] |
| **Completed** | [DATE] |
| **Output Location** | [FILE_PATH] |

### Results

[BRIEF_SUMMARY_OF_RESULTS]

### Issues Encountered

| Issue | Resolution |
|-------|------------|
| [ISSUE_1] | [RESOLUTION_1] |

---

## Checklist (Complete Before Closing Task)

- [ ] All placeholders filled: `[PLACEHOLDER]` -> actual values
- [ ] Task objective clearly stated
- [ ] Input data location specified
- [ ] Output format defined
- [ ] Success criteria are measurable
- [ ] Escalation criteria defined
- [ ] Completion report filled out

---

> **REMINDER**: This template follows U-shaped attention pattern. Critical sections are at TOP (header, summary) and BOTTOM (completion, checklist). Instructions and details go in MIDDLE.
