local opts = { noremap = true, silent = true }

-- Enter Mode
vim.keymap.set('n', '<C-q>', '<C-v>', { desc = 'Enter Visual Block mode' })

-- Fast Saving / Quit files
vim.keymap.set("n", "<leader>x", vim.cmd.Ex, { desc = "Open netrw" })
vim.keymap.set("n", "<leader>q", vim.cmd.q, { desc = "Quit" })
vim.keymap.set("n", "<leader>w", vim.cmd.w, { desc = "Save file" })

-- Navigate visual lines
vim.keymap.set({ 'n', 'x' }, 'j', 'gj', { desc = 'Navigate down (visual line)' })
vim.keymap.set({ 'n', 'x' }, 'k', 'gk', { desc = 'Navigate up (visual line)' })
vim.keymap.set({ 'n', 'x' }, '<Down>', 'gj', { desc = 'Navigate down (visual line)' })
vim.keymap.set({ 'n', 'x' }, '<Up>', 'gk', { desc = 'Navigate up (visual line)' })
vim.keymap.set('i', '<Down>', '<C-\\><C-o>gj', { desc = 'Navigate down (visual line)' })
vim.keymap.set('i', '<Up>', '<C-\\><C-o>gk', { desc = 'Navigate up (visual line)' })

-- Move Lines
vim.keymap.set({ 'n', 'x' }, '<M-S-Up>', ':move -2<cr>', { desc = 'Move Line Up' })
vim.keymap.set({ 'n', 'x' }, '<M-S-Down>', ':move +1<cr>', { desc = 'Move Line Down' })
vim.keymap.set('i', '<M-S-Up>', '<C-o>:move -2<cr>', { desc = 'Move Line Up' })
vim.keymap.set('i', '<M-S-Down>', '<C-o>:move +1<cr>', { desc = 'Move Line Down' })

-- Standard Application behaviour
vim.keymap.set({'n', 'x'}, '<C-c>', '"+y', { desc = 'Copy to system clipboard' }) 
vim.keymap.set({'n', 'x'}, '<C-v>', '"+p', { desc = 'Paste from system clipboard' })
vim.keymap.set({'n', 'x'}, '<C-x>', '"+d', { desc = 'Cut to system clipboard' })
vim.keymap.set({'n', 'x'}, '<C-a>', 'ggVG', { desc = 'Select all' })
vim.keymap.set({'n', 'x'}, '<C-z>', 'u', { desc = 'Undo last change' })
vim.keymap.set({'n', 'x'}, '<C-s>', vim.cmd.w, { desc = "Save File" })

-- Navigating buffers
vim.keymap.set('n', '<leader>bb', '<C-^>', { desc = 'Switch to alternate buffer' })
vim.keymap.set('n', '<leader>bn', ':bnext<cr>', { desc = 'Next buffer' })
vim.keymap.set('n', '<leader>bp', ':bprevious<cr>', { desc = 'Previous buffer' })

-- Ctrl-L redraws the screen by default. Now it will also toggle search highlighting.
vim.keymap.set('n', '<C-l>', ':set hlsearch!<cr><C-l>', { desc = 'Toggle search highlighting' })

-- Toggle visible whitespace characters
vim.keymap.set('n', '<leader>lc', ':listchars!<cr>', { desc = 'Toggle listchars' })

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>d', vim.diagnostic.setloclist, { desc = 'Open diagnostic quickfix list' })

-- Quickly source current file / execute Lua code
vim.keymap.set('n', '<leader>s', '<Cmd>source %<CR>', { desc = 'Source current file' })
vim.keymap.set('n', '<leader>lx', '<Cmd>:.lua<CR>', { desc = 'Lua: execute current line' })
vim.keymap.set('v', '<leader>lx', '<Cmd>:lua<CR>', { desc = 'Lua: execute current selection' })
