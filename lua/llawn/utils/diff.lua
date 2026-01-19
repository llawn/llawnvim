--- Utility functions for diff operations

local M = {}

--- Applies a unified diff to an existing buffer with syntax highlighting
--- @param bufnr number The buffer to apply the diff to
--- @param old_content string The original content
--- @param new_content string The modified content
--- @param ns_name string The namespace name for highlights
function M.apply_diff_to_buffer(bufnr, old_content, new_content, ns_name)
  local diff = vim.diff(old_content, new_content, { result_type = "unified" })
  assert(type(diff) == "string", "vim.diff with result_type='unified' should return a string")

  local diff_lines = vim.split(diff, "\n", { trimempty = false })
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, diff_lines)

  -- Add highlights for diff
  local ns_id = vim.api.nvim_create_namespace(ns_name)
  for i, line in ipairs(diff_lines) do
    if vim.startswith(line, "+") then
      vim.api.nvim_buf_set_extmark(bufnr, ns_id, i - 1, 0, { end_col = #line, hl_group = "DiffAdd" })
    elseif vim.startswith(line, "-") then
      vim.api.nvim_buf_set_extmark(bufnr, ns_id, i - 1, 0, { end_col = #line, hl_group = "DiffDelete" })
    elseif vim.startswith(line, "@@") then
      vim.api.nvim_buf_set_extmark(bufnr, ns_id, i - 1, 0, { end_col = #line, hl_group = "DiffChange" })
    end
  end
end

--- Displays a unified diff in a new buffer with syntax highlighting
--- @param old_content string The original content
--- @param new_content string The modified content
--- @param title string The title for the diff window
--- @return number, number The buffer and window numbers
function M.show_diff(old_content, new_content, title)
  local buf = vim.api.nvim_create_buf(false, true) -- Scratch buffer
  M.apply_diff_to_buffer(buf, old_content, new_content, "diff_highlight")
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
      title = title
    }
  )

  vim.wo[win].wrap = false
  vim.wo[win].cursorline = true

  return buf, win
end

return M
