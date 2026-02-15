# Security Rules

Mandatory security requirements for all code. Non-negotiable.

## Standards

- **OWASP Top 10 (2021+)**
- **OWASP API Security Top 10**
- **CIS Benchmarks**
- **SLSA Supply Chain**

## Input/Output

### Validation

- All user input validated before processing
- Validate at API boundary with schema types
- Allowlist preferred over blocklist

### Output Encoding

- HTML: Entity encoding
- SQL: Parameterized queries ONLY
- Shell: Escape arguments, never interpolate
- JSON: Use proper serializers

### File Uploads

- Validate: type, size, magic bytes
- Store: outside webroot
- Name: randomized, not user-provided

## Authentication

### Requirements

- Auth required for non-public endpoints
- RBAC with least privilege
- MFA for admin accounts

### Passwords

- Hash: bcrypt, scrypt, or argon2 ONLY
- Never store plaintext or reversible encryption
- Never log passwords

### Tokens

- Cryptographically random generation
- Rotate on privilege change
- Invalidate on logout
- JWT: short expiry (15 min access, 7 day refresh)

## Authorization

- Check on every request
- Principle of least privilege
- Deny by default
- Verify object ownership (BOLA prevention)

## Secrets Management

### Never

- Hardcode secrets in source code
- Commit `.env` files
- Log sensitive data
- Include secrets in error messages

### Always

- Load from environment variables
- Use vaults/secret managers in production
- Use placeholder values in example files

## Data Protection

### Encryption

- At rest: AES-256 or equivalent
- In transit: TLS 1.2+ minimum
- Key management: Use KMS/cloud key management

### PII

- Minimize collection
- Define retention policies
- Anonymize/aggregate when possible

### Database

- Parameterized queries ONLY
- Never concatenate user input into SQL
- Use ORM parameterized queries

## Dependencies

### Requirements

- Pin exact versions in lock files
- Scan before every commit: `npm audit`, `pip-audit`, `trivy`
- Block merge on critical/high CVEs

### Supply Chain

- Verify dependency signatures
- Generate SBOM for production images
- Use lock files (`poetry.lock`, `package-lock.json`, `composer.lock`)

## Error Handling

### To Users

- Generic, safe messages
- No stack traces
- No internal paths
- No SQL queries

### Logging

- Structured JSON format
- Include request ID for tracing
- Never log: passwords, tokens, PII
- Log security events: auth failures, permission denials

## Transport Security

### HTTPS

- Enforce HTTPS everywhere
- HSTS header enabled
- Secure cookie flags: `Secure`, `HttpOnly`, `SameSite`

### Headers

```
Content-Security-Policy: default-src 'self'
X-Content-Type-Options: nosniff
X-Frame-Options: DENY
Referrer-Policy: strict-origin-when-cross-origin
```

### CORS

- Restrict to allowed origins
- No wildcard (`*`) in production
- Validate origin header

## Common Vulnerabilities

### SQL Injection

```python
# ❌ NEVER
query = f"SELECT * FROM users WHERE id = {user_id}"

# ✅ ALWAYS
cursor.execute("SELECT * FROM users WHERE id = %s", (user_id,))
```

### XSS

```javascript
// ❌ NEVER
element.innerHTML = userInput;

// ✅ ALWAYS
element.textContent = userInput;
// Or sanitize: DOMPurify.sanitize(userInput)
```

### Path Traversal

```python
# ❌ NEVER
path = f"/uploads/{filename}"

# ✅ ALWAYS
import os.path
base = "/uploads/"
safe_path = os.path.join(base, os.path.basename(filename))
if not safe_path.startswith(base):
    raise ValueError("Invalid path")
```

## SAST/DAST Tools

| Language | SAST | Dependency Scan |
|----------|------|-----------------|
| Python | Semgrep, Bandit | pip-audit, safety |
| JavaScript | Semgrep | npm audit, snyk |
| Java | Semgrep, CodeQL | dependency-check |
| PHP | Semgrep, Psalm | composer audit |
| Go | Semgrep, gosec | trivy |
| IaC | checkov, tfsec | trivy |

## Pre-commit Hooks

Recommended hooks:

- `gitleaks` — detect secrets
- `trufflehog` — detect credentials
- `trivy` — vulnerability scan
- Language-specific linters
