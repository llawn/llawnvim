--- @brief Mason LSP configuration
--- configures mason-lspconfig to automatically install some LSP
---

return {
  {
    "williamboman/mason-lspconfig.nvim",
    opts = {
      -- list of servers for mason to install
      ensure_installed = {
        -- C/C++/Objective-C
        "clangd",

        -- Fortran
        "fortls",

        -- Go
        "gopls",

        -- Lua
        "lua_ls",

        -- Python
        "ty",
        "ruff",
      },
    },
    dependencies = {
      -- Mason core plugin for managing LSP servers
      {
        "williamboman/mason.nvim",
        opts = {
          -- UI configuration for mason
          ui = {
            icons = {
              package_installed = "✓",
              package_pending = "➜",
              package_uninstalled = "✗",
            },
          },
        },
      },
      -- Neovim's built-in LSP configuration
      "neovim/nvim-lspconfig",
    },
  },
}
