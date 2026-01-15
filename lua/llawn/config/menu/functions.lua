--- @brief Functions menu using Telescope and Treesitter
local M = {}
M.functions = {}
M.functions.menu = function()
    local choices = {
        { "Functions", function() require('telescope.builtin').treesitter({symbols = {'function'}}) end },
        { "Methods", function() require('telescope.builtin').treesitter({symbols = {'method'}}) end },
        { "Classes", function() require('telescope.builtin').treesitter({symbols = {'class'}}) end },
        { "Structs", function() require('telescope.builtin').treesitter({symbols = {'struct'}}) end },
        { "Constants", function() require('telescope.builtin').treesitter({symbols = {'constant'}}) end },
        { "Interfaces", function() require('telescope.builtin').treesitter({symbols = {'interface'}}) end },
        { "Enums", function() require('telescope.builtin').treesitter({symbols = {'enum'}}) end },
        { "Types", function() require('telescope.builtin').treesitter({symbols = {'type'}}) end },
        { "Variables", function() require('telescope.builtin').treesitter({symbols = {'variable'}}) end },
        { "Properties", function() require('telescope.builtin').treesitter({symbols = {'property'}}) end },
        { "All Symbols", function() require('telescope.builtin').treesitter() end },
    }
    vim.ui.select(choices, {
        prompt = "Treesitter Symbols:",
        format_item = function(item) return item[1] end
    }, function(choice)
        if choice then
            choice[2]()
end

return M
