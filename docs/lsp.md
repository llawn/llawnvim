______________________________________________________________________

title: LSP Configurations

description: Language Server Protocol setup and configurations for various
programming languages

icon: material/code-braces

______________________________________________________________________

# LSP Configurations

This page details the Language Server Protocol (LSP) setup and configurations
for various programming languages in the LLawn Neovim configuration.

## LSP Architecture

The configuration leverages Neovim 0.11+'s built-in LSP capabilities with
`vim.lsp.enable` for efficient, modern language support.

### Core Components

1. **Language Server Management**: Mason handles automatic installation
2. **Completion Integration**: nvim-cmp provides intelligent code completion
3. **Custom Configurations**: Language-specific fine-tuning in `after/lsp/`

## LSP Setup

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

!!! info "Supported Languages"

    | Language     | LSP Server                                                              |
    | ------------ | ----------------------------------------------------------------------- |
    | C/C++        | [clangd](https://clangd.llvm.org)                                       |
    | Flutter/Dart | flutter_ls                                                              |
    | Fortran      | [fortls](https://fortls.fortran-lang.org)                               |
    | Go           | [gopls](https://go.dev/gopls/)                                          |
    | Lua          | [lua_ls](https://luals.github.io/)                                      |
    | Python       | [ty](https://docs.astral.sh/ty/) + [ruff](https://docs.astral.sh/ruff/) |

## Language-Specific Configurations

### Flutter/Dart (flutter_ls)

**Location**: `after/lsp/flutter_ls.lua`

**Features**:

- **Custom Command**: Uses Flutter SDK's analysis server
- **Environment**: Requires `FLUTTER_ROOT` environment variable
- **Enhanced Features**: Outline views, closing labels, Flutter-specific
  analysis

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

### Lua (lua_ls)

**Location**: `after/lsp/lua_ls.lua`

**Features**:

- Lua language server configuration
- Custom diagnostics and settings for Neovim Lua development

### Python Linter (ruff)

**Location**: `after/lsp/ruff.lua`

**Features**:

- Ruff linter integration
- Python code quality and style checking

## LSP Features

See @docs/keymaps.md for LSP keymaps and features.

Lualine Integration: Active LSP clients shown in status line

## Extending LSP Support

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

For servers requiring special setup, create files in `after/lsp/` following the
Flutter example. This allows fine-tuning of:

- Command arguments
- Initialization options
- Server settings
- File type associations
- Root markers

## Troubleshooting

### Common Issues

1. **Server Not Starting**: Check Mason installation status
2. **No Completion**: Verify cmp-nvim-lsp capabilities setup
3. **Performance**: Check for conflicting LSP configurations

### Diagnostic Commands

- `:LspInfo` - Show LSP client information

- `:Mason` - Open Mason UI

- `:LspRestart` - Restart all LSP clients

    This LSP setup provides a solid foundation for productive development across
    multiple languages while remaining lightweight and maintainable.
