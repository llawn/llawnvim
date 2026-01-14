--- @brief Quit menu

local M = {}

local unsaved = require('llawn.config.menu.unsaved')

M.quit = {}

M.quit.smart_quit = function()
  if vim.fn.winnr('$') == 1 then
    -- Single window: check all buffers for unsaved and quit all
    local bufs = vim.api.nvim_list_bufs()
    local has_unsaved = false
    for _, buf in ipairs(bufs) do
      if vim.api.nvim_buf_is_loaded(buf) and vim.api.nvim_get_option_value('modified', { buf = buf }) and vim.api.nvim_buf_get_name(buf) ~= '' then
        has_unsaved = true
        break
      end
    end
    if has_unsaved then
      M.quit.menu()
    else
      vim.cmd("qa")
    end
  else
    -- Multiple windows: just close current window
    vim.cmd("q")
  end
end

M.quit.menu = function()
  local choices = {
    { "Unsaved Menu", function() unsaved.unsaved.menu() end },
    { "Force Quit", function() vim.cmd("qa!") end },
    { "Save All and Quit", function() vim.cmd("wa") vim.cmd("qa") end },
  }

  vim.ui.select(choices, {
    prompt = "Quit Options:",
    format_item = function(item) return item[1] end
  }, function(choice)
      if choice then
        choice[2]()
      end
    end)
end

return M
