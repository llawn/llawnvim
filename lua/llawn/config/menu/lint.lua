-- Lint Menu: Provides linting information and actions
local M = {}

-- Internal Helpers
local function get_executable_path(name)
  local lint_ok, lint = pcall(require, "lint")
  local cmd_name = name

  if lint_ok then
    local linter = lint.linters[name]
    if linter and linter.cmd and linter.cmd ~= "not found" then
      if type(linter.cmd) == "string" then
        cmd_name = linter.cmd
      elseif type(linter.cmd) == "table" then
        cmd_name = linter.cmd[1]
      end
    end
  end

  local path = vim.fn.exepath(cmd_name)
  return (path ~= "") and path or nil
end

local function get_lsp_linters(bufnr)
  local lsp_linters = {}
  local clients = vim.lsp.get_clients({ bufnr = bufnr })
  for _, client in ipairs(clients) do
    -- Check if the client provides diagnostics (the modern LSP way to "lint")
    if client.server_capabilities.diagnosticProvider then
      table.insert(lsp_linters, {
        name = client.name,
        path = client.config.cmd and vim.fn.exepath(client.config.cmd[1]) or "unknown",
      })
    end
  end
  return lsp_linters
end

---@param name string Linter name
---@param status string "ready" | "available" | "configured"
---@param ft string Filetype
local function format_linter_line(name, status, ft)
  local path = get_executable_path(name)
  local path_str = path and (" " .. path) or " (command not in PATH)"
  return string.format("    %s %s (%s)%s", name, status, ft, path_str)
end

-- Main Info Function
local function show_lint_info()
  local mason_utils = require("llawn.utils.mason")
  local lint_ok, lint = pcall(require, "lint")
  if not lint_ok then
    vim.notify("nvim-lint not found", vim.log.levels.ERROR)
    return
  end

  local bufnr = vim.api.nvim_get_current_buf()
  local current_ft = vim.bo[bufnr].filetype
  local lines = { "# Linting Report", "" }

  -- 1. Get Active LSP Linters
  local lsp_linters = get_lsp_linters(bufnr)
  table.insert(lines, "## Current Buffer (" .. current_ft .. ")")

  if #lsp_linters > 0 then
    table.insert(lines, "  LSP Providers:")
    for _, client in ipairs(lsp_linters) do
      table.insert(lines, string.format("    %s ready %s", client.name, client.path))
    end
  end

  -- 2. Get nvim-lint Linters
  local configured_linters = lint.linters_by_ft[current_ft] or {}
  if #configured_linters > 0 then
    table.insert(lines, "  Configured Linters (nvim-lint):")
    for _, name in ipairs(configured_linters) do
      table.insert(lines, format_linter_line(name, "ready", current_ft))
    end
  end

  -- 3. Get Mason suggestions (not yet configured)
  local mason_all = mason_utils.get_mason_tools("Linter")[current_ft] or {}
  local available = {}
  for _, name in ipairs(mason_all) do
    local is_lsp = vim.iter(lsp_linters):any(function(l)
      return l.name == name
    end)
    if not is_lsp and not vim.tbl_contains(configured_linters, name) then
      table.insert(available, name)
    end
  end

  if #available > 0 then
    table.insert(lines, "  Available from Mason (unconfigured):")
    for _, name in ipairs(available) do
      table.insert(lines, format_linter_line(name, "available", current_ft))
    end
  end

  -- 4. Other Filetypes
  table.insert(lines, "")
  table.insert(lines, "## Other Filetypes")
  local all_mason = mason_utils.get_mason_tools("Linter")
  local other_fts = vim.tbl_keys(all_mason)
  table.sort(other_fts)

  for _, ft in ipairs(other_fts) do
    if ft ~= current_ft then
      for _, name in ipairs(all_mason[ft]) do
        local status = vim.tbl_contains(lint.linters_by_ft[ft] or {}, name) and "configured" or "available"
        table.insert(lines, format_linter_line(name, status, ft))
      end
    end
  end

  -- UI Creation
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

  -- Apply basic syntax highlighting
  vim.bo[buf].filetype = "markdown"
  vim.bo[buf].buftype = "nofile"
  vim.bo[buf].bufhidden = "wipe"

  local width = math.floor(vim.o.columns * 0.8)
  local height = math.min(#lines + 2, math.floor(vim.o.lines * 0.8))

  vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    col = math.floor((vim.o.columns - width) / 2),
    row = math.floor((vim.o.lines - height) / 2),
    style = "minimal",
    border = "rounded",
    title = " Lint Info ",
    title_pos = "center",
  })

  local opts = { buffer = buf, silent = true }
  vim.keymap.set("n", "q", "<cmd>close<CR>", opts)
  vim.keymap.set("n", "<Esc>", "<cmd>close<CR>", opts)
end

M.lint = {
  menu = show_lint_info
}

return M
