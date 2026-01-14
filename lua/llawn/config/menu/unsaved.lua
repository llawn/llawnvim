--- @brief Unsaved files menu

local M = {}

M.unsaved = {}

M.unsaved.menu = function()
  -- Load required telescope modules
  local pickers = require('telescope.pickers')
  local finders = require('telescope.finders')
  local sorters = require('telescope.sorters')
  local previewers = require('telescope.previewers')

  -- Get list of unsaved buffers
  local bufs = vim.api.nvim_list_bufs()
  local unsaved = {}
  for _, buf in ipairs(bufs) do
    if vim.api.nvim_buf_is_loaded(buf) and vim.api.nvim_buf_get_option(buf, 'modified') then
      local name = vim.api.nvim_buf_get_name(buf)
      if name ~= '' then
        table.insert(unsaved, { buf = buf, name = name })
      end
    end
  end

  if #unsaved == 0 then
    print("No unsaved files")
    return
  end

  -- Diff previewer
  local diff_previewer = previewers.new_buffer_previewer({
    title = "Unsaved Diff",
    define_preview = function(self, entry, _)
      local bufnr = self.state.bufnr
      local file = entry.value.name
      -- Get buffer lines
      local lines = vim.api.nvim_buf_get_lines(entry.value.buf, 0, -1, false)
      -- Create temp file with buffer content
      local temp_file = vim.fn.tempname()
      vim.fn.writefile(lines, temp_file)
      -- Run diff command
      local cmd = "diff -u '" .. vim.fn.shellescape(file) .. "' '" .. vim.fn.shellescape(temp_file) .. "' 2>/dev/null || echo 'No differences'"
      local handle = io.popen(cmd)
      local diff_output = handle:read("*a")
      handle:close()
      os.remove(temp_file)
      local diff_lines = vim.split(diff_output, "\n", { trimempty = false })
      vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, diff_lines)
      -- Add highlights for diff
      local ns_id = vim.api.nvim_create_namespace("unsaved_diff")
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
  })

  -- Entry maker
  local entry_maker = function(entry)
    return {
      value = entry,
      display = entry.name,
      ordinal = entry.name,
    }
  end

      -- Create picker
      pickers.new({}, {
        prompt_title = "Unsaved Files [u: save, d: discard, U: save all, D: discard all]",
        finder = finders.new_table({ results = unsaved, entry_maker = entry_maker }),
        sorter = sorters.get_generic_fuzzy_sorter(),
        previewer = diff_previewer,
        attach_mappings = function(prompt_bufnr, map)
          local actions = require('telescope.actions')
          local action_state = require('telescope.actions.state')

          -- Save selected file
          map('i', 'u', function()
            local selection = action_state.get_selected_entry()
            if selection then
              local buf = selection.value.buf
              vim.api.nvim_buf_call(buf, function() vim.cmd("w") end)
              print("Saved " .. selection.value.name)
              actions.close(prompt_bufnr)
              M.unsaved.menu()
            end
          end)

          -- Discard selected file changes
          map('i', 'd', function()
            local selection = action_state.get_selected_entry()
            if selection then
              local buf = selection.value.buf
              vim.api.nvim_buf_call(buf, function() vim.cmd("e!") end)
              print("Discarded changes for " .. selection.value.name)
              actions.close(prompt_bufnr)
              M.unsaved.menu()
            end
          end)

          -- Save all files
          map('i', 'U', function()
            vim.cmd("wa")
            print("Saved all files")
            actions.close(prompt_bufnr)
            M.unsaved.menu()
          end)

          -- Discard all changes
          map('i', 'D', function()
            for _, entry in ipairs(unsaved) do
              vim.api.nvim_buf_call(entry.buf, function() vim.cmd("e!") end)
            end
            print("Discarded all changes")
            actions.close(prompt_bufnr)
            M.unsaved.menu()
          end)

          return true
        end,
      }):find()
end

return M
