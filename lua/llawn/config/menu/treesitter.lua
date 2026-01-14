local M = {}

M.treesitter = {}

M.treesitter.menu = function()

  -- Helper: Open URL
  local function open_url(url)
    local opener = vim.fn.has("mac") == 1 and "open" or "xdg-open"
    os.execute(opener .. " " .. url .. " > /dev/null 2>&1")
  end

  -- Load required nvim-treesitter modules for parser management
  local utils = require('nvim-treesitter.utils')
  local parsers = require('nvim-treesitter.parsers')
  local configs = require('nvim-treesitter.configs')

  -- Global lockfile data for parser revisions
  local lockfile = {}

  -- Load the lockfile.json containing parser revision information
  local function load_lockfile()
    local filename = utils.join_path(utils.get_package_path(), "lockfile.json")
    lockfile = vim.fn.filereadable(filename) == 1 and vim.fn.json_decode(vim.fn.readfile(filename)) or {}
  end

  -- Get list of all available parsers from nvim-treesitter configs
  local function get_available_parsers()
    local parser_configs = parsers.get_parser_configs()
    local available = {}
    for lang, _ in pairs(parser_configs) do
      table.insert(available, lang)
    end
    table.sort(available)
    return available
  end

  -- Retrieve installation info for a specific parser
  local function get_parser_install_info(lang)
    local parser_config = parsers.get_parser_configs()[lang]
    if not parser_config then
      error('Parser not available for language "' .. lang .. '"')
    end
    return parser_config.install_info
  end

  -- Get the latest revision for a parser from lockfile or install info
  local function get_revision(lang)
    if #lockfile == 0 then
      load_lockfile()
    end
    local install_info = get_parser_install_info(lang)
    if install_info.revision then
      return install_info.revision
    end
    if lockfile[lang] then
      return lockfile[lang].revision
    end
  end

  -- Get the currently installed revision for a parser
  local function get_installed_revision(lang)
    local parser_info_dir = configs.get_parser_info_dir()
    if not parser_info_dir then
      return nil
    end
    local lang_file = utils.join_path(parser_info_dir, lang .. ".revision")
    if vim.fn.filereadable(lang_file) == 1 then
      return vim.fn.readfile(lang_file)[1]
    end
  end

  -- Normalize path for cross-platform compatibility
  local function clean_path(input)
    local pth = vim.fn.fnamemodify(input, ":p")
    if vim.fn.has "win32" == 1 then
      pth = pth:gsub("/", "\\")
    end
    return pth
  end

  -- Check if a parser is installed by verifying the .so file exists in install dir
  local function is_installed(lang)
    local matched_parsers = vim.api.nvim_get_runtime_file("parser/" .. lang .. ".so", true) or {}
    local install_dir = configs.get_parser_install_dir()
    if not install_dir then
      return false
    end
    install_dir = clean_path(install_dir)
    for _, path in ipairs(matched_parsers) do
      local abspath = clean_path(path)
      if vim.startswith(abspath, install_dir) then
        return true
      end
    end
    return false
  end

  -- Check if a parser needs updating by comparing revisions
  local function needs_update(lang)
    local revision = get_revision(lang)
    return not revision or revision ~= get_installed_revision(lang)
  end

  -- Define highlight groups for parser status indicators
  vim.api.nvim_set_hl(0, "TSInstallInfoGood", { fg = "#00FF00", bold = true })
  vim.api.nvim_set_hl(0, "TSInstallInfoWarning", { fg = "#FFA500", bold = true })
  vim.api.nvim_set_hl(0, "TSInstallInfoBad", { fg = "#FF0000", bold = true })

  -- Load telescope modules for creating the interactive picker UI
  local pickers = require('telescope.pickers')
  local finders = require('telescope.finders')
  local sorters = require('telescope.sorters')
  local previewers = require('telescope.previewers')
  local actions = require('telescope.actions')
  local action_state = require('telescope.actions.state')

  -- Create a custom previewer to show detailed parser information
  local treesitter_previewer = previewers.new_buffer_previewer({
    title = "Parser Info",
    define_preview = function(self, entry, _)
      local bufnr = self.state.bufnr
      vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, {})
      if entry.value:match("^%[") then
        local lang_part = entry.value:match("%]%s+(.+)")
        local lang = lang_part:match("^(%w+)")
        local lines = {}
        table.insert(lines, "Language: " .. lang)
        local parser_config = parsers.get_parser_configs()[lang]
        if parser_config then
          local install_info = parser_config.install_info
          table.insert(lines, "URL: " .. (install_info.url or "unknown"))
          local revision = get_revision(lang)
          table.insert(lines, "Latest Revision: " .. (revision or "unknown"))
          local installed_rev = get_installed_revision(lang)
          table.insert(lines, "Installed Revision: " .. (installed_rev or "not installed"))
          local is_inst = is_installed(lang)
          table.insert(lines, "Status: " .. (is_inst and "installed" or "not installed"))
          if is_inst then
            local needs_up = needs_update(lang)
            table.insert(lines, "Up to date: " .. (needs_up and "no" or "yes"))
          end
        end
        vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
      else
        local lines = {"Category: " .. entry.value}
        vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
      end
    end
  })

  -- Categorize available parsers by installation status
  local available = get_available_parsers()
  local installed_up_to_date = {}
  local installed_outdated = {}
  local not_installed = {}

  for _, lang in ipairs(available) do
    if is_installed(lang) then
      if needs_update(lang) then
        local current = get_installed_revision(lang) or "unknown"
        local latest = get_revision(lang) or "unknown"
        table.insert(installed_outdated, string.format("[⚠] %s %s -> %s", lang, current:sub(1,7), latest:sub(1,7)))
      else
        local version = get_installed_revision(lang) or "unknown"
        table.insert(installed_up_to_date, string.format("[✓] %s %s", lang, version:sub(1,7)))
      end
    else
      table.insert(not_installed, string.format("[✗] %s", lang))
    end
  end

  -- Build the display list with categorized parsers
  local results = {}
  if #installed_up_to_date > 0 then
    table.insert(results, "Installed (up-to-date):")
    for _, line in ipairs(installed_up_to_date) do
      table.insert(results, line)
    end
    table.insert(results, "")
  end
  if #installed_outdated > 0 then
    table.insert(results, "Installed (outdated):")
    for _, line in ipairs(installed_outdated) do
      table.insert(results, line)
    end
    table.insert(results, "")
  end
  if #not_installed > 0 then
    table.insert(results, "Not installed:")
    for _, line in ipairs(not_installed) do
      table.insert(results, line)
    end
  end

  -- Create entry maker for telescope with colored status indicators
  local entry_maker = function(entry)
    return {
      value = entry,
      display = function(e)
        local text = e.value
        if text:match("^%[✓%]") then
          return text, { { {0, 5}, "TSInstallInfoGood" } }
        elseif text:match("^%[⚠%]") then
          return text, { { {0, 5}, "TSInstallInfoWarning" } }
        elseif text:match("^%[✗%]") then
          return text, { { {0, 5}, "TSInstallInfoBad" } }
        else
          return text
        end
      end,
      ordinal = entry,
    }
  end

  -- Create and launch the telescope picker for parser management
  pickers.new({}, {
    prompt_title = "Treesitter Install Info [I]nstall, [X]Uninstall, [U]pdate, [o]pen URL",
    finder = finders.new_table({ results = results, entry_maker = entry_maker }),
    sorter = sorters.get_generic_fuzzy_sorter(),
    previewer = treesitter_previewer,
    attach_mappings = function(prompt_bufnr, map)
      -- Disable default enter action
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
      end)
      -- Map 'I' to install not installed parsers
      map('i', 'I', function()
        local selection = action_state.get_selected_entry()
        if selection and selection.value:match("^%[✗%]") then
          local lang = selection.value:match("%]%s+(.+)")
          print("Installing " .. lang)
          actions.close(prompt_bufnr)
          vim.cmd("TSInstall " .. lang)
          local attempts = 0
          local function check_install()
            attempts = attempts + 1
            if attempts > 60 then return end
            if is_installed(lang) then
              M.treesitter.menu()
            else
              vim.defer_fn(check_install, 1000)
            end
          end
          vim.defer_fn(check_install, 1000)
        end
      end)
      -- Map 'X' to uninstall installed parsers
      map('i', 'X', function()
        local selection = action_state.get_selected_entry()
        if selection and (selection.value:match("^%[✓%]") or selection.value:match("^%[⚠%]")) then
          local lang_part = selection.value:match("%]%s+(.+)")
          local lang = lang_part:match("^(%w+)")
          print("Uninstalling " .. lang)
          actions.close(prompt_bufnr)
          vim.cmd("TSUninstall " .. lang)
          local attempts = 0
          local function check_uninstall()
            attempts = attempts + 1
            if attempts > 60 then return end
            if not is_installed(lang) then
              M.treesitter.menu()
            else
              vim.defer_fn(check_uninstall, 1000)
            end
          end
          vim.defer_fn(check_uninstall, 1000)
        end
      end)
      -- Map 'U' to update outdated parsers
      map('i', 'U', function()
        local selection = action_state.get_selected_entry()
        if selection and selection.value:match("^%[⚠%]") then
          local lang_part = selection.value:match("%]%s+(.+)")
          local lang = lang_part:match("^(%w+)")
          print("Updating " .. lang)
          actions.close(prompt_bufnr)
          vim.cmd("TSUpdate " .. lang)
          local attempts = 0
          local function check_update()
            attempts = attempts + 1
            if attempts > 60 then return end
            if not needs_update(lang) then
              M.treesitter.menu()
            else
              vim.defer_fn(check_update, 1000)
            end
          end
          vim.defer_fn(check_update, 1000)
         end
        end)
        -- Map 'o' to open URL in browser
        map('i', 'o', function()
          local selection = action_state.get_selected_entry()
          if selection and selection.value:match("^%[") then
            local lang_part = selection.value:match("%]%s+(.+)")
            local lang = lang_part:match("^(%w+)")
            local install_info = get_parser_install_info(lang)
            if install_info.url then
              open_url(install_info.url)
              print("Opened " .. install_info.url)
            else
              print("No URL available for " .. lang)
            end
          end
        end)
        return true
     end,
   }):find()
end

return M
