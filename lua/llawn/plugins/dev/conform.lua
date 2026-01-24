-- Plugin: conform
-- Description: Lightweight yet powerful formatter plugin for Neovim
--              Automatically checks mason-registry to looks for installed formatters
-- Note: Custom configuration for individual formatter in config/formatter
--       Trigger formatting in config/lsp.lua (synchronized behaviour)

local formatter_config = require("llawn.config.formatter")

return {
  {
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = function()
      local mason_utils = require("llawn.utils.mason")
      local mason_formatters = mason_utils.get_mason_tools("Formatter")
      local merged_formatters = vim.tbl_deep_extend('force', mason_formatters, formatter_config.formatters_by_ft or {})

      return {
        formatters_by_ft = merged_formatters,
        formatters = formatter_config.options or {},
        default_format_opts = {
          lsp_format = "fallback",
        },
        format_on_save = false,
      }
    end,
  },
}
