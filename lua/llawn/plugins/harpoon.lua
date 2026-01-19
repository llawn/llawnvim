-- Plugin: Harpoon
-- Description: Plugin configuration for quick file navigation in Neovim
--              Provides keybindings for adding and selecting frequently accessed files
-- Note: See harpoon files in ~/.local/share/nvim/harpoon/

return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },

  config = function()
    local harpoon = require("harpoon")

    -- basic telescope configuration
    local conf = require("telescope.config").values


    --- Deletes a harpoon item from the list
    --- @param selection table The selected entry to delete
    local function delete_harpoon_item(selection)
      local list = harpoon:list()
      -- find the index of the selected item
      local index
      local item_to_remove
      for i, item in ipairs(list.items) do
        if item and item.value == selection.value.value then
          index = i
          item_to_remove = item
          break
        end
      end
      if index then
        table.remove(list.items, index)
        list._length = list._length - 1
        -- Emit the REMOVE event to persist the change
        local Extensions = require("harpoon.extensions")
        Extensions.extensions:emit(Extensions.event_names.REMOVE, { list = list, item = item_to_remove, idx = index })
      end
    end

    --- Opens a telescope picker for harpoon files
    --- @param harpoon_files table The harpoon list
    local function toggle_telescope(harpoon_files)
      local finder = require("telescope.finders").new_table({
        results = harpoon_files.items,
        entry_maker = function(entry)
          return {
            value = entry,
            path = entry.value,
            display = entry.value,
            ordinal = entry.value,
          }
        end
      })

      require("telescope.pickers").new({}, {
        prompt_title = "Harpoon | [D]elete",
        finder = finder,
        previewer = conf.file_previewer({}),
        sorter = conf.generic_sorter({}),
        attach_mappings = function(prompt_bufnr, map)
          local actions = require("telescope.actions")
          local action_state = require("telescope.actions.state")

          map("i", "D", function()
            local selection = action_state.get_selected_entry()
            delete_harpoon_item(selection)
            actions.close(prompt_bufnr)
            vim.schedule(function() toggle_telescope(harpoon:list()) end)
          end)

          map("n", "D", function()
            local selection = action_state.get_selected_entry()
            delete_harpoon_item(selection)
            actions.close(prompt_bufnr)
            vim.schedule(function() toggle_telescope(harpoon:list()) end)
          end)

          return true
        end,
      }):find()
    end

    vim.keymap.set(
      "n",
      "<leader>a",
      function() harpoon:list():add() end,
      { desc = "Add to Harpoon" }
    )

    vim.keymap.set(
      "n",
      "<C-e>",
      function() toggle_telescope(harpoon:list()) end,
      { desc = "Open harpoon window" }
    )

    vim.keymap.set(
      "n",
      "<C-1>",
      function() harpoon:list():select(1) end,
      { desc = "Harpoon 1" }
    )

    vim.keymap.set(
      "n",
      "<C-2>",
      function() harpoon:list():select(2) end,
      { desc = "Harpoon 2" }
    )

    vim.keymap.set(
      "n",
      "<C-3>",
      function() harpoon:list():select(3) end,
      { desc = "Harpoon 3" }
    )

    -- Toggle previous & next buffers stored within Harpoon list
    vim.keymap.set(
      "n",
      "<leader>hp",
      function() harpoon:list():prev({ ui_nav_wrap = true }) end,
      { desc = "Harpoon previous" }
    )

    vim.keymap.set(
      "n",
      "<leader>hn",
      function() harpoon:list():next({ ui_nav_wrap = true }) end,
      { desc = "Harpoon next" }
    )
  end
}
