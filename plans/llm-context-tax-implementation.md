# LLM Context Tax Implementation Strategy

## Executive Summary

This document analyzes the 13 "LLM Context Tax" strategies and designs specific implementations for the GLM-5 instructions repository. The focus is on strategies that can be implemented as **instructions to the LLM**, not as application code.

**Key Insight**: GLM-5 is a free model with different characteristics than Claude:

- No direct token cost, but context window limits still apply
- Latency increases with context size
- Quality degrades with excessive context (lost-in-the-middle)
- KV cache efficiency still matters for response speed

---

## Strategy Applicability Analysis

| # | Strategy | Applicability | Priority | Rationale |
|---|----------|--------------|----------|-----------|
| 1 | Stable Prefixes for KV Cache | **HIGH** | P1 | Direct instruction impact on prompt structure |
| 2 | Append-Only Context | **HIGH** | P1 | Instructions can enforce append-only patterns |
| 3 | Store Tool Outputs in Filesystem | **HIGH** | P1 | Already partially implemented, can enhance |
| 4 | Design Precise Tools | **HIGH** | P2 | Instructions for tool design patterns |
| 5 | Clean Your Data First | **HIGH** | P1 | Instructions for data processing |
| 6 | Delegate to Cheaper Subagents | **LOW** | P3 | Architecture-level, limited instruction impact |
| 7 | Reusable Templates | **HIGH** | P2 | Already started, can expand significantly |
| 8 | Lost-in-the-Middle | **HIGH** | P1 | Critical for instruction file structure |
| 9 | Server-Side Compaction | **NONE** | N/A | API-level feature, not instruction-level |
| 10 | Output Token Budgeting | **HIGH** | P1 | Direct instruction for response conciseness |
| 11 | 200K Pricing Cliff | **MEDIUM** | P3 | GLM-5 is free, but context limits matter |
| 12 | Parallel Tool Calls | **MEDIUM** | P2 | Instructions for batching operations |
| 13 | Application-Level Caching | **LOW** | N/A | Application-level, not instruction-level |

**Summary**: 9 strategies are HIGH/MEDIUM applicability, 4 are LOW/NONE.

---

## Detailed Implementation Design

### Strategy 1: Stable Prefixes for KV Cache Hits

**Problem**: Dynamic content in system prompts invalidates KV cache.

**Current State**:

- [`custom-instructions.md`](custom-instructions.md) has stable structure
- [`templates/project-state.md`](templates/project-state.md:92) uses `[Date]` placeholder

**Implementation**:

1. **Modify `templates/project-state.md`**:
   - Move timestamp to END of file
   - Use date-only format (no seconds/milliseconds)
   - Add "Last Read" section at bottom for dynamic data

2. **Add to `custom-instructions.md`**:

   ```markdown
   ## Context Structure Rules
   
   - Stable content at beginning (role, rules, patterns)
   - Dynamic content at end (timestamps, session data)
   - Never include seconds in timestamps (use ISO date or YYYY-MM-DD)
   - Session identifiers at document end only
   ```

3. **Create new rule file `rules/context-optimization.md`**:
   - Document the stable prefix pattern
   - Provide examples of correct vs incorrect structure

---

### Strategy 2: Append-Only Context

**Problem**: Mutating earlier context invalidates KV cache.

**Current State**: No explicit guidance on append-only patterns.

**Implementation**:

1. **Add to `custom-instructions.md`** under new section:

   ```markdown
   ## Context Mutation Rules
   
   - NEVER modify earlier conversation context
   - ALWAYS append new information
   - When updating state: append new entry, don't replace
   - Logs are append-only: new entries at bottom
   - Decisions are additive: new decisions don't erase old
   ```

2. **Modify `templates/project-state.md`**:
   - Add "Session Log" section for append-only entries
   - Structure decisions log as append-only table
   - Add example of correct append pattern

3. **Add to `rules/main.md`**:

   ```markdown
   ## State Updates
   
   - Append new state; never delete history
   - Use strikethrough for obsolete items: ~~obsolete item~~
   - Add "Superseded by: [link]" for updated decisions
   ```

---

### Strategy 3: Store Tool Outputs in Filesystem

**Problem**: Large tool outputs consume context window.

**Current State**:

- [`templates/project-state.md`](templates/project-state.md) exists for state tracking
- No guidance on file-based output storage

**Implementation**:

1. **Add to `custom-instructions.md`**:

   ```markdown
   ## Output Storage Strategy
   
   For large outputs (>1KB estimated):
   - Write to file instead of displaying
   - Report file path and summary only
   - Use `.kilocode/outputs/` directory for generated files
   
   Examples:
   - Generated code → write to file, show snippet
   - API responses → save to JSON, summarize
   - Analysis results → save to markdown, show key findings
   ```

2. **Create `templates/output-summary.md`**:

   ```markdown
   # Output Summary
   
   ## File: [path]
   ## Size: [lines/bytes]
   ## Generated: [timestamp]
   
   ### Key Contents
   - [bullet points of main content]
   
   ### Location
   Full output stored at: [file path]
   ```

3. **Add to `agents.md`**:
   - Directory structure for `.kilocode/outputs/`
   - Naming convention for output files

---

### Strategy 4: Design Precise Tools

**Problem**: Tools returning excessive data waste tokens.

**Current State**: No guidance on tool design patterns.

**Implementation**:

1. **Create `rules/tool-design.md`**:

   ```markdown
   # Tool Design Rules
   
   ## Two-Phase Pattern
   
   For tools that might return large data:
   
   ### Phase 1: Search/List
   Returns metadata only:
   - IDs, names, timestamps
   - Relevance scores
   - Summary snippets (max 100 chars)
   
   ### Phase 2: Fetch/Detail
   Returns full content for specific item:
   - Called only after user selection
   - Returns exactly what's needed
   
   ## Response Size Limits
   
   | Tool Type | Max Response Size |
   |-----------|-------------------|
   | Search/List | 50 items, metadata only |
   | Detail/Fetch | Full content, single item |
   | Analysis | Summary + file path |
   
   ## Output Format
   
   - Use structured data (JSON, tables)
   - No prose explanations in tool output
   - Include only requested fields
   ```

2. **Add to `rules/backend.md`** under new section:
   - Tool design patterns for API endpoints
   - Pagination requirements
   - Field selection patterns

---

### Strategy 5: Clean Your Data First

**Problem**: Garbage in context wastes tokens and reduces quality.

**Current State**: No explicit data cleaning guidance.

**Implementation**:

1. **Add to `custom-instructions.md`**:

   ```markdown
   ## Data Processing Rules
   
   Before adding content to context:
   
   ### Strip Boilerplate
   - Remove navigation, footers, ads
   - Extract main content only
   - Strip tracking parameters from URLs
   
   ### Normalize Whitespace
   - Single spaces between words
   - Single newlines between paragraphs
   - No trailing whitespace
   
   ### Convert Formats
   - HTML → Markdown (already ~40% reduction)
   - PDF → Plain text with structure
   - JSON → Summary or table format
   
   ### Remove Redundancy
   - Deduplicate similar content
   - Summarize repeated patterns
   - Keep only unique information
   ```

2. **Create `rules/data-processing.md`**:
   - Detailed cleaning patterns by source type
   - Examples of before/after cleaning
   - Token estimation formulas

---

### Strategy 6: Delegate to Cheaper Subagents

**Problem**: Token-heavy operations in main context.

**Applicability**: LOW for instruction sets. This is primarily an architecture decision.

**Implementation**: Limited to guidance in `rules/main.md`:

```markdown
## Task Delegation

For token-heavy operations:
- Consider if task can be isolated
- Document the pattern for future reference
- Note: GLM-5 is free, so cost savings don't apply
- Still valuable for context isolation
```

---

### Strategy 7: Reusable Templates Over Regeneration

**Problem**: Regenerating content costs 5x input tokens.

**Current State**:

- [`templates/project-state.md`](templates/project-state.md) exists
- Output templates in [`custom-instructions.md`](custom-instructions.md:66-86)

**Implementation**:

1. **Expand `templates/` directory**:

   ```
   templates/
   ├── project-state.md      # Existing
   ├── output-summary.md     # New (Strategy 3)
   ├── user-story.md         # New
   ├── sprint-review.md      # New
   ├── api-design.md         # New
   ├── error-report.md       # New
   └── decision-log.md       # New
   ```

2. **Add to `custom-instructions.md`**:

   ```markdown
   ## Template Usage
   
   ALWAYS use templates from `.kilocode/templates/`:
   - Copy template structure exactly
   - Fill placeholders only
   - Don't regenerate template content
   
   Template precedence:
   1. Project-specific templates
   2. Domain templates (from rules/)
   3. Default templates (from custom-instructions.md)
   ```

3. **Create individual template files** with clear placeholder syntax.

---

### Strategy 8: Lost-in-the-Middle Problem

**Problem**: LLMs have U-shaped attention; middle content is often ignored.

**Current State**:

- Critical rules are at top of files (good)
- Some important content in middle sections

**Implementation**:

1. **Restructure `custom-instructions.md`**:

   ```markdown
   # Structure Principle: U-Shaped Attention
   
   Place content by importance:
   - BEGINNING: Role, critical rules, mandatory requirements
   - MIDDLE: Examples, detailed explanations, edge cases
   - END: Checklists, reminders, action triggers
   
   ## Critical Content (Top)
   - Role definition
   - Priority order
   - Security requirements
   - Quality gates
   
   ## Supporting Content (Middle)
   - Workflow details
   - User profiles
   - Output templates
   
   ## Action Triggers (Bottom)
   - Pre-commit checklist
   - State management reminder
   - "Ask if unclear" prompt
   ```

2. **Restructure all rule files** following same pattern:
   - Critical rules at top
   - Examples in middle
   - Checklists at bottom

3. **Add to `rules/main.md`**:

   ```markdown
   ## Information Placement
   
   When writing documentation:
   - Critical warnings at TOP
   - Examples in MIDDLE
   - Action items at END
   
   User will remember first and last best.
   ```

---

### Strategy 9: Server-Side Compaction

**Applicability**: NONE. This is an API-level feature, not implementable via instructions.

---

### Strategy 10: Output Token Budgeting

**Problem**: Verbose responses waste tokens and time.

**Current State**:

- [`rules/code-mode.md`](rules/code-mode.md:31-36) mentions "Minimal explanation unless asked"
- No explicit token budgets

**Implementation**:

1. **Add to `custom-instructions.md`**:

   ```markdown
   ## Response Size Budgets
   
   | Task Type | Max Response | Format |
   |-----------|--------------|--------|
   | Quick fix | 50 words | Direct code |
   | Feature implementation | 200 words | Code + brief context |
   | Explanation requested | 500 words | Structured prose |
   | Architecture decision | 300 words | ADR format |
   | Error analysis | 150 words | Problem + solution |
   
   ## Conciseness Rules
   
   - No preamble ("I'll help you...", "Here's the solution...")
   - No postscript ("Let me know if...", "Hope this helps...")
   - Code first, explanation only if requested
   - Use bullet points over paragraphs
   - Tables over prose for comparisons
   ```

2. **Modify `rules/code-mode.md`**:

   ```markdown
   ## Output Style
   
   - Direct code output (no preamble)
   - One-line context if needed
   - Show test results in table format
   - Flag issues in bullet list
   - Max 200 words for implementation responses
   ```

---

### Strategy 11: The 200K Pricing Cliff

**Problem**: Context limits affect quality even without pricing.

**Current State**: No context size awareness.

**Implementation**:

1. **Add to `custom-instructions.md`**:

   ```markdown
   ## Context Size Awareness
   
   GLM-5 context limits:
   - Optimal: <50K tokens
   - Acceptable: 50K-100K tokens
   - Degraded: >100K tokens
   
   When context grows large:
   - Summarize older conversation turns
   - Archive completed tasks to files
   - Use project-state.md for persistent info
   - Request context compaction if needed
   ```

2. **Add to `templates/project-state.md`**:

   ```markdown
   ## Context Health
   
   - Last Compaction: [date]
   - Active Items: [count]
   - Archived Items: [count]
   ```

---

### Strategy 12: Parallel Tool Calls

**Problem**: Sequential calls increase round trips.

**Current State**: No guidance on parallel execution.

**Implementation**:

1. **Add to `custom-instructions.md`**:

   ```markdown
   ## Parallel Execution
   
   Batch independent operations:
   - Read multiple files in one request
   - Execute independent checks simultaneously
   - Gather all context before analysis
   
   Example:
   ❌ Read file1 → analyze → read file2 → analyze
   ✅ Read file1, file2, file3 → analyze all together
   
   Dependencies must be sequential:
   - Read config → use config values in next call
   - Write file → read file for verification
   ```

2. **Add to `rules/main.md`**:

   ```markdown
   ## Operation Batching
   
   When gathering context:
   1. Identify all needed files/operations
   2. Batch independent reads
   3. Process together
   4. Report findings in single response
   ```

---

### Strategy 13: Application-Level Response Caching

**Applicability**: LOW. This is application architecture, not instruction content.

**Limited Implementation**: Add note in `rules/main.md` about caching patterns when generating code.

---

## Implementation Priority Order

### Phase 1: High Impact, Low Effort (P1)

| Strategy | Files to Modify | Effort |
|----------|-----------------|--------|
| 8. Lost-in-the-Middle | Restructure all rule files | Medium |
| 10. Output Token Budgeting | custom-instructions.md, code-mode.md | Low |
| 5. Clean Your Data First | custom-instructions.md, new rules file | Low |
| 1. Stable Prefixes | templates/project-state.md, new rules file | Low |
| 2. Append-Only Context | custom-instructions.md, templates | Low |

### Phase 2: Medium Impact (P2)

| Strategy | Files to Modify | Effort |
|----------|-----------------|--------|
| 3. Store Tool Outputs | New templates, custom-instructions.md | Medium |
| 7. Reusable Templates | New template files | Medium |
| 4. Design Precise Tools | New rules file | Medium |
| 12. Parallel Tool Calls | custom-instructions.md, rules/main.md | Low |

### Phase 3: Lower Priority (P3)

| Strategy | Files to Modify | Effort |
|----------|-----------------|--------|
| 11. Context Size Awareness | custom-instructions.md, templates | Low |
| 6. Delegate to Subagents | rules/main.md (minimal) | Low |

---

## New Files to Create

```
rules/
├── context-optimization.md    # Strategy 1, 8
├── tool-design.md             # Strategy 4
└── data-processing.md         # Strategy 5

templates/
├── output-summary.md          # Strategy 3
├── user-story.md              # Strategy 7
├── sprint-review.md           # Strategy 7
├── api-design.md              # Strategy 7
├── error-report.md            # Strategy 7
└── decision-log.md            # Strategy 7
```

---

## Files to Modify

| File | Changes |
|------|---------|
| `custom-instructions.md` | Add 8 new sections for strategies 1, 2, 3, 5, 8, 10, 11, 12 |
| `rules/main.md` | Add context mutation rules, operation batching |
| `rules/code-mode.md` | Enhance output style section with budgets |
| `templates/project-state.md` | Restructure for stable prefixes, add context health |
| `agents.md` | Add output directory structure |

---

## GLM-5 Specific Considerations

### Model Characteristics

1. **Free Model**: No direct token cost, but latency still matters
2. **Context Window**: Similar degradation patterns at scale
3. **Attention Pattern**: U-shaped attention confirmed in testing
4. **Language**: Strong Chinese/English bilingual support

### Optimization Adjustments

1. **Less aggressive on token counting** - No cost pressure
2. **More focus on latency** - Free tier may have rate limits
3. **Quality over quantity** - Context pollution affects free models more
4. **Template reuse critical** - Reduces generation variance

### Chinese Language Support

Add to `custom-instructions.md`:

```markdown
## Language Optimization

For Chinese content:
- Use concise Chinese characters (信息 density higher)
- Prefer structured formats (tables, lists)
- Technical terms: English with Chinese explanation first time
```

---

## Success Metrics

| Metric | Current | Target | Measurement |
|--------|---------|--------|-------------|
| Avg response tokens | Unknown | <300 | Manual sampling |
| Template usage | 1 template | 7 templates | File count |
| Rule file structure | Mixed | U-shaped | Audit |
| Output storage | None | File-based | Directory check |

---

## Next Steps

1. Review this plan with stakeholder
2. Prioritize Phase 1 implementations
3. Create new rule files
4. Modify existing files
5. Test with GLM-5
6. Iterate based on results
