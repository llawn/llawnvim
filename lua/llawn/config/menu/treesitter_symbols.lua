--- Treesitter symbols menu

local M = {}
M.ts_symbols = {}
M.ts_symbols.menu = function()
  local builtin = require('telescope.builtin')

  local choices = {
    { "Functions",   function() builtin.treesitter({ symbols = { 'function' } }) end },
    { "Methods",     function() builtin.treesitter({ symbols = { 'method' } }) end },
    { "Classes",     function() builtin.treesitter({ symbols = { 'class' } }) end },
    { "Structs",     function() builtin.treesitter({ symbols = { 'struct' } }) end },
    { "Constants",   function() builtin.treesitter({ symbols = { 'constant' } }) end },
    { "Interfaces",  function() builtin.treesitter({ symbols = { 'interface' } }) end },
    { "Enums",       function() builtin.treesitter({ symbols = { 'enum' } }) end },
    { "Types",       function() builtin.treesitter({ symbols = { 'type' } }) end },
    { "Variables",   function() builtin.treesitter({ symbols = { 'variable' } }) end },
    { "Properties",  function() builtin.treesitter({ symbols = { 'property' } }) end },
    { "All Symbols", function() builtin.treesitter() end },
  }

  vim.ui.select(choices, {
    prompt = "Treesitter Symbols:",
    format_item = function(item) return item[1] end
  }, function(choice)
    if choice then
      choice[2]()
    end
  end)
end

return M
