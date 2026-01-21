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

--- Generates a list of strings representing diagnostics in the current buffer, optionally filtered by source.
--- Uses global diagnostic config for icons and severity names.
--- @param source string|nil The source to filter by (e.g., "ruff", "ty"). If nil, show all.
--- @return table|nil lines A list of formatted strings or nil if no diagnostics are found.
--- @return number|nil count The total number of diagnostics found or nil.
local function get_formatted_diagnostics(source)
  local bufnr = vim.api.nvim_get_current_buf()
  local diagnostics = vim.diagnostic.get(bufnr)
  if #diagnostics == 0 then return nil end

  -- Filter diagnostics by source if specified
  if source then
    diagnostics = vim.tbl_filter(
      function(diag)
        return diag.source == source
      end,
      diagnostics
    )
    if #diagnostics == 0 then return nil end
  end

  local lines = {}
  for i, diag in ipairs(diagnostics) do
    local severity_id = diag.severity
    local severity_name = vim.diagnostic.severity[severity_id] or "UNKNOWN"

    local line_content = vim.api.nvim_buf_get_lines(bufnr, diag.lnum, diag.lnum + 1, false)[1] or ""
    local marker = string.rep(" ", diag.col) .. "^"

    -- Header: Icon + Severity Name + Source + Line Number
    local header = string.format("`[%d/%d]` %s (%s): line %d", i, #diagnostics, severity_name, diag.source or "N/A",
      diag.lnum + 1)
    table.insert(lines, header)

    -- Message (Indented)
    for line in diag.message:gmatch("[^\n]+") do
      table.insert(lines, line)
    end

    -- Code Snippet & Marker (Indented)
    table.insert(lines, line_content)
    table.insert(lines, marker)
    table.insert(lines, "") -- Spacer
  end

  return lines, #diagnostics
end


--- Copies formatted diagnostics from the current buffer to the system clipboard, optionally filtered by source.
--- Uses the '+' register to interface with the system clipboard.
--- @param source string|nil The source to filter by. If nil, copy all.
--- @return nil
local function yank_buffer_diagnostics(source)
  local lines, count = get_formatted_diagnostics(source)

  if not lines then
    local msg = source and ("No diagnostics from " .. source .. " to copy") or "No diagnostics to copy"
    print(msg)
    return
  end

  vim.fn.setreg('+', table.concat(lines, '\n'))

  local msg = source and ("Copied " .. count .. " " .. source .. " diagnostics to clipboard") or
      ("Copied " .. count .. " diagnostics to clipboard")
  print(msg)
end

--- Show formatted diagnostics filtered by source in a floating window.
--- @param source string|nil The source to filter by (e.g., "ruff", "ty"). If nil, show all.
--- @return nil
local function show_buffer_diagnostics_float(source)
  local lines, _ = get_formatted_diagnostics(source)
  if not lines then
    local msg = source and ("No diagnostics from " .. source) or "No diagnostics to show"
    vim.notify(msg, vim.log.levels.INFO)
    return
  end

  local title = source and (" " .. source .. " Diagnostics ") or " Buffer Diagnostics "

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
      title = title,
      title_pos = "center",
    }
  )

  local map_opts = { buffer = float_buf, silent = true, nowait = true }
  vim.keymap.set("n", "q", ":close<CR>", map_opts)
  vim.keymap.set("n", "<Esc>", ":close<CR>", map_opts)
end

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

  opts.desc = "Show LSP buffer symbols"
  keymap.set("n", "<leader>tb", "<cmd>Telescope lsp_document_symbols<CR>", opts)

  opts.desc = "Show LSP project symbols"
  keymap.set("n", "<leader>tw", "<cmd>Telescope lsp_dynamic_workspace_symbols<CR>", opts)

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
  keymap.set("n", "<leader>dc", function() yank_buffer_diagnostics() end, opts)

  opts.desc = "Copy buffer diagnostics to clipboard (prompt for source)"
  keymap.set("n", "<leader>dC", function()
    vim.ui.input({ prompt = "Diagnostic source: " }, function(input)
      if input and input ~= "" then
        yank_buffer_diagnostics(input)
      end
    end)
  end, opts)

  opts.desc = "See buffer diagnostics"
  keymap.set("n", "<leader>ds", function() show_buffer_diagnostics_float() end, opts)

  opts.desc = "See buffer diagnostics (prompt for source)"
  keymap.set("n", "<leader>dS", function()
    vim.ui.input({ prompt = "Diagnostic source: " }, function(input)
      if input and input ~= "" then
        show_buffer_diagnostics_float(input)
      end
    end)
  end, opts)

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

  -- Synchronize formatting behaviour between builtin lsp formatting and conform
  -- So formatting (works even without LSP)
  opts.desc = "Format file (y/n)"
  keymap.set("n", "<leader>pf", require("llawn.utils.formatting").format_with_confirmation, opts)
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
