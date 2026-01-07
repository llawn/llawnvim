--- @brief
---
--- Defines automatic actions triggered by Neovim events
--- 

-- ============================================================================
-- Highlight on Yank
-- ============================================================================

vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup(
    "highlight-yank",
    { clear = true }
  ),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- ============================================================================
-- Clean Undo Files Command
-- ============================================================================

vim.api.nvim_create_user_command("CleanUndo", function()
  local undodir = vim.fn.expand("~/.undodir", 1)
  if vim.fn.isdirectory(undodir) == 1 then
    vim.fn.system("rm -rf " .. undodir .. "/*")
    vim.notify("Undo files cleaned.", vim.log.levels.INFO)
  else
    vim.notify("Undodir does not exist.", vim.log.levels.WARN)
  end
end, { desc = "Clean all persistent undo files" })
