--- @brief Plugin configuration for undotree
--- undotree visualizes the undo history as a tree for easy navigation
---

return {
  "mbbill/undotree",

  config = function()
    -- Keybinding to toggle the undotree panel
    vim.keymap.set(
      "n",
      "<leader>u",
      vim.cmd.UndotreeToggle,
      { desc = "Toggle UndoTree"}
    )
  end
}

