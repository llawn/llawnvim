-- Configuration: Individual linter configuration
-- This file loads all *.lua files in the linter config directory and merges them.
-- You can configure everything here, or split into separate files like python.lua.
--
-- Example:
-- A python configuration with ruff for linting and mypy for type checking.
-- Option 1: Edit this init.lua directly:
-- return {
--   linters_by_ft = {
--     python = { "ruff", "mypy" },
--   },
--   options = {
--     ruff = {
--       args = { "--select", "E,F" },
--     },
--     mypy = {
--       args = { "--strict" },
--     },
--   },
-- }
-- Option 2: Create python.lua with:
-- return {
--   linters = {
--     python = { "ruff", "mypy" },
--   },
--   options = {
--     ruff = {
--       args = { "--select", "E,F" },
--     },
--     mypy = {
--       args = { "--strict" },
--     },
--   },
-- }

-- Disabled anoying linters
-- Bridges that don't work between mason and nvim-lint
local disabled_linters = {
  "mbake",
}

local linters_by_ft = {}
local options = {}

local dir = vim.fs.dirname(debug.getinfo(1, "S").source:sub(2))
for _, file in ipairs(vim.fn.glob(dir .. "/*.lua", false, true)) do
  local module_name = file:match("([^/]+)%.lua$"):gsub("%.lua$", "")
  if module_name ~= "init" then -- avoid loading self
    local config = require("llawn.config.linter." .. module_name)
    if config.linters then
      -- Ensure linters is a table
      local linters = config.linters
      if type(linters) ~= "table" then
        linters = { linters }
      end
      linters_by_ft = vim.tbl_deep_extend('force', linters_by_ft, linters)
    end
    if config.options then
      options = vim.tbl_deep_extend('force', options, config.options)
    end
  end
end

return {
  linters_by_ft = linters_by_ft,
  options = options,
  disabled_linters = disabled_linters,
}
