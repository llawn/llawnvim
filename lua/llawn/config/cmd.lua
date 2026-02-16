-- ============================================================================
-- Clean Undo Files Command
-- ============================================================================

--- Clean undo files
--- @return nil
local function clean_undofiles()
  local undodir = vim.fn.expand("~/.local/state/nvim/undo", true)
  if vim.fn.isdirectory(undodir) == 1 then
    vim.fn.system("rm -rf " .. undodir .. "/*")
    vim.notify("Undo files cleaned.", vim.log.levels.INFO)
  else
    vim.notify("Undodir does not exist.", vim.log.levels.WARN)
  end
end

vim.api.nvim_create_user_command("CleanUndo", clean_undofiles, { desc = "Clean all persistent undo files" })


-- ============================================================================
-- Execute file
-- ============================================================================

vim.api.nvim_create_user_command("ExecuteFile", function()
    local ft = vim.bo.filetype
    local exec_map = {
        lua    = "luafile %",
        python = "write | !python3 %",
        go     = "write | !go run %",
        zig    = "write | !zig run %",
        sh     = "write | !bash %",
    }

    local cmd = exec_map[ft]
    if cmd then
        -- We use vim.cmd to execute the string as a Vim command
        vim.cmd(cmd)
    else
        vim.notify("No execute command found for: " .. ft, vim.log.levels.WARN)
    end
end, { desc = "Execute current file based on filetype" })
