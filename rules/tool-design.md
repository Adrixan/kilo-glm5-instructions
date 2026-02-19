# Tool Design Rules

## Critical Rules (Top)

- **NEVER return full content from search/list operations**
- **ALWAYS use two-phase pattern for potentially large data**
- **Maximize parallel calls for independent operations**

---

## Two-Phase Tool Pattern

For tools that might return large data, use a two-phase approach:

### Phase 1: Search/List

Returns metadata only:

- IDs, names, timestamps
- Relevance scores
- Summary snippets (max 100 chars)

```markdown
# Example Search Output
| ID | Name | Modified | Relevance |
|----|------|----------|-----------|
| 001 | user-auth.ts | 2024-01-15 | 0.95 |
| 002 | auth-utils.ts | 2024-01-10 | 0.82 |
```

### Phase 2: Fetch/Detail

Returns full content for specific item:

- Called only after user selection
- Returns exactly what's needed
- Single item per call

```markdown
# Example Detail Output
File: user-auth.ts (245 lines)
Purpose: Authentication middleware
Key functions: validateToken(), refreshToken()
[Full content returned here]
```

---

## Response Size Limits

| Tool Type | Max Response Size | Format |
|-----------|-------------------|--------|
| Search/List | 50 items, metadata only | Table |
| Detail/Fetch | Full content, single item | Raw |
| Analysis | Summary + file path | Structured |
| Status/Health | Single line | Key-value |

### Size Estimation Rules

Before returning data:

1. Estimate response size
2. If >1KB: use two-phase pattern
3. If >5KB: write to file, return path
4. If >50KB: mandatory file storage

---

## Output Format Standards

### Structured Data Priority

1. **Tables** for comparisons and lists
2. **JSON** for structured data
3. **Key-value pairs** for status
4. **No prose** in tool output

### Field Selection

Include only requested fields:

```
❌ GET /api/users → {id, name, email, address, phone, created, modified, preferences...}
✅ GET /api/users?fields=id,name → {id, name}
```

### No Explanations in Output

Tool output should be data, not documentation:

```
❌ "Here are the users that match your search criteria..."
✅ [table of users]
```

---

## Parallel Tool Calls

### When to Batch

Batch independent operations in a single request:

- Read multiple files simultaneously
- Execute independent checks together
- Gather all context before analysis

### Example: Correct Batching

```
❌ Sequential (3 round trips):
   read file1 → analyze
   read file2 → analyze  
   read file3 → analyze

✅ Parallel (1 round trip):
   read file1, file2, file3 → analyze all
```

### When Sequential is Required

Dependencies must be sequential:

- Read config → use config values in next call
- Write file → read file for verification
- Create resource → use resource ID in next call

### Parallel Call Limits

| Operation Type | Max Parallel | Reason |
|----------------|--------------|--------|
| File reads | 5 | Balance speed vs. memory |
| API calls | 3 | Rate limit protection |
| Searches | 3 | Result quality |

---

## Tool Output Storage Strategy

### When to Store in Filesystem

Store output to file when:

- Response size >5KB
- Content will be referenced later
- User needs to persist the result

### Storage Location

```
.kilocode/
└── outputs/
    ├── analysis/
    │   └── [task]-[timestamp].md
    ├── api-responses/
    │   └── [endpoint]-[timestamp].json
    └── generated/
        └── [filename].[ext]
```

### Output Summary Format

When storing to file, return summary:

```markdown
# Output Summary

## File: .kilocode/outputs/analysis/auth-review-20240115.md
## Size: 2,450 bytes (87 lines)
## Generated: 2024-01-15T10:30:00Z

### Key Findings
- 3 security issues found
- 2 performance optimizations recommended
- 1 deprecated function identified

### Location
Full output stored at: .kilocode/outputs/analysis/auth-review-20240115.md
```

---

## Tool Design Checklist

Before creating or using a tool, verify:

- [ ] Does search return metadata only?
- [ ] Is detail fetch separate from search?
- [ ] Are parallel calls used for independent operations?
- [ ] Is output format structured (not prose)?
- [ ] Are large outputs stored to files?
- [ ] Is response size within limits?
