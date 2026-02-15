# DevOps & Infrastructure Rules

Rules for Docker, Kubernetes, Terraform, Ansible, and CI/CD.

## Universal DevOps Rules

### Security Standards

- **CIS Benchmarks** for Docker, Kubernetes, cloud
- **NIST SP 800-190** for container security
- **SLSA** for supply chain integrity

### Key Principles

- Immutable infrastructure (replace, don't modify)
- IaC in separate repo from app code
- Environment parity (dev/staging/prod)
- Declarative over imperative
- GitOps for all infra changes

---

## Docker / Podman

### CIS Controls

- Non-root user mandatory
- Read-only root filesystem
- No privileged containers
- Resource limits defined
- Health checks present

### Dockerfile Rules

```dockerfile
# ❌ NEVER
FROM node:latest
USER root
ENV API_KEY=secret123

# ✅ ALWAYS
FROM node:22-alpine@sha256:abc123...
RUN addgroup -g 1001 app && adduser -u 1001 -G app app
USER app
HEALTHCHECK CMD curl -f http://localhost:3000/health || exit 1
```

### Best Practices

- Pin base images by SHA digest in production
- Multi-stage builds (50-90% size reduction)
- Order layers least→most frequently changed
- Build secrets via `--mount=type=secret`
- Generate SBOM with `trivy` or `syft`

### Validation

- `hadolint` for Dockerfiles
- `docker compose config` for compose files

### Pitfalls

| Issue | Solution |
|-------|----------|
| Separate apt-get update/install | Combine in one RUN layer |
| Secrets in ENV | Use `--mount=type=secret` |
| Running as root | `USER app` with non-root UID |
| No health check | Add `HEALTHCHECK` instruction |

---

## Kubernetes

### CIS Controls

- Pod Security Standards (restricted)
- RBAC least privilege
- Network policies deny-by-default
- etcd encryption
- Audit logging enabled

### Security Context

```yaml
securityContext:
  readOnlyRootFilesystem: true
  allowPrivilegeEscalation: false
  runAsNonRoot: true
  capabilities:
    drop: ["ALL"]
```

### Resource Management

```yaml
resources:
  requests:
    memory: "128Mi"
    cpu: "100m"
  limits:
    memory: "512Mi"
    cpu: "500m"
```

### Required Configurations

- Always set `requests` and `limits`
- Network policies with deny-by-default
- Pod Disruption Budgets for production
- `imagePullPolicy: IfNotPresent`

### Secrets

- Sealed Secrets or External Secrets Operator
- Never in Git or ConfigMaps

### Validation

- `kubeconform` or `kubectl --dry-run=server`

### Pitfalls

| Issue | Solution |
|-------|----------|
| No resource limits | Always set requests and limits |
| `:latest` tag | Use SHA digests |
| Secrets in ConfigMaps | Use Kubernetes Secrets |
| No network policy | Deny-by-default, allowlist traffic |
| No PDB | Add Pod Disruption Budgets |

---

## Terraform / OpenTofu

### Version

- **Terraform 1.7+** or **OpenTofu 1.7+**

### State Management

- Remote state (S3+DynamoDB, Azure Blob, TF Cloud)
- State locking enabled
- Encryption at rest
- Separate state per environment

### Module Structure

```
main.tf
variables.tf
outputs.tf
versions.tf
```

### Key Rules

- `import` blocks for adopting existing infra
- `removed` blocks for safe removal from state
- `terraform test` for module validation
- `prevent_destroy` on stateful resources
- `for_each` over `count` for collections

### Secrets

- Never commit `.tfvars` with secrets
- Use `TF_VAR_*` env vars or Vault
- Mark sensitive outputs

### Validation

```bash
terraform fmt -check
terraform validate
tflint
checkov
```

### Pitfalls

| Issue | Solution |
|-------|----------|
| No `prevent_destroy` on DBs | Always protect stateful resources |
| `count` for collections | Use `for_each` for stable identity |
| Hardcoded AMI IDs | Use `data` sources |
| Modifying released state | Use `moved` blocks for refactoring |

---

## Ansible

### Requirements

- All playbooks idempotent
- Ansible Vault for sensitive variables
- `become: yes` with documented justification

### Performance

- `gather_facts: no` when unneeded
- SSH pipelining for 2-5x speedup
- Tune `forks` for parallelism

### Validation

- `ansible-lint`
- `ansible-playbook --check --diff`
- `molecule` for role testing

### Pitfalls

| Issue | Solution |
|-------|----------|
| `shell` without `creates` | Use native modules for idempotency |
| Undocumented `become` | Comment why privilege escalation needed |
| Secrets in plaintext | Use Ansible Vault |
| No `--check` before apply | Always dry-run in CI |

---

## CI/CD Pipeline

### Security Scanning

| Stage | Tools |
|-------|-------|
| SAST | Semgrep, CodeQL |
| SCA | Dependabot, Snyk, trivy |
| Secrets | gitleaks, trufflehog |
| Container | trivy, grype |
| IaC | checkov, tfsec, terrascan |

### Pipeline Stages

```yaml
stages:
  - lint
  - test
  - security-scan
  - build
  - deploy-staging
  - integration-test
  - deploy-production
```

### Quality Gates

- Block merge on:
  - Failed tests
  - Critical/high CVEs
  - Secrets detected
  - Linting errors

---

## Supply Chain Security (SLSA)

### Requirements

- Sign container images (cosign/Notary)
- Verify signatures before deployment
- Generate SBOM for all images
- Provenance attestation (SLSA Level 2+)
- Pin all dependencies

### Tools

- **Signing**: cosign, Notary
- **SBOM**: syft, trivy
- **Scanning**: trivy, grype, snyk
- **Attestation**: SLSA verifier

---

## Observability

### Stack

- OpenTelemetry Collector for unified telemetry
- Export to Grafana stack (Loki/Tempo/Mimir)
- Or cloud-native backends

### Metrics

- Request rate, error rate, latency (P50/P95/P99)
- Alert on: error rate >1%, P99 >500ms

### Logging

- Structured JSON logs
- Trace/span IDs for correlation
- Never log sensitive data

---

## Common Pitfalls

| Domain | Issue | Solution |
|--------|-------|----------|
| Docker | Root user | `USER app` with non-root UID |
| K8s | No limits | Always define requests and limits |
| Terraform | Local state | Use remote state with locking |
| Ansible | Non-idempotent | Use native modules |
| CI/CD | No security scan | Add SAST/SCA to pipeline |
