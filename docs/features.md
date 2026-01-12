---

title: Features

description: Comprehensive overview of LLawn Neovim configuration features

icon: material/star

---

# Features

This page provides a comprehensive overview of the key features and capabilities of the LLawn Neovim configuration.

## Core Architecture

### Modular Configuration

The configuration is organized into logical modules for easy maintenance and extension:

- **Configuration Layer**: Editor options, keymaps, LSP setup, and UI preferences
- **Plugin Layer**: Plugin specifications and configurations
- **Language Layer**: LSP server configurations and language-specific settings

### Lazy Loading

All plugins are lazy-loaded for optimal startup performance.
The Lazy plugin manager handles dependencies and updates automatically.

## Language Server Protocol (LSP)

Comprehensive LSP support for multiple languages with native Neovim 0.11+ integration. See [LSP Configurations](lsp.md) for detailed setup and configuration.

!!! info "Supported Languages"

    | Language | LSP Server | Features |
    |----------|------------|----------|
    | C/C++ | clangd | Full language support, diagnostics |
    | Flutter/Dart | flutter_ls | Hot reload, outline views, widgets |
    | Fortran | fortls | Modern Fortran support |
    | Go | gopls | Google's official Go language server |
    | Lua | lua_ls | Lua language support with Neovim API |
    | Python | ty + ruff | Type checking and linting |

## User Interface

### Theme

- **Rose Pine Moon**: A beautiful, low-contrast color scheme
- **Custom Highlights**: Enhanced visibility for invisible characters
- **Transparent Background**: Clean, distraction-free editing

### Status Line

- **Lualine**: Informative status line with git integration
- **Mode Indicators**: Clear visual feedback for current mode
- **File Information**: Encoding, file type, and position

### Window Management

- **Popup Menus**: Intuitive window, git, and treesitter operation menus
- **Custom Borders**: Rounded borders for floating windows
- **Alpha Dashboard**: Clean startup screen with quick access to common actions

## Keymaps and Navigation

### Popup Menus

- **Window Menu** (`<C-w>`): Split windows, navigate, and close
- **Git Menu** (`<C-g>`): Status, commit, push, log, and diff operations
- **Treesitter Menu** (`<C-t>`): Parser installation, updates, and management

### File Navigation

- **Harpoon**: Quick file marking and navigation (1-3 keys)
- **Telescope**: Fuzzy finding for files, buffers, help, and grep
- **Yazi**: Modern file manager integration

### Editing Enhancements

- **Visual Line Navigation**: Natural movement with j/k and arrow keys
- **Line Movement**: Alt+j/k to move lines up/down
- **Clipboard Integration**: System clipboard support
- **Undo Tree**: Visual undo history management

## Development Tools

### Code Generation

- **Neogen**: Generate documentation strings for functions and classes
- **Completion**: Intelligent code completion with LSP integration

### Git Integration

- **LazyGit**: Terminal-based git interface
- **Git Signs**: Inline git status indicators
- **Telescope Git**: Git file and status browsing

### Productivity

- **Neogen**: Generate documentation strings for functions and classes
- **Completion**: Intelligent code completion with LSP integration

### Git Integration

- **LazyGit**: Terminal-based git interface
- **Git Signs**: Inline git status indicators
- **Telescope Git**: Git file and status browsing

### Productivity

- **Which-Key**: Interactive key binding hints
- **Color Tools**: Color pickers (HexColors, ColorPick2D) and completion

### LSP Management

- **Mason**: Automatic LSP server installation
- **Mason-LSPConfig**: Bridge between Mason and nvim-lspconfig
- **List Characters**: Toggle visibility of whitespace and tabs

## Configuration Options

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

## Plugin Ecosystem

The configuration includes carefully selected plugins that enhance productivity without bloat. All plugins are lazy-loaded for optimal startup performance.

### Plugin Manager

#### Lazy.nvim

**Repository**: [folke/lazy.nvim](https://github.com/folke/lazy.nvim)

The modern plugin manager for Neovim that provides lazy loading, dependency management, update checking, and performance profiling.

### Appearance & UI

#### Rose Pine Theme

**Repository**: [rose-pine/neovim](https://github.com/rose-pine/neovim)

A beautiful, warm dark theme with moon variant, transparent background, and custom highlights for invisible characters.

#### Alpha Dashboard

**Repository**: [goolord/alpha-nvim](https://github.com/goolord/alpha-nvim)

A fast and fully customizable greeter for Neovim with quick access to recent files, commands, and settings.

#### Lualine Status Line

**Repository**: [nvim-lualine/lualine.nvim](https://github.com/nvim-lualine/lualine.nvim)

Blazing fast status line with git integration, LSP status, file information, and mode indicators.

### Language Server Protocol (LSP)

#### Mason & Mason-LSPConfig

Automatic LSP server management with auto-installation for clangd, fortls, gopls, lua_ls, ty, and ruff.

#### Nvim-CMP & CMP-Nvim-LSP

Intelligent code completion with LSP integration, multiple sources, and snippet support.

### Navigation & Search

#### Telescope

**Repository**: [nvim-telescope/telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)

Highly extendable fuzzy finder for files, live grep, buffers, and help.

#### Harpoon

**Repository**: [ThePrimeagen/harpoon](https://github.com/ThePrimeagen/harpoon)

Quick file marking and navigation with persistent lists.

### Syntax & Parsing

#### Treesitter

**Repository**: [nvim-treesitter/nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)

Advanced syntax highlighting, code navigation, and structural editing with tree-sitter parsers. Includes a comprehensive menu for parser management and automatic installation for configured languages.

##### Supported Parsers

The following parsers are automatically installed:

| Parser | Revision |
|--------|----------|
| lua | db16e76 |
| vim | 11b688a |
| vimdoc | 2694c3d |
| query | 930202c |
| json | 46aa487 |
| markdown | 4132852 |
| markdown_inline | 4132852 |

### File Management

#### Yazi File Manager

**Repository**: [mikavilpas/yazi.nvim](https://github.com/mikavilpas/yazi.nvim)

Modern terminal file manager with floating windows and LazyGit integration.

### Git Integration

#### LazyGit

**Repository**: [kdheepak/lazygit.nvim](https://github.com/kdheepak/lazygit.nvim)

Terminal UI for git commands with full workflow support.

### Development Tools

#### Neogen

**Repository**: [danymat/neogen](https://github.com/danymat/neogen)

Documentation generation for functions and classes across multiple languages.



#### UndoTree

**Repository**: [mbbill/undotree](https://github.com/mbbill/undotree)

Visual undo history with tree view and persistent storage.

#### Which-Key

**Repository**: [folke/which-key.nvim](https://github.com/folke/which-key.nvim)

Interactive key binding hints with popup display and grouping.

## Customization

### Easy Extension

The modular structure makes it simple to add new features:

- **New Languages**: Add LSP servers to the servers table
- **Custom Keymaps**: Extend the keymaps.lua file
- **Plugin Addition**: Add to the plugins directory
- **Theme Customization**: Modify `lua/llawn/plugins/colors.lua`

### Configuration Philosophy

- **Progressive Enhancement**: Start simple, add complexity as needed
- **Community Standards**: Follow Neovim best practices
