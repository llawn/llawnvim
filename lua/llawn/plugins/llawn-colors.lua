return {
  'llawn/llawn.colors',
  config = function()
    -- Command to start the palette server
    vim.api.nvim_create_user_command('StartPaletteServer', function()
      local plugin_dir = vim.fn.stdpath('data') .. '/lazy/llawn.colors/lua/llawn/colors'
      vim.fn.jobstart({'bash', plugin_dir .. '/serve_palette.sh'}, {
        detach = true,
        on_exit = function() end
      })
      vim.notify('Palette server started on http://localhost:8000', vim.log.levels.INFO)
    end, {})

    -- Command to open the palette generator web UI
    vim.api.nvim_create_user_command('OpenPaletteGenerator', function()
      local url = 'http://localhost:8000/palette_generator.html'
      -- Open in default browser
      if vim.fn.has('mac') == 1 then
        vim.fn.system('open ' .. url)
      elseif vim.fn.has('unix') == 1 then
        vim.fn.system('xdg-open ' .. url)
      elseif vim.fn.has('win32') == 1 then
        vim.fn.system('start ' .. url)
      end
    end, {})

    -- Keymap to open it (optional)
    vim.keymap.set('n', '<leader>pc', ':OpenPaletteGenerator<CR>', { desc = 'Open Palette Generator' })
  end
}