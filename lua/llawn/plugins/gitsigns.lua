-- Plugin: Gitsigns
-- Description: Provides Git integration for buffers with signs for changes,
--              hunk navigation, staging, and various Git actions.

return {
  'lewis6991/gitsigns.nvim',

  -- Configures gitsigns with custom signs, keymaps, and options
  config = function()
    require('gitsigns').setup {
      signs                        = {
        add          = { text = '┃' },
        change       = { text = '┃' },
        delete       = { text = '_' },
        topdelete    = { text = '‾' },
        changedelete = { text = '~' },
        untracked    = { text = '┆' },
      },
      signs_staged                 = {
        add          = { text = '┃' },
        change       = { text = '┃' },
        delete       = { text = '_' },
        topdelete    = { text = '‾' },
        changedelete = { text = '~' },
        untracked    = { text = '┆' },
      },
      signs_staged_enable          = true,
      signcolumn                   = true,  -- Toggle with `:Gitsigns toggle_signs`
      numhl                        = false, -- Toggle with `:Gitsigns toggle_numhl`
      linehl                       = false, -- Toggle with `:Gitsigns toggle_linehl`
      word_diff                    = false, -- Toggle with `:Gitsigns toggle_word_diff`
      watch_gitdir                 = {
        follow_files = true
      },
      auto_attach                  = true,
      attach_to_untracked          = false,
      current_line_blame           = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
      current_line_blame_opts      = {
        virt_text = true,
        virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
        delay = 1000,
        ignore_whitespace = false,
        virt_text_priority = 100,
        use_focus = true,
      },
      current_line_blame_formatter = '<author>, <author_time:%R> - <summary>',
      sign_priority                = 6,
      update_debounce              = 100,
      status_formatter             = nil,   -- Use default
      max_file_length              = 40000, -- Disable if file is longer than this (in lines)
      preview_config               = {
        -- Options passed to nvim_open_win
        style = 'minimal',
        relative = 'cursor',
        row = 0,
        col = 1
      },

      --- Sets up buffer-local keymaps for gitsigns actions
      --- @param bufnr number The buffer number
      on_attach                    = function(bufnr)
        local gitsigns = require('gitsigns')

        --- Maps a key in the given mode for the buffer
        --- @param mode string | string[] The mode(s)
        --- @param l string The left-hand side (key)
        --- @param r function|string The right-hand side (command or function)
        --- @param opts table Optional options table (desc)
        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -----------------------------------------------------------------------
        -- Navigation
        -----------------------------------------------------------------------
        --- Navigates to the next hunk or diff change
        local function next_hunk()
          if vim.wo.diff then
            vim.cmd.normal({ ']c', bang = true })
          else
            gitsigns.nav_hunk('next')
          end
        end

        --- Navigates to the previous hunk or diff change
        local function prev_hunk()
          if vim.wo.diff then
            vim.cmd.normal({ '[c', bang = true })
          else
            gitsigns.nav_hunk('prev')
          end
        end

        map('n', ']h', next_hunk, { desc = "Next Hunk" })
        map('n', '[h', prev_hunk, { desc = "Prev Hunk" })

        -----------------------------------------------------------------------
        -- Actions
        -----------------------------------------------------------------------
        --- Stages the selected hunk in visual mode
        local function stage_hunk_visual()
          gitsigns.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
        end

        --- Resets the selected hunk in visual mode
        local function reset_hunk_visual()
          gitsigns.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
        end

        --- Shows full blame information for the current line
        local function blame_line_full()
          gitsigns.blame_line({ full = true })
        end

        --- Diffs the current file against HEAD
        local function diff_this_head()
          gitsigns.diffthis('~')
        end

        --- Adds all hunks to the quickfix list
        local function setqflist_all()
          gitsigns.setqflist('all')
        end

        map('n', '<leader>gb', blame_line_full, { desc = "Blame Line" })
        map('n', '<leader>gd', gitsigns.diffthis, { desc = "Diff This" })
        map('n', '<leader>gD', diff_this_head, { desc = "Diff This ~" })
        map('n', '<leader>gi', gitsigns.preview_hunk_inline, { desc = "Preview Hunk Inline" })
        map('n', '<leader>gp', gitsigns.preview_hunk, { desc = "Preview Hunk" })
        map('n', '<leader>gq', gitsigns.setqflist, { desc = "Quickfix" })
        map('n', '<leader>gQ', setqflist_all, { desc = "Quickfix All" })
        map('n', '<leader>gr', gitsigns.reset_hunk, { desc = "Reset Hunk" })
        map('v', '<leader>gr', reset_hunk_visual, { desc = "Reset Hunk" })
        map('n', '<leader>gR', gitsigns.reset_buffer, { desc = "Reset Buffer" })
        map('n', '<leader>gs', gitsigns.stage_hunk, { desc = "Stage Hunk" })
        map('v', '<leader>gs', stage_hunk_visual, { desc = "Stage Hunk" })
        map('n', '<leader>gS', gitsigns.stage_buffer, { desc = "Stage Buffer" })

        -----------------------------------------------------------------------
        -- Toggles
        -----------------------------------------------------------------------

        map('n', '<leader>gl', gitsigns.toggle_current_line_blame, { desc = "Toggle Blame" })
        map('n', '<leader>gw', gitsigns.toggle_word_diff, { desc = "Toggle Word Diff" })

        -----------------------------------------------------------------------
        -- Text object
        -----------------------------------------------------------------------

        map({ 'o', 'x' }, '<leader>gh', gitsigns.select_hunk, { desc = "Select Hunk" })
      end
    }
  end
}
