-- Plugin: conform
-- Description: Lightweight yet powerful formatter plugin for Neovim
--              Automatically checks mason-registry to looks for installed formatters

--- @alias FormatterMap table<string, string[]> Mapping of filetypes to lists of formatters

--- Override or supplement formatters detected from Mason registry.
--- Formatter names can be very specific in conform (e.g., 'ruff_format' vs 'ruff')
--- @type FormatterMap
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
      local mason_utils = require("llawn.utils.mason")
      local mason_formatters = mason_utils.get_mason_tools("Formatter")
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
