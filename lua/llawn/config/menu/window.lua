--- @brief Window menu

local M = {}

M.window = {}

M.window.menu = function()
  local choices = {
    { "Horizontal Split", function() vim.cmd("split") end },
    { "Vertical Split", function() vim.cmd("vsplit") end },
    { "Move Left", function() vim.cmd("wincmd h") end },
    { "Move Right", function() vim.cmd("wincmd l") end },
    { "Move Up", function() vim.cmd("wincmd k") end },
    { "Move Down", function() vim.cmd("wincmd j") end },
    { "Close Window", function() vim.cmd("confirm close") end },
  }

  vim.ui.select(choices, {
    prompt = "Window Menu:",
    format_item = function(item) return item[1] end
  }, function(choice)
      if choice then
        choice[2]()
      end
    end)
end

return M
