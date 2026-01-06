--- @brief Harpoon plugin configuration for quick file navigation in Neovim
--- Provides keybindings for adding and selecting frequently accessed files
---

return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },

  config = function()
    local harpoon = require("harpoon")

    harpoon:setup()

    vim.keymap.set(
      "n",
      "<leader>a",
      function() harpoon:list():add() end,
      { desc = "Add file to harpoon list"}
    )
    vim.keymap.set(
      "n",
      "<C-e>",
      function() harpoon.ui:toggle_quick_menu(harpoon:list()) end,
      { desc = "Toggle harpoon quick menu" }
    )

    vim.keymap.set(
      "n",
      "<C-1>",
      function() harpoon:list():select(1) end,
      { desc = "Select harpoon file 1" }
    )

    vim.keymap.set(
      "n",
      "<C-2>",
      function() harpoon:list():select(2) end,
      { desc = "Select harpoon file 2" }
    )

    vim.keymap.set(
      "n",
      "<C-3>",
      function() harpoon:list():select(3) end,
      { desc = "Select harpoon file 3" }
    )
  end
}
