-- This file loads all *.lua files in the formatter config directory and merges them.
-- You can configure everything here, or split into separate files like
--
-- Example:
-- A python configuration with Ruff + Black formatters
--
-- Option 1: Edit this init.lua directly:
-- ```lua
-- formatters_by_ft = {
--   python = { "ruff_format", "black" },
-- }
-- options = {
--   ruff_format =  {
--     args = { "--line-length", "88" }
--   } ,
--   black = {
--     args = { "--line-length", "88" }
--   },
-- }
-- ```
--
-- Option 2: Create formatter/python.lua with:
-- ```lua
-- return {
--   formatters = {
--     python = { "ruff_format", "black" },
--   },
--   options = {
--     ruff_format = {
--       args = { "--line-length", "88" },
--     },
--     black = {
--       args = { "--line-length", "88" },
--     },
--   },
-- }
-- ```

local formatters_by_ft = {
  python = {
    "ruff_format",
    "ruff_organize_imports",
    "ruff_fix",
  },
  make = { "bake" },
}
local options = {}

local dir = vim.fs.dirname(debug.getinfo(1, "S").source:sub(2))
for _, file in ipairs(vim.fn.glob(dir .. "/*.lua", false, true)) do
  local module_name = file:match("([^/]+)%.lua$"):gsub("%.lua$", "")
  if module_name ~= "init" then -- avoid loading self
    local config = require("llawn.config.formatter." .. module_name)
    if config.formatters then
      -- Ensure formatters is a table
      local formatters = config.formatters
      if type(formatters) ~= "table" then
        formatters = { formatters }
      end
      formatters_by_ft = vim.tbl_deep_extend('force', formatters_by_ft, formatters)
    end
    if config.options then
      options = vim.tbl_deep_extend('force', options, config.options)
    end
  end
end

return {
  formatters_by_ft = formatters_by_ft,
  options = options,
}
