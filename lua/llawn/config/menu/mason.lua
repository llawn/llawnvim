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

--- @class MasonEntry
--- @field value table The raw package data
--- @field ordinal string The string used for fuzzy searching
--- @field display function The function that renders the UI line

--- Creates a telescope entry for mason packages.
--- @param entry table|string The package entry or a string
--- @return MasonEntry The telescope entry
local function entry_maker(entry)
  if type(entry) == "string" then
    -- Handle category headers
    return {
      value = entry,
      ordinal = entry,
      display = function(e) return e.value end
    }
  else
    -- Handle package info entries
    return {
      value = entry,
      ordinal = entry.pkg.name,
      --- The display function Telescope calls to render each line in the picker.
      --- @param e MasonEntry The entry table
      --- @return string text The formatted string to display.
      --- @return table highlights A list of { {start, end}, hl_group } for coloring.
      display = function(e)
        local i = e.value
        local istatus = categorize_results(i)
        local status = ""
        local sym = ""
        if istatus == menu_utils.Status.UP_TO_DATE then
          status = "Good"
          sym = "✓"
        elseif istatus == menu_utils.Status.OUTDATED then
          status = "Warning"
          sym = "⚠"
        elseif istatus == menu_utils.Status.MISSING then
          status = "Bad"
          sym = "✗"
        end

        local pkg_status = string.format(
          "[%s] %s %s",
          sym,
          i.pkg.name,
          (i.pkg:get_installed_version() or "")
        )
        return pkg_status, { { { 0, 5 }, "MasonInstallInfo" .. status } }
      end
    }
  end
end

M.mason = {}
--- Shows mason packages for a given category with optional status filter.
--- @param cat_name string The category name (e.g., "All", "LSP")
--- @param status_filter string|nil The status filter to apply
--- @return nil
M.mason.show_packages = function(cat_name, status_filter)
  menu_utils.setup_highlights("MasonInstallInfo")
  local registry = require('mason-registry')

  registry.refresh(function()
    local locked = read_lockfile()
    local filter_cat = cat_name:lower() == "all" and "all" or cat_name
    local filtered = {}
    for _, pkg in ipairs(registry.get_all_packages()) do
      if filter_cat == "all" or (pkg.spec.categories and vim.tbl_contains(pkg.spec.categories, filter_cat)) then
        table.insert(filtered, { pkg = pkg, name = pkg.name, target = locked[pkg.name] or pkg:get_latest_version() })
      end
    end

    local results = menu_utils.build_categorized_list(filtered, categorize_results, status_filter)

    local previewer = menu_utils.create_install_previewer(
      function(entry)
        local i = entry
        if type(i) ~= "table" or not i.pkg then
          return { name = "No package info", languages = "", url = "", target = "", status = "", description = "" }
        end
        return {
          name = i.pkg.name,
          languages = table.concat(i.pkg.spec.languages or {}, ", "),
          url = i.pkg.spec.homepage or "N/A",
          target = i.target or "N/A",
          status = categorize_results(i),
          description = i.pkg.spec.description or "No description available"
        }
      end,
      "[F]ilter, [I]nstall, [X]Uninstall, [U]pdate, [O]pen in Browser, [C]hange category"
    )

    menu_utils.create_picker({
      prompt_title = "Mason Manager (" .. cat_name .. ")",
      finder = require('telescope.finders').new_table({ results = results, entry_maker = entry_maker }),
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
            action = function(_) M.mason.menu(status_filter) end,
            no_close = true
          },
        },
        function() M.mason.show_packages(cat_name, status_filter) end,
        function(f) M.mason.show_packages(cat_name, f) end
      )
    })
  end)
end

--- Displays the mason category selection menu.
--- @param status_filter string|nil The status filter to apply
--- @return nil
M.mason.menu = function(status_filter)
  vim.ui.select({ "All", "LSP", "DAP", "Linter", "Formatter" }, { prompt = "Category:" }, function(c)
    if c then M.mason.show_packages(c, status_filter) end
  end)
end

return M
