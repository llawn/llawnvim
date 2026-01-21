---
title: Installation
description: Step-by-step guide for installing and setting up the LLawn Neovim configuration
icon: material/download
---

# Installation

This guide provides step-by-step instructions for installing and setting up the
LLawn Neovim configuration.

## Prerequisites

!!! note "System Requirements"

    - **Neovim**: Version 0.11+ (required for native LSP support)
    - **Git**: For cloning repositories
    - **Flutter SDK**: For Flutter/Dart development (optional)

!!! info "Operating System Support"

    This configuration has been developed and tested on Bluefin OS.

### Advanced Requirements

!!! tip "System Dependencies Check"

    Run these commands to verify your system has the necessary dependencies for full
    functionality:

    ```bash
    # Check for common build tools
    command -v make gcc || echo "Build tools missing - install build-essential or equivalent"

    # Check for ripgrep (used by telescope)
    command -v rg || echo "ripgrep missing - install ripgrep"

    # Check for fd (used by telescope)
    command -v fd || echo "fd missing - install fd-find"

    # Check for python3 and pip
    command -v python3 && python3 -c "import pip" || echo "Python3/pip missing"

    # Check for node.js (for some LSP servers)
    command -v node || echo "Node.js missing - install nodejs"

    # Check for Go (for gopls)
    command -v go || echo "Go missing - install golang"

    # Check for Rust (for some tools)
    command -v cargo || echo "Rust missing - install rust"

    # Check for C compiler
    command -v clang || gcc --version || echo "C compiler missing"

    # Check for mdformat (for documentation formatting)
    command -v mdformat || echo "mdformat missing - install with: pip install mdformat"
    ```

!!! info "CI/CD Integration"

    This repository includes GitHub Actions workflow
    (`.github/workflows/deploy.yml`) that automatically:

    - Builds and validates the MkDocs documentation on tagged releases
    - Deploys the documentation to GitHub Pages
    - Ensures documentation is always up-to-date with code changes

    The workflow runs on Ubuntu with Python 3.x and MkDocs Material, providing
    automated quality checks for the documentation.

!!! info "Release Process"

    The repository includes automated release scripts for managing versions and changelogs.

    To create a new release:

    1. Ensure all changes are committed.
    2. Run the release command:

       ```bash
       make release TAG=0.1.3
       ```

    This will:
    - Generate the changelog from git history
    - Create a signed git tag
    - Update CHANGELOG.md with the new release entry
    - Amend the commit with changelog updates
    - Push the tag and branch to remote

    The release script handles all changelog generation, signing, and pushing automatically.

    For manual changelog updates, use `make changelog`.

## Quick Installation

1. !!! warning "Backup existing config"

    ```bash
    mv ~/.config/nvim ~/.config/nvim.backup 2>/dev/null || true
    ```

2. Clone the configuration

    ```bash
    git clone https://github.com/llawn/llawnvim.git ~/.config/nvim
    ```

3. Start Neovim (plugins will install automatically)

    ```bash
    nvim
    ```

## Initial Setup

### First Launch

1. **Open Neovim**: `nvim`

2. **Install plugins**:

    ```vim
    :Lazy sync
    ```

3. **Wait for installation**: Mason will automatically install LSP servers

4. **Restart Neovim** to ensure everything loads correctly

### Verify Installation

Run these commands to verify the setup:

```vim
:checkhealth              " Check for any issues
:Lazy                      " View plugin status
:Mason                    " View LSP server status
:LspInfo                   " Check LSP client status
:TSInstallInfo             " Check Treesitter parser status
:checkhealth treesitter    " Specific Treesitter health check
:checkhealth which_key     " Check which-key configuration
```

## Configuration

### Environment Variables

#### Flutter Development

Add to your shell profile (`~/.bashrc`, `~/.zshrc`, etc.):

```bash
export FLUTTER_ROOT=/path/to/your/flutter/sdk
export PATH="$PATH:$FLUTTER_ROOT/bin"
```

#### Custom Paths (Optional)

```bash
# Custom Neovim data directory
export XDG_DATA_HOME=~/.local/share

# Custom Neovim config directory
export XDG_CONFIG_HOME=~/.config
```

### Neovim Options

#### Font and Terminal

Ensure your terminal supports:

- **True Color**: For proper color rendering
- **Unicode**: For special characters and icons
- **Font**: A monospace font with programming ligatures (optional)

## Plugin Management

### Updating Plugins

```vim
:Lazy update  " Update all plugins
:Lazy sync    " Sync plugin specifications
```

### Adding New Plugins

1. **Create plugin file** in `lua/llawn/plugins/your_plugin.lua`:

    ```lua
    return {
      "author/plugin-name",
      config = function()
        -- Configuration here
      end
    }
    ```

2. **Sync plugins**:

    ```vim
    :Lazy sync
    ```

### LSP Server Management

```vim
:Mason              " Open Mason UI
:MasonInstallAll    " Install all configured servers
:MasonUpdate        " Update LSP servers
```

## Troubleshooting

### Common Issues

#### Plugins Not Installing

```bash
# Check Lazy status
:Lazy

# Force sync
:Lazy sync
```

#### LSP Servers Not Working

```vim
:LspInfo           " Check LSP status
:Mason             " Verify server installation
:LspRestart        " Restart LSP clients
```

#### Flutter LSP Issues

```bash
# Verify Flutter installation
flutter doctor

# Check FLUTTER_ROOT
echo $FLUTTER_ROOT

# Restart LSP
:LspRestart
```

#### Performance Issues

```vim
:Lazy profile      " Check plugin loading times
:checkhealth       " Run health checks
```

### Log Files

- **Neovim logs**: `~/.local/state/nvim/log`
- **LSP logs**: `~/.local/state/nvim/lsp.log`
- **Mason logs**: `~/.local/state/nvim/mason.log`
- **Luasnip**: `~/.local/state/nvim/luasnip.log`
- **Lazy logs**: `:Lazy log`

## Post-Installation

### Customization

- **Keymaps**: Edit `lua/llawn/config/keymaps.lua`
- **Options**: Modify `lua/llawn/config/options.lua`
- **Theme**: Customize `lua/llawn/plugins/colors.lua`
- **Plugins**: Add to `lua/llawn/plugins/`

### Release Setup

!!! info "Configuring Releases"

    To prepare for releases, ensure GPG signing is configured for commits and tags:

    ```bash
    # Set your GPG signing key
    git config --global user.signingkey YOUR_GPG_KEY_ID

    # Enable commit signing globally
    git config --global commit.gpgsign true
    ```

    The release script uses signed commits and tags for security and verification.

### Makefile Targets

The repository includes a Makefile with useful development targets:

!!! info "Available Make Targets"

    ```bash
    make build      # Build the MkDocs documentation
    make serve      # Serve documentation locally for development
    make clean      # Clean built documentation files
    make changelog  # Generate changelog from git history
    make release    # Create and push a new release tag (usage: make release TAG=<tag-name>)
    make help       # Show available targets

    # Format documentation with mdformat
    mdformat docs/ README.md CONTRIBUTING.md
    ```

    These targets help with documentation maintenance and development workflow.

## Additional Resources

- [Neovim Documentation](https://neovim.io/doc/)
- [Lazy.nvim Documentation](https://lazy.folke.io/)
- [Mason Documentation](https://github.com/williamboman/mason.nvim)
- [LSP Configuration Guide](lsp.md)

## Getting Help

If you encounter issues:

1. **Check this documentation**
2. **Run health checks**: `:checkhealth`
3. **Search existing issues**:
   [GitHub Issues](https://github.com/llawn/llawnvim/issues)
4. **Create an issue**: Provide Neovim version, OS, and error messages

The configuration is designed to be robust and should work out of the box. Most
issues can be resolved by ensuring all prerequisites are met and LSP servers are
properly installed.
