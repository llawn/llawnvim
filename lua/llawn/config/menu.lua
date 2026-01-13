--- @brief Provides UI menus in Neovim.
---

local M = {}

-- ============================================================================
-- Window Menu
-- ============================================================================

M.window = {}

M.window.menu = function()
  local choices = {
    { "Horizontal Split", function() vim.cmd("split") end },
    { "Vertical Split", function() vim.cmd("vsplit") end },
    { "Move Left", function() vim.cmd("wincmd h") end },
    { "Move Right", function() vim.cmd("wincmd l") end },
    { "Move Up", function() vim.cmd("wincmd k") end },
    { "Move Down", function() vim.cmd("wincmd j") end },
    { "Close Window", function() vim.cmd("close") end },
  }

  vim.ui.select(choices, {
    prompt = "Window Menu:",
    format_item = function(item) return item[1] end
  }, function(choice)
      if choice then
        choice[2]()
      end
    end)
end

-- ============================================================================
-- Git Menu
-- ============================================================================

M.git = {}

M.git.menu = function()
  local choices = {
    { "Git Status", function() vim.cmd("!git status") end },
    { "Git Commit", function() vim.cmd("!git commit") end },
    { "Git Push", function() vim.cmd("!git push") end },
    { "Git Log", function() vim.cmd("!git log --oneline --graph --decorate --all") end },
    { "Git Diff", function() vim.cmd("!git diff") end },
  }

  vim.ui.select(choices, {
    prompt = "Git Menu:",
    format_item = function(item) return item[1] end
  }, function(choice)
      if choice then
        choice[2]()
      end
    end)
end

-- ============================================================================
-- Treesitter Menu
-- ============================================================================
-- This section provides an interactive telescope based menu for managing
-- nvim-treesitter parsers, displaying their installation status and enabling
-- install / uninstall / update actions via keybindings (I, X, U) with
-- automatic status refresh.

M.treesitter = {}

M.treesitter.menu = function()

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
    prompt_title = "Treesitter Install Info",
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
      return true
    end,
  }):find()
end

-- ============================================================================
-- Mason Menu
-- ============================================================================
-- This section provides an interactive telescope based menu for managing
-- mason packages, displaying their installation status and enabling
-- install / uninstall / update actions via keybindings (I, X, U) with
-- automatic status refresh.

M.mason = {}

local function setup_highlights()
  vim.api.nvim_set_hl(0, "MasonInstallInfoGood", { fg = "#00FF00", bold = true })
  vim.api.nvim_set_hl(0, "MasonInstallInfoWarning", { fg = "#FFA500", bold = true })
  vim.api.nvim_set_hl(0, "MasonInstallInfoBad", { fg = "#FF0000", bold = true })
end

M.mason.menu = function()
  local category_choices = {
    { "All", "all" },
    { "LSP", "lsp" },
    { "DAP", "dap" },
    { "Linters", "linter" },
    { "Formatters", "formatter" },
    { "Other", "other" },
  }

  vim.ui.select(
    category_choices,
    {
      prompt = "Mason Category:",
      format_item = function(item) return item[1] end
    },
    function(choice)
      if choice then
        M.mason.show_packages(choice[2])
      end
    end
  )
end

M.mason.show_packages = function(selected_category)
  setup_highlights()
  local registry = require('mason-registry')

  -- Use the async callback for refresh to ensure data is ready
  registry.refresh(function()
    local all_packages = registry.get_all_packages()

    local categories = {
      lsp = { installed_up_to_date = {}, installed_outdated = {}, not_installed = {} },
      dap = { installed_up_to_date = {}, installed_outdated = {}, not_installed = {} },
      linter = { installed_up_to_date = {}, installed_outdated = {}, not_installed = {} },
      formatter = { installed_up_to_date = {}, installed_outdated = {}, not_installed = {} },
      other = { installed_up_to_date = {}, installed_outdated = {}, not_installed = {} },
    }

    -- Categorization Logic
    for _, pkg in ipairs(all_packages) do
      local spec = pkg.spec
      local cats_to_process = (spec.categories and #spec.categories > 0) and spec.categories or { nil }

      for _, cat_name in ipairs(cats_to_process) do
        local key = cat_name and cat_name:lower()
        local target_cat = categories[key] or categories.other

        if pkg:is_installed() then
          local installed_ver = pkg:get_installed_version()
          local latest_ver = pkg:get_latest_version()
          if installed_ver == latest_ver then
            table.insert(target_cat.installed_up_to_date, pkg)
          else
            table.insert(target_cat.installed_outdated, pkg)
          end
        else
          table.insert(target_cat.not_installed, pkg)
        end
      end
    end

    -- Telescope setup
    local pickers = require('telescope.pickers')
    local finders = require('telescope.finders')
    local sorters = require('telescope.sorters')
    local previewers = require('telescope.previewers')
    local actions = require('telescope.actions')
    local action_state = require('telescope.actions.state')

    -- Previewer with header highlighting (Extmarks)
    local mason_previewer = previewers.new_buffer_previewer({
      title = "Package Info",
      define_preview = function(self, entry)
        local bufnr = self.state.bufnr
        if type(entry.value) ~= "table" then
          vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, { "Category Header: " .. entry.value })
          return
        end

        local pkg = entry.value
        local spec = pkg.spec

        -- Start building the lines array
        local lines = {}
        table.insert(lines, "Name: " .. spec.name)
        table.insert(lines, "")

        local raw_desc = spec.description or "No description"
        local desc_lines = vim.split(raw_desc, "\n", { trimempty = true })

        table.insert(lines, "Description:")
        for _, d_line in ipairs(desc_lines) do
          table.insert(lines, "  " .. d_line)
        end

        table.insert(lines, "")
        table.insert(lines, "Homepage: " .. (spec.homepage or "N/A"))
        table.insert(lines, "Categories: " .. table.concat(spec.categories or {}, ", "))
        table.insert(lines, "Languages: " .. table.concat(spec.languages or {}, ", "))
        table.insert(lines, "")
        table.insert(lines, "Latest Version: " .. tostring(pkg:get_latest_version() or "unknown"))

        if pkg:is_installed() then
          table.insert(lines, "Status: Installed")
          table.insert(lines, "Installed Version: " .. tostring(pkg:get_installed_version()))
        else
          table.insert(lines, "Status: Not Installed")
        end

        vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)

        -- Highlights
        local ns_id = vim.api.nvim_create_namespace("mason_preview")
        for i, line in ipairs(lines) do
          local pos = line:find(":")
          if pos then
            vim.api.nvim_buf_set_extmark(bufnr, ns_id, i-1, 0, { end_col = pos - 1, hl_group = "Title" })
          end
        end
      end
    })

    -- Building results list
    local results = {}
    local added = {}
    local cats_to_show = selected_category == "all" and { "lsp", "dap", "linter", "formatter", "other" } or { selected_category }

    local sections = {
      { key = "installed_up_to_date", label = "  Installed (up-to-date):" },
      { key = "installed_outdated",   label = "  Installed (outdated):"   },
      { key = "not_installed",        label = "  Not installed:"          },
    }

    for _, cat_name in ipairs(cats_to_show) do
      local cat_data = categories[cat_name]
      if cat_data then
        table.insert(results, cat_name:upper() .. ":")
        for _, section in ipairs(sections) do
          local pkgs = cat_data[section.key]
          if #pkgs > 0 then
            table.insert(results, section.label)
            for _, pkg in ipairs(pkgs) do
              if not added[pkg.name] then
                table.insert(results, pkg)
                added[pkg.name] = true
              end
            end
            table.insert(results, "")
          end
        end
      end
    end

    -- Entry Maker with Search Logic
    local entry_maker = function(entry)
      if type(entry) == "string" then
        return { value = entry, display = entry, ordinal = "" }
      end

      local pkg = entry
      local spec = pkg.spec
      -- We include name, languages, and categories for a better search experience.
      local search_terms = string.format("%s %s %s",
        spec.name,
        table.concat(spec.languages or {}, " "),
        table.concat(spec.categories or {}, " ")
      )

      return {
        value = pkg,
        ordinal = search_terms,
        display = function(e)
          local p = e.value
          local s = p.spec
          if p:is_installed() then
            local inst = p:get_installed_version()
            local lat = p:get_latest_version()
            if inst == lat then
              return string.format("[✓] %s %s", s.name, inst), { { {0, 3}, "MasonInstallInfoGood" } }
            else
              return string.format("[⚠] %s %s -> %s", s.name, inst, lat), { { {0, 3}, "MasonInstallInfoWarning" } }
            end
          end
          return string.format("[✗] %s", s.name), { { {0, 3}, "MasonInstallInfoBad" } }
        end,
      }
    end

    -- Launch Picker
    pickers.new({}, {
      prompt_title = "Mason Manager (" .. selected_category:upper() .. ") - [I]nst, [U]pdt, [X]Uninst",
      finder = finders.new_table({ results = results, entry_maker = entry_maker }),
      sorter = sorters.get_generic_fuzzy_sorter(),
      previewer = mason_previewer,
      attach_mappings = function(prompt_bufnr, map)
        local function handle_pkg_action(key, action_fn, success_msg)
          map('i', key, function()
            local selection = action_state.get_selected_entry()
            -- 4. Safety check for headers
            if selection and type(selection.value) == "table" then
              local pkg = selection.value
              actions.close(prompt_bufnr)
              print(success_msg .. pkg.spec.name)
              action_fn(pkg)
              vim.defer_fn(function() M.mason.show_packages(selected_category) end, 1000)
            end
          end)
        end

        handle_pkg_action('I', function(p) p:install() end, "Installing ")
        handle_pkg_action('X', function(p) p:uninstall() end, "Uninstalling ")
        handle_pkg_action('U', function(p) p:install() end, "Updating ")

        return true
      end,
    }):find()
  end)
end

return M
