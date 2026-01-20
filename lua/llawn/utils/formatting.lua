-- Synchronize Formatting behaviour between builtin lsp behaviour and conform

local M = {}

--- Format with confirmation using show diff
--- Use conform if available, otherwise fallback to vim.lsp.buf.format
--- @return nil
function M.format_with_confirmation()
  local bufnr = vim.api.nvim_get_current_buf()

  -- Check if LSP is available for this buffer
  local clients = vim.lsp.get_clients({ bufnr = bufnr })
  local has_lsp_formatter = false
  for _, client in ipairs(clients) do
    if client.server_capabilities.documentFormattingProvider or client.server_capabilities.documentRangeFormattingProvider then
      has_lsp_formatter = true
      break
    end
  end

  -- Check if conform has formatters for this buffer
  local ok, conform = pcall(require, "conform")
  local has_conform_formatter = false
  if ok then
    local conform_formatters = conform.list_formatters(bufnr)
    has_conform_formatter = #conform_formatters > 0
  end

  if not has_conform_formatter and not has_lsp_formatter then
    vim.notify("No formatter available", vim.log.levels.WARN)
    return
  end

  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

  if has_conform_formatter then
    conform.format({ async = false, bufnr = bufnr, lsp_format = "prefer" })
  else
    vim.lsp.buf.format({ bufnr = bufnr, async = false })
  end

  local new_lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

  if vim.deep_equal(lines, new_lines) then
    vim.notify("No formatting needed", vim.log.levels.INFO)
    return
  end

  local formatter_used = nil
  if has_conform_formatter then
    formatter_used = "Conform"
  end
  if has_lsp_formatter then
    formatter_used = formatter_used and formatter_used .. " LSP" or "LSP"
  end

  -- remove formatting on buffer
  vim.cmd("undo")

  local diff_utils = require('llawn.utils.diff')
  local buf, win = diff_utils.show_diff(
    table.concat(lines, "\n"),
    table.concat(new_lines, "\n"),
    " Review Changes (y: apply, n/q: cancel) "
  )

  --- Apply formatting and close diff window
  --- @return nil
  local function close_and_apply()
    vim.api.nvim_win_close(win, true)
    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, new_lines)
    vim.notify("Formatted with " .. formatter_used .. "!", vim.log.levels.INFO)
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

return M
