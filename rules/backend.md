# Backend Development Rules

Rules for Python, Java, Go, PHP, and SQL backend development.

## Universal Backend Rules

### Architecture

- Layered: Controllers → Services → Repositories → Database
- DTOs at API boundaries; entities internally
- Dependency injection via constructor

### API Versioning

Choose one strategy per project:

- URL path: `/api/v1/users` (recommended for public APIs)
- Accept header: `Accept: application/vnd.myapp.v1+json`

### Testing

| Layer | Coverage | Type |
|-------|----------|------|
| Business logic | 80% | Unit |
| Controllers | Basic | Integration |
| Repositories | With DB | Testcontainers |
| Critical paths | 100% | All |

### Performance

- Connection pooling (HikariCP, SQLAlchemy pool)
- Indexes on query columns
- Redis for hot data
- Paginate all list endpoints
- Async I/O for I/O-bound operations

### Observability

- OpenTelemetry for traces/metrics/logs
- Structured JSON logs with trace IDs
- Metrics: latency (P50/P95/P99), error rate, throughput

---

## Python (FastAPI / Django / Flask)

### Standards

- **Python 3.12+** with mandatory type hints
- `type` statement for type aliases: `type UserId = int`
- `@override` decorator for explicit overrides
- Protocol classes for interfaces

### Tooling

- **Linting**: Ruff (replaces Black + isort + flake8)
- **Typing**: mypy with `strict: true`
- **Testing**: pytest + pytest-cov
- **SAST**: Semgrep or Bandit

### SQL Safety

```python
# ❌ NEVER
query = f"SELECT * FROM users WHERE username = '{username}'"

# ✅ ALWAYS
query = "SELECT * FROM users WHERE username = %s"
cursor.execute(query, (username,))
```

### Logging

- Use `structlog` or `python-json-logger`
- Never log sensitive data

---

## Java (Spring Boot / Jakarta EE)

### Standards

- **Java 21 LTS** with **Spring Boot 3.3+**
- Virtual threads for I/O-bound workloads
- Records for DTOs and value objects
- Constructor injection (no field injection)

### Features

- Pattern matching for `instanceof`, `switch`
- Sequenced collections for ordered access
- GraalVM native image for serverless

### Tooling

- **Build**: Maven or Gradle with version catalogs
- **Testing**: JUnit 5 + Mockito + AssertJ
- **SAST**: SpotBugs, PMD, or Semgrep

### Dependency Injection

```java
// ❌ NEVER
@Autowired
private UserService userService;

// ✅ ALWAYS
private final UserService userService;

public UserController(UserService userService) {
    this.userService = userService;
}
```

---

## Go

### Standards

- **Go 1.22+** with modules
- Standard library first
- `log/slog` for structured logging
- `context.Context` as first parameter for I/O operations

### Error Handling

```go
// ❌ NEVER
result, _ := doSomething()

// ✅ ALWAYS
result, err := doSomething()
if err != nil {
    return fmt.Errorf("context: %w", err)
}
```

### Concurrency

- Use `context.Context` for cancellation
- `errgroup` for goroutine coordination
- `-race` flag in tests

### Tooling

- **Linting**: golangci-lint (govet, staticcheck, errcheck, gosec)
- **Testing**: testing package + testify
- **ORM**: sqlc preferred over gorm

### Key Rules

- No `panic` in library code
- Define interfaces at consumer site
- Keep packages small and focused

---

## PHP (Laravel / Symfony)

### Standards

- **PHP 8.3+** with `declare(strict_types=1);` at top of every file
- **Laravel 11.x** or **Symfony 7.x**
- Readonly properties and constructor promotion
- Typed class constants: `const string STATUS = 'active';`
- `#[\Override]` attribute on overridden methods

### Tooling

- **Testing**: PHPUnit 11 or Pest 3
- **Static Analysis**: PHPStan (level 9) or Psalm
- **SAST**: Semgrep or Psalm taint analysis

### SQL Safety

```php
// ❌ NEVER
DB::select("SELECT * FROM users WHERE id = $id");

// ✅ ALWAYS
DB::select("SELECT * FROM users WHERE id = ?", [$id]);
```

---

## SQL

### Standards

- ANSI SQL preferred for portability
- Migrations ONLY for schema changes (Flyway, Liquibase, Alembic)
- `snake_case` for all identifiers
- Indexes on Foreign Keys, WHERE, JOIN, ORDER BY columns

### Query Optimization

- Use EXPLAIN/ANALYZE for slow queries
- Eager loading to prevent N+1
- Cursor-based pagination for large datasets
- Prefer `EXISTS` over `IN` for subqueries

### Migration Rules

- Every migration must be reversible
- Test against production-like data volumes
- Never modify a released migration

```sql
-- ❌ NEVER (SQL Injection via app code)
-- ✅ ALWAYS use prepared statements in app code
```

---

## Common Pitfalls

| Issue | Solution |
|-------|----------|
| N+1 queries | Eager loading / joinedload |
| Missing input validation | Validate at API boundary with schemas |
| Leaking entities | Return DTOs, never database entities |
| No transactions | Wrap multi-step mutations in transactions |
| Field injection | Use constructor injection |
| No API versioning | Version from day one |

---

## AI Integration Security

When integrating LLM/AI APIs:

### Prompt Injection

- Never pass raw user input to system prompts
- Use structured input/output schemas
- Separate system instructions from user content

### Data Security

- Never send PII or secrets to external LLM APIs
- Mask/redact sensitive data before sending
- Log interactions for audit (redact sensitive content)

### Output Safety

- Treat AI output as untrusted user input
- Sanitize before rendering in DOM
- Never `eval()` AI-generated code without sandboxing

### Reliability

- Retry with exponential backoff
- Set timeouts (10-30s)
- Graceful degradation when unavailable
- Cache responses where appropriate
