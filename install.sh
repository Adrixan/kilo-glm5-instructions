#!/bin/bash
#
# install.sh - Installation script for kilo-glm5-instructions
#
# This script sets up symlinks for the GLM-5 instructions repository
# when used as a git submodule with the Kilo VS Code extension.
#
# Usage:
#   From your project root, run:
#   ./.kilocode/glm5-instructions/install.sh
#
# Or specify a custom submodule path:
#   SUBMODULE_PATH=.kilocode/instructions ./install.sh
#

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Helper functions
info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

warn() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1" >&2
}

# Determine script location
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Determine project root
# Try git first, then fall back to parent directory assumptions
PROJECT_ROOT="$(git rev-parse --show-toplevel 2>/dev/null)" || PROJECT_ROOT=""
if [ -z "$PROJECT_ROOT" ]; then
    # Assume script is in a submodule under .kilocode/
    # Go up until we're outside the submodule directory
    PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
fi

# Allow override via environment variable
SUBMODULE_PATH="${SUBMODULE_PATH:-}"

# Determine the relative path from project root to submodule
if [ -n "$SUBMODULE_PATH" ]; then
    KILOCODE_SUBMODULE="$PROJECT_ROOT/$SUBMODULE_PATH"
else
    # Try to detect submodule path automatically
    RELATIVE_PATH="${SCRIPT_DIR#$PROJECT_ROOT/}"
    KILOCODE_SUBMODULE="$SCRIPT_DIR"
fi

KILOCODE_DIR="$PROJECT_ROOT/.kilocode"

info "GLM-5 Instructions Installer for Kilo Code"
echo "============================================"
echo ""
info "Script directory: $SCRIPT_DIR"
info "Project root: $PROJECT_ROOT"
info "Target .kilocode directory: $KILOCODE_DIR"
echo ""

# Verify we're in a valid submodule location
if [ ! -d "$SCRIPT_DIR/rules" ]; then
    error "Cannot find 'rules' directory in $SCRIPT_DIR"
    error "Please ensure this script is run from the kilo-glm5-instructions repository"
    exit 1
fi

if [ ! -d "$SCRIPT_DIR/templates" ]; then
    error "Cannot find 'templates' directory in $SCRIPT_DIR"
    error "Please ensure this script is run from the kilo-glm5-instructions repository"
    exit 1
fi

# Create .kilocode directory if it doesn't exist
if [ ! -d "$KILOCODE_DIR" ]; then
    info "Creating .kilocode directory..."
    mkdir -p "$KILOCODE_DIR"
    success "Created $KILOCODE_DIR"
fi

# Calculate relative path from .kilocode to submodule for portable symlinks
# This makes the symlinks work across different machines
get_relative_path() {
    local from="$1"
    local to="$2"
    
    # Use realpath if available, otherwise fall back to absolute paths
    if command -v realpath &>/dev/null; then
        realpath --relative-to="$from" "$to" 2>/dev/null || echo "$to"
    else
        # Fall back to absolute path
        echo "$to"
    fi
}

# Function to handle existing files/directories
handle_existing() {
    local target="$1"
    local type="$2"  # "file" or "directory"
    
    if [ -L "$target" ]; then
        # It's a symlink, check if it points to the right place
        local current_target
        current_target="$(readlink "$target")"
        info "Found existing symlink at $target -> $current_target"
        
        # Remove it so we can create a new one
        rm "$target"
        success "Removed existing symlink"
        
    elif [ -e "$target" ]; then
        # It's a real file or directory
        warn "Found existing $type at $target"
        
        # Create backup
        local backup="${target}.backup.$(date +%Y%m%d_%H%M%S)"
        mv "$target" "$backup"
        success "Backed up to: $backup"
    fi
}

# Install rules symlink
install_rules() {
    local target="$KILOCODE_DIR/rules"
    local source="$SCRIPT_DIR/rules"
    
    info "Setting up rules symlink..."
    
    handle_existing "$target" "directory"
    
    # Create relative symlink for portability
    local relative_source
    relative_source="$(get_relative_path "$KILOCODE_DIR" "$source")"
    
    ln -s "$relative_source" "$target"
    success "Created symlink: $target -> $relative_source"
}

# Install templates symlink
install_templates() {
    local target="$KILOCODE_DIR/templates"
    local source="$SCRIPT_DIR/templates"
    
    info "Setting up templates symlink..."
    
    handle_existing "$target" "directory"
    
    # Create relative symlink for portability
    local relative_source
    relative_source="$(get_relative_path "$KILOCODE_DIR" "$source")"
    
    ln -s "$relative_source" "$target"
    success "Created symlink: $target -> $relative_source"
}

# Copy agents.md to project root (not symlinked - users should customize)
install_agents() {
    local target="$PROJECT_ROOT/agents.md"
    local source="$SCRIPT_DIR/agents.md"
    
    info "Setting up agents.md..."
    
    if [ -f "$target" ]; then
        if [ -L "$target" ]; then
            warn "Found symlink at $target - replacing with copy"
            rm "$target"
        else
            # Create backup
            local backup="${target}.backup.$(date +%Y%m%d_%H%M%S)"
            mv "$target" "$backup"
            success "Backed up existing agents.md to: $backup"
        fi
    fi
    
    cp "$source" "$target"
    success "Copied agents.md to project root"
    info "You can customize this file for your project's specific needs"
}

# Main installation
echo ""
install_rules
echo ""
install_templates
echo ""
install_agents

# Print summary
echo ""
echo "============================================"
success "Installation complete!"
echo ""
echo "Installed components:"
echo "  • Rules:     $KILOCODE_DIR/rules/"
echo "  • Templates: $KILOCODE_DIR/templates/"
echo "  • Agents:    $PROJECT_ROOT/agents.md"
echo ""
echo "The Kilo VS Code extension will automatically detect these files."
echo ""
info "To update instructions in the future:"
echo "  git submodule update --remote"
echo ""
info "To customize rules for your project:"
echo "  Edit files in $KILOCODE_DIR/rules/"
echo ""
