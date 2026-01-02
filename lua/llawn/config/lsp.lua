---@brief LSP setup and configuration 
--- see https://github.com/josean-dev/dev-environment-files
---

-------------------------------------------------------------------------------
-- LSP SERVERS CONFIGURATION
-------------------------------------------------------------------------------

-- Define LSP servers grouped by language
local servers = {
  lua = { "lua_ls" },
  dart = { "flutter_ls" },
  cpp = { "clangd" },
  go = { "gopls" },
  python = { "ty", "ruff" },
  fortran = { "fortls" },
}

-- Enable every LSP server listed above
for _, group in pairs(servers) do
  for _, server in ipairs(group) do
    vim.lsp.enable(server)
  end
end

-------------------------------------------------------------------------------
-- LSP KEYMAPS (BUFFER-LOCAL, ON ATTACH)
-------------------------------------------------------------------------------

local keymap = vim.keymap

-- Autocommand triggered when an LSP attaches to a buffer
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(ev)
    -- Common options for all LSP mappings
    local opts = { buffer = ev.buf, silent = true, noremap = true }

    ---------------------------------------------------------------------------
    -- Navigation & Symbol Lookup
    ---------------------------------------------------------------------------

    opts.desc = "Show LSP references"
    keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts)

    ---------------------------------------------------------------------------
    -- DIAGNOSTIC UI CONFIGURATION
    ---------------------------------------------------------------------------

    opts.desc = "Go to declaration"
    keymap.set("n", "gD", vim.lsp.buf.declaration, opts)

    opts.desc = "Show LSP definition"
    keymap.set("n", "gd", vim.lsp.buf.definition, opts)

    opts.desc = "Show LSP implementations"
    keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)

    opts.desc = "Show LSP type definitions"
    keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts)

    ---------------------------------------------------------------------------
    -- Code Actions & Refactoring
    ---------------------------------------------------------------------------

    opts.desc = "See available code actions"
    keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)

    opts.desc = "Smart rename"
    keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

    ---------------------------------------------------------------------------
    -- Diagnostics
    ---------------------------------------------------------------------------

    opts.desc = "Show buffer diagnostics"
    keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts)

    opts.desc = "Show line diagnostics"
    keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)

    opts.desc = "Go to previous diagnostic"
    local function previous_diagnostic()
      vim.diagnostic.jump({ count = -1, float = true })
    end
    keymap.set("n", "[d", previous_diagnostic, opts)

    opts.desc = "Go to next diagnostic"
    local function next_diagnostic()
      vim.diagnostic.jump({ count = 1, float = true })
    end
    keymap.set("n", "]d", next_diagnostic, opts)

    ---------------------------------------------------------------------------
    -- Documentation
    ---------------------------------------------------------------------------

    opts.desc = "Show documentation for what is under cursor"
    keymap.set("n", "K", vim.lsp.buf.hover, opts)

     --------------------------------------------------------------------------
    -- LSP Management
    ---------------------------------------------------------------------------

    opts.desc = "Restart LSP"
    keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts)
  end,
})

-------------------------------------------------------------------------------
-- INLAY HINTS
-------------------------------------------------------------------------------

vim.lsp.inlay_hint.enable(false)

-------------------------------------------------------------------------------
-- DIAGNOSTIC UI CONFIGURATION
-------------------------------------------------------------------------------


local severity = vim.diagnostic.severity

vim.diagnostic.config({
  signs = {
    text = {
      [severity.ERROR] = " ",
      [severity.WARN] = " ",
      [severity.HINT] = "󰠠 ",
      [severity.INFO] = " ",
    },
  },
})
