-- Plugin: Mason
-- Description: Configures mason-lspconfig to automatically install LSP
--              Custom lockfile to see LSP installation

-- Custom lockfile for mason
local function save_mason_lock()
  local registry = require('mason-registry')
  local installed = registry.get_installed_packages()
  local data = {}
  for _, pkg in ipairs(installed) do
    if pkg then
      table.insert(data, {
        name = pkg.name,
        version = pkg:get_installed_version(),
      })
    end
  end
  table.sort(data, function(a, b) return a.name < b.name end)
  local json_lines = { "[" }
  for i, entry in ipairs(data) do
    local entry_str = string.format(
      '{"name": %s, "version": %s}',
      vim.fn.json_encode(entry.name),
      vim.fn.json_encode(entry.version)
    )
    table.insert(json_lines, "  " .. entry_str .. (i < #data and "," or ""))
  end
  table.insert(json_lines, "]")
  local path = vim.fn.stdpath('config') .. '/mason-lock.json'
  vim.fn.writefile(json_lines, path)
end

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
        config = function(_, opts)
          require('mason').setup(opts)
          -- Hook into Mason events
          local registry = require('mason-registry')
          registry:on('package:install:success', save_mason_lock)
          registry:on('package:uninstall:success', save_mason_lock)
          -- Also on VimEnter to save initial state
          vim.api.nvim_create_autocmd('VimEnter', {
            callback = save_mason_lock,
          })
        end,
      },
      -- Neovim's built-in LSP configuration
      "neovim/nvim-lspconfig",
    },
  },
}
