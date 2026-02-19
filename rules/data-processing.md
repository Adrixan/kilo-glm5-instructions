# Data Processing Rules

> **Critical**: Clean data before adding to context. Garbage in context wastes tokens and reduces response quality.

---

## Data Cleaning Before Context

### Core Principle

**Problem**: Unclean data in context wastes tokens and reduces LLM response quality.

**Solution**: Always preprocess external content before adding it to the LLM context window.

### Pre-Processing Checklist

Before adding any external content to context:

- [ ] Remove boilerplate (navigation, footers, ads)
- [ ] Extract main content only
- [ ] Strip tracking parameters from URLs
- [ ] Normalize whitespace
- [ ] Convert to optimal format
- [ ] Remove redundant information

---

## Content Preprocessing Strategies

### By Source Type

| Source Type | Cleaning Strategy | Token Reduction |
|-------------|-------------------|-----------------|
| HTML pages | Extract main content, convert to markdown | ~40-60% |
| PDFs | Extract text with structure preservation | ~30-50% |
| JSON APIs | Summarize or convert to table | ~50-70% |
| Code files | Remove comments (if not needed), minify imports | ~10-20% |
| Logs | Filter relevant entries, compress patterns | ~60-80% |
| Documentation | Extract relevant sections only | ~40-60% |

### HTML to Markdown Conversion

**Rules**:

1. **Extract main content only**:
   - Use content selectors (`main`, `article`, `[role="main"]`)
   - Ignore navigation, sidebars, footers
   - Remove ads and tracking pixels

2. **Convert to clean markdown**:

   ```
   HTML: <h1>Title</h1><p>Content <strong>bold</strong></p>
   Markdown: # Title\n\nContent **bold**
   ```

3. **Strip unnecessary elements**:
   - Remove `<script>`, `<style>`, `<nav>`
   - Remove `data-` attributes
   - Remove tracking parameters from URLs

**Before Cleaning**:

```html
<!DOCTYPE html>
<html>
<head>
  <title>Page Title</title>
  <script>analytics.track('pageview');</script>
  <style>.nav { color: blue; }</style>
</head>
<body>
  <nav class="nav">
    <a href="/home">Home</a>
    <a href="/about">About</a>
  </nav>
  <main>
    <h1>Important Article</h1>
    <p class="content">The key insight is that data cleaning improves quality.</p>
    <a href="/article?id=123&utm_source=twitter&utm_campaign=spring">Read More</a>
  </main>
  <footer>© 2024 Company</footer>
</body>
</html>
```

**After Cleaning**:

```markdown
# Important Article

The key insight is that data cleaning improves quality.

[Read More](/article?id=123)
```

### Boilerplate Removal

**Identify and Remove**:

1. **Navigation elements**:
   - Header navigation
   - Breadcrumbs (unless contextually necessary)
   - Sidebar menus
   - Footer links

2. **Repetitive content**:
   - Copyright notices
   - Privacy policy links
   - Cookie banners
   - Newsletter signup forms

3. **Tracking and analytics**:
   - UTM parameters: `?utm_source=...&utm_campaign=...`
   - Tracking pixels
   - Analytics scripts
   - A/B testing markers

**URL Cleaning Examples**:

```
Before: https://example.com/article?utm_source=twitter&utm_medium=social&utm_campaign=spring_sale&ref=newsletter
After:  https://example.com/article

Before: https://docs.example.com/api/v2/users?page=1&tracking_id=abc123&session=xyz
After:  https://docs.example.com/api/v2/users?page=1
```

---

## Whitespace Normalization Rules

### Standard Rules

1. **Single spaces between words**:

   ```
   Before: "Hello    world"
   After:  "Hello world"
   ```

2. **Single newlines between paragraphs**:

   ```
   Before: Paragraph 1\n\n\n\nParagraph 2
   After:  Paragraph 1\n\nParagraph 2
   ```

3. **No trailing whitespace**:

   ```
   Before: "Text   \n"
   After:  "Text\n"
   ```

4. **No leading whitespace on lines** (except code indentation):

   ```
   Before: "    Text\n    More text"
   After:  "Text\nMore text"
   ```

### Code Whitespace

For code files, preserve meaningful whitespace:

- Keep indentation for code blocks
- Keep blank lines between functions
- Remove trailing whitespace on all lines
- Remove multiple consecutive blank lines (max 1)

### Markdown Whitespace

For markdown content:

- Single blank line before/after headings
- Single blank line between list groups
- No blank lines inside list items
- Single space after list markers (`- item` not `-item`)

---

## Format Conversion Guidelines

### HTML to Markdown

**Conversion Table**:

| HTML Element | Markdown Equivalent |
|--------------|-------------------|
| `<h1>` | `#` |
| `<h2>` | `##` |
| `<h3>` | `###` |
| `<p>` | Blank line separation |
| `<strong>`, `<b>` | `**text**` |
| `<em>`, `<i>` | `*text*` |
| `<code>` | `` `code` `` |
| `<pre><code>` | Fenced code block |
| `<a href="url">text</a>` | `[text](url)` |
| `<ul>/<ol>` | `-` or `1.` |
| `<blockquote>` | `>` |

**Token Savings**: ~40% reduction from HTML to Markdown

### PDF to Plain Text

**Strategy**:

1. Extract text with structure preservation
2. Convert headings to markdown format
3. Preserve list structures
4. Remove page numbers and headers/footers
5. Merge hyphenated words across line breaks

**Example**:

```
PDF Content:
---------------
Page 1
Chapter 1: Introduction
This document explains the
process of data cleaning for
LLM contexts.

Page 2
1. First step
2. Second step
---------------

Cleaned Output:
# Chapter 1: Introduction

This document explains the process of data cleaning for LLM contexts.

1. First step
2. Second step
```

### JSON to Summary/Table

**For Large JSON Objects**:

Convert to markdown table or summary list:

**Before** (JSON):

```json
{
  "users": [
    {"id": 1, "name": "Alice", "email": "alice@example.com", "role": "admin", "created": "2024-01-15"},
    {"id": 2, "name": "Bob", "email": "bob@example.com", "role": "user", "created": "2024-01-16"},
    {"id": 3, "name": "Carol", "email": "carol@example.com", "role": "user", "created": "2024-01-17"}
  ]
}
```

**After** (Table):

```markdown
| ID | Name | Role | Created |
|----|------|------|---------|
| 1 | Alice | admin | 2024-01-15 |
| 2 | Bob | user | 2024-01-16 |
| 3 | Carol | user | 2024-01-17 |
```

**Token Savings**: ~50-70% reduction

### Log File Compression

**Strategy**:

1. Filter to relevant time range
2. Filter to relevant log levels (ERROR, WARN)
3. Compress repeated patterns
4. Remove timestamps if not needed

**Before**:

```
2024-01-15 10:23:45.123 INFO [main] Application started
2024-01-15 10:23:45.456 DEBUG [main] Loading config
2024-01-15 10:23:45.789 DEBUG [main] Config loaded
2024-01-15 10:23:46.012 INFO [main] Connecting to database
2024-01-15 10:23:46.345 ERROR [main] Connection failed: timeout
2024-01-15 10:23:46.678 WARN [main] Retrying connection
2024-01-15 10:23:47.901 ERROR [main] Connection failed: timeout
```

**After**:

```markdown
## Error Summary (2024-01-15 10:23)

- ERROR: Database connection timeout (2 occurrences)
- WARN: Connection retry initiated
```

**Token Savings**: ~60-80% reduction

---

## Redundancy Removal

### Deduplication

**Rules**:

1. **Remove duplicate content**:
   - Identical paragraphs
   - Repeated sections
   - Duplicate entries in lists

2. **Summarize similar content**:
   - Group related items
   - Extract common patterns
   - Create summary statements

3. **Keep only unique information**:

**Before**:

```markdown
The API returns user data.
The API endpoint is /api/users.
The API returns user data in JSON format.
The API endpoint /api/users returns JSON.
```

**After**:

```markdown
API endpoint `/api/users` returns user data in JSON format.
```

### Pattern Compression

Identify and compress repeated patterns:

**Before**:

```markdown
- User Alice logged in at 10:00
- User Bob logged in at 10:05
- User Carol logged in at 10:10
- User Dave logged in at 10:15
```

**After**:

```markdown
Users logged in (10:00-10:15): Alice, Bob, Carol, Dave
```

---

## Token Estimation Formulas

### Quick Estimation

| Content Type | Estimation Formula |
|--------------|-------------------|
| Plain text | ~4 characters per token |
| Code | ~3-4 characters per token |
| Markdown | ~4-5 characters per token |
| JSON | ~3-4 characters per token |
| Chinese text | ~1.5-2 characters per token |

### Size Guidelines

| Content Size | Action |
|--------------|--------|
| <1KB | Include directly |
| 1KB-10KB | Clean and include |
| 10KB-50KB | Summarize or extract key parts |
| >50KB | Store in file, include summary only |

### Reduction Targets

After cleaning, aim for:

- HTML content: 40-60% reduction
- JSON data: 50-70% reduction
- Log files: 60-80% reduction
- Documentation: 40-60% reduction

---

## Quick Reference Checklist

Before adding content to context:

- [ ] Main content extracted?
- [ ] Boilerplate removed?
- [ ] URLs cleaned of tracking parameters?
- [ ] Whitespace normalized?
- [ ] Converted to optimal format?
- [ ] Duplicates removed?
- [ ] Size under threshold?

---

## Related Files

- [`custom-instructions.md`](../custom-instructions.md) - Main instruction file
- [`rules/context-optimization.md`](context-optimization.md) - Context optimization rules
- [`rules/tool-design.md`](tool-design.md) - Tool design patterns
