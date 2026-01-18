--- Utility for reading lockfile

local M = {}
--- Reads and parses a JSON lockfile.
--- @param path string The path to the lockfile
--- @return table The parsed data as a table, or an empty table if file not readable
M.read_lockfile = function(path)
  if vim.fn.filereadable(path) == 1 then
    local content = vim.fn.readfile(path)
    return vim.fn.json_decode(table.concat(content, "\n"))
  end
  return {}
end
return M
