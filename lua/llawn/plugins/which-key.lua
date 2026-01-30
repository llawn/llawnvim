-- Plugin: Which-key
-- Description: which-key displays available keybindings in a popup menu

return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    win = {
      padding = { 0, 0 },
      height = { min = 1, max = 5 },
      title = false,
    },
    layout = {
      width = { min = 15, max = 25 },
      spacing = 3,
      align = "left",
    },
  },
  keys = {
    {
      "<leader>?",
      function()
        require("which-key").show({ global = false })
      end,
      desc = "Buffer Local Keymaps (which-key)",
    },
  },
  config = function(_, opts)
    local wk = require("which-key")
    wk.setup(opts)
    wk.add({
      -- Groups
      { "g", group = "Go to", icon = { icon = "󰺯 ", color = "blue" } },
      { "<A-g>", group = "Git" },
      { "<A-m>", group = "Mason" },
      { "<A-t>", group = "Treesitter" },
      { "<A-w>", group = "Window", icon = { icon = "󰖲", color = "blue" } },
      { "<leader>", group = "Leader", icon = { icon = "󰘳", color = "grey" } },
      { "<leader>b", group = "Buffers", icon = { icon = "󰓩 ", color = "purple" } },
      { "<leader>c", group = "Colors", icon = { icon = "󰏘", color = "purple" } },
      { "<leader>d", group = "Diagnostics", icon = { icon = "󰨮", color = "red" } },
      { "<leader>D", group = "Debug", icon = { icon = "", color = "red" } },
      { "<leader>f", group = "Find", icon = { icon = "󰱼", color = "blue" } },
      { "<leader>fg", group = "Git Find", icon = { icon = "󰊢", color = "orange" } },
      { "<leader>fi", group = "Insert", icon = { icon = "", color = "purple" } },
      { "<leader>g", group = "Git", icon = { icon = "󰊢", color = "orange" } },
      { "<leader>h", group = "Harpoon", icon = { icon = "󰛢", color = "purple" } },
      { "<leader>l", group = "Lua", icon = { icon = "", color = "purple" } },
      { "<leader>n", group = "Notes (Fusen)", icon = { icon = "", color = "yellow" } },
      { "<leader>p", group = "LSP", icon = { icon = "󰒓", color = "blue" } },
      { "<leader>s", group = "TS Swap", icon = { icon = "󰓡", color = "green" } },
      { "<leader>t", group = "TS", icon = { icon = "󰐅", color = "green" } },

      -- Function Key
      { "<F5>", icon = { icon = "", color = "red" } }, -- Debug: Start/Continue
      { "<F6>", icon = { icon = "", color = "red" } }, -- Debug: Step Over
      { "<F7>", icon = { icon = "", color = "red" } }, -- Debug: Step Into
      { "<F8>", icon = { icon = "", color = "red" } }, -- Debug: Step Out
      { "<F9>", icon = { icon = "", color = "red" } }, -- Run Last

      -- Alt Key
      { "<A-g>", icon = { icon = "󰊢", color = "orange" } }, -- Git Menu
      { "<A-h>", icon = { icon = "󰜱", color = "blue" } }, -- Move Left
      { "<A-j>", icon = { icon = "󰜮", color = "blue" } }, -- Move Line Down
      { "<A-k>", icon = { icon = "󰜷", color = "red" } }, -- Move Line Up
      { "<A-l>", icon = { icon = "󰜴", color = "blue" } }, -- Move Right
      { "<A-m>", icon = { icon = "󱌢", color = "green" } }, -- Mason Menu
      { "<A-t>", icon = { icon = "󰐅", color = "green" } }, -- Treesitter Menu

      -- Control Key
      { "<C-1>", icon = { icon = "󰛢", color = "purple" } }, -- Harpoon 1
      { "<C-2>", icon = { icon = "󰛢", color = "purple" } }, -- Harpoon 2
      { "<C-3>", icon = { icon = "󰛢", color = "purple" } }, -- Harpoon 3
      { "<C-a>", icon = { icon = "󰒆", color = "grey" } }, -- Select All
      { "<C-c>", icon = { icon = "󰅍", color = "yellow" } }, -- Copy Clipboard
      { "<C-e>", icon = { icon = "󰛢", color = "purple" } }, -- Harpoon Menu
      { "<C-k>", icon = { icon = "󰋖", color = "grey" }, mode = "i" }, -- Signature Help (insert)
      { "<C-l>", icon = { icon = "󰌶", color = "grey" } }, -- Toggle List Chars
      { "<C-q>", icon = { icon = "󰩭", color = "grey" } }, -- Visual Block
      { "<C-s>", icon = { icon = "󰆓", color = "green" } }, -- Save File
      { "<C-v>", icon = { icon = "󰅌", color = "cyan" } }, -- Paste Clipboard
      { "<C-x>", icon = { icon = "󰆐", color = "orange" } }, -- Cut Clipboard
      { "<C-y>", icon = { icon = "󰑎", color = "green" } }, -- Redo
      { "<C-z>", icon = { icon = "󰕌", color = "red" } }, -- Undo
      { "<C-Space>", icon = { icon = "󰋖", color = "grey" }, mode = "i", desc = "CMP Complete" },
      { "<C-Up>", icon = { icon = "󰙅", color = "blue" } }, -- Yazi Toggle

      -- 1-stroke key
      { "<leader>a", icon = { icon = "󰛢", color = "purple" } }, -- Add to Harpoon
      { "<leader>q", icon = { icon = "󰈆", color = "red" } }, -- Quit Neovim
      { "<leader>R", icon = { icon = "󰑐", color = "blue" } }, -- Reload Config
      { "<leader>S", icon = { icon = "", color = "green" } }, -- Source File
      { "<leader>u", icon = { icon = "󰕍", color = "red" } }, -- UndoTree
      { "<leader>w", icon = { icon = "󰆓", color = "green" } }, -- Save File
      { "<leader>x", icon = { icon = "󰙅", color = "blue" } }, -- File Explorer
      { "<leader>y", icon = { icon = "󰙅", color = "blue" } }, -- Yazi CWD
      { "<leader>-", icon = { icon = "󰙅", color = "blue" } }, -- Yazi File
      { "<leader>?", icon = { icon = "󰋖", color = "grey" } }, -- Keymaps

      -- Buffers
      { "<leader>bb", icon = { icon = "󰓩 ", color = "purple" } }, -- Alternate Buffer
      { "<leader>bn", icon = { icon = "󰮱 ", color = "cyan" } }, -- Next Buffer
      { "<leader>bp", icon = { icon = "󰮳 ", color = "cyan" } }, -- Previous Buffer

      -- Color
      { "<leader>cC", icon = { icon = "󰈊", color = "purple" } }, -- Pick Colors 2D
      { "<leader>ct", icon = { icon = "󰏘", color = "purple" } }, -- Toggle Colors

      -- Diagnostics
      { "<leader>db", icon = { icon = "󰨮", color = "red" } }, -- Buffer Diagnostics
      { "<leader>dc", icon = { icon = "󰅍", color = "yellow" } }, -- Copy Diagnostics
      { "<leader>dC", icon = { icon = "󰅍", color = "yellow" } }, -- Copy Diagnostics (Source)
      { "<leader>dd", icon = { icon = "󰨮", color = "red" } }, -- Show line Diagnostic
      { "<leader>ds", icon = { icon = "󰨮", color = "red" } }, -- Show Buffer Diagnostic
      { "<leader>dS", icon = { icon = "󰨮", color = "red" } }, -- Show BUffer Diagnostic (Source)

      -- Debug
      { "<leader>Dc", icon = { icon = "●", color = "orange" } }, -- Conditional Breakpoint
      { "<leader>Dd", icon = { icon = "●", color = "red" } }, -- Breakpoint
      { "<leader>Dl", icon = { icon = "", color = "cyan" } }, -- Log Point
      { "<leader>Dr", icon = { icon = "", color = "red" } }, -- Open Repl
      { "<leader>Du", icon = { icon = "", color = "red" } }, -- Toggle UI
      { "<leader>Dx", icon = { icon = "󰆴", color = "red" } }, -- Remove all breakpoints

      -- Find/Telescope
      { "<leader>fb", icon = { icon = "󰓩 ", color = "cyan" } }, -- Buffers
      { "<leader>ff", icon = { icon = "󰱼 ", color = "blue" } }, -- Find Files
      { "<leader>fh", icon = { icon = "󰋖", color = "grey" } }, -- Help Tags
      { "<leader>fk", icon = { icon = "󰌌", color = "blue" } }, -- Keymaps
      { "<leader>fl", icon = { icon = "󰱼", color = "blue" } }, -- Live Grep
      { "<leader>fp", icon = { icon = "󰱼", color = "blue" } }, -- Projects
      { "<leader>fr", icon = { icon = "󰱼", color = "blue" } }, -- Frecency
      { "<leader>ft", icon = { icon = "󰱼", color = "blue" } }, -- Undo Tree
      { "<leader>fu", icon = { icon = "󰷊", color = "orange" } }, -- Unsaved Files
      { "<leader>fw", icon = { icon = "󰈬", color = "yellow" } }, -- Find Word
      { "<leader>fs", icon = { icon = "󰆏", color = "red" } }, -- Swap Files
      { "<leader>fgb", icon = { icon = "󰊢", color = "orange" } }, -- Git Branches
      { "<leader>fgc", icon = { icon = "󰊢", color = "orange" } }, -- Git Commits
      { "<leader>fgf", icon = { icon = "󰊢", color = "orange" } }, -- Git Files
      { "<leader>fgi", icon = { icon = "󰊢", color = "orange" } }, -- GH Issues
      { "<leader>fgp", icon = { icon = "󰊢", color = "orange" } }, -- GH PR
      { "<leader>fgs", icon = { icon = "󰊢", color = "orange" } }, -- Git Status
      { "<leader>fgw", icon = { icon = "󰊢", color = "orange" } }, -- GH Runs
      { "<leader>fie", icon = { icon = "󰞅", color = "purple" } }, -- Emoji
      { "<leader>fig", icon = { icon = "", color = "purple" } }, -- Gitmoji
      { "<leader>fij", icon = { icon = "", color = "purple" } }, -- Julia
      { "<leader>fik", icon = { icon = "󰏘", color = "purple" } }, -- Kaomoji
      { "<leader>fil", icon = { icon = "", color = "purple" } }, -- LaTeX
      { "<leader>fim", icon = { icon = "󰿉", color = "purple" } }, -- Math
      { "<leader>fin", icon = { icon = "", color = "purple" } }, -- Nerd

      -- Git/Gitsigns
      { "<leader>gb", icon = { icon = "󰋀 ", color = "orange" } }, -- Blame Line
      { "<leader>gd", icon = { icon = "󰊢", color = "orange" } }, -- Diff This
      { "<leader>gD", icon = { icon = "󰊢", color = "orange" } }, -- Diff This
      { "<leader>gg", icon = { icon = "󰊢", color = "orange" } }, -- LazyGit
      { "<leader>gh", icon = { icon = "󰜄", color = "orange" }, mode = { "o", "x" } }, -- Select Hunk
      { "<leader>gi", icon = { icon = "󰜄", color = "blue" } }, -- Preview Hunk Inline
      { "<leader>gl", icon = { icon = "󰌶", color = "grey" } }, -- Toggle Blame
      { "<leader>gp", icon = { icon = "󰜄", color = "blue" } }, -- Preview Hunk
      { "<leader>gq", icon = { icon = "󰮱 ", color = "orange" } }, -- Quickfix
      { "<leader>gQ", icon = { icon = "󰮱 ", color = "orange" } }, -- Quickfix All
      { "<leader>gr", icon = { icon = "󰜄", color = "red" }, mode = { "n", "v" } }, -- Reset Hunk
      { "<leader>gR", icon = { icon = "󰜄", color = "red" } }, -- Reset Buffer
      { "<leader>gs", icon = { icon = "󰜄", color = "green" }, mode = { "n", "v" } }, -- Stage Hunk
      { "<leader>gS", icon = { icon = "󰜄", color = "green" } }, -- Stage Buffer
      { "<leader>gw", icon = { icon = "󰌶", color = "grey" } }, -- Toggle Word Diff

      -- Harpoon
      { "<leader>hn", icon = { icon = "󰛢", color = "purple" } }, -- Harpoon Next
      { "<leader>hp", icon = { icon = "󰛢", color = "purple" } }, -- Harpoon Previous

      -- Lua
      { "<leader>lx", icon = { icon = " ", color = "purple" }, mode = { "n", "v" } }, -- Execute Lua
      { "<leader>lf", icon = { icon = " ", color = "purple" } }, -- Execute Lua File

      -- Notes (Fusen)
      { "<leader>nc", icon = { icon = "󱙑", color = "yellow" }, desc = "Clear Line Note" },
      { "<leader>nC", icon = { icon = "󱙑", color = "orange" }, desc = "Clear Buffer Notes" },
      { "<leader>nD", icon = { icon = "󰆴", color = "red" }, desc = "Clear All Notes" },
      { "<leader>ne", icon = { icon = "󱞁", color = "yellow" }, desc = "Add/Edit Notes" },
      { "<leader>nf", icon = { icon = "󱙓", color = "yellow" }, desc = "Find Notes" },
      { "<leader>ni", icon = { icon = "", color = "blue" }, desc = "Info Note" },
      { "<leader>nl", icon = { icon = "󰚸", color = "yellow" }, desc = "List Notes" },
      { "<leader>nt", desc = "Toggle Notes" },

      -- LSP + Neogen
      { "<leader>pa", icon = { icon = "󰌵", color = "green" }, mode = { "n", "v" } }, -- Code Action
      { "<leader>pd", icon = { icon = "󰏫", color = "green" } }, -- Function Doc
      { "<leader>pf", icon = { icon = "󰉶", color = "green" } }, -- Format
      { "<leader>ph", icon = { icon = "󰌶", color = "grey" } }, -- Toggle Inlay Hints
      { "<leader>pi", icon = { icon = "", color = "blue" } }, -- Indent file
      { "<leader>pl", icon = { icon = "󰨮", color = "red" } }, -- Trigger Linting
      { "<leader>pm", icon = { icon = "󰽛", color = "cyan" } }, -- Toggle Markdown Render
      { "<leader>pn", icon = { icon = "󰑕", color = "orange" } }, -- Rename
      { "<leader>ps", icon = { icon = "󰑐", color = "blue" } }, -- Restart LSP
      { "<leader>pt", icon = { icon = "󰏫", color = "green" } }, -- Type Doc

      -- Treesitter + Symbols
      { "<leader>tb", icon = { icon = "󰭷 ", color = "blue" } }, -- LSP Buffer Symbols
      { "<leader>tp", icon = { icon = "󰐅", color = "green" } }, -- TS Playground
      { "<leader>th", icon = { icon = "󰐅", color = "green" } }, -- Toggle TS Highlight
      { "<leader>ts", icon = { icon = "󰭷 ", color = "blue" } }, -- Find Symbols
      { "<leader>tw", icon = { icon = "󰭷 ", color = "blue" } }, -- LSP Workspace Symbols

      -- TS Textobjects Select
      { "aa", icon = { icon = "󰐅", color = "green" }, mode = { "o", "x" } }, -- Parameter Outer
      { "ab", icon = { icon = "󰐅", color = "green" }, mode = { "o", "x" } }, -- Block Outer
      { "ac", icon = { icon = "󰐅", color = "green" }, mode = { "o", "x" } }, -- Class Outer
      { "af", icon = { icon = "󰐅", color = "green" }, mode = { "o", "x" } }, -- Function Outer
      { "ai", icon = { icon = "󰐅", color = "green" }, mode = { "o", "x" } }, -- Conditional Outer
      { "al", icon = { icon = "󰐅", color = "green" }, mode = { "o", "x" } }, -- Loop Outer
      { "am", icon = { icon = "󰐅", color = "green" }, mode = { "o", "x" } }, -- Call Outer
      { "as", icon = { icon = "󰐅", color = "green" }, mode = { "o", "x" } }, -- Statement Outer
      { "ia", icon = { icon = "󰐅", color = "green" }, mode = { "o", "x" } }, -- Parameter Inner
      { "ib", icon = { icon = "󰐅", color = "green" }, mode = { "o", "x" } }, -- Block Inner
      { "ic", icon = { icon = "󰐅", color = "green" }, mode = { "o", "x" } }, -- Class Inner
      { "if", icon = { icon = "󰐅", color = "green" }, mode = { "o", "x" } }, -- Function Inner
      { "ii", icon = { icon = "󰐅", color = "green" }, mode = { "o", "x" } }, -- Conditional Inner
      { "il", icon = { icon = "󰐅", color = "green" }, mode = { "o", "x" } }, -- Loop Inner
      { "im", icon = { icon = "󰐅", color = "green" }, mode = { "o", "x" } }, -- Call Inner
      { "is", icon = { icon = "󰐅", color = "green" }, mode = { "o", "x" } }, -- Statement Inner

      -- TS Textobjects Swap
      { "<leader>sa", icon = { icon = "󰓡", color = "green" } }, -- Swap Param Next
      { "<leader>sA", icon = { icon = "󰓡", color = "green" } }, -- Swap Param Prev
      { "<leader>sb", icon = { icon = "󰓡", color = "green" } }, -- Swap Block Next
      { "<leader>sB", icon = { icon = "󰓡", color = "green" } }, -- Swap Block Prev
      { "<leader>sc", icon = { icon = "󰓡", color = "green" } }, -- Swap Class Next
      { "<leader>sC", icon = { icon = "󰓡", color = "green" } }, -- Swap Class Prev
      { "<leader>sf", icon = { icon = "󰓡", color = "green" } }, -- Swap Function Next
      { "<leader>sF", icon = { icon = "󰓡", color = "green" } }, -- Swap Function Prev
      { "<leader>sm", icon = { icon = "󰓡", color = "green" } }, -- Swap Call Next
      { "<leader>sM", icon = { icon = "󰓡", color = "green" } }, -- Swap Call Prev

      -- TS Incremental Selection
      { "gnn", icon = { icon = "󰐅", color = "green" } }, -- Init Selection
      { "grn", icon = { icon = "󰐅", color = "green" } }, -- Node Incremental
      { "grc", icon = { icon = "󰐅", color = "green" } }, -- Scope Incremental
      { "grm", icon = { icon = "󰐅", color = "green" } }, -- Node Decremental

      -- Bracket Key
      { "]a", icon = { icon = "󰐅", color = "green" } }, -- Next Parameter
      { "[a", icon = { icon = "󰐅", color = "green" } }, -- Prev Parameter
      { "]A", icon = { icon = "󰐅", color = "green" } }, -- Next Parameter End
      { "[A", icon = { icon = "󰐅", color = "green" } }, -- Prev Parameter End
      { "]b", icon = { icon = "󰐅", color = "green" } }, -- Next Block
      { "[b", icon = { icon = "󰐅", color = "green" } }, -- Prev Block
      { "]B", icon = { icon = "󰐅", color = "green" } }, -- Next Block End
      { "[B", icon = { icon = "󰐅", color = "green" } }, -- Prev Block End
      { "]c", icon = { icon = "󰐅", color = "green" } }, -- Next Class
      { "[c", icon = { icon = "󰐅", color = "green" } }, -- Prev Class
      { "]C", icon = { icon = "󰐅", color = "green" } }, -- Next Class End
      { "[C", icon = { icon = "󰐅", color = "green" } }, -- Prev Class End
      { "[d", icon = { icon = "󰮱 ", color = "red" } }, -- Prev Diagnostic
      { "]d", icon = { icon = "󰮳 ", color = "red" } }, -- Next Diagnostic
      { "]f", icon = { icon = "󰐅", color = "green" } }, -- Next Function
      { "[f", icon = { icon = "󰐅", color = "green" } }, -- Prev Function
      { "]F", icon = { icon = "󰐅", color = "green" } }, -- Next Function End
      { "[F", icon = { icon = "󰐅", color = "green" } }, -- Prev Function End
      { "]h", icon = { icon = "󰊢", color = "orange" } }, -- Next Hunk
      { "[h", icon = { icon = "󰊢", color = "orange" } }, -- Prev Hunk
      { "]i", icon = { icon = "󰐅", color = "green" } }, -- Next Conditional
      { "[i", icon = { icon = "󰐅", color = "green" } }, -- Prev Conditional
      { "]I", icon = { icon = "󰐅", color = "green" } }, -- Next Conditional End
      { "[I", icon = { icon = "󰐅", color = "green" } }, -- Prev Conditional End
      { "]l", icon = { icon = "󰐅", color = "green" } }, -- Next Loop
      { "[l", icon = { icon = "󰐅", color = "green" } }, -- Prev Loop
      { "]L", icon = { icon = "󰐅", color = "green" } }, -- Next Loop End
      { "[L", icon = { icon = "󰐅", color = "green" } }, -- Prev Loop End
      { "]m", icon = { icon = "󰐅", color = "green" } }, -- Next Call
      { "[m", icon = { icon = "󰐅", color = "green" } }, -- Prev Call
      { "]M", icon = { icon = "󰐅", color = "green" } }, -- Next Call End
      { "[M", icon = { icon = "󰐅", color = "green" } }, -- Prev Call End
      { "]n", icon = { icon = "󰍉", color = "yellow" } }, -- Next Mark
      { "[n", icon = { icon = "󰍉", color = "yellow" } }, -- Prev Mark
      { "]s", icon = { icon = "󰐅", color = "green" } }, -- Next Statement
      { "[s", icon = { icon = "󰐅", color = "green" } }, -- Prev Statement
      { "]S", icon = { icon = "󰐅", color = "green" } }, -- Next Statement End
      { "[S", icon = { icon = "󰐅", color = "green" } }, -- Prev Statement End

      -- g-key
      { "gd", icon = { icon = "󰺯", color = "blue" } }, -- LSP Definition
      { "gD", icon = { icon = "󰺯", color = "blue" } }, -- LSP Declaration
      { "gi", icon = { icon = "󰆕", color = "blue" } }, -- LSP Implementations
      { "gR", icon = { icon = "󰆕", color = "blue" } }, -- LSP References
      { "gt", icon = { icon = "󰆧", color = "blue" } }, -- LSP Type Definition

      -- Others
      { "K", icon = { icon = "󰋖", color = "grey" } }, -- Signature help (normal)

      -- nvim-cmp Keymaps
      -- { "<C-b>", icon = { icon = "󰋖", color = "grey" }, mode = "i", desc = "CMP Scroll Docs Up" },
      -- { "<C-e>", icon = { icon = "󰋖", color = "grey" }, mode = "i", desc = "CMP Abort" },
      -- { "<C-f>", icon = { icon = "󰋖", color = "grey" }, mode = "i", desc = "CMP Scroll Docs Down" },
      -- { "<C-j>", icon = { icon = "󰋖", color = "grey" }, mode = "i", desc = "CMP Select Next Item" },
      -- { "<C-k>", icon = { icon = "󰋖", color = "grey" }, mode = "i", desc = "CMP Select Previous Item" },
      -- { "<CR>", icon = { icon = "󰋖", color = "grey" }, mode = "i", desc = "CMP Confirm" },

      -- Yazi
      -- { "<A-b>", desc = "Open Telescope Buffer from Yazi" },
      -- { "<A-e>", desc = "Open Harpoon from Yazi " },
      -- { "<A-g>", desc = "Open Live Grep from Yazi" },
      -- { "<A-l>", desc = "Open Lazygit from Yazi" },
      -- { "<A-p>", desc = "Open Project from Yazi" },
      -- { "<A-s>", desc = "Open Git status from Yazi" },
      -- { "<A-u>", desc = "Open Unsaved files from Yazi" },
    })
  end
}
