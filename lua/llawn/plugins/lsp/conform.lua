-- Plugin: conform
-- Description: Lightweight yet powerful formatter plugin for Neovim
--              Automatically checks mason-registry to looks for installed formatters

--- @alias FormatterMap table<string, string[]> Mapping of filetypes to lists of Mason package names.

--- Bridges Mason language names to Neovim filetypes
--- @type table<string, string>
local lang_to_ft = {
  makefile = "make",
  csharp = "cs",
  powershell = "ps1",
  ["f#"] = "fs",
  bash = "sh",
  zsh = "sh",
  ksh = "sh",
}

--- Scans Mason-regisry to identify installed formatters and organizes them by filetype.
--- @return FormatterMap # A table where keys are filetypes and values are arrays of formatter names.
local function get_mason_formatters()
  local registry = require('mason-registry')
  local formatters = {}
  for _, pkg in ipairs(registry.get_installed_packages()) do
    if pkg.spec.categories and vim.tbl_contains(pkg.spec.categories, 'Formatter') then
      local langs = pkg.spec.languages or {}
      for _, lang in ipairs(langs) do
        local ft = lang_to_ft[lang:lower()] or lang:lower()
        formatters[ft] = formatters[ft] or {}
        table.insert(formatters[ft], pkg.name)
      end
    end
  end
  return formatters
end

--- Override or supplement formatters detected from Mason registry.
--- Formatter names can be very specific in conform (e.g., 'ruff_format' vs 'ruff')
--- @type table<string, string[]>
local formatters_by_ft = {
  python = {
    "ruff_format",
    "ruff_organize_imports",
    "ruff_fix",
  },
  make = {
    "bake"
  }
}

return {
  {
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = function()
      local mason_formatters = get_mason_formatters()
      local merged_formatters = vim.tbl_deep_extend('force', mason_formatters, formatters_by_ft)
      return {
        formatters_by_ft = merged_formatters,
        -- Set default options
        default_format_opts = {
          lsp_format = "prefer",
        },
        -- Format on save disabled
        format_on_save = false,
        -- You can manually trigger formatting using a custom command
        -- Logic can be find in lua/llawn/utils/formatting.lua
        -- Keymap is defined in lua/llawn/config/lsp.lua
        -- Mason is more useful than Conform so I synchronized behaviour in lua/llawn/config/lsp.lua
      }
    end,
  },
}
