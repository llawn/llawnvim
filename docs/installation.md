---

title: Installation

description: Step-by-step guide for installing and setting up the LLawn Neovim configuration

icon: material/download

---

# Installation

This guide provides step-by-step instructions for installing and setting up the LLawn Neovim configuration.

## Prerequisites

!!! note "System Requirements"
    - **Neovim**: Version 0.11+ (required for native LSP support)
    - **Git**: For cloning repositories
    - **Flutter SDK**: For Flutter/Dart development (optional)

!!! info "Operating System Support"
    This configuration has been developed and tested on Bluefin OS.

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
:checkhealth  " Check for any issues
:Lazy          " View plugin status
:Mason         " View LSP server status
:LspInfo       " Check LSP client status
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

## Additional Resources

- [Neovim Documentation](https://neovim.io/doc/)
- [Lazy.nvim Documentation](https://lazy.folke.io/)
- [Mason Documentation](https://github.com/williamboman/mason.nvim)
- [LSP Configuration Guide](lsp.md)

## Getting Help

If you encounter issues:

1. **Check this documentation**
2. **Run health checks**: `:checkhealth`
3. **Search existing issues**: [GitHub Issues](https://github.com/llawn/llawnvim/issues)
4. **Create an issue**: Provide Neovim version, OS, and error messages

The configuration is designed to be robust and should work out of the box. 
Most issues can be resolved by ensuring all prerequisites are met and LSP servers are properly installed.
