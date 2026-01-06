--- @brief Provides UI menus in Neovim.
---

local M = {}

-- ============================================================================
-- Window Menu
-- ============================================================================

M.window = {}

M.window.menu = function()
  local choices = {
    { "Horizontal Split", function() vim.cmd("split") end },
    { "Vertical Split", function() vim.cmd("vsplit") end },
    { "Move Left", function() vim.cmd("wincmd h") end },
    { "Move Right", function() vim.cmd("wincmd l") end },
    { "Move Up", function() vim.cmd("wincmd k") end },
    { "Move Down", function() vim.cmd("wincmd j") end },
    { "Close Window", function() vim.cmd("close") end },
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

-- ============================================================================
-- Git Menu
-- ============================================================================

M.git = {}

M.git.menu = function()
  local choices = {
    { "Git Status", function() vim.cmd("!git status") end },
    { "Git Commit", function() vim.cmd("!git commit") end },
    { "Git Push", function() vim.cmd("!git push") end },
    { "Git Log", function() vim.cmd("!git log --oneline --graph --decorate --all") end },
    { "Git Diff", function() vim.cmd("!git diff") end },
  }

  vim.ui.select(choices, {
    prompt = "Git Menu:",
    format_item = function(item) return item[1] end
  }, function(choice)
    if choice then
      choice[2]()
    end
  end)
end

return M

