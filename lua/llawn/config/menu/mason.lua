local M = {}

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
