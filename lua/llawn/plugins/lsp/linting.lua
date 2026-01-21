-- Manual overrides or additions for linters by filetype
local linters_by_ft_manual = {
  -- Add linters manually
}
-- Get merged linters from Mason and manual overrides, filtering out linters that are also LSP servers
-- @return table<string, string[]> # Merged linters by filetype
local function get_merged_linters()
  local mason_utils = require("llawn.utils.mason")
  local mason_linters = mason_utils.get_mason_tools("Linter")
  local lsp_tools = mason_utils.get_mason_tools("LSP")
  local lsp_tools_flat = {}
  for _, names in pairs(lsp_tools) do
    for _, name in ipairs(names) do
      lsp_tools_flat[name] = true
    end
  end
  local filtered_linters = {}
  for ft, names in pairs(mason_linters) do
    filtered_linters[ft] = {}
    for _, name in ipairs(names) do
      if not lsp_tools_flat[name] then
        table.insert(filtered_linters[ft], name)
      end
    end
  end
  return vim.tbl_deep_extend('force', filtered_linters, linters_by_ft_manual)
end

return {
  "mfussenegger/nvim-lint",
  event = {
    "BufReadPre",
    "BufNewFile",
  },
  config = function()
    local lint = require("lint")

    lint.linters_by_ft = get_merged_linters()

    local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

    vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
      group = lint_augroup,
      callback = function()
        lint.try_lint()
      end,
    })
    vim.keymap.set("n", "<leader>pl", function()
      lint.try_lint()
    end, { desc = "Trigger linting" })
  end,
}
