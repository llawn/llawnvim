--- @brief
---
--- Key Mappings
--- Defines general keybindings used across the Neovim configuration
--- Mappings are grouped by functionality for clarity and maintainability
--- Some plugin keybindings can be found directly in their configuration file.
---

local opts = { noremap = true, silent = true }

-- ============================================================================
-- Popup Menus
-- ============================================================================

local menu = require("llawn.config.menu")

opts.desc = "Window Popup Menu"
vim.keymap.set("n", "<C-w>", menu.window.menu, opts)

opts.desc = "Disabled (overlaps with window menu)"
vim.keymap.set("n", "<C-w>d", "<nop>", opts)
vim.keymap.set("n", "<C-w><C-D>", "<nop>", opts)

opts.desc = "Git Popup Menu"
vim.keymap.set("n", "<C-g>", menu.git.menu, opts)

opts.desc = "Treesitter Popup Menu"
vim.keymap.set("n", "<C-t>", menu.treesitter.menu, opts)

opts.desc = "Mason Popup Menu"
vim.keymap.set("n", "<A-m>", menu.mason.menu, opts)

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
-- Navigation
-- ============================================================================

-- Visual line navigation
opts.desc = "Navigate visual line"
for _, keymap in ipairs({
  { "j", "gj" },
  { "k", "gk" },
  { "<Down>", "gj" },
  { "<Up>", "gk" },
}) do
  vim.keymap.set({ "n", "x" }, keymap[1], keymap[2], opts)
end

for _, keymap in ipairs({
  { "<Down>", "<C-\\><C-o>gj" },
  { "<Up>", "<C-\\><C-o>gk" },
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

-- Move Lines
opts.desc = "Move line up"
vim.keymap.set("n", "<A-k>", ":m .-2<CR>==", opts)
vim.keymap.set("i", "<A-k>", "<Esc>:m .-2<CR>==gi", opts)
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv", opts)

opts.desc = "Move line down"
vim.keymap.set("n", "<A-j>", ":m .+1<CR>==", opts)
vim.keymap.set("i", "<A-j>", "<Esc>:m .+1<CR>==gi", opts)
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv", opts)

-- ============================================================================
-- File & Workspace
-- ============================================================================

-- Open file explorer (Yazi if available, fallback to netrw)
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

-- Quit Neovim
opts.desc = "Quit Neovim"
vim.keymap.set("n", "<leader>q", vim.cmd.q, opts)

-- Save file
opts.desc = "Save file"
vim.keymap.set("n", "<leader>w", vim.cmd.w, opts)

-- ============================================================================
-- Color Picker
-- ============================================================================

opts.desc = "Pick colors"
vim.keymap.set("n", "<leader>tc", ":HexColors<CR>", opts)
opts.desc = "Pick colors 2D"
vim.keymap.set("n", "<leader>cc", ":ColorPick2D<CR>", opts)

-- ============================================================================
-- Lua Utilities
-- ============================================================================

opts.desc = "Source current file"
vim.keymap.set("n", "<leader>s", "<Cmd>source %<CR>", opts)
opts.desc = "Execute current line (Lua)"
vim.keymap.set("n", "<leader>lx", "<Cmd>:.lua<CR>", opts)
opts.desc = "Execute selection (Lua)"
vim.keymap.set("v", "<leader>lx", "<Cmd>:lua<CR>", opts)

-- ============================================================================
-- Treesitter
-- ============================================================================

vim.keymap.set("n", "<leader>tp", ":InspectTree<CR>", opts)

-- Toggle treesitter highlight for buffer with feedback
local function toggle_treesitter_highlight()
  local current = vim.treesitter.highlighter.active[vim.api.nvim_get_current_buf()]
  vim.cmd("TSBufToggle highlight")
  local new_state = vim.treesitter.highlighter.active[vim.api.nvim_get_current_buf()]
  print("Treesitter highlight " .. (new_state and "ON" or "OFF"))
end
opts.desc = "Toggle treesitter highlight for buffer"
vim.keymap.set("n", "<leader>tl", toggle_treesitter_highlight, opts)

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
vim.keymap.set({"n","i", "v"}, "<C-s>", vim.cmd.w, opts)

