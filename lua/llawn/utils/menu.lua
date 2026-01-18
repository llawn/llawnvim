--- Utility function for installation menu

local M = {}

--- @enum InstallationStatus
M.Status = {
  MISSING = "Not Installed",
  OUTDATED = "Outdated",
  UP_TO_DATE = "Installed",
}

--- Opens a URL using the system's default browser.
--- @param url string The URL to open
--- @return nil
M.open_url = function(url)
  local opener = vim.fn.has("mac") == 1 and "open" or "xdg-open"
  os.execute(opener .. " " .. url .. " > /dev/null 2>&1")
end

--- Sets up highlight groups with the given prefix.
--- @param prefix string The prefix for highlight group names
--- @return nil
M.setup_highlights = function(prefix)
  vim.api.nvim_set_hl(0, prefix .. "Good", { fg = "#00FF00", bold = true })
  vim.api.nvim_set_hl(0, prefix .. "Warning", { fg = "#FFA500", bold = true })
  vim.api.nvim_set_hl(0, prefix .. "Bad", { fg = "#FF0000", bold = true })
end

--- Creates a standardized previewer for installation menus.
--- @param extract_fn function Function that returns {name, languages, url, target, status}
--- @param title string|nil Optional title for the previewer
--- @return table The telescope previewer object
M.create_install_previewer = function(extract_fn, title)
  local default_title = "[F]ilter, [I]nstall, [X]Remove, [U]pdate, [O]pen in Browser"
  return M.create_base_previewer(
    title or default_title,
    function(entry)
      local data = extract_fn(entry)
      local lines = {
        "**Name:** " .. data.name,
        "**Languages:** " .. data.languages,
        "**Url:** " .. data.url,
        "**Target:** " .. data.target,
        "**Status:** " .. data.status,
        "",
        "**Description:**"
      }
      -- Add description lines
      local desc_lines = vim.split(data.description, "\n", { plain = true })
      for _, line in ipairs(desc_lines) do
        table.insert(lines, line)
      end
      return lines
    end
  )
end

--- Creates a base previewer for telescope.
--- @param title string The title for the previewer
--- @param info_extract_fn function Function to extract info from an entry
--- @return table The telescope previewer object
M.create_base_previewer = function(title, info_extract_fn)
  return require('telescope.previewers').new_buffer_previewer({
    title = title,
    define_preview = function(self, entry)
      if type(entry.value) ~= "table" then return end
      local lines = info_extract_fn(entry.value)
      vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, lines)
      vim.bo[self.state.bufnr].filetype = 'markdown'
    end
  })
end

--- Builds a categorized list from items based on a check function and filter.
--- @param items table List of items to categorize
--- @param check_fn fun(item): InstallationStatus Function that returns the status enum
--- @param active_filter string|nil The filter to apply, or nil for no filter
--- @return table The categorized results list
M.build_categorized_list = function(items, check_fn, active_filter)
  local categories = {
    [M.Status.UP_TO_DATE] = { label = "--- Up to Date ---", list = {} },
    [M.Status.OUTDATED]   = { label = "--- Outdated ---", list = {} },
    [M.Status.MISSING]    = { label = "--- Not Installed ---", list = {} },
  }

  for _, item in ipairs(items) do
    local status = check_fn(item)
    if not active_filter or active_filter == "All" or active_filter == status then
      table.insert(categories[status].list, item)
    end
  end

  local results = {}
  local order = { M.Status.OUTDATED, M.Status.UP_TO_DATE, M.Status.MISSING }

  for _, key in ipairs(order) do
    local cat = categories[key]
    if #cat.list > 0 then
      table.insert(results, cat.label)

      for _, item in ipairs(cat.list) do
        table.insert(results, item)
      end

      table.insert(results, "")
    end
  end

  return results
end

--- Creates attach mappings for telescope picker.
--- @param action_table table Table of key-action configurations
--- @param reload_fn function Function to reload the picker
--- @param filter_fn function Function to apply a filter
--- @return function The attach mappings function
M.create_attach_mappings = function(action_table, reload_fn, filter_fn)
  return function(prompt_bufnr, map)
    local actions = require('telescope.actions')
    local action_state = require('telescope.actions.state')

    -- The "F" key opens the status filter menu
    map('i', 'F', function()
      actions.close(prompt_bufnr)
      vim.ui.select(
        {
          "All",
          M.Status.UP_TO_DATE,
          M.Status.OUTDATED,
          M.Status.MISSING
        },
        { prompt = "Filter by status:" },
        function(choice)
          if choice then filter_fn(choice) end
        end
      )
    end)

    for key, config in pairs(action_table) do
      map('i', key, function()
        local sel = action_state.get_selected_entry()
        local item = sel and type(sel.value) == "table" and sel.value or nil
        if config.condition(item) then
          if config.msg and item then print(config.msg .. (item.name or item.lang or "")) end
          config.action(item)
          if not config.no_close then
            actions.close(prompt_bufnr)
            vim.defer_fn(reload_fn, 500)
          end
        end
      end)
    end
    return true
  end
end

--- Creates a telescope picker with common configuration.
--- @param opts table Options for the picker (prompt_title, finder, previewer, attach_mappings)
--- @return nil
M.create_picker = function(opts)
  local default_opts = {
    sorter = require('telescope.sorters').get_generic_fuzzy_sorter(),
    layout_config = { preview_width = 0.7 },
  }
  local picker_opts = vim.tbl_extend("force", default_opts, opts)
  require('telescope.pickers').new({}, picker_opts):find()
end

return M
