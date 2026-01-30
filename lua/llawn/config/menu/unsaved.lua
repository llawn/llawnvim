--- Unsaved files menu

local M = {}

M.unsaved = {}

--- Gets a list of unsaved buffers
--- @return table List of unsaved buffer entries {buf, name}
local function get_unsaved_buffers()
  local bufs = vim.api.nvim_list_bufs()
  local unsaved = {}
  for _, buf in ipairs(bufs) do
    if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].modified then
      local name = vim.api.nvim_buf_get_name(buf)
      local filetype = vim.bo[buf].filetype
      -- Filter out dap-repl and other special buffers
      if name ~= '' and filetype ~= 'dap-repl' and filetype ~= 'dapui_watches' and filetype ~= 'dapui_hover' then
        table.insert(unsaved, { buf = buf, name = name })
      end
    end
  end
  return unsaved
end

--- Creates a diff previewer for unsaved files
--- @return table The diff previewer
local function create_diff_previewer()
  local previewers = require('telescope.previewers')
  return previewers.new_buffer_previewer({
    title = "Unsaved Diff",
    define_preview = function(self, entry, _)
      local bufnr = self.state.bufnr
      local file = entry.value.name
      -- Get buffer lines (modified)
      local buffer_lines = vim.api.nvim_buf_get_lines(entry.value.buf, 0, -1, false)
      -- Get file lines (original)
      local file_lines = {}
      if vim.fn.filereadable(file) == 1 then
        file_lines = vim.fn.readfile(file)
      end
      -- Apply diff to the preview buffer
      local diff_utils = require('llawn.utils.diff')
      diff_utils.apply_diff_to_buffer(
        bufnr,
        table.concat(file_lines, "\n"),
        table.concat(buffer_lines, "\n"),
        "unsaved_diff"
      )
    end
  })
end

--- Creates an entry maker for unsaved buffers
---@return function The entry maker function
local function create_entry_maker()
  return function(entry)
    return {
      value = entry,
      display = entry.name,
      ordinal = entry.name,
    }
  end
end

--- Sets up attach mappings for the unsaved files picker
---@param unsaved table List of unsaved buffers
---@return function The attach mappings function
local function setup_attach_mappings(unsaved)
  return function(prompt_bufnr, map)
    local actions = require('telescope.actions')
    local action_state = require('telescope.actions.state')

    -- Save selected file
    map('i', 'u', function()
      local selection = action_state.get_selected_entry()
      if selection then
        local buf = selection.value.buf
        vim.api.nvim_buf_call(buf, function()
          vim.cmd("w")
        end)
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
        vim.api.nvim_buf_call(buf, function()
          vim.cmd("e!")
        end)
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
        vim.api.nvim_buf_call(entry.buf, function()
          vim.cmd("e!")
        end)
      end
      print("Discarded all changes")
      actions.close(prompt_bufnr)
      M.unsaved.menu()
    end)

    return true
  end
end

M.unsaved.menu = function()
  local unsaved = get_unsaved_buffers()

  if #unsaved == 0 then
    print("No unsaved files")
    return
  end

  -- Load required telescope modules
  local pickers = require('telescope.pickers')
  local finders = require('telescope.finders')
  local sorters = require('telescope.sorters')

  local diff_previewer = create_diff_previewer()
  local entry_maker = create_entry_maker()
  local attach_mappings = setup_attach_mappings(unsaved)

  -- Create picker
  pickers.new({}, {
    prompt_title = "Unsaved Files [u: save, d: discard, U: save all, D: discard all]",
    finder = finders.new_table({ results = unsaved, entry_maker = entry_maker }),
    sorter = sorters.get_generic_fuzzy_sorter(),
    previewer = diff_previewer,
    attach_mappings = attach_mappings,
  }):find()
end

return M
