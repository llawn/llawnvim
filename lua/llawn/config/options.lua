--- Core Neovim editor options

-- Line numbering
vim.opt.number = true
vim.opt.relativenumber = true

-- Highligh the current cursor line
vim.opt.cursorline = true

-- Display whitespace characters
vim.opt.list = false
vim.opt.listchars = {
  tab = "▸ ",
  trail = "•",
  extends = "⟩",
  precedes = "⟨",
  nbsp = "␣",
  eol = "↲",
  space = "·",
}

-- Preview substitutions
-- :%s/foo/bar/g
vim.opt.inccommand = 'split'

-- Line wrapping and indentation
vim.opt.wrap = true
vim.opt.breakindent = true
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.smartindent = true

-- Window split behaviour
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Persistent undo history (undotree)
if vim.fn.has("persistent_undo") == 1 then
  vim.opt.undofile = true
end

-- Default border style for floating windows
vim.opt.winborder = 'rounded'

-- Show dotfiles and dot-directories in completion
vim.opt.wildignore:append(".*")

-- Incremental search
vim.opt.incsearch = true

-- UI and Color related options
vim.opt.termguicolors = true
vim.opt.scrolloff = 7
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")
vim.opt.colorcolumn = "80"

-- Hide mode indicator since lualine shows it
vim.opt.showmode = false
