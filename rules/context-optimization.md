# Context Optimization Rules

> **Critical**: These rules optimize LLM context usage for better performance, quality, and latency with GLM-5.

---

## KV Cache Optimization

### Stable Prefix Pattern

**Problem**: Dynamic content at the beginning of prompts invalidates KV cache, forcing re-computation.

**Rules**:

1. **Stable content at the BEGINNING**:
   - Role definitions
   - Core rules and patterns
   - Static configuration
   - Reference materials

2. **Dynamic content at the END**:
   - Timestamps (use date-only format: `YYYY-MM-DD`)
   - Session identifiers
   - Runtime state
   - User-specific data

3. **Never include seconds in timestamps**:

   ```
   ✅ 2024-01-15
   ✅ 2024-01-15T14:30
   ❌ 2024-01-15T14:30:45.123Z
   ```

### Append-Only Context

**Problem**: Modifying earlier context invalidates KV cache entries.

**Rules**:

1. **NEVER modify earlier conversation context**
2. **ALWAYS append new information**
3. **When updating state**: Append new entry, don't replace
4. **Logs are append-only**: New entries at bottom
5. **Decisions are additive**: New decisions don't erase old

**Correct Pattern**:

```markdown
## Decision Log

| Date | Decision | Rationale |
|------|----------|-----------|
| 2024-01-10 | Use PostgreSQL | Team expertise |
| 2024-01-15 | Add Redis cache | Performance need |
```

**Incorrect Pattern**:

```markdown
## Decision Log
| Date | Decision | Rationale |
|------|----------|-----------|
| 2024-01-15 | Add Redis cache | Performance need |
```

(Deleted previous entry - WRONG)

---

## U-Shaped Attention Pattern

### Lost-in-the-Middle Problem

**Problem**: LLMs have U-shaped attention distribution. Content in the middle of long contexts receives less attention and is often "forgotten."

**Attention Distribution**:

```
Attention Level
    HIGH ┤  ●                    ●
         │   ╲                  ╱
         │    ╲                ╱
         │     ╲              ╱
         │      ╲            ╱
     LOW ┤       ●━━━━━━━━━━●
         └────────────────────────
           Start  Middle    End
```

### Content Placement Rules

**BEGINNING (High Attention)**:

- Critical rules and mandatory requirements
- Security constraints
- Quality gates
- Role definition
- Priority order

**MIDDLE (Lower Attention)**:

- Examples and demonstrations
- Detailed explanations
- Edge cases and exceptions
- Supporting documentation

**END (High Attention)**:

- Checklists and reminders
- Action triggers
- Pre-commit requirements
- "Ask if unclear" prompts

### Document Structure Template

```markdown
# [Document Title]

## Critical Rules (TOP)
- Must always apply
- Security requirements
- Quality standards

## Detailed Guidance (MIDDLE)
- Workflow steps
- Examples
- Edge cases

## Checklist (BOTTOM)
- [ ] Verify X
- [ ] Check Y
- [ ] Complete Z
```

---

## Context Size Awareness

### GLM-5 Context Limits

| Zone | Token Range | Quality Level | Action |
|------|-------------|---------------|--------|
| Optimal | <50K | Full quality | Normal operation |
| Acceptable | 50K-100K | Slight degradation | Consider summarization |
| Degraded | >100K | Significant degradation | Compact immediately |

### When Context Grows Large

1. **Summarize older conversation turns**
2. **Archive completed tasks to files**
3. **Use project-state.md for persistent info**
4. **Request context compaction if needed**

### Context Health Tracking

Track in project-state.md:

```markdown
## Context Health

- Last Compaction: YYYY-MM-DD
- Active Items: [count]
- Archived Items: [count]
```

---

## GLM-5 Specific Optimizations

### Model Characteristics

1. **Free Model**: No direct token cost, but latency matters
2. **Context Window**: Similar degradation patterns at scale
3. **Attention Pattern**: U-shaped attention confirmed
4. **Language**: Strong Chinese/English bilingual support

### Optimization Adjustments

1. **Less aggressive on token counting** - No cost pressure
2. **More focus on latency** - Free tier may have rate limits
3. **Quality over quantity** - Context pollution affects free models more
4. **Template reuse critical** - Reduces generation variance

### Language Optimization

For Chinese content:

- Use concise Chinese characters (信息 density higher)
- Prefer structured formats (tables, lists)
- Technical terms: English with Chinese explanation first time

---

## Quick Reference Checklist

Before finalizing any context:

- [ ] Stable content at beginning?
- [ ] Dynamic content at end?
- [ ] Timestamps without seconds?
- [ ] Critical rules at top?
- [ ] Examples in middle?
- [ ] Checklists at bottom?
- [ ] Context size under 50K tokens?
- [ ] Using append-only pattern?

---

## Examples

### Correct Context Structure

```markdown
# Project Instructions

## Role (TOP - HIGH ATTENTION)
You are a senior developer...

## Critical Rules (TOP - HIGH ATTENTION)
- Always test before commit
- Security first

## Workflow Details (MIDDLE)
1. Read requirements
2. Design solution
...

## Examples (MIDDLE)
Here's how to structure...

## Pre-Commit Checklist (END - HIGH ATTENTION)
- [ ] Tests pass
- [ ] Code reviewed
```

### Incorrect Context Structure

```markdown
# Project Instructions

## Session: 2024-01-15T14:30:45.123Z (WRONG - dynamic at top)

## Examples (WRONG - critical content should be higher)

## Critical Rules (WRONG - should be at top)
- Always test before commit

## Role (WRONG - should be at top)
You are a senior developer...
```

---

## Related Files

- [`custom-instructions.md`](../custom-instructions.md) - Main instruction file
- [`templates/project-state.md`](../templates/project-state.md) - State tracking template
- [`rules/main.md`](main.md) - General rules
