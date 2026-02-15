# Scripting Rules

Rules for Bash and PowerShell scripting with security focus.

## Universal Scripting Rules

### Security Standards

- **CWE/SANS Top 25** (relevant entries)
- **CIS Benchmarks** for OS hardening scripts

### Key Risks

| CWE | Risk | Prevention |
|-----|------|------------|
| CWE-78 | OS Command Injection | Never pass unsanitized input to `eval` |
| CWE-22 | Path Traversal | Validate and canonicalize paths |
| CWE-377 | Insecure Temp Files | Use `mktemp` / `GetTempFileName()` |
| CWE-269 | Privilege Escalation | Document why elevated |
| CWE-312 | Cleartext Storage | Never store secrets in variables |

### Universal Checklist

- [ ] Strict mode enabled
- [ ] Variables quoted/validated
- [ ] Exit codes checked
- [ ] Help/usage function exists
- [ ] Script is idempotent
- [ ] Errors go to stderr
- [ ] Static analysis passes

---

## Bash

### Preamble (MANDATORY)

```bash
#!/usr/bin/env bash
# Description: Brief description
# Usage: ./script.sh [options] <required-arg>
# Requirements: curl, jq

set -euo pipefail
IFS=$'\n\t'

[[ "${DEBUG:-0}" == "1" ]] && set -x
```

### Key Rules

- Use `[[ ]]` over `[ ]` for conditionals
- Quote all variables: `"$var"`, `"${files[@]}"`
- Use arrays for file lists: `files=(*.txt)`
- Trap for cleanup: `trap 'rm -f "$tmpfile"' EXIT`
- Check commands: `command -v docker &>/dev/null || exit 1`
- Idempotent: Check before creating

### Argument Parsing

```bash
while [[ $# -gt 0 ]]; do
  case "$1" in
    --help) usage; exit 0 ;;
    --input) input="$2"; shift 2 ;;
    *) echo "Unknown: $1" >&2; exit 1 ;;
  esac
done
```

### Error Handling

```bash
# ❌ NEVER
cd /dir

# ✅ ALWAYS
cd /dir || { echo "Failed to cd" >&2; exit 1; }
```

### File Operations

```bash
# ❌ NEVER
for f in $(ls *.txt); do

# ✅ ALWAYS
for f in *.txt; do
```

### Testing

- **Framework**: BATS
- **Static Analysis**: ShellCheck

```bash
# BATS test
@test "function returns 0" {
  run my_function "arg"
  [ "$status" -eq 0 ]
}
```

### Pitfalls

| Issue | Solution |
|-------|----------|
| Unquoted variables | Always `"$var"` |
| Bare `cd /dir` | `cd /dir || exit 1` |
| Parsing `ls` output | Use globs: `for f in *.txt` |
| No cleanup on exit | Add `trap` for cleanup |

---

## PowerShell

### Preamble (MANDATORY)

```powershell
<#
.SYNOPSIS
    Brief description
.PARAMETER InputPath
    Description of parameter
.EXAMPLE
    .\script.ps1 -InputPath "C:\data\input.txt"
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)]
    [ValidateScript({Test-Path $_})]
    [string]$InputPath
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
```

### Key Rules

- Verb-Noun naming: `Get-UserData`, `Set-Configuration`
- `[CmdletBinding()]` for `-Verbose`, `-WhatIf` support
- Parameter validation: `[ValidateNotNullOrEmpty()]`, `[ValidateSet()]`
- Try-Catch with `-ErrorAction Stop`
- Return objects (PSCustomObject), not strings
- `SupportsShouldProcess` for destructive operations

### Cross-Platform

```powershell
# Platform detection
if ($IsWindows) { }
elseif ($IsLinux) { }
elseif ($IsMacOS) { }

# Paths
Join-Path $dir $file
```

### Error Handling

```powershell
# ❌ NEVER
Get-Content $file

# ✅ ALWAYS
try {
    Get-Content $file -ErrorAction Stop
}
catch {
    Write-Error "Failed to read: $_"
    exit 1
}
```

### Comparison Operators

```powershell
# ❌ NEVER
if ($value == "test")

# ✅ ALWAYS
if ($value -eq "test")
```

### Testing

- **Framework**: Pester
- **Static Analysis**: PSScriptAnalyzer

```powershell
# Pester test
Describe "Get-UserData" {
    It "returns user object" {
        $result = Get-UserData -Id 1
        $result.Name | Should -Be "Test User"
    }
}
```

### Pitfalls

| Issue | Solution |
|-------|----------|
| Missing `-ErrorAction Stop` | Non-terminating errors silently continue |
| Using `==` for comparison | PowerShell uses `-eq`, `-gt`, `-like` |
| No `SupportsShouldProcess` | Add for safe `-WhatIf` testing |

---

## Security Checklist

### Input Validation

- Validate all arguments
- Allowlist, don't blocklist
- Reject `..` sequences in paths

### Secrets

- Accept via environment variables or stdin
- Never as CLI arguments (visible in `ps`)
- Never log sensitive values
- Redact in error messages

### File Permissions

- Bash: `umask 077`
- PowerShell: `icacls` for restrictive permissions

### Command Execution

- Never `eval` or `Invoke-Expression` with user input
- If unavoidable, validate against strict allowlist
- Use arrays for command construction

---

## SAST Tools

| Language | Tool |
|----------|------|
| Bash | ShellCheck |
| PowerShell | PSScriptAnalyzer |

### ShellCheck Integration

```bash
# Run in CI
shellcheck -s bash script.sh
```

### PSScriptAnalyzer Integration

```powershell
# Run in CI
Invoke-ScriptAnalyzer -Path .\script.ps1
```

---

## Examples

### Secure Temp File (Bash)

```bash
tmpfile=$(mktemp) || exit 1
trap 'rm -f "$tmpfile"' EXIT
echo "data" > "$tmpfile"
```

### Secure Temp File (PowerShell)

```powershell
$tmpfile = [System.IO.Path]::GetTempFileName()
try {
    "data" | Out-File $tmpfile
}
finally {
    Remove-Item $tmpfile -ErrorAction SilentlyContinue
}
```

### Validated Path (Bash)

```bash
canonical=$(realpath -m "$user_path")
if [[ "$canonical" != /allowed/path/* ]]; then
    echo "Invalid path" >&2
    exit 1
fi
```

### Validated Path (PowerShell)

```powershell
$resolved = (Resolve-Path $userPath -ErrorAction Stop).Path
if ($resolved -notlike "C:\Allowed\Path\*") {
    throw "Invalid path"
}
```
