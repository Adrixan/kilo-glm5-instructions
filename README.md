# GLM-5 Instructions for Kilo Code

Optimized instruction set for the GLM-5 model, designed for use with the [Kilo VS Code extension](https://github.com/kilocode/kilo). These instructions are adapted from copilot-instructions for token efficiency while maintaining security and quality standards.

## What This Repository Provides

- **Domain-specific coding rules** - Comprehensive rules for security, accessibility, frontend, backend, DevOps, and scripting
- **Project templates** - Ready-to-use templates for project state tracking
- **Agent configuration** - Pre-configured agent settings for project-level customization
- **Custom instructions** - IDE-wide custom instructions for GLM-5 optimization

## Installation

### Prerequisites

- [Git](https://git-scm.com/) installed
- [Kilo VS Code extension](https://marketplace.visualstudio.com/items?itemName=kilocode.kilocode) installed
- For Windows: PowerShell 5.1+ or PowerShell Core 7+

### Method 1: Git Submodule (Recommended)

Using this repository as a git submodule allows you to easily update the instructions across all your projects with a single command.

#### Linux / macOS

```bash
# Navigate to your project
cd /path/to/your/project

# Add the submodule
git submodule add https://github.com/Adrixan/kilo-glm5-instructions.git .kilocode/glm5-instructions

# Run the installation script
./.kilocode/glm5-instructions/install.sh
```

#### Windows (PowerShell)

```powershell
# Navigate to your project
cd C:\path\to\your\project

# Add the submodule
git submodule add https://github.com/Adrixan/kilo-glm5-instructions.git .kilocode/glm5-instructions

# Run the installation script
.\.kilocode\glm5-instructions\install.ps1
```

**Note for Windows users:** Creating symlinks on Windows may require:

- Administrator privileges, OR
- Developer Mode enabled in Windows Settings (Windows 10+)

If you encounter permission errors, try running PowerShell as Administrator.

### Method 2: Manual Copy

If you prefer not to use submodules, you can manually copy the files:

```bash
# Clone the repository
git clone https://github.com/Adrixan/kilo-glm5-instructions.git

# Copy rules to your project
cp -r kilo-glm5-instructions/rules/ /your/project/.kilocode/rules/

# Copy templates
cp -r kilo-glm5-instructions/templates/ /your/project/.kilocode/templates/

# Copy agents.md to project root (optional)
cp kilo-glm5-instructions/agents.md /your/project/
```

### Method 3: Global Installation

To use these instructions across all your projects:

```bash
# Copy to your home directory
cp -r kilo-glm5-instructions/rules/ ~/.kilocode/rules/
cp -r kilo-glm5-instructions/templates/ ~/.kilocode/templates/
```

### Method 4: Custom Instructions (IDE-wide)

For IDE-wide custom instructions that apply to all modes:

1. Open Kilo Code extension in VS Code
2. Navigate to the Modes Tab (organization icon)
3. Find "Custom Instructions for All Modes"
4. Paste the contents of `custom-instructions.md`

## What Gets Installed

The installation script creates the following structure:

```
your-project/
├── .kilocode/
│   ├── glm5-instructions/     # Git submodule
│   ├── rules/                 # Symlink → glm5-instructions/rules/
│   └── templates/             # Symlink → glm5-instructions/templates/
├── agents.md                  # Copied (can be customized)
└── .gitmodules                # Tracks the submodule
```

## Updating the Submodule

To update to the latest version of the instructions:

```bash
# Update the submodule to the latest commit
git submodule update --remote .kilocode/glm5-instructions

# Or update to a specific version
cd .kilocode/glm5-instructions
git checkout v1.0.0  # or any tag/commit
cd ../..
git add .kilocode/glm5-instructions
```

## Repository Structure

```
kilo-glm5-instructions/
├── README.md                    # This file
├── LICENSE                      # GNU AGPL v3
├── install.sh                   # Unix installation script
├── install.ps1                  # Windows installation script
├── custom-instructions.md       # IDE-wide custom instructions
├── agents.md                    # Project-level agent config
├── rules/                       # Kilo Code rules directory
│   ├── main.md                  # Core orchestrator rules
│   ├── security.md              # Security requirements
│   ├── accessibility.md         # WCAG compliance
│   ├── backend.md               # Backend development
│   ├── frontend.md              # Frontend development
│   ├── devops.md                # DevOps/IaC
│   ├── scripting.md             # Bash/PowerShell
│   └── code-mode.md             # Code mode specific rules
└── templates/                   # Project templates
    └── project-state.md         # State tracking template
```

## Rule Loading Priority

The Kilo extension loads rules in the following priority order:

1. **Global rules**: `~/.kilocode/rules/` - User-wide defaults
2. **Project rules**: `.kilocode/rules/` - Repository-specific rules
3. **Mode-specific**: `.kilocode/rules-{mode}/` - Mode-specific overrides

## Customization

### Customizing Rules

Edit the files in `.kilocode/rules/` to match your project needs:

```bash
# Edit a specific rule file
nano .kilocode/rules/security.md
```

Since the rules directory is a symlink to the submodule, your customizations will be tracked in the submodule. To preserve customizations across updates:

1. Fork this repository
2. Add your fork as the submodule instead
3. Commit your changes to your fork

### Customizing Agents

The `agents.md` file is copied (not symlinked) to your project root, allowing you to customize it freely:

```bash
# Edit agents configuration
nano agents.md
```

## GLM-5 Optimizations

These instructions are optimized for the GLM-5 model:

- **Condensed XML tags** → Markdown headers
- **Verbose explanations** → Bullet points
- **Redundant sections** → Merged
- **Examples inline** → Referenced separately
- **Token reduction**: ~40% while preserving all rules

## Troubleshooting

### Symlink Permission Denied (Windows)

If you get permission errors when creating symlinks on Windows:

1. **Option A**: Run PowerShell as Administrator
2. **Option B**: Enable Developer Mode:
   - Open Windows Settings
   - Go to Update & Security → For developers
   - Enable "Developer Mode"

### Submodule Not Loading

If the Kilo extension doesn't detect the rules:

1. Verify the symlink exists: `ls -la .kilocode/rules`
2. Check the symlink target: `readlink .kilocode/rules`
3. Ensure the target directory contains `.md` files

### Existing Rules Conflict

If you have existing rules in `.kilocode/rules/`:

- The install script will back them up automatically
- Backups are named with timestamps: `rules.backup.20240115_120000`

### Git Submodule Issues

If the submodule isn't updating:

```bash
# Reinitialize the submodule
git submodule deinit -f .kilocode/glm5-instructions
git submodule update --init --remote
```

## Contributing

Contributions are welcome! Please:

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

## License

This project is licensed under the GNU Affero General Public License v3.0 - see the [LICENSE](LICENSE) file for details.

## Related Resources

- [Kilo VS Code Extension](https://github.com/kilocode/kilo)
- [Kilo Documentation](https://docs.kilocode.ai)
- [Git Submodules Guide](https://git-scm.com/book/en/v2/Git-Tools-Submodules)
