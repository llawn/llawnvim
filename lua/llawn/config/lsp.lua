--- LSP setup and configuration
--- see https://github.com/josean-dev/dev-environment-files

-- ============================================================================
-- LSP SERVERS CONFIGURATION
-- ============================================================================

--- @alias ServerMap table<string, string[]> Mapping of filetypes to lists of servers

--- Override or supplement servers detected from Mason registry.
--- Server names should match Mason package names
--- @type ServerMap
local servers_by_ft = {
  dart = { "flutter_ls" },
}

local mason_utils = require("llawn.utils.mason")
local mason_servers = mason_utils.get_mason_tools("LSP")
local merged_servers = vim.tbl_deep_extend('force', mason_servers, servers_by_ft)

-- Enable all servers
for _, group in pairs(merged_servers) do
  for _, server in ipairs(group) do
    vim.lsp.config(server, {})
    vim.lsp.enable(server)
  end
end

-- ============================================================================
-- UI Config
-- ============================================================================

-- Enable inlay hints globally by default (can be toggled with <leader>ti)
vim.lsp.inlay_hint.enable(true)

-- ============================================================================
-- Utils
-- ============================================================================

--- Configures and applies buffer-local keymaps for LSP interaction.
--- This function is intended to be called within an LspAttach autocommand.
--- It maps lsp commands specifically for the buffer where the LSP client is active.
--- @param ev table The event object provided by the LspAttach autocommand, containing 'buf' and 'data.client_id'.
--- @return nil
local function setup_lsp_keymaps(ev)
  local client = vim.lsp.get_client_by_id(ev.data.client_id)
  local opts = { buffer = ev.buf, silent = true, noremap = true }
  local keymap = vim.keymap

  -- --------------------------------------------------------------------------
  -- NAVIGATION
  -- --------------------------------------------------------------------------

  opts.desc = "Show LSP definition"
  keymap.set("n", "gd", vim.lsp.buf.definition, opts)

  opts.desc = "Go to declaration"
  keymap.set("n", "gD", vim.lsp.buf.declaration, opts)

  opts.desc = "Show LSP implementations"
  keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)

  opts.desc = "Show LSP type definitions"
  keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts)

  opts.desc = "Show LSP references"
  keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts)

  -- --------------------------------------------------------------------------
  -- Symbols
  -- --------------------------------------------------------------------------

  opts.desc = "LSP buffer symbols"
  keymap.set("n", "<leader>tb", "<cmd>Telescope lsp_document_symbols<CR>", opts)

  opts.desc = "LSP project symbols"
  keymap.set("n", "<leader>tw", "<cmd>Telescope lsp_dynamic_workspace_symbols<CR>", opts)

  -- --------------------------------------------------------------------------
  -- Documentation
  -- --------------------------------------------------------------------------

  opts.desc = "Show documentation"
  keymap.set("n", "K", vim.lsp.buf.hover, opts)

  opts.desc = "Show function signature"
  keymap.set("i", "<C-k>", vim.lsp.buf.signature_help, opts)

  -- --------------------------------------------------------------------------
  -- Actions
  -- --------------------------------------------------------------------------

  opts.desc = "Code actions"
  keymap.set({ "n", "v" }, "<leader>pa", vim.lsp.buf.code_action, opts)

  opts.desc = "Smart rename"
  keymap.set("n", "<leader>pn", vim.lsp.buf.rename, opts)

  opts.desc = "Restart LSP"
  keymap.set("n", "<leader>ps", ":LspRestart<CR>", opts)

  -- --------------------------------------------------------------------------
  -- INLAY HINTS
  -- --------------------------------------------------------------------------

  --- Toggle inlay hint for current buffer
  --- @return nil
  local function toggle_inlay_hint()
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = ev.buf }), { bufnr = ev.buf })
  end

  if client and client.server_capabilities.inlayHintProvider then
    opts.desc = "Toggle Inlay Hints"
    keymap.set("n", "<leader>ph", toggle_inlay_hint, opts)
  end
end

-- ============================================================================
-- LSP KEYMAPS & LOGIC (BUFFER-LOCAL)
-- ============================================================================

vim.api.nvim_create_autocmd(
  "LspAttach",
  {
    group = vim.api.nvim_create_augroup("UserLspConfig", {}),
    callback = setup_lsp_keymaps,
  }
)
