# Test Template

> **CRITICAL**: Copy this structure exactly. Fill placeholders only. Do not regenerate template content.

---

## Test File Header

```[LANGUAGE]
/**
 * [TEST_FILE_NAME] - Tests for [MODULE_UNDER_TEST]
 * 
 * Created: [DATE]
 * Author: [AUTHOR]
 * 
 * Test Coverage: [COVERAGE_TARGET]%
 * Test Framework: [FRAMEWORK: Jest | Pytest | JUnit | Mocha | Other]
 */
```

---

## Test Configuration

```[LANGUAGE]
// Test setup and configuration
const TEST_CONFIG = {
    timeout: [TIMEOUT_MS],
    retries: [RETRY_COUNT],
    coverage: {
        statements: [COVERAGE_TARGET],
        branches: [BRANCH_COVERAGE],
        functions: [FUNCTION_COVERAGE],
        lines: [LINE_COVERAGE]
    }
};

// Mock configuration
const MOCKS = {
    [MOCK_NAME]: [MOCK_VALUE],
    [MOCK_NAME]: [MOCK_VALUE]
};
```

---

## Test Suite: [SUITE_NAME]

### Setup & Teardown

```[LANGUAGE]
beforeEach(() => {
    // Setup code
    [SETUP_CODE]
});

afterEach(() => {
    // Cleanup code
    [CLEANUP_CODE]
});
```

### Test Case 1: [TEST_NAME]

```[LANGUAGE]
describe('[FUNCTION_OR_FEATURE]', () => {
    test('[TEST_DESCRIPTION]', () => {
        // Arrange
        const input = [INPUT_VALUE];
        const expected = [EXPECTED_VALUE];
        
        // Act
        const result = [FUNCTION_UNDER_TEST](input);
        
        // Assert
        expect(result).toBe(expected);
    });
});
```

### Test Case 2: [TEST_NAME] - Edge Case

```[LANGUAGE]
test('[TEST_DESCRIPTION] - edge case', () => {
    // Arrange
    const input = [EDGE_CASE_INPUT];
    
    // Act & Assert
    expect(() => [FUNCTION_UNDER_TEST](input))
        .toThrow([EXPECTED_ERROR]);
});
```

### Test Case 3: [TEST_NAME] - Integration

```[LANGUAGE]
test('[TEST_DESCRIPTION] - integration', async () => {
    // Arrange
    [ARRANGE_CODE]
    
    // Act
    const result = await [ASYNC_FUNCTION]();
    
    // Assert
    expect(result).toMatchObject([EXPECTED_OBJECT]);
});
```

---

## Test Data

```[LANGUAGE]
// Test fixtures
const FIXTURES = {
    validInput: [VALID_INPUT_DATA],
    invalidInput: [INVALID_INPUT_DATA],
    edgeCaseInput: [EDGE_CASE_DATA],
    mockApiResponse: [API_RESPONSE_MOCK]
};
```

---

## Test Summary Table

| Test Category | Count | Pass | Fail | Skip |
|---------------|-------|------|------|------|
| Unit Tests | [COUNT] | [PASS] | [FAIL] | [SKIP] |
| Integration Tests | [COUNT] | [PASS] | [FAIL] | [SKIP] |
| Edge Cases | [COUNT] | [PASS] | [FAIL] | [SKIP] |
| **Total** | **[TOTAL]** | **[PASS]** | **[FAIL]** | **[SKIP]** |

---

## Coverage Report

| Metric | Target | Actual | Status |
|--------|--------|--------|--------|
| Statements | [TARGET]% | [ACTUAL]% | [Pass/Fail] |
| Branches | [TARGET]% | [ACTUAL]% | [Pass/Fail] |
| Functions | [TARGET]% | [ACTUAL]% | [Pass/Fail] |
| Lines | [TARGET]% | [ACTUAL]% | [Pass/Fail] |

---

## Checklist (Complete Before Committing)

- [ ] All placeholders filled: `[PLACEHOLDER]` -> actual values
- [ ] Each test has Arrange-Act-Assert structure
- [ ] Edge cases are covered (null, undefined, empty, max values)
- [ ] Error conditions are tested
- [ ] Mocks are properly configured and cleaned up
- [ ] Test names describe what is being tested
- [ ] Coverage meets target threshold
- [ ] All tests pass locally

---

> **REMINDER**: This template follows U-shaped attention pattern. Critical sections are at TOP (header, config) and BOTTOM (summary, checklist). Test cases go in MIDDLE.
