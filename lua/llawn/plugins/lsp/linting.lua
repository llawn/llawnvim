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

    -- LintInfo function to show linting information like ConformInfo
    local function show_lint_info()
      local mason_utils = require("llawn.utils.mason")
      local bufnr = vim.api.nvim_get_current_buf()
      local current_ft = vim.bo[bufnr].filetype

      local lines = {}
      table.insert(lines, "Linters:")

      -- Get LSP clients that are categorized as linters in Mason
      local lsp_linter_tools = mason_utils.get_mason_tools({ "Linter", "LSP" }) -- Tools that are both Linter and LSP
      local lsp_linters = {}
      local clients = vim.lsp.get_clients({ bufnr = bufnr })
      for _, client in ipairs(clients) do
        -- Check if this LSP client is also a linter according to Mason
        for _, linters in pairs(lsp_linter_tools) do
          if vim.tbl_contains(linters, client.name) then
            table.insert(lsp_linters, client.name)
            break
          end
        end
      end

      -- Get Mason linters for current buffer
      local mason_linters = mason_utils.get_mason_tools("Linter")[current_ft] or {}

      -- Show current buffer linters first
      table.insert(lines, "")
      table.insert(lines, string.format("Filetype %s:", current_ft))

      if #lsp_linters > 0 then
        table.insert(lines, "  LSP:")
        for _, name in ipairs(lsp_linters) do
          local client = vim.lsp.get_clients({ name = name })[1]
          local path = ""
          if client and client.config.cmd and client.config.cmd[1] then
            local cmd_path = vim.fn.exepath(client.config.cmd[1])
            if cmd_path ~= "" then
              path = " " .. cmd_path
            end
          end
          table.insert(lines, "    " .. name .. path)
        end
      end

      if #mason_linters > 0 then
        table.insert(lines, "  Linter:")
        for _, linter_name in ipairs(mason_linters) do
          -- Check if this linter is configured in nvim-lint
          local configured_in_lint = vim.tbl_contains(lint.linters_by_ft[current_ft] or {}, linter_name)
          local status = configured_in_lint and "ready" or "available"
          local path = ""

          -- Try to get path from nvim-lint linter definition
          local linter = lint.linters[linter_name]
          if linter and linter.cmd ~= "not found" then
            local cmd_name = ""
            if type(linter.cmd) == "string" then
              cmd_name = linter.cmd
            elseif type(linter.cmd) == "table" and linter.cmd[1] then
              cmd_name = linter.cmd[1]
            elseif type(linter.cmd) == "function" then
              cmd_name = linter_name
            end

            if cmd_name ~= "" then
              local full_path = vim.fn.exepath(cmd_name)
              if full_path ~= "" then
                path = " " .. full_path
              else
                path = " " .. cmd_name .. " (command not in PATH)"
              end
            end
          else
            -- Fallback: try to find the executable
            local full_path = vim.fn.exepath(linter_name)
            if full_path ~= "" then
              path = " " .. full_path
            end
          end

          table.insert(lines, string.format("    %s %s (%s)%s", linter_name, status, current_ft, path))
        end
      end

      if #lsp_linters == 0 and #mason_linters == 0 then
        table.insert(lines, "  No linters configured")
      end

      -- Show linters for other filetypes (from Mason registry)
      local all_mason_linters = mason_utils.get_mason_tools("Linter")
      local other_fts = {}
      for ft, linters_list in pairs(all_mason_linters) do
        if ft ~= current_ft and #linters_list > 0 then
          table.insert(other_fts, ft)
        end
      end

      table.sort(other_fts)

      for _, ft in ipairs(other_fts) do
        table.insert(lines, "")
        table.insert(lines, string.format("Filetype %s:", ft))
        table.insert(lines, "  Linter:")
        for _, linter_name in ipairs(all_mason_linters[ft]) do
          -- Check if this linter is configured in nvim-lint
          local configured_in_lint = vim.tbl_contains(lint.linters_by_ft[ft] or {}, linter_name)
          local status = configured_in_lint and "configured" or "available"
          local path = ""

          -- Try to get path from nvim-lint linter definition
          local linter = lint.linters[linter_name]
          if linter and linter.cmd ~= "not found" then
            local cmd_name = ""
            if type(linter.cmd) == "string" then
              cmd_name = linter.cmd
            elseif type(linter.cmd) == "table" and linter.cmd[1] then
              cmd_name = linter.cmd[1]
            elseif type(linter.cmd) == "function" then
              cmd_name = linter_name
            end

            if cmd_name ~= "" then
              local full_path = vim.fn.exepath(cmd_name)
              if full_path ~= "" then
                path = " " .. full_path
              else
                path = " " .. cmd_name .. " (command not in PATH)"
              end
            end
          else
            -- Fallback: try to find the executable
            local full_path = vim.fn.exepath(linter_name)
            if full_path ~= "" then
              path = " " .. full_path
            end
          end

          table.insert(lines, string.format("    %s %s (%s)%s", linter_name, status, ft, path))
        end
      end

      -- Show in floating window
      local buf = vim.api.nvim_create_buf(false, true)
      vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
      vim.bo[buf].buftype = 'nofile'
      vim.bo[buf].bufhidden = 'wipe'

      local width = math.floor(vim.o.columns * 0.8)
      local height = math.min(#lines + 2, math.floor(vim.o.lines * 0.8))

      vim.api.nvim_open_win(buf, true, {
        relative = 'editor',
        width = width,
        height = height,
        col = math.floor((vim.o.columns - width) / 2),
        row = math.floor((vim.o.lines - height) / 2),
        style = 'minimal',
        border = 'rounded',
        title = ' LintInfo ',
        title_pos = 'center',
      })

      vim.keymap.set('n', 'q', '<cmd>close<CR>', { buffer = buf, silent = true })
      vim.keymap.set('n', '<Esc>', '<cmd>close<CR>', { buffer = buf, silent = true })
    end

    vim.api.nvim_create_user_command("LintInfo", show_lint_info, {})
  end,
}
