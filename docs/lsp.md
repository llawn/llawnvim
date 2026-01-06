# LSP Configurations

This page details the Language Server Protocol (LSP) setup and configurations for various programming languages in the LLawn Neovim configuration.

## 🏗️ LSP Architecture

The configuration leverages Neovim 0.11+'s built-in LSP capabilities with `vim.lsp.enable` for efficient, modern language support.

### Core Components

1. **Language Server Management**: Mason handles automatic installation
2. **Completion Integration**: nvim-cmp provides intelligent code completion
3. **Custom Configurations**: Language-specific fine-tuning in `after/lsp/`

## 🔧 LSP Setup

### Server Configuration

LSP servers are organized by language and enabled automatically:

```lua
local servers = {
  lua = { "lua_ls" },
  dart = { "flutter_ls" },
  cpp = { "clangd" },
  go = { "gopls" },
  python = { "ty", "ruff" },
  fortran = { "fortls" },
}

for _, group in pairs(servers) do
  for _, server in ipairs(group) do
    vim.lsp.enable(server)
  end
end
```

### Mason Auto-Installation

The following servers are automatically installed via Mason:

| Language | Server | Description |
|----------|--------|-------------|
| **C/C++** | clangd | LLVM-based C/C++ language server |
| **Fortran** | fortls | Fortran language server |
| **Go** | gopls | Google's official Go language server |
| **Lua** | lua_ls | Lua language server with Neovim API |
| **Python** | ty | Python type checker |
| **Python** | ruff | Fast Python linter |

## 🎯 Language-Specific Configurations

### Flutter/Dart (flutter_ls)

**Location**: `after/lsp/flutter_ls.lua`

**Features**:
- **Custom Command**: Uses Flutter SDK's analysis server
- **Environment**: Requires `FLUTTER_ROOT` environment variable
- **Enhanced Features**: Outline views, closing labels, Flutter-specific analysis

**Configuration**:
```lua
{
  cmd = {
    "dart",
    flutter_sdk .. "/bin/cache/dart-sdk/bin/snapshots/analysis_server.dart.snapshot",
    "--lsp",
  },
  filetypes = { "dart" },
  root_markers = { "pubspec.yaml" },
  init_options = {
    onlyAnalyzeProjectsWithOpenFiles = true,
    suggestFromUnimportedLibraries = true,
    closingLabels = true,
    outline = true,
    flutterOutline = true,
  },
  settings = {
    dart = {
      completeFunctionCalls = true,
      showTodos = true,
    },
  },
}
```

**Setup Requirements**:
1. Install Flutter SDK
2. Set `FLUTTER_ROOT` environment variable
3. Ensure Dart analysis server is available

## ⚙️ LSP Features

### Code Completion
- **Source**: LSP server suggestions via nvim-cmp
- **Capabilities**: Enhanced with cmp-nvim-lsp
- **File Operations**: Automatic file operations handling

### Diagnostics
- **Signs**: Custom diagnostic signs in sign column
- **Virtual Text**: Inline error/warning messages
- **Severity Levels**: Error, warning, hint, info

### Navigation
- **Go to Definition**: `gd` - Jump to symbol definition
- **Go to References**: `gR` - Find all references (via Telescope)
- **Go to Implementation**: `gi` - Jump to implementation (via Telescope)
- **Go to Type Definition**: `gt` - Jump to type definition (via Telescope)

### Code Actions
- **Quick Fix**: `<leader>ca` - Apply code actions
- **Refactoring**: Rename symbols with `<leader>rn`

### Documentation
- **Hover**: `K` - Show documentation on hover
- **Signature Help**: Automatic parameter hints

## ⌨️ LSP Key Bindings

| Key | Mode | Description |
|-----|------|-------------|
| `gd` | n | Go to definition |
| `gR` | n | Show references |
| `gi` | n | Go to implementations |
| `gt` | n | Go to type definitions |
| `gD` | n | Go to declaration |
| `<leader>ca` | n,v | Code actions |
| `<leader>rn` | n | Rename symbol |
| `<leader>D` | n | Show buffer diagnostics |
| `<leader>d` | n | Show line diagnostics |
| `[d` | n | Previous diagnostic |
| `]d` | n | Next diagnostic |
| `K` | n | Hover documentation |
| `<leader>rs` | n | Restart LSP |

## 🎨 UI Customization

### Diagnostic Signs
Custom signs for different diagnostic levels:
- **Error**: `` (nf-fa-times_circle)
- **Warning**: `` (nf-fa-exclamation_triangle)
- **Hint**: `󰠠` (nf-cod-lightbulb)
- **Info**: `` (nf-fa-info_circle)

### Inlay Hints
Enabled by default for enhanced code readability:
```lua
vim.lsp.inlay_hint.enable(true)
```

## 🔍 LSP Management

### Server Status
- **Lualine Integration**: Active LSP clients shown in status line
- **Restart Capability**: `<leader>rs` to restart LSP servers
- **Client Information**: View attached clients

### Debugging
- **Log Access**: LSP logs available for troubleshooting
- **Client Inspection**: Query active LSP clients and their capabilities

## 🚀 Performance

### Lazy Loading
LSP-related plugins load on buffer read for optimal startup time.

### Efficient Configuration
- **Native LSP**: Uses Neovim's built-in LSP for better performance
- **Minimal Setup**: Only essential LSP features enabled
- **Smart Loading**: Servers start only when needed

## 🔧 Extending LSP Support

### Adding New Languages

1. **Add to servers table** in `lsp.lua`:
```lua
local servers = {
  -- existing servers...
  javascript = { "tsserver" },
}
```

2. **Add to Mason ensure_installed** in `mason.lua`:
```lua
ensure_installed = {
  -- existing servers...
  "tsserver",
}
```

3. **Create custom config** (optional) in `after/lsp/`:
```lua
-- after/lsp/tsserver.lua
return {
  -- custom configuration
}
```

### Custom Server Configuration

For servers requiring special setup, create files in `after/lsp/` following the Flutter example. This allows fine-tuning of:

- Command arguments
- Initialization options
- Server settings
- File type associations
- Root markers

## 🐛 Troubleshooting

### Common Issues

1. **Server Not Starting**: Check Mason installation status
2. **No Completion**: Verify cmp-nvim-lsp capabilities setup
3. **Flutter Issues**: Ensure `FLUTTER_ROOT` is set correctly
4. **Performance**: Check for conflicting LSP configurations

### Diagnostic Commands
- `:LspInfo` - Show LSP client information
- `:Mason` - Open Mason UI
- `:LspRestart` - Restart all LSP clients

This LSP setup provides a solid foundation for productive development across multiple languages while remaining lightweight and maintainable.