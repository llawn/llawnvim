# Installation

This guide provides step-by-step instructions for installing and setting up the LLawn Neovim configuration.

## 📋 Prerequisites

### System Requirements
- **Neovim**: Version 0.11+ (required for native LSP support)
- **Git**: For cloning repositories
- **curl/wget**: For downloading plugins
- **Node.js**: For some LSP servers and tools (optional)
- **Python**: For Python LSP servers (optional)
- **Go**: For Go development (optional)
- **Flutter SDK**: For Flutter/Dart development (optional)

### Operating System Support
- **Linux**: Fully supported
- **macOS**: Should work (untested)
- **Windows**: May require WSL or adjustments

## 🚀 Quick Installation

### Method 1: Direct Clone (Recommended)
```bash
# Backup existing Neovim config if it exists
mv ~/.config/nvim ~/.config/nvim.backup 2>/dev/null || true

# Clone the configuration
git clone https://github.com/llawn/nvimconfig.git ~/.config/nvim

# Start Neovim (plugins will install automatically)
nvim
```

### Method 2: Manual Setup
If you prefer to set up manually:

1. **Clone the repository**:
   ```bash
   git clone https://github.com/llawn/nvimconfig.git ~/nvimconfig
   ```

2. **Copy configuration**:
   ```bash
   cp -r ~/nvimconfig/* ~/.config/nvim/
   rm -rf ~/nvimconfig
   ```

## 🔧 Initial Setup

### First Launch
1. **Open Neovim**:
   ```bash
   nvim
   ```

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

## 🛠️ Language-Specific Setup

### C/C++ Development
```bash
# Install clangd (usually handled by Mason)
# On Ubuntu/Debian:
sudo apt install clangd

# On macOS:
brew install llvm

# On Arch Linux:
sudo pacman -S clang
```

### Python Development
```bash
# Install Python LSP servers (Mason handles most)
pip install pyright ruff  # Alternative to ty/ruff

# Or using conda/pipenv/virtualenv as preferred
```

### Go Development
```bash
# Install Go (if not already installed)
# On Ubuntu/Debian:
sudo apt install golang-go

# On macOS:
brew install go

# Install gopls (handled by Mason)
```

### Flutter/Dart Development
```bash
# Install Flutter SDK
git clone https://github.com/flutter/flutter.git -b stable ~/flutter
export PATH="$PATH:~/flutter/bin"

# Add to shell profile (~/.bashrc, ~/.zshrc, etc.):
export FLUTTER_ROOT=~/flutter
export PATH="$PATH:$FLUTTER_ROOT/bin"

# Verify installation
flutter doctor
```

### Lua Development
```bash
# Install Lua LSP (handled by Mason)
# Additional tools if needed:
sudo apt install lua5.1 luarocks  # Linux
brew install lua luarocks         # macOS
```

### Fortran Development
```bash
# Install Fortran compiler
# On Ubuntu/Debian:
sudo apt install gfortran

# On macOS:
brew install gcc

# fortls will be installed by Mason
```

## ⚙️ Configuration

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

#### Terminal Configuration
```bash
# Set TERM variable if needed
export TERM=xterm-256color

# Enable true color support
export COLORTERM=truecolor
```

## 🔌 Plugin Management

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

## 🐛 Troubleshooting

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
- **LSP logs**: `:lua vim.lsp.set_log_level('debug')` then check logs
- **Lazy logs**: `:Lazy log`

### Reset Configuration
If you need to start fresh:
```bash
# Backup current config
mv ~/.config/nvim ~/.config/nvim.backup

# Reinstall
git clone https://github.com/llawn/nvimconfig.git ~/.config/nvim
```

## 🎯 Post-Installation

### Recommended Tools
```bash
# Install additional tools as needed
sudo apt install ripgrep fd-find  # For faster file searching
pip install neovim               # Python support for plugins
npm install -g neovim            # Node.js support for plugins
```

### Customization
- **Keymaps**: Edit `lua/llawn/config/keymaps.lua`
- **Options**: Modify `lua/llawn/config/options.lua`
- **Colors**: Customize `lua/llawn/plugins/colors.lua`
- **Plugins**: Add to `lua/llawn/plugins/`

### Testing
Run through these checks:
1. **File opening**: Open various file types
2. **LSP features**: Test completion, diagnostics, navigation
3. **Plugin functions**: Try Telescope, Harpoon, LazyGit
4. **Keymaps**: Verify all mappings work as expected

## 📚 Additional Resources

- [Neovim Documentation](https://neovim.io/doc/)
- [Lazy.nvim Documentation](https://lazy.folke.io/)
- [Mason Documentation](https://github.com/williamboman/mason.nvim)
- [LSP Configuration Guide](lsp.md)

## 🆘 Getting Help

If you encounter issues:
1. **Check this documentation**
2. **Run health checks**: `:checkhealth`
3. **Search existing issues**: [GitHub Issues](https://github.com/llawn/nvimconfig/issues)
4. **Create an issue**: Provide Neovim version, OS, and error messages

The configuration is designed to be robust and should work out of the box. Most issues can be resolved by ensuring all prerequisites are met and LSP servers are properly installed.