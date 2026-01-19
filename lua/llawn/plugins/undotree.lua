-- Plugin: Undotree
-- Description: The undo tree visualizes the undo history and makes it easy
--              to browse and switch between different undo branches.

return {
  "mbbill/undotree",

  config = function()
    -- Keybinding to toggle the undotree panel
    vim.keymap.set(
      "n",
      "<leader>u",
      vim.cmd.UndotreeToggle,
      { desc = "UndoTree"}
    )
  end
}

