--- Defines general keybindings used across the Neovim configuration
--- Mappings are grouped by functionality for clarity and maintainability
--- Some plugin keybindings can be found directly in their configuration file.

local opts = { noremap = true, silent = true }

-- ============================================================================
-- Source file
-- ============================================================================

opts.desc = "Reload Nvim Config"

vim.keymap.set("n", "<leader>R", function()
  vim.cmd("source $MYVIMRC")
  vim.notify("Config Reloaded!", vim.log.levels.INFO)
end, opts)

opts.desc = "Source current file"
vim.keymap.set("n", "<leader>S", "<Cmd>source %<CR>", opts)

-- ============================================================================
-- System / Classic Keybindings
-- ============================================================================

-- Yank
opts.desc = "Copy to system clipboard"
vim.keymap.set("x", "<C-c>", '"+y', opts)
opts.desc = "Cut to system clipboard"
vim.keymap.set("x", "<C-x>", '"+d', opts)
opts.desc = "Paste from system clipboard"
vim.keymap.set({ "n", "i", "x" }, "<C-v>", '"+p', opts)

-- File & Workspace
opts.desc = "Select all"
vim.keymap.set("n", "<C-a>", "ggVG", opts)
opts.desc = "Undo"
vim.keymap.set("n", "<C-z>", "u", opts)
opts.desc = "Redo"
vim.keymap.set("n", "<C-y>", "<C-r>", opts)
opts.desc = "Save file"
vim.keymap.set({ "n", "i", "v" }, "<C-s>", vim.cmd.w, opts)

-- ============================================================================
-- File & Workspace
-- ============================================================================

--- Open file explorer (Yazi if available, fallback to netrw)
--- @return nil
local function open_file_explorer()
  local ok, yazi = pcall(require, "yazi")
  if ok and yazi.yazi then
    yazi.yazi({
      cwd = vim.fn.expand("%:p:h"),
    })
  else
    vim.cmd.Ex()
  end
end

opts.desc = "Open file explorer"
vim.keymap.set("n", "<leader>x", open_file_explorer, opts)

-- Save file
opts.desc = "Save file"
vim.keymap.set("n", "<leader>w", vim.cmd.w, opts)

-- ============================================================================
-- Navigation
-- ============================================================================

-- Visual line navigation
opts.desc = "Navigate visual line"
for _, keymap in ipairs({
  { "j",      "gj" },
  { "k",      "gk" },
  { "<Down>", "gj" },
  { "<Up>",   "gk" },
}) do
  vim.keymap.set({ "n", "x" }, keymap[1], keymap[2], opts)
end

for _, keymap in ipairs({
  { "<Down>", "<C-\\><C-o>gj" },
  { "<Up>",   "<C-\\><C-o>gk" },
}) do
  vim.keymap.set("i", keymap[1], keymap[2], opts)
end

-- Buffer navigation
opts.desc = "Switch to alternate buffer"
vim.keymap.set("n", "<leader>bb", "<C-^>", opts)
opts.desc = "Next buffer"
vim.keymap.set("n", "<leader>bn", vim.cmd.bnext, opts)
opts.desc = "Previous buffer"
vim.keymap.set("n", "<leader>bp", vim.cmd.bprevious, opts)

-- ============================================================================
-- Editing
-- ============================================================================

-- Enter Visual Block mode
opts.desc = "Visual block mode"
vim.keymap.set("n", "<C-q>", "<C-v>", opts)

-- Format entire file and return to original position
opts.desc = "Indent file"
vim.keymap.set("n", "<leader>pi", function()
  local pos = vim.fn.getpos('.')
  vim.cmd('normal! gg=G')
  vim.fn.setpos('.', pos)
end, opts)

local function get_visual_selection_range()
  -- Ensure marks are updated by exiting visual mode briefly
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "x", true)

  local start_pos = vim.fn.getpos("'<")
  local end_pos = vim.fn.getpos("'>")

  -- Rows are 0-indexed in API, cols depend on usage
  return {
    start_row = start_pos[2] - 1,
    start_col = start_pos[3] - 1,
    end_row = end_pos[2] - 1,
    end_col = end_pos[3],
    bufnr = vim.api.nvim_get_current_buf()
  }
end

local function move_visual_left()
  local r = get_visual_selection_range()
  local start_pos = vim.fn.getpos("'<")
  local end_pos = vim.fn.getpos("'>")
  if r.start_col > 0 then
    for row = r.start_row, r.end_row do
      local text = vim.api.nvim_buf_get_text(r.bufnr, row, r.start_col, row, r.end_col, {})
      vim.api.nvim_buf_set_text(r.bufnr, row, r.start_col, row, r.end_col, {})
      vim.api.nvim_buf_set_text(r.bufnr, row, r.start_col - 1, row, r.start_col - 1, text)
    end

    -- Reset selection
    vim.fn.setpos("'<", { r.bufnr, r.start_row + 1, start_pos[3] - 1, 0 })
    vim.fn.setpos("'>", { r.bufnr, r.end_row + 1, end_pos[3] - 1, 0 })
    vim.cmd("normal! gv")
  else
    vim.cmd("normal! gv") -- Keep selection if we can't move
  end
end

local function move_visual_right()
  local r = get_visual_selection_range()
  local start_pos = vim.fn.getpos("'<")
  local end_pos = vim.fn.getpos("'>")
  local can_move = true
  for row = r.start_row, r.end_row do
    local line = vim.api.nvim_buf_get_lines(r.bufnr, row, row + 1, false)[1]
    local line_len = #line
    if r.end_col >= line_len then
      can_move = false
      break
    end
  end
  if can_move then
    for row = r.start_row, r.end_row do
      local text = vim.api.nvim_buf_get_text(r.bufnr, row, r.start_col, row, r.end_col, {})
      vim.api.nvim_buf_set_text(r.bufnr, row, r.start_col, row, r.end_col, {})
      vim.api.nvim_buf_set_text(r.bufnr, row, r.start_col + 1, row, r.start_col + 1, text)
    end

    -- Reset selection
    vim.fn.setpos("'<", { r.bufnr, r.start_row + 1, start_pos[3] + 1, 0 })
    vim.fn.setpos("'>", { r.bufnr, r.end_row + 1, end_pos[3] + 1, 0 })
    vim.cmd("normal! gv")
  else
    vim.cmd("normal! gv")
  end
end

-- Fixed mapping function
local function set_move_keymaps(desc, key, commands)
  vim.keymap.set("n", key, commands.n, opts)
  vim.keymap.set("i", key, commands.i, opts)
  vim.keymap.set("v", key, commands.v, opts)
end

local move_commands = {
  up    = { n = ":m .-2<CR>==", i = "<Esc>:m .-2<CR>==gi", v = ":m '<-2<CR>gv=gv" },
  down  = { n = ":m .+1<CR>==", i = "<Esc>:m .+1<CR>==gi", v = ":m '>+1<CR>gv=gv" },
  left  = {
    n = "xhP",
    i = "<Left><Esc>xhPli",
    v = move_visual_left
  },
  right = {
    n = "xp",
    i = "<Esc>xpli",
    v = move_visual_right
  }
}

-- Bindings
set_move_keymaps("Move text up", "<A-k>", move_commands.up)
set_move_keymaps("Move text up", "<A-Up>", move_commands.up)
set_move_keymaps("Move text down", "<A-j>", move_commands.down)
set_move_keymaps("Move text down", "<A-Down>", move_commands.down)
set_move_keymaps("Move text left", "<A-h>", move_commands.left)
set_move_keymaps("Move text left", "<A-Left>", move_commands.left)
set_move_keymaps("Move text right", "<A-l>", move_commands.right)
set_move_keymaps("Move text right", "<A-Right>", move_commands.right)

-- ============================================================================
-- UI Toggles
-- ============================================================================

-- Toggle display of list characters
local function toggle_list()
  local current = vim.o.list
  vim.o.list = not current
  print("List chars " .. (not current and "ON" or "OFF"))
end

opts.desc = "Toggle list characters"
vim.keymap.set("n", "<C-l>", toggle_list, opts)


-- ============================================================================
-- Lua Utilities
-- ============================================================================

opts.desc = "Execute Lua"
vim.keymap.set("n", "<leader>lx", "<Cmd>:.lua<CR>", opts)
opts.desc = "Execute Lua"
vim.keymap.set("v", "<leader>lx", "<Cmd>:lua<CR>", opts)
opts.desc = "Execute Lua File"
vim.keymap.set("n", "<leader>lf", "<Cmd>luafile %<CR>", opts)

-- ============================================================================
-- Popup Menus
-- ============================================================================

-- Lazy require for menu to avoid circular dependency
local function get_menu()
  return require("llawn.config.menu")
end

opts.desc = "Git Popup Menu"
vim.keymap.set("n", "<A-g>", function() get_menu().git.menu() end, opts)

opts.desc = "Mason Popup Menu"
vim.keymap.set("n", "<A-m>", function() get_menu().mason.menu() end, opts)

opts.desc = "Quit Neovim"
vim.keymap.set("n", "<leader>q", function() get_menu().quit.smart_quit() end, opts)

opts.desc = "Treesitter Popup Menu"
vim.keymap.set("n", "<A-t>", function() get_menu().treesitter.menu() end, opts)

opts.desc = "Window Popup Menu"
vim.keymap.set("n", "<A-w>", function() get_menu().window.menu() end, opts)

-- ============================================================================
-- Color Picker
-- ============================================================================

opts.desc = "Pick colors"
vim.keymap.set("n", "<leader>cc", ":HexColors<CR>", opts)
opts.desc = "Pick colors 2D"
vim.keymap.set("n", "<leader>cC", ":ColorPick2D<CR>", opts)

-- ============================================================================
-- Treesitter
-- ============================================================================

opts.desc = "TS Playground"
vim.keymap.set("n", "<leader>tp", ":InspectTree<CR>", opts)

--- Toggle treesitter highlight for buffer with feedback
--- desc: Toggle TS Highlight
--- @return nil
local function toggle_treesitter_highlight()
  local _ = vim.treesitter.highlighter.active[vim.api.nvim_get_current_buf()]
  vim.cmd("TSBufToggle highlight")
  local new_state = vim.treesitter.highlighter.active[vim.api.nvim_get_current_buf()]
  print("Treesitter highlight " .. (new_state and "ON" or "OFF"))
end

opts.desc = "Toggle TS Highlight"
vim.keymap.set("n", "<leader>th", toggle_treesitter_highlight, opts)

opts.desc = "Find Symbols"
vim.keymap.set("n", "<leader>ts", function() get_menu().ts_symbols.menu() end, opts)