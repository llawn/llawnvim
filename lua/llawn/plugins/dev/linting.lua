-- Plugin: nvim-lint
-- Description: Linter plugin for Neovim
--              Automatically checks mason-registry to looks for installed linters
-- Note: See config/linter for individual linter configuration

-- Load linter overrides from config/linter/
local linter_config = require("llawn.config.linter")

-- Get merged linters from Mason and manual overrides, filtering out linters that are also LSP servers
-- @return table<string, string[]> # Merged linters by filetype
local function get_merged_linters()
  local mason_utils = require("llawn.utils.mason")
  local mason_linters = mason_utils.get_mason_tools("Linter")
  local disabled = linter_config.disabled_linters or {}
  local is_disabled = {}
  for _, name in ipairs(disabled) do is_disabled[name] = true end
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
      if not lsp_tools_flat[name] and not is_disabled[name] then
        table.insert(filtered_linters[ft], name)
      end
    end
  end
  return vim.tbl_deep_extend('force', filtered_linters, linter_config.linters_by_ft or {})
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

    -- Apply custom linter options
    for linter, opts in pairs(linter_config.options or {}) do
      if opts then
        local original = lint.linters[linter]
        if type(original) == "function" then
          -- Wrapping linters which are defined as function for lazy evaluation
          lint.linters[linter] = function()
            local linter_ = original()
            return vim.tbl_deep_extend('force', linter_, opts)
          end
        else
          -- Should be a table
          assert(type(original) == "table")
          lint.linters[linter] = vim.tbl_deep_extend('force', original, opts)
        end
      end
    end

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

    -- Set up LintInfo command to open the lint menu
    vim.api.nvim_create_user_command("LintInfo", function()
      require("llawn.config.menu.lint").lint.menu()
    end, {})
  end,
}
