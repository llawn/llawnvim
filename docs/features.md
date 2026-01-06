# Features

This page provides a comprehensive overview of the key features and capabilities of the LLawn Neovim configuration.

## 🏗️ Core Architecture

### Modular Configuration
The configuration is organized into logical modules for easy maintenance and extension:

- **Configuration Layer**: Editor options, keymaps, LSP setup, and UI preferences
- **Plugin Layer**: Plugin specifications and configurations
- **Language Layer**: LSP server configurations and language-specific settings

### Lazy Loading
All plugins are lazy-loaded for optimal startup performance. The Lazy plugin manager handles dependencies and updates automatically.

## 🔧 Language Server Protocol (LSP)

### Built-in LSP Support
Utilizes Neovim 0.11+'s native LSP capabilities with `vim.lsp.enable` for modern, efficient language support.

### Supported Languages
- **C/C++**: clangd for comprehensive C/C++ development
- **Flutter/Dart**: Custom flutter_ls configuration with analysis server integration
- **Fortran**: fortls for modern Fortran language support
- **Go**: gopls (Google's official Go language server)
- **Lua**: lua_ls with Neovim API awareness
- **Python**: ty for type checking and ruff for linting

### LSP Features
- Code completion with nvim-cmp
- Diagnostics with custom signs and virtual text
- Code actions and refactoring
- Go to definition, references, and implementations
- Hover documentation and signature help
- Inlay hints for type information
- Symbol navigation with Telescope

## 🎨 User Interface

### Theme
- **Rose Pine Moon**: A beautiful, low-contrast color scheme
- **Custom Highlights**: Enhanced visibility for invisible characters
- **Transparent Background**: Clean, distraction-free editing

### Status Line
- **Lualine**: Informative status line with git integration
- **Mode Indicators**: Clear visual feedback for current mode
- **File Information**: Encoding, file type, and position

### Window Management
- **Popup Menus**: Intuitive window and git operation menus
- **Split Navigation**: Easy movement between windows
- **Custom Borders**: Rounded borders for floating windows

## ⌨️ Keymaps and Navigation

### Popup Menus
- **Window Menu** (`<C-w>`): Split windows, navigate, and close
- **Git Menu** (`<C-g>`): Status, commit, push, log, and diff operations

### File Navigation
- **Harpoon**: Quick file marking and navigation (1-3 keys)
- **Telescope**: Fuzzy finding for files, buffers, help, and grep
- **Yazi**: Modern file manager integration

### Editing Enhancements
- **Visual Line Navigation**: Natural movement with j/k and arrow keys
- **Line Movement**: Alt+j/k to move lines up/down
- **Clipboard Integration**: System clipboard support
- **Undo Tree**: Visual undo history management

## 🛠️ Development Tools

### Code Generation
- **Neogen**: Generate documentation strings for functions and classes
- **Completion**: Intelligent code completion with LSP integration

### Git Integration
- **LazyGit**: Terminal-based git interface
- **Git Signs**: Inline git status indicators
- **Telescope Git**: Git file and status browsing

### Productivity
- **Which-Key**: Interactive key binding hints
- **Color Tools**: Color picker and highlighter (CCC)
- **List Characters**: Toggle visibility of whitespace and tabs

### LSP Management
- **Mason**: Automatic LSP server installation
- **Mason-LSPConfig**: Bridge between Mason and nvim-lspconfig
- **LSP Restart**: Easy LSP server restart capability

## ⚙️ Configuration Options

### Editor Settings
- **Line Numbers**: Relative numbering with current line absolute
- **Indentation**: 2-space tabs, smart indentation
- **Search**: Incremental search with preview
- **Wrapping**: Soft wrapping with break indent
- **Color Column**: 80-character guide line

### UI Preferences
- **True Color**: Full 24-bit color support
- **Scroll Offset**: 7-line scroll margin
- **Sign Column**: Always visible for diagnostics
- **Cursor Line**: Highlighted current line

### File Handling
- **Persistent Undo**: Undo history survives sessions
- **Backup Management**: Sensible backup and swap file locations
- **File Type Detection**: Enhanced filename patterns

## 🔌 Plugin Ecosystem

The configuration includes carefully selected plugins that enhance productivity without bloat:

| Category | Plugin | Purpose |
|----------|--------|---------|
| **Theme** | rose-pine | Beautiful color scheme |
| **Completion** | nvim-cmp, cmp-nvim-lsp | Code completion |
| **LSP** | mason, mason-lspconfig | LSP server management |
| **Navigation** | harpoon, telescope | File and symbol navigation |
| **Git** | lazygit | Git interface |
| **UI** | lualine, which-key | Interface enhancements |
| **Tools** | neogen, ccc, undotree, yazi | Development utilities |

## 🚀 Performance

### Startup Optimization
- **Lazy Loading**: Plugins load only when needed
- **Minimal Dependencies**: Only essential plugins included
- **Efficient Configuration**: Optimized Lua code execution

### Memory Usage
- **Garbage Collection**: Tuned for Neovim's usage patterns
- **Plugin Selection**: Quality over quantity approach
- **Resource Management**: Careful memory allocation

## 🔧 Customization

### Easy Extension
The modular structure makes it simple to add new features:

- **New Languages**: Add LSP servers to the servers table
- **Custom Keymaps**: Extend the keymaps.lua file
- **Plugin Addition**: Add to the plugins directory
- **Theme Customization**: Modify colors.lua

### Configuration Philosophy
- **Convention over Configuration**: Sensible defaults
- **Progressive Enhancement**: Start simple, add complexity as needed
- **Community Standards**: Follow Neovim best practices