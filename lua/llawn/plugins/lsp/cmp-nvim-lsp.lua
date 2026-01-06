--- @brief
--- This file configures the cmp-nvim-lsp plugin for Neovim, which enables
--- autocompletion capabilities for Language Server Protocol (LSP) servers.
--- It integrates with cmp (completion) plugin to provide intelligent
--- code completion suggestions.
---
--- Dependencies:
---   - antosha417/nvim-lsp-file-operations: Handles LSP file operations
---   - folke/lazydev.nvim: Lazy loading for development plugins
---

return {
  "hrsh7th/cmp-nvim-lsp",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    { "antosha417/nvim-lsp-file-operations", config = true },
    { "folke/lazydev.nvim", opts = {} },
  },
  config = function()
    local cmp_nvim_lsp = require("cmp_nvim_lsp")
    local capabilities = cmp_nvim_lsp.default_capabilities()

    -- Apply capabilities to all LSP configurations
    vim.lsp.config("*", {
      capabilities = capabilities,
    })
  end,
}
