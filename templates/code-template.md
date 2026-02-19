# Code Template

> **CRITICAL**: Copy this structure exactly. Fill placeholders only. Do not regenerate template content.

---

## File Header

```[LANGUAGE]
/**
 * [FILE_NAME] - [BRIEF_DESCRIPTION]
 * 
 * Created: [DATE]
 * Author: [AUTHOR]
 * Module: [MODULE_NAME]
 * 
 * Dependencies: [LIST_DEPENDENCIES]
 */
```

---

## Implementation Section

### Imports/Requires

```[LANGUAGE]
// External dependencies
[EXTERNAL_IMPORTS]

// Internal modules
[INTERNAL_IMPORTS]
```

### Constants & Configuration

```[LANGUAGE]
// Configuration constants
const [CONSTANT_NAME] = [VALUE];

// Environment-based config
const config = {
    [CONFIG_KEY]: [CONFIG_VALUE]
};
```

### Core Implementation

```[LANGUAGE]
/**
 * [FUNCTION_NAME] - [ONE_LINE_DESCRIPTION]
 * 
 * @param {[TYPE]} [PARAM_NAME] - [PARAM_DESCRIPTION]
 * @returns {[TYPE]} [RETURN_DESCRIPTION]
 * @throws {[ERROR_TYPE]} [ERROR_CONDITION]
 */
function [FUNCTION_NAME]([PARAMS]) {
    // Input validation
    if (![VALIDATION_CONDITION]) {
        throw new Error('[ERROR_MESSAGE]');
    }
    
    // Core logic
    [IMPLEMENTATION]
    
    return [RESULT];
}
```

### Error Handling

```[LANGUAGE]
/**
 * Error handler for [CONTEXT]
 */
function handle[ErrorType](error) {
    // Log error
    console.error('[CONTEXT] failed:', error.message);
    
    // Recovery or re-throw
    [ERROR_HANDLING_LOGIC]
}
```

---

## Exports/Public API

```[LANGUAGE]
module.exports = {
    [EXPORTED_FUNCTION_1],
    [EXPORTED_FUNCTION_2],
    // Add new exports above this line
};
```

---

## Checklist (Complete Before Committing)

- [ ] All placeholders filled: `[PLACEHOLDER]` → actual values
- [ ] Input validation implemented for all public functions
- [ ] Error handling covers all failure modes
- [ ] No console.log in production code (use proper logging)
- [ ] Dependencies listed in package.json/requirements.txt
- [ ] File follows project naming conventions

---

> **REMINDER**: This template follows U-shaped attention pattern. Critical sections are at TOP (header, imports) and BOTTOM (exports, checklist). Implementation details go in MIDDLE.
