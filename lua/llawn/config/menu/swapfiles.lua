-- Menu for swap files

local M = {}

M.swapfiles = {}

M.swapfiles.menu = function()
  -- Load required telescope modules
  local pickers = require('telescope.pickers')
  local finders = require('telescope.finders')
  local sorters = require('telescope.sorters')
  local previewers = require('telescope.previewers')

  -- Helper to decode swap file name to original path
  local function decode_swapname(encoded)
    local result = {}
    local i = 1
    while i <= #encoded do
      if encoded:sub(i, i) == '%' then
        i = i + 1
        if i <= #encoded then
          local next_char = encoded:sub(i, i)
          if next_char == '%' then
            table.insert(result, '%')
          elseif next_char == ':' then
            table.insert(result, ':')
          else
            table.insert(result, '/')
            i = i - 1  -- replay the current char
          end
        else
          table.insert(result, '/')
        end
      else
        table.insert(result, encoded:sub(i, i))
      end
      i = i + 1
    end
    return table.concat(result)
  end

  -- Find swap files in Neovim's swap directory
  local swap_dir = vim.opt.directory:get()
  if type(swap_dir) == "table" then swap_dir = swap_dir[1] end
  -- Remove trailing // if present
  swap_dir = swap_dir:gsub("//$", "/")
  local swapfiles_list = vim.fn.globpath(swap_dir, "**/*.swp", false, true)
  local swapfiles = {}
  for _, swapfile in ipairs(swapfiles_list) do
    -- Get the encoded part from the filename
    local fname = vim.fn.fnamemodify(swapfile, ":t")
    local encoded = fname:gsub("%.swp$", "")
    local original = decode_swapname(encoded)
    table.insert(swapfiles, { swapfile = swapfile, original = original })
  end

  -- Filter to only swap files for files not currently open in buffers
  local filtered_swapfiles = {}
  for _, entry in ipairs(swapfiles) do
    local is_open = false
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      if vim.api.nvim_buf_is_loaded(buf) and vim.api.nvim_buf_get_name(buf) == entry.original then
        is_open = true
        break
      end
    end
    if not is_open then
      table.insert(filtered_swapfiles, entry)
    end
  end
  swapfiles = filtered_swapfiles

  if #swapfiles == 0 then
    print("No swap files found for closed files")
    return
  end

  -- Previewer to show diff between saved file and swap content
  local swap_previewer = previewers.new_buffer_previewer({
    title = "Swap File Diff",
    define_preview = function(self, entry, _)
      local bufnr = self.state.bufnr
      local original = entry.value.original

      if not vim.fn.filereadable(original) then
        vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, {"Original file does not exist, cannot show diff."})
        return
      end

      -- Get saved file lines
      local saved_lines = vim.fn.readfile(original)

      -- Recover swap content to temp buffer (silently)
      local temp_buf = vim.api.nvim_create_buf(false, true)
      vim.api.nvim_buf_call(temp_buf, function() vim.cmd("silent recover! " .. vim.fn.fnameescape(original)) end)
      local swap_lines = vim.api.nvim_buf_get_lines(temp_buf, 0, -1, false)
      vim.api.nvim_buf_delete(temp_buf, { force = true })

      -- Create temp files for diff
      local temp_saved = vim.fn.tempname()
      local temp_swap = vim.fn.tempname()
      vim.fn.writefile(saved_lines, temp_saved)
      vim.fn.writefile(swap_lines, temp_swap)

       -- Run diff
       local cmd = "diff -u '" .. vim.fn.shellescape(temp_saved) .. "' '" .. vim.fn.shellescape(temp_swap) .. "' 2>/dev/null || echo 'No differences'"
       local handle = io.popen(cmd)
       local diff_output
       if handle then
         diff_output = handle:read("*a")
         handle:close()
       else
         diff_output = "Failed to run diff command"
       end
      os.remove(temp_saved)
      os.remove(temp_swap)

      -- Clean output and split into lines
      diff_output = diff_output:gsub("\r", ""):gsub("\n+", "\n")
      local diff_lines = {}
      for line in diff_output:gmatch("[^\n]*") do
        if line ~= "" then
          table.insert(diff_lines, line)
        end
      end

      -- Add header for clarity
      table.insert(diff_lines, 1, "Diff: Saved file (---) vs Swap content (+++)")
      table.insert(diff_lines, 2, "- lines: removed from saved, + lines: added in swap")
      table.insert(diff_lines, 3, "")

      vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, diff_lines)

      -- Add highlights
      local ns_id = vim.api.nvim_create_namespace("swap_diff")
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
    local relative_original = vim.fn.fnamemodify(entry.original, ":.")
    return {
      value = entry,
      display = relative_original .. " (swap)",
      ordinal = entry.original,
    }
  end

  -- Create picker
  pickers.new({}, {
    prompt_title = "Swap Files [r: recover, x: delete, X: delete all]",
    finder = finders.new_table({ results = swapfiles, entry_maker = entry_maker }),
    sorter = sorters.get_generic_fuzzy_sorter(),
    previewer = swap_previewer,
    attach_mappings = function(prompt_bufnr, map)
      local actions = require('telescope.actions')
      local action_state = require('telescope.actions.state')

      -- Override default enter to do simple recover
      actions.select_default:replace(function()
        local selection = action_state.get_selected_entry()
        if selection then
          local original = selection.value.original
          local swapfile = selection.value.swapfile
          vim.cmd("recover! " .. vim.fn.fnameescape(original))
          os.remove(swapfile)
          print("Recovered " .. original)
        end
        pcall(function() actions.close(prompt_bufnr) end)
      end)

      -- Recover selected swap file (simple recover without merge)
      map('i', 'r', function()
        local selection = action_state.get_selected_entry()
        if selection then
          local original = selection.value.original
          local swapfile = selection.value.swapfile
          local ok = pcall(function() vim.cmd("recover! " .. vim.fn.fnameescape(original)) end)
          if ok then
            os.remove(swapfile)
          else
            print("Recover failed for " .. original)
          end
          actions.close(prompt_bufnr)
          M.swapfiles.menu()
        end
      end)

      -- Delete selected swap file
      map('i', 'x', function()
        local selection = action_state.get_selected_entry()
        if selection then
          local swapfile = selection.value.swapfile
          os.remove(swapfile)
          print("Deleted swap file: " .. swapfile)
          actions.close(prompt_bufnr)
          M.swapfiles.menu()
        end
      end)

      -- Delete all swap files
      map('i', 'X', function()
        for _, entry in ipairs(swapfiles) do
          os.remove(entry.swapfile)
        end
        print("Deleted all swap files")
        actions.close(prompt_bufnr)
        M.swapfiles.menu()
      end)

      return true
    end,
  }):find()
end

return M
