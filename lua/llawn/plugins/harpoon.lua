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
    local conf = require("telescope.config").values
    local themes = require("telescope.themes")

    --- Deletes a harpoon item from the list
    --- @param selection table The selected entry to delete
    local function delete_harpoon_item(selection)
      local list = harpoon:list()
      -- find the index of the selected item
      local index
      local item_to_remove
      for i, item in ipairs(list.items) do
        if item and item.value == selection.value then
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
        results = vim.tbl_map(function(item) return item.value end, harpoon_files.items),
        entry_maker = require("telescope.make_entry").gen_from_file({})
      })

      local dropdown_options = themes.get_dropdown({
        previewer = false,
        initial_mode = "insert",
      })

      require("telescope.pickers").new(dropdown_options, {
        prompt_title = "Harpoon | [D]elete",
        finder = finder,
        sorter = conf.generic_sorter({}),
        attach_mappings = function(prompt_bufnr, map)
          local actions = require("telescope.actions")
          local action_state = require("telescope.actions.state")

          -- Helper to handle deletion
          local function do_delete()
            local selection = action_state.get_selected_entry()
            delete_harpoon_item(selection)
            actions.close(prompt_bufnr)
            -- Re-open to refresh the list
            vim.schedule(function()
              toggle_telescope(harpoon:list())
            end)
          end

          map("i", "<C-d>", do_delete) -- Use Ctrl+d in insert mode
          map("n", "D", do_delete)     -- Use D in normal mode

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
