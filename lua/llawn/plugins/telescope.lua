-- Plugin: Telescope
-- Description: Highly extendable fuzzy finder over lists with multiple extensions for enhanced functionality.

return {
  'nvim-telescope/telescope.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    'debugloop/telescope-undo.nvim',
    'nvim-telescope/telescope-frecency.nvim',
    'nvim-telescope/telescope-live-grep-args.nvim',
    'nvim-telescope/telescope-project.nvim',
    'nvim-telescope/telescope-symbols.nvim',
    'nvim-telescope/telescope-github.nvim',
    'kkharji/sqlite.lua',
  },
  config = function()
    local telescope = require('telescope')
    local builtin = require('telescope.builtin')

    telescope.setup({
      defaults = {
        file_ignore_patterns = { "node_modules", ".git/" },
        path_display = { "truncate" },
        mappings = {
          i = {
            ["<C-k>"] = require('telescope.actions').move_selection_previous,
            ["<C-j>"] = require('telescope.actions').move_selection_next,
          },
        },
      },
      extensions = {
        fzf = {
          fuzzy = true,
          override_generic_sorter = true,
          override_file_sorter = true,
          case_mode = "smart_case",
        },
        undo = {},
        live_grep_args = { auto_quoting = true },
        project = {
          base_dirs = {
            '~/Source',
          },
          hidden_files = true,
          theme = "dropdown",
          order_by = "recent",
          search_by = "title",
          sync_with_nvim_tree = false,
        },
        frecency = {
          show_scores = true,
          show_unindexed = true,
          ignore_patterns = { "*.git/*", "*/tmp/*" },
        },
        gh = {
        },
      }
    })

    -- Load Extensions
    telescope.load_extension('fzf')
    telescope.load_extension('undo')
    telescope.load_extension('frecency')
    telescope.load_extension('live_grep_args')
    telescope.load_extension('project')
    telescope.load_extension('gh')

    -- --- Keybindings ---

    -- Basic File Navigation
    vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Find Files' })
    vim.keymap.set('n', '<leader>fgf', builtin.git_files, { desc = 'Git Files' })
    vim.keymap.set('n', '<leader>fr', telescope.extensions.frecency.frecency, { desc = 'Frecency (Smart Recent)' })

    -- Search/Grep
    vim.keymap.set('n', '<leader>fl', telescope.extensions.live_grep_args.live_grep_args, { desc = 'Live Grep (Args)' })
    vim.keymap.set('n', '<leader>fw', builtin.grep_string, { desc = 'Find word' })

    -- Extension Specific Bindings
    vim.keymap.set('n', '<leader>ft', '<cmd>Telescope undo<cr>', { desc = 'Undo Tree' })
    vim.keymap.set('n', '<leader>fp', telescope.extensions.project.project, { desc = 'Projects' })

    -- Symbols/Icons by source
    vim.keymap.set(
      'n',
      '<leader>fie',
      function() builtin.symbols { sources = { 'emoji' } } end,
      { desc = 'Insert Emoji' }
    )
    vim.keymap.set(
      'n',
      '<leader>fij',
      function() builtin.symbols { sources = { 'julia' } } end,
      { desc = 'Insert Julia' }
    )
    vim.keymap.set(
      'n',
      '<leader>fig',
      function() builtin.symbols { sources = { 'gitmoji' } } end,
      { desc = 'Insert Gitmoji' }
    )
    vim.keymap.set(
      'n',
      '<leader>fik',
      function() builtin.symbols { sources = { 'kaomoji' } } end,
      { desc = 'Insert Kaomoji' }
    )
    vim.keymap.set(
      'n',
      '<leader>fil',
      function() builtin.symbols { sources = { 'latex' } } end,
      { desc = 'Insert LaTeX Symbols' }
    )
    vim.keymap.set(
      'n',
      '<leader>fim',
      function() builtin.symbols { sources = { 'math' } } end,
      { desc = 'Insert Math Symbols' }
    )
    vim.keymap.set(
      'n',
      '<leader>fin',
      function() builtin.symbols { sources = { 'nerd' } } end,
      { desc = 'Insert Nerd Fonts' }
    )

    -- Neovim / Buffer exploration
    vim.keymap.set('n', '<leader>fb', function()
      builtin.buffers(require('telescope.themes').get_dropdown({
        previewer = false,
        initial_mode = "insert",
      }))
    end, { desc = 'Buffers' })

    vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Help Tags' })
    vim.keymap.set('n', '<leader>fk', builtin.keymaps, { desc = 'Search Keymaps' })

    -- GitHub specific bindings
    vim.keymap.set('n', '<leader>fgi', telescope.extensions.gh.issues, { desc = 'GH Issues' })
    vim.keymap.set('n', '<leader>fgp', telescope.extensions.gh.pull_request, { desc = 'GH Pull Requests' })
    vim.keymap.set('n', '<leader>fgw', telescope.extensions.gh.run, { desc = 'GH Workflow Runs' })

    vim.keymap.set('n', '<leader>fgc', require('llawn.config.menu').git.log, { desc = 'Git Commits' })
    vim.keymap.set('n', '<leader>fgb', builtin.git_branches, { desc = 'Git Branches' })
    vim.keymap.set('n', '<leader>fgs', require('llawn.config.menu').git.status_menu, { desc = 'Git Status' })

    -- Custom menus
    vim.keymap.set('n', '<leader>fu', require('llawn.config.menu').unsaved.menu, { desc = 'Unsaved Files' })
    vim.keymap.set('n', '<leader>fs', require('llawn.config.menu').swapfiles.menu, { desc = 'Swap Files' })
  end
}
