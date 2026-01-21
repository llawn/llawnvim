---
title: LSP Configurations
description: Language Server Protocol setup and configurations for various programming languages
icon: material/code-braces
---

# LSP Configurations

This page details the Language Server Protocol (LSP) setup and configurations
for various programming languages in the LLawn Neovim configuration.

## LSP Architecture

The configuration leverages Neovim 0.11+'s built-in LSP capabilities with
`vim.lsp.enable` for efficient, modern language support.

### Core Components

1. **Language Server Management**: Mason handles automatic installation
2. **Completion Integration**: nvim-cmp provides intelligent code completion
3. **Linting**: nvim-lint provides asynchronous linting with Mason integration
4. **Formatting**: conform provides formatting with Mason integration and LSP
   fallback
5. **Custom Configurations**: Language-specific fine-tuning in `after/lsp/`

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

## Linting and Formatting

### Linting with nvim-lint

The configuration uses
[mfussenegger/nvim-lint](https://github.com/mfussenegger/nvim-lint) for
asynchronous linting, integrated with Mason for automatic tool installation.

**Key Features**:

- Automatic linter detection from Mason registry
- Filters out linters that are also LSP servers to avoid duplication
- Runs on buffer enter, write, and insert leave
- Manual trigger with `<leader>pl`

**Configuration** (`lua/llawn/plugins/lsp/linting.lua`):

```lua
-- Manual overrides for linters by filetype
local linters_by_ft_manual = {
  -- Add linters manually if needed
}

-- Get merged linters from Mason and manual overrides
local function get_merged_linters()
  local mason_utils = require("llawn.utils.mason")
  local mason_linters = mason_utils.get_mason_tools("Linter")
  local lsp_tools = mason_utils.get_mason_tools("LSP")
  -- Filter logic to avoid duplication with LSP servers
  -- ... (filtered logic)
  return vim.tbl_deep_extend('force', filtered_linters, linters_by_ft_manual)
end

return {
  "mfussenegger/nvim-lint",
  config = function()
    local lint = require("lint")
    lint.linters_by_ft = get_merged_linters()
    -- Auto-trigger on events
    vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
      callback = function()
        lint.try_lint()
      end,
    })
  end,
}
```

### Formatting with conform

[stevearc/conform.nvim](https://github.com/stevearc/conform.nvim) handles code
formatting, prioritizing Mason formatters with LSP fallback.

**Key Features**:

- Integrates with Mason registry for formatter discovery
- Format on save disabled by default (manual trigger)
- Confirmation dialog with diff preview before applying changes
- Supports multiple formatters per filetype

**Configuration** (`lua/llawn/plugins/lsp/conform.lua`):

```lua
-- Override or supplement formatters from Mason registry
local formatters_by_ft = {
  python = {
    "ruff_format",
    "ruff_organize_imports",
    "ruff_fix",
  },
  make = { "bake" },
}

return {
  {
    "stevearc/conform.nvim",
    opts = function()
      local mason_utils = require("llawn.utils.mason")
      local mason_formatters = mason_utils.get_mason_tools("Formatter")
      local merged_formatters = vim.tbl_deep_extend('force', mason_formatters, formatters_by_ft)
      return {
        formatters_by_ft = merged_formatters,
        format_on_save = false,  -- Manual trigger preferred
      }
    end,
  },
}
```

**Formatting Utility** (`lua/llawn/utils/formatting.lua`):

Provides a confirmation-based formatting function that shows diffs and allows
approval/rejection:

```lua
function M.format_with_confirmation()
  -- Check for available formatters (conform or LSP)
  -- Apply formatting
  -- Show diff for confirmation
  -- Apply or reject based on user input
end
```

### Mason Integration

The `lua/llawn/utils/mason.lua` provides utilities to bridge Mason tools with
Neovim configurations:

- `get_mason_tools(category)`: Get tools by Mason category (LSP, Linter,
  Formatter)
- Handles language name mapping (e.g., makefile → make)
- Filters tools based on categories

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

**Formatting**: `<leader>pf` triggers formatting with confirmation dialog
showing diff preview. Uses conform if available, falls back to LSP formatting.

**Linting**: Automatic linting on buffer events, manual trigger with
`<leader>pl`.

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
