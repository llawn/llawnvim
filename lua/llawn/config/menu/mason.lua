--- Mason manager

local M = {}
local lockfile_utils = require('llawn.utils.lockfile')
local menu_utils = require('llawn.utils.menu')

--- Reads the mason lockfile and returns locked versions.
--- @return table Table of package names to versions
local function read_lockfile()
  local path = vim.fn.stdpath("config") .. "/mason-lock.json"
  local data = lockfile_utils.read_lockfile(path)
  local locked = {}
  for _, item in ipairs(data) do locked[item.name] = item.version end
  return locked
end

--- Categorize mason package results
--- @param i table The package item
--- @return InstallationStatus
local function categorize_results(i)
  if not i.pkg:is_installed() then
    return menu_utils.Status.MISSING
  elseif i.pkg:get_installed_version() ~= i.target then
    return menu_utils.Status.OUTDATED
  else
    return menu_utils.Status.UP_TO_DATE
  end
end

M.mason = {}

--- Shows mason packages for a given category with optional status and language filters.
--- @param cat_name string The category name (e.g., "All", "LSP")
--- @param status_filter string|nil The status filter to apply
--- @param language_filter string|nil The language filter to apply
--- @return nil
M.mason.show_packages = function(cat_name, status_filter, language_filter)
  menu_utils.setup_highlights("MasonInstallInfo")
  local registry = require('mason-registry')

  registry.refresh(function()
    local locked = read_lockfile()
    local filter_cat = cat_name:lower() == "all" and "all" or cat_name
    local filtered = {}
    for _, pkg in ipairs(registry.get_all_packages()) do
      if (filter_cat == "all" or (pkg.spec.categories and vim.tbl_contains(pkg.spec.categories, filter_cat))) and
          (not language_filter or (pkg.spec.languages and vim.tbl_contains(pkg.spec.languages, language_filter))) then
        table.insert(filtered, { pkg = pkg, name = pkg.name, target = locked[pkg.name] or pkg:get_latest_version() })
      end
    end

    local results = menu_utils.build_categorized_list(filtered, categorize_results, status_filter)

    -- Collect unique languages for language filter menu
    local languages = {}
    for _, item in ipairs(filtered) do
      if item.pkg.spec.languages then
        for _, lang in ipairs(item.pkg.spec.languages) do
          languages[lang] = true
        end
      end
    end
    local lang_list = vim.tbl_keys(languages)
    table.sort(lang_list)

    local previewer = menu_utils.create_install_previewer(
      function(entry)
        local i = entry
        if type(i) ~= "table" or not i.pkg then
          return { name = "No package info", languages = "", url = "", target = "", status = "", description = "" }
        end
        return {
          name = i.pkg.name,
          languages = table.concat(i.pkg.spec.languages or {}, ", "),
          categories = table.concat(i.pkg.spec.categories or {}, ", "),
          url = i.pkg.spec.homepage or "N/A",
          target = i.target or "N/A",
          status = categorize_results(i),
          description = i.pkg.spec.description or "No description available"
        }
      end,
      "[F]ilter, [L]anguage, [I]nstall, [X]Uninstall, [U]pdate, [O]pen in Browser, [C]ategory"
    )

    local maker = menu_utils.gen_entry_maker(
      "name",
      function(i) return i.pkg:get_installed_version() end,
      categorize_results,
      "MasonInstallInfo"
    )

    menu_utils.create_picker({
      prompt_title = "Mason Manager (" .. cat_name .. (language_filter and " - " .. language_filter or "") .. ")",
      finder = require('telescope.finders').new_table({ results = results, entry_maker = maker }),
      previewer = previewer,
      attach_mappings = menu_utils.create_attach_mappings(
        {
          I = { condition = function() return true end, action = function(i) i.pkg:install({ version = i.target }) end, msg = "Installing " },
          X = { condition = function(i) return i.pkg:is_installed() end, action = function(i) i.pkg:uninstall() end, msg = "Uninstalling " },
          U = {
            condition = function(i) return i.pkg:is_installed() end,
            action = function(i)
              i.pkg:install({ version = i.target })
            end,
            msg = "Updating "
          },
          O = {
            condition = function(i) return i.pkg.spec.homepage ~= nil end,
            action = function(i)
              menu_utils.open_url(i
                .pkg.spec.homepage)
            end
          },
          C = {
            condition = function(_) return true end,
            action = function(_) M.mason.menu(status_filter, language_filter) end,
            no_close = true
          },
          L = {
            condition = function(_) return true end,
            action = function(_)
              menu_utils.create_picker({
                prompt_title = "Select Language",
                finder = require('telescope.finders').new_table({ results = lang_list }),
                attach_mappings = function(prompt_bufnr, _)
                  local actions = require('telescope.actions')
                  actions.select_default:replace(function()
                    local selection = require('telescope.actions.state').get_selected_entry()
                    actions.close(prompt_bufnr)
                    if selection then
                      M.mason.show_packages(cat_name, status_filter, selection.value)
                    end
                  end)
                  return true
                end
              })
            end,
            no_close = true
          },
        },
        function() M.mason.show_packages(cat_name, status_filter, language_filter) end,
        function(f) M.mason.show_packages(cat_name, f, language_filter) end
      )
    })
  end)
end

--- Displays the mason category selection menu.
--- @param status_filter string|nil The status filter to apply
--- @param language_filter string|nil The language filter to apply
--- @return nil
M.mason.menu = function(status_filter, language_filter)
  vim.ui.select({ "All", "LSP", "DAP", "Linter", "Formatter" }, { prompt = "Category:" }, function(c)
    if c then M.mason.show_packages(c, status_filter, language_filter) end
  end)
end

return M
