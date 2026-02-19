# API Response Template

> **CRITICAL**: Copy this structure exactly. Fill placeholders only. Do not regenerate template content.

---

## Response Metadata

| Field | Value |
|-------|-------|
| **Endpoint** | `[ENDPOINT_PATH]` |
| **Method** | `[HTTP_METHOD]` |
| **Status** | `[STATUS_CODE]` |
| **Timestamp** | `[TIMESTAMP]` |
| **Request ID** | `[REQUEST_ID]` |

---

## Success Response (2xx)

### Structure

```json
{
    "success": true,
    "data": {
        "[PRIMARY_KEY]": "[PRIMARY_VALUE]",
        "[SECONDARY_KEY]": "[SECONDARY_VALUE]"
    },
    "meta": {
        "timestamp": "[TIMESTAMP]",
        "requestId": "[REQUEST_ID]"
    }
}
```

### Example: Single Resource

```json
{
    "success": true,
    "data": {
        "id": "[RESOURCE_ID]",
        "type": "[RESOURCE_TYPE]",
        "attributes": {
            "[ATTRIBUTE_1]": "[VALUE_1]",
            "[ATTRIBUTE_2]": "[VALUE_2]"
        }
    },
    "meta": {
        "timestamp": "2024-01-15T10:30:00Z",
        "requestId": "req_abc123"
    }
}
```

### Example: Collection

```json
{
    "success": true,
    "data": [
        { "id": "[ID_1]", "name": "[NAME_1]" },
        { "id": "[ID_2]", "name": "[NAME_2]" }
    ],
    "meta": {
        "timestamp": "[TIMESTAMP]",
        "requestId": "[REQUEST_ID]",
        "pagination": {
            "page": [PAGE_NUMBER],
            "perPage": [ITEMS_PER_PAGE],
            "total": [TOTAL_ITEMS],
            "totalPages": [TOTAL_PAGES]
        }
    }
}
```

---

## Error Response (4xx/5xx)

### Structure

```json
{
    "success": false,
    "error": {
        "code": "[ERROR_CODE]",
        "message": "[USER_FRIENDLY_MESSAGE]",
        "details": "[TECHNICAL_DETAILS]"
    },
    "meta": {
        "timestamp": "[TIMESTAMP]",
        "requestId": "[REQUEST_ID]"
    }
}
```

### Example: Validation Error (400)

```json
{
    "success": false,
    "error": {
        "code": "VALIDATION_ERROR",
        "message": "Invalid input parameters",
        "details": [
            {
                "field": "[FIELD_NAME]",
                "issue": "[ISSUE_DESCRIPTION]",
                "value": "[PROVIDED_VALUE]"
            }
        ]
    },
    "meta": {
        "timestamp": "[TIMESTAMP]",
        "requestId": "[REQUEST_ID]"
    }
}
```

### Example: Not Found (404)

```json
{
    "success": false,
    "error": {
        "code": "NOT_FOUND",
        "message": "[RESOURCE_TYPE] not found",
        "details": "No [RESOURCE_TYPE] exists with id: [RESOURCE_ID]"
    },
    "meta": {
        "timestamp": "[TIMESTAMP]",
        "requestId": "[REQUEST_ID]"
    }
}
```

### Example: Server Error (500)

```json
{
    "success": false,
    "error": {
        "code": "INTERNAL_ERROR",
        "message": "An unexpected error occurred",
        "details": "[ERROR_REFERENCE_ID]"
    },
    "meta": {
        "timestamp": "[TIMESTAMP]",
        "requestId": "[REQUEST_ID]"
    }
}
```

---

## HTTP Status Codes Reference

| Code | Meaning | When to Use |
|------|---------|-------------|
| 200 | OK | Successful GET, PUT, PATCH |
| 201 | Created | Successful POST that creates resource |
| 204 | No Content | Successful DELETE |
| 400 | Bad Request | Invalid request syntax, validation failure |
| 401 | Unauthorized | Authentication required or failed |
| 403 | Forbidden | Authenticated but not authorized |
| 404 | Not Found | Resource does not exist |
| 409 | Conflict | Resource conflict (duplicate, version mismatch) |
| 422 | Unprocessable Entity | Semantic errors in request |
| 429 | Too Many Requests | Rate limit exceeded |
| 500 | Internal Server Error | Unexpected server error |
| 503 | Service Unavailable | Server temporarily unavailable |

---

## Response Size Guidelines

| Response Type | Max Size | Notes |
|---------------|----------|-------|
| Single Resource | 10KB | Include all relevant attributes |
| Collection | 100KB | Use pagination for larger sets |
| Error Response | 1KB | Keep minimal, log details server-side |

---

## Checklist (Complete Before Implementing)

- [ ] All placeholders filled: `[PLACEHOLDER]` -> actual values
- [ ] Success responses include `success: true` and `data` object
- [ ] Error responses include `success: false` and `error` object
- [ ] Error messages are user-friendly (no stack traces)
- [ ] HTTP status code matches response type
- [ ] Pagination included for collection responses
- [ ] Request ID included for traceability
- [ ] Response size within guidelines

---

> **REMINDER**: This template follows U-shaped attention pattern. Critical sections are at TOP (metadata, status codes) and BOTTOM (guidelines, checklist). Response examples go in MIDDLE.
