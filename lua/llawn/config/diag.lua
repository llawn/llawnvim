--- Diagnostic utilities and global keymaps
--- Works with both LSP diagnostics and nvim-lint

-- ============================================================================
-- DIAGNOSTIC CONFIGURATION
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

-- ============================================================================
-- DIAGNOSTIC UTILITIES
-- ============================================================================

local M = {}

--- Generates a list of strings representing diagnostics in the current buffer, optionally filtered by source.
--- Uses global diagnostic config for icons and severity names.
--- @param source string|nil The source to filter by (e.g., "ruff", "ty"). If nil, show all.
--- @return table|nil lines A list of formatted strings or nil if no diagnostics are found.
--- @return number|nil count The total number of diagnostics found or nil.
function M.get_formatted_diagnostics(source)
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
function M.yank_buffer_diagnostics(source)
  local lines, count = M.get_formatted_diagnostics(source)

  if not lines then
    local msg = source and ("No diagnostics from " .. source .. " to copy") or "No diagnostics to copy"
    print(msg)
    return
  end

  vim.fn.setreg('+', table.concat(lines, '\n'))

  local src_text = source and source .. " " or ""
  local msg = ("Copied %d %sdiagnostics to clipboard"):format(count, src_text)
  print(msg)
end

--- Show formatted diagnostics filtered by source in a floating window.
--- @param source string|nil The source to filter by (e.g., "ruff", "ty"). If nil, show all.
--- @return nil
function M.show_buffer_diagnostics_float(source)
  local lines, _ = M.get_formatted_diagnostics(source)
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

-- ============================================================================
-- GLOBAL DIAGNOSTIC KEYMAPS (works with LSP and nvim-lint)
-- ============================================================================

function M.setup_global_diagnostic_keymaps()
  local base_opts = { silent = true, noremap = true }
  local keymap = vim.keymap

  keymap.set("n", "<leader>db", "<cmd>Telescope diagnostics bufnr=0<CR>",
    vim.tbl_extend("force", base_opts, { desc = "Telescope buffer diag" }))
  keymap.set("n", "<leader>dd", vim.diagnostic.open_float,
    vim.tbl_extend("force", base_opts, { desc = "Line diagnostics" }))
  keymap.set("n", "[d", function() vim.diagnostic.jump({ count = -1, float = true }) end,
    vim.tbl_extend("force", base_opts, { desc = "Previous diagnostic" }))
  keymap.set("n", "]d", function() vim.diagnostic.jump({ count = 1, float = true }) end,
    vim.tbl_extend("force", base_opts, { desc = "Next diagnostic" }))
  keymap.set("n", "<leader>dc", function() M.yank_buffer_diagnostics() end,
    vim.tbl_extend("force", base_opts, { desc = "Copy buffer diag" }))
  keymap.set("n", "<leader>dC", function()
    vim.ui.input({ prompt = "Diagnostic source: " }, function(input)
      if input and input ~= "" then
        M.yank_buffer_diagnostics(input)
      end
    end)
  end, vim.tbl_extend("force", base_opts, { desc = "Copy buffer diag (source)" }))
  keymap.set("n", "<leader>ds", function() M.show_buffer_diagnostics_float() end,
    vim.tbl_extend("force", base_opts, { desc = "See buffer diag" }))
  keymap.set("n", "<leader>dS", function()
    vim.ui.input({ prompt = "Diagnostic source: " }, function(input)
      if input and input ~= "" then
        M.show_buffer_diagnostics_float(input)
      end
    end)
  end, vim.tbl_extend("force", base_opts, { desc = "See buffer diag (source)" }))
end

return M
