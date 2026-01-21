-- Utility functions for working with Mason packages

local M = {}

-- Bridges Mason language names to Neovim filetypes
-- Sometimes Mason language names doesn't follow Neovim filetypes
-- @type table<string, string>
M.default_lang_to_ft = {
  makefile = "make",
  csharp = "cs",
  powershell = "ps1",
  ["f#"] = "fs",
  bash = "sh",
  zsh = "sh",
  ksh = "sh",
}

--- Checks if a package has any of the specified categories
--- @param pkg_categories string[]|nil The package's categories
--- @param required_categories string|string[] The required categories (string for single, table for multiple)
--- @return boolean # True if package has any of the required categories
local function has_categories(pkg_categories, required_categories)
  if not pkg_categories then return false end

  if type(required_categories) == "string" then
    return vim.tbl_contains(pkg_categories, required_categories)
  elseif type(required_categories) == "table" then
    -- Must have ANY category in the table
    for _, cat in ipairs(required_categories) do
      if vim.tbl_contains(pkg_categories, cat) then
        return true
      end
    end
    return false
  end
  return false
end

--- Checks if a package has all specified categories
--- @param pkg_categories string[]|nil The package's categories
--- @param required_categories string|string[] The required categories
--- @return boolean # True if package has all required categories
local function has_all_categories(pkg_categories, required_categories)
  if not pkg_categories then return false end

  if type(required_categories) == "string" then
    return vim.tbl_contains(pkg_categories, required_categories)
  elseif type(required_categories) == "table" then
    for _, cat in ipairs(required_categories) do
      if not vim.tbl_contains(pkg_categories, cat) then
        return false
      end
    end
    return true
  end
  return false
end

--- Get Mason installed packages that have ANY specified categories and organizes them by filetype.
--- @param category string|string[] The Mason category/categories to filter by (e.g., 'LSP', 'Linter', {'Linter', 'LSP'})
--- @return table<string, string[]> # A table where keys are filetypes and values are arrays of package names.
M.get_mason_tools_all = function(category)
  local lang_to_ft = M.default_lang_to_ft
  local registry = require('mason-registry')
  local tools = {}
  for _, pkg in ipairs(registry.get_installed_packages()) do
    if has_categories(pkg.spec.categories, category) then
      local langs = pkg.spec.languages or {}
      for _, lang in ipairs(langs) do
        local ft = lang_to_ft[lang:lower()] or lang:lower()
        tools[ft] = tools[ft] or {}
        table.insert(tools[ft], pkg.name)
      end
    end
  end
  return tools
end

--- Gets Mason packages that have specified categories and organizes them by filetype.
--- @param categories string|string[] The Mason category/categories to filter by (e.g., 'LSP', 'Linter', {'Linter', 'LSP'})
--- @return table<string, string[]> # A table where keys are filetypes and values are arrays of package names.
M.get_mason_tools = function(categories)
  local lang_to_ft = M.default_lang_to_ft
  local registry = require('mason-registry')
  local tools = {}
  for _, pkg in ipairs(registry.get_installed_packages()) do
    if has_all_categories(pkg.spec.categories, categories) then
      local langs = pkg.spec.languages or {}
      for _, lang in ipairs(langs) do
        local ft = lang_to_ft[lang:lower()] or lang:lower()
        tools[ft] = tools[ft] or {}
        table.insert(tools[ft], pkg.name)
      end
    end
  end
  return tools
end

return M
