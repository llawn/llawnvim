# Plugins

This page documents all the plugins included in the LLawn Neovim configuration, organized by category with their configurations and key features.

## 📦 Plugin Manager

### Lazy.nvim
**Repository**: [folke/lazy.nvim](https://github.com/folke/lazy.nvim)

The modern plugin manager for Neovim that provides:
- **Lazy Loading**: Plugins load only when needed for optimal startup time
- **Dependency Management**: Automatic handling of plugin dependencies
- **Update Checking**: Background checks for plugin updates
- **Profile Support**: Performance profiling capabilities

**Configuration**:
- Automatic update checking enabled
- No update notifications to reduce distractions
- Change detection notifications disabled

## 🎨 Appearance & UI

### Rose Pine Theme
**Repository**: [rose-pine/neovim](https://github.com/rose-pine/neovim)

A beautiful, warm dark theme with the following features:
- **Moon Variant**: Low-contrast, eye-friendly colors
- **Transparent Background**: Clean, distraction-free editing
- **Custom Highlights**: Enhanced visibility for invisible characters (tabs, spaces, etc.)
- **Syntax Highlighting**: Carefully chosen colors for code readability

**Custom Configuration**:
- Non-text characters: `#9ccfd8` (cyan)
- Whitespace: `#eb6f92` (red-pink)
- Special keys: `#f6c177` (yellow)
- End of buffer: `#6e6a86` (muted purple)

### Lualine Status Line
**Repository**: [nvim-lualine/lualine.nvim](https://github.com/nvim-lualine/lualine.nvim)

A blazing fast and easy-to-configure status line with:
- **Git Integration**: Branch name, diff status, diagnostics
- **LSP Status**: Active language servers display
- **File Information**: Encoding, format, and type
- **Mode Indicators**: Current Vim mode
- **Progress**: File position and progress

**Custom Features**:
- LSP status function showing active clients
- Auto theme detection
- Rounded section separators

## 🔧 Language Server Protocol (LSP)

### Mason & Mason-LSPConfig
**Mason**: [williamboman/mason.nvim](https://github.com/williamboman/mason.nvim)
**Mason-LSPConfig**: [williamboman/mason-lspconfig.nvim](https://github.com/williamboman/mason-lspconfig.nvim)

Automatic LSP server management providing:
- **Auto-Installation**: LSP servers installed automatically
- **Version Management**: Consistent server versions
- **UI Integration**: User-friendly installation interface

**Ensured Servers**:
- `clangd` - C/C++ language server
- `fortls` - Fortran language server
- `gopls` - Go language server
- `lua_ls` - Lua language server
- `ty` - Python type checker
- `ruff` - Python linter

### Nvim-CMP & CMP-Nvim-LSP
**Nvim-CMP**: [hrsh7th/nvim-cmp](https://github.com/hrsh7th/nvim-cmp)
**CMP-Nvim-LSP**: [hrsh7th/cmp-nvim-lsp](https://github.com/hrsh7th/cmp-nvim-lsp)

Intelligent code completion with:
- **LSP Integration**: Completion from language servers
- **Multiple Sources**: Various completion sources
- **Smart Selection**: Context-aware suggestions
- **Snippet Support**: Code snippet expansion

## 🧭 Navigation & Search

### Telescope
**Repository**: [nvim-telescope/telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)

Highly extendable fuzzy finder with:
- **File Finding**: Fast file discovery
- **Live Grep**: Content searching across files
- **Buffer Management**: Quick buffer switching
- **Help Integration**: Built-in help system

**Key Bindings**:
- `<leader>tf` - Find files
- `<leader>tg` - Git files only
- `<leader>tb` - Browse buffers
- `<leader>th` - Help tags
- `<leader>tw` - Find word under cursor

### Harpoon
**Repository**: [ThePrimeagen/harpoon](https://github.com/ThePrimeagen/harpoon) (harpoon2 branch)

File navigation utility for:
- **Quick Marking**: Mark frequently used files
- **Fast Switching**: 1-3 key access to marked files
- **Persistent Lists**: File marks survive sessions

**Key Bindings**:
- `<leader>a` - Add current file to harpoon
- `<C-e>` - Toggle quick menu
- `<C-1/2/3>` - Select marked files 1-3

## 📁 File Management

### Yazi File Manager
**Repository**: [mikavilpas/yazi.nvim](https://github.com/mikavilpas/yazi.nvim)

Modern terminal file manager integration:
- **Floating Window**: Fullscreen file browsing
- **Directory Opening**: Replaces netrw for directories
- **Integration**: Seamless LazyGit switching

**Key Bindings**:
- `<leader>-` - Open Yazi at current file
- `<leader>cw` - Open Yazi in current working directory
- `<c-up>` - Resume last Yazi session
- `<c-l>` (in Yazi) - Switch to LazyGit

## 🐙 Git Integration

### LazyGit
**Repository**: [kdheepak/lazygit.nvim](https://github.com/kdheepak/lazygit.nvim)

Terminal UI for git commands:
- **Full Git Interface**: Complete git workflow in terminal
- **Integration**: Works with Yazi file manager
- **Key Bindings**: `<leader>lg` to launch

## 🛠️ Development Tools

### Neogen
**Repository**: [danymat/neogen](https://github.com/danymat/neogen)

Documentation generation for:
- **Function Docs**: Generate function documentation
- **Class/Type Docs**: Documentation for classes and types
- **Multiple Languages**: Support for various programming languages

**Key Bindings**:
- `<leader>nf` - Generate function documentation
- `<leader>nt` - Generate type/class documentation

### CCC (Color Picker)
**Repository**: [uga-rosa/ccc.nvim](https://github.com/uga-rosa/ccc.nvim)

Color manipulation tools:
- **Color Picker**: Interactive color selection
- **Highlighter**: Toggle color highlighting in code
- **Format Support**: Multiple color formats (hex, rgb, hsl)

**Key Bindings**:
- `<leader>cc` - Open color picker
- `<leader>ct` - Toggle color highlighter

### UndoTree
**Repository**: [mbbill/undotree](https://github.com/mbbill/undotree)

Visual undo history:
- **Tree View**: Graphical representation of undo history
- **Branch Navigation**: Explore different undo branches
- **Persistent**: History survives sessions

**Key Binding**: `<leader>u` - Toggle undo tree

### Which-Key
**Repository**: [folke/which-key.nvim](https://github.com/folke/which-key.nvim)

Interactive key binding hints:
- **Popup Display**: Shows available key combinations
- **Grouping**: Organized key binding groups
- **Discovery**: Helps learn available commands

## 🔧 Configuration Details

All plugins are configured with sensible defaults and integrated key bindings. The configuration emphasizes:

- **Performance**: Lazy loading and minimal dependencies
- **Integration**: Plugins work seamlessly together
- **Usability**: Intuitive key bindings and discoverable features
- **Maintainability**: Clean, documented configurations

## 📋 Plugin Versions

| Plugin | Version/Commit | Description |
|--------|----------------|-------------|
| rose-pine | cf2a288 | Color scheme |
| ccc | 9d1a256 | Color picker and highlighter |
| harpoon | 87b1a35 | File navigation |
| lazygit | a04ad0d | Git integration |
| lualine | 47f91c4 | Status line |
| neogen | d7f9461 | Documentation generation |
| nvim-cmp | 85bbfad | Completion engine |
| cmp-nvim-lsp | cbc7b02 | LSP completion integration |
| mason | 57e5a8a | LSP server manager |
| mason-lspconfig | 4cfe411 | Mason LSP bridge |
| telescope | 3333a52 | Fuzzy finder |
| undotree | 178d19e | Undo tree |
| which-key | 3aab214 | Key binding hints |
| yazi | ba8aa93 | File manager |

Versions are tracked to ensure compatibility and reproducible setups.