--- @brief LSP setup and configuration
--- see https://github.com/josean-dev/dev-environment-files

-- ============================================================================
-- LSP SERVERS CONFIGURATION
-- ============================================================================

local servers = {
  cpp = { "clangd" },
  dart = { "flutter_ls" },
  fortran = { "fortls" },
  go = { "gopls" },
  lua = { "lua_ls" },
  python = { "ty", "ruff" },
}

for _, group in pairs(servers) do
  for _, server in ipairs(group) do
    vim.lsp.config(server, {})
    vim.lsp.enable(server)
  end
end

-- ============================================================================
-- UI Config
-- ============================================================================

vim.diagnostic.config({
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = " ",
      [vim.diagnostic.severity.WARN] = " ",
      [vim.diagnostic.severity.HINT] = "󰠠 ",
      [vim.diagnostic.severity.INFO] = " ",
    },
  },
})

-- Enable inlay hints globally by default (can be toggled with <leader>ti)
vim.lsp.inlay_hint.enable(true)

-- ============================================================================
-- Utils
-- ============================================================================

--- Generates a list of strings representing all diagnostics in the current buffer.
--- Uses global diagnostic config for icons and severity names.
---
--- @return table|nil lines A list of formatted strings or nil if no diagnostics are found.
--- @return number|nil count The total number of diagnostics found or nil.
local function get_formatted_diagnostics()
  local bufnr = vim.api.nvim_get_current_buf()
  local diagnostics = vim.diagnostic.get(bufnr)
  if #diagnostics == 0 then return nil end

  -- Pull icons from your diagnostic config
  local diag_config = vim.diagnostic.config()
  local icons = (diag_config and diag_config.signs and diag_config.signs.text) or {}

  local lines = {}
  for _, diag in ipairs(diagnostics) do
    local severity_id = diag.severity
    local icon = icons[severity_id] or ""
    local severity_name = vim.diagnostic.severity[severity_id] or "UNKNOWN"

    local line_content = vim.api.nvim_buf_get_lines(bufnr, diag.lnum, diag.lnum + 1, false)[1] or ""
    local marker = string.rep(" ", diag.col) .. "^"

    -- Header: Icon + Severity Name + Source + Line Number
    local header = string.format("%s %s (%s): line %d", icon, severity_name, diag.source or "LSP", diag.lnum + 1)
    table.insert(lines, header)

    -- Message (Indented)
    for line in diag.message:gmatch("[^\n]+") do
      table.insert(lines, "  " .. line)
    end

    -- Code Snippet & Marker
    table.insert(lines, line_content)
    table.insert(lines, marker)
    table.insert(lines, "") -- Spacer
  end

  return lines, #diagnostics
end


--- Copies all formatted diagnostics from the current buffer to the system clipboard.
--- Uses the '+' register to interface with the system clipboard.
---
--- @return nil
local function yank_buffer_diagnostics()
  local lines, count = get_formatted_diagnostics()

  if not lines then
    print("No diagnostics to copy")
    return
  end

  vim.fn.setreg('+', table.concat(lines, '\n'))

  print("Copied " .. count .. " diagnostics to clipboard")
end

--- Show all formatted diagnostic in a floating window.
---
--- @return nil
local function show_buffer_diagnostics_float()
  local lines = get_formatted_diagnostics()
  if not lines then
    vim.notify("No diagnostics to show", vim.log.levels.INFO)
    return
  end

  local float_buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(float_buf, 0, -1, false, lines)

  vim.bo[float_buf].bufhidden = "wipe"
  vim.bo[float_buf].filetype = "markdown"
  vim.bo[float_buf].modifiable = false

  local width = math.floor(vim.o.columns * 0.8)
  local height = math.floor(vim.o.lines * 0.8)
  vim.api.nvim_open_win(
    float_buf,
    true,
    {
      relative = "editor",
      width = width,
      height = height,
      col = (vim.o.columns - width) / 2,
      row = (vim.o.lines - height) / 2,
      style = "minimal",
      border = "rounded",
      title = " Buffer Diagnostics ",
      title_pos = "center",
    }
  )

  local map_opts = { buffer = float_buf, silent = true, nowait = true }
  vim.keymap.set("n", "q", ":close<CR>", map_opts)
  vim.keymap.set("n", "<Esc>", ":close<CR>", map_opts)
end


--- Format current buffer, display diff and confirm changes
--- @return nil
local function format_with_confirmation()
  local bufnr = vim.api.nvim_get_current_buf()
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  vim.lsp.buf.format({ async = false })
  local new_lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

  if vim.deep_equal(lines, new_lines) then
    vim.notify("No formatting needed", vim.log.levels.INFO)
    return
  end

  -- remove formatting
  vim.cmd("undo")

  local diff = vim.diff(table.concat(lines, "\n"), table.concat(new_lines, "\n"), { result_type = "unified" })
  assert(type(diff) == "string", "vim.diff with result_type='unified' should return a string")

  local buf = vim.api.nvim_create_buf(false, true) -- Scratch buffer
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(diff, "\n"))
  vim.bo[buf].filetype = "diff"
  vim.bo[buf].modifiable = false

  local width = math.floor(vim.o.columns * 0.8)
  local height = math.floor(vim.o.lines * 0.8)
  local win = vim.api.nvim_open_win(
    buf,
    true,
    {
      relative = "editor",
      width = width,
      height = height,
      col = (vim.o.columns - width) / 2,
      row = (vim.o.lines - height) / 2,
      style = "minimal",
      border = "rounded",
      title = " Review Changes (y: apply, n/q: cancel) "
    }
  )

  vim.wo[win].wrap = false
  vim.wo[win].cursorline = true

  --- Apply formatting and close diff window
  --- @return nil
  local function close_and_apply()
    vim.api.nvim_win_close(win, true)
    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, new_lines)
    vim.notify("Formatted!", vim.log.levels.INFO)
  end

  --- Reject formatting and close diff window
  --- @return nil
  local function close_and_reject()
    vim.api.nvim_win_close(win, true)
    vim.notify("Formatting Cancelled", vim.log.levels.WARN)
  end

  local win_opts = { buffer = buf, nowait = true }
  vim.keymap.set("n", "y", close_and_apply, win_opts)
  vim.keymap.set("n", "n", close_and_reject, win_opts)
  vim.keymap.set("n", "q", close_and_reject, win_opts)
  vim.keymap.set("n", "<Esc>", close_and_reject, win_opts)
end

--- Configures and applies buffer-local keymaps for LSP interaction.
--- This function is intended to be called within an LspAttach autocommand.
--- It maps lsp commands specifically for the buffer where the LSP client is active.
---
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

  opts.desc = "Show LSP buffer symbols"
  keymap.set("n", "<leader>fb", "<cmd>Telescope lsp_document_symbols<CR>", opts)

  opts.desc = "Show LSP project symbols"
  keymap.set("n", "<leader>fp", "<cmd>Telescope lsp_dynamic_workspace_symbols<CR>", opts)

  -- --------------------------------------------------------------------------
  -- DIAGNOSTICS
  -- --------------------------------------------------------------------------

  opts.desc = "Show buffer diagnostics"
  keymap.set("n", "<leader>db", "<cmd>Telescope diagnostics bufnr=0<CR>", opts)

  opts.desc = "Show line diagnostics"
  keymap.set("n", "<leader>dd", vim.diagnostic.open_float, opts)

  opts.desc = "Go to previous diagnostic"
  keymap.set("n", "[d", function() vim.diagnostic.jump({ count = -1, float = true }) end, opts)

  opts.desc = "Go to next diagnostic"
  keymap.set("n", "]d", function() vim.diagnostic.jump({ count = 1, float = true }) end, opts)

  opts.desc = "Copy buffer diagnostics to clipboard"
  keymap.set("n", "<leader>dc", yank_buffer_diagnostics, opts)

  opts.desc = "See buffer diagnostics"
  keymap.set("n", "<leader>ds", show_buffer_diagnostics_float, opts)

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

  opts.desc = "See available code actions"
  keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)

  opts.desc = "Smart rename"
  keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

  opts.desc = "Restart LSP"
  keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts)

  -- --------------------------------------------------------------------------
  -- INLAY HINTS
  -- --------------------------------------------------------------------------

  --- Toggle inlay hint for current buffer
  --- @return nil
  local function toggle_inlay_hint()
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = ev.buf }), { bufnr = ev.buf })
  end

  ---@diagnostic disable-next-line: param-type-mismatch
  if client and client.supports_method("textDocument/inlayHint", ev.buf) then
    opts.desc = "Toggle Inlay Hints"
    keymap.set("n", "<leader>ti", toggle_inlay_hint, opts)
  end

  -- --------------------------------------------------------------------------
  -- FORMAT WITH CONFIRMATION (Y/N/Q)
  -- --------------------------------------------------------------------------
  opts.desc = "Format file (y/n)"
  keymap.set("n", "<leader>ff", format_with_confirmation, opts)
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
