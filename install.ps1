<#
.SYNOPSIS
    Installation script for kilo-glm5-instructions

.DESCRIPTION
    This script sets up symlinks for the GLM-5 instructions repository
    when used as a git submodule with the Kilo VS Code extension.

    Note: Creating symlinks on Windows may require Administrator privileges.
    On Windows 10+ with Developer Mode enabled, symlinks can be created
    without admin privileges.

.USAGE
    From your project root in PowerShell, run:
    .\.kilocode\glm5-instructions\install.ps1

    Or specify a custom submodule path:
    $env:SUBMODULE_PATH=".kilocode\instructions"; .\install.ps1

.PARAMETER SubmodulePath
    Optional path to the submodule directory (relative to project root)

.PARAMETER Force
    Force overwrite of existing files without prompting

.EXAMPLE
    .\install.ps1
    .\install.ps1 -SubmodulePath ".kilocode\instructions"
    .\install.ps1 -Force
#>

[CmdletBinding()]
param(
    [string]$SubmodulePath = "",
    [switch]$Force = $false
)

# Helper functions
function Write-Info {
    param([string]$Message)
    Write-Host "[INFO] " -ForegroundColor Blue -NoNewline
    Write-Host $Message
}

function Write-Success {
    param([string]$Message)
    Write-Host "[SUCCESS] " -ForegroundColor Green -NoNewline
    Write-Host $Message
}

function Write-Warning {
    param([string]$Message)
    Write-Host "[WARNING] " -ForegroundColor Yellow -NoNewline
    Write-Host $Message
}

function Write-Error {
    param([string]$Message)
    Write-Host "[ERROR] " -ForegroundColor Red -NoNewline
    Write-Host $Message
}

function Test-Administrator {
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = [Security.Principal.WindowsPrincipal]$currentUser
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

function New-Symlink {
    param(
        [string]$Path,
        [string]$Target
    )
    
    # On Windows, we need to create directory junctions or symlinks
    # Junctions don't require admin rights and work well for directories
    
    $targetType = if (Test-Path -Path $Target -PathType Container) { "Directory" } else { "File" }
    
    if ($targetType -eq "Directory") {
        # Use junction for directories (doesn't require admin)
        # Or use symbolic link if we have admin rights
        if (Test-Administrator) {
            New-Item -ItemType SymbolicLink -Path $Path -Target $Target -Force | Out-Null
        }
        else {
            # Try symlink first, fall back to junction
            try {
                New-Item -ItemType SymbolicLink -Path $Path -Target $Target -Force -ErrorAction Stop | Out-Null
            }
            catch {
                # Fall back to junction
                Write-Info "Using directory junction instead of symlink (no admin privileges)"
                New-Item -ItemType Junction -Path $Path -Target $Target -Force | Out-Null
            }
        }
    }
    else {
        New-Item -ItemType SymbolicLink -Path $Path -Target $Target -Force | Out-Null
    }
}

# Main script
Write-Info "GLM-5 Instructions Installer for Kilo Code"
Write-Host "============================================"
Write-Host ""

# Determine script location
$ScriptDir = $PSScriptRoot
if ([string]::IsNullOrEmpty($ScriptDir)) {
    $ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
}

# Determine project root
# Try git first, then fall back to parent directory assumptions
$ProjectRoot = $null

try {
    $gitRoot = git rev-parse --show-toplevel 2>$null
    if ($LASTEXITCODE -eq 0 -and $gitRoot) {
        $ProjectRoot = $gitRoot.Trim()
    }
}
catch {
    # Git not available or not in a repo
}

if (-not $ProjectRoot) {
    # Assume script is in a submodule under .kilocode/
    $ProjectRoot = (Get-Item "$ScriptDir\..\..").FullName
}

# Allow override via parameter or environment variable
if ([string]::IsNullOrEmpty($SubmodulePath)) {
    $SubmodulePath = $env:SUBMODULE_PATH
}

# Determine the relative path from project root to submodule
$KilocodeSubmodule = $ScriptDir
if (-not [string]::IsNullOrEmpty($SubmodulePath)) {
    $KilocodeSubmodule = Join-Path $ProjectRoot $SubmodulePath
}

$KilocodeDir = Join-Path $ProjectRoot ".kilocode"

Write-Info "Script directory: $ScriptDir"
Write-Info "Project root: $ProjectRoot"
Write-Info "Target .kilocode directory: $KilocodeDir"
Write-Host ""

# Verify we're in a valid submodule location
$RulesDir = Join-Path $ScriptDir "rules"
$TemplatesDir = Join-Path $ScriptDir "templates"

if (-not (Test-Path -Path $RulesDir -PathType Container)) {
    Write-Error "Cannot find 'rules' directory in $ScriptDir"
    Write-Error "Please ensure this script is run from the kilo-glm5-instructions repository"
    exit 1
}

if (-not (Test-Path -Path $TemplatesDir -PathType Container)) {
    Write-Error "Cannot find 'templates' directory in $ScriptDir"
    Write-Error "Please ensure this script is run from the kilo-glm5-instructions repository"
    exit 1
}

# Check for symlink privileges
$symlinkTestPath = Join-Path $env:TEMP "symlink_test_$(Get-Random)"
$symlinkTestTarget = Join-Path $env:TEMP "symlink_test_target_$(Get-Random)"

try {
    New-Item -ItemType Directory -Path $symlinkTestTarget -Force | Out-Null
    New-Item -ItemType SymbolicLink -Path $symlinkTestPath -Target $symlinkTestTarget -Force | Out-Null
    Remove-Item -Path $symlinkTestPath -Force
    Remove-Item -Path $symlinkTestTarget -Force
}
catch {
    Write-Warning "Cannot create symlinks without Administrator privileges"
    Write-Warning "Please either:"
    Write-Warning "  1. Run PowerShell as Administrator"
    Write-Warning "  2. Enable Developer Mode in Windows Settings"
    Write-Warning "The script will attempt to use junctions instead, which may work without admin rights"
    Write-Host ""
}

# Create .kilocode directory if it doesn't exist
if (-not (Test-Path -Path $KilocodeDir -PathType Container)) {
    Write-Info "Creating .kilocode directory..."
    New-Item -ItemType Directory -Path $KilocodeDir -Force | Out-Null
    Write-Success "Created $KilocodeDir"
}

# Function to handle existing files/directories
function Handle-Existing {
    param(
        [string]$Path,
        [string]$Type
    )
    
    if (Test-Path -Path $Path) {
        $item = Get-Item -Path $Path
        
        if ($item.LinkType) {
            # It's a symlink or junction
            Write-Info "Found existing $($item.LinkType) at $Path"
            
            # Remove it so we can create a new one
            Remove-Item -Path $Path -Force -Recurse
            Write-Success "Removed existing $($item.LinkType)"
        }
        else {
            # It's a real file or directory
            Write-Warning "Found existing $Type at $Path"
            
            if (-not $Force) {
                $response = Read-Host "Backup and replace? (Y/n)"
                if ($response -eq 'n' -or $response -eq 'N') {
                    Write-Warning "Skipping $Path"
                    return $false
                }
            }
            
            # Create backup
            $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
            $backup = "${Path}.backup.${timestamp}"
            Move-Item -Path $Path -Destination $backup -Force
            Write-Success "Backed up to: $backup"
        }
    }
    
    return $true
}

# Install rules symlink
Write-Host ""
Write-Info "Setting up rules symlink..."

$RulesTarget = Join-Path $KilocodeDir "rules"

if (Handle-Existing -Path $RulesTarget -Type "directory") {
    try {
        New-Symlink -Path $RulesTarget -Target $RulesDir
        Write-Success "Created symlink: $RulesTarget -> $RulesDir"
    }
    catch {
        Write-Error "Failed to create rules symlink: $_"
        Write-Info "You may need to run as Administrator or enable Developer Mode"
    }
}

# Install templates symlink
Write-Host ""
Write-Info "Setting up templates symlink..."

$TemplatesTarget = Join-Path $KilocodeDir "templates"

if (Handle-Existing -Path $TemplatesTarget -Type "directory") {
    try {
        New-Symlink -Path $TemplatesTarget -Target $TemplatesDir
        Write-Success "Created symlink: $TemplatesTarget -> $TemplatesDir"
    }
    catch {
        Write-Error "Failed to create templates symlink: $_"
        Write-Info "You may need to run as Administrator or enable Developer Mode"
    }
}

# Copy agents.md to project root (not symlinked - users should customize)
Write-Host ""
Write-Info "Setting up agents.md..."

$AgentsSource = Join-Path $ScriptDir "agents.md"
$AgentsTarget = Join-Path $ProjectRoot "agents.md"

if (Test-Path -Path $AgentsSource) {
    if (Test-Path -Path $AgentsTarget) {
        $item = Get-Item -Path $AgentsTarget
        
        if ($item.LinkType) {
            Write-Warning "Found symlink at $AgentsTarget - replacing with copy"
            Remove-Item -Path $AgentsTarget -Force
        }
        else {
            $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
            $backup = "${AgentsTarget}.backup.${timestamp}"
            Move-Item -Path $AgentsTarget -Destination $backup -Force
            Write-Success "Backed up existing agents.md to: $backup"
        }
    }
    
    Copy-Item -Path $AgentsSource -Destination $AgentsTarget -Force
    Write-Success "Copied agents.md to project root"
    Write-Info "You can customize this file for your project's specific needs"
}

# Print summary
Write-Host ""
Write-Host "============================================"
Write-Success "Installation complete!"
Write-Host ""
Write-Host "Installed components:"
Write-Host "  * Rules:     $KilocodeDir\rules\"
Write-Host "  * Templates: $KilocodeDir\templates\"
Write-Host "  * Agents:    $ProjectRoot\agents.md"
Write-Host ""
Write-Host "The Kilo VS Code extension will automatically detect these files."
Write-Host ""
Write-Info "To update instructions in the future:"
Write-Host "  git submodule update --remote"
Write-Host ""
Write-Info "To customize rules for your project:"
Write-Host "  Edit files in $KilocodeDir\rules\"
Write-Host ""