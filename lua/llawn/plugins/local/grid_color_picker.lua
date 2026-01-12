--- @brief A Neovim plugin that provides a 2D grid color picker.
--- Displays colors in a grid sorted by HSL to minimize perceptual jumps.
--- Hover over colors to see info, press Enter to insert #hex at cursor.

local colors = require('llawn.plugins.local.colors')
local utils = require('llawn.plugins.local.colors_utils')

local M = {}

-- =============================================================================
-- MAIN COLOR PICKER FUNCTION
-- =============================================================================
-- Creates and displays a 2D grid color picker window with interactive selection.

function M.pick_color()
  -- =============================================================================
  -- CURSOR POSITION AND GRID SETUP
  -- =============================================================================
  -- Saves original cursor position and calculates optimal grid dimensions.

  -- Get original cursor position
  local orig_win = vim.api.nvim_get_current_win()
  local orig_buf = vim.api.nvim_get_current_buf()
  local orig_cursor = vim.api.nvim_win_get_cursor(orig_win)

  -- Number of colors
  local n = #colors

  -- Number of line / rows
  local l = math.ceil(math.sqrt(n / 2))
  local rows = l
  local cols = 2 * l
  local total_slots = rows * cols

  if total_slots - 2 * l > n then
    rows = rows - 1
    total_slots = total_slots - 2 * l
  elseif total_slots - l > n then
    cols = cols - 1
    total_slots = total_slots - l
  end

  -- =============================================================================
  -- COLOR SORTING
  -- =============================================================================
  -- Sorts colors by HSL values to minimize perceptual jumps in the grid.

  -- Prepare sorted colors
  local color_list = {}
  for _, c in ipairs(colors) do
    local r, g, b = utils.int_to_rgb(c.color)
    local h, s, lv = utils.rgb_to_hsl(r, g, b)
    table.insert(color_list, {color = c, h = h, s = s, lv = lv})
  end
  table.sort(color_list, function(a, b)
    if a.h ~= b.h then return a.h < b.h end
    if a.s ~= b.s then return a.s < b.s end
    return a.lv < b.lv
  end)

  -- =============================================================================
  -- GRID FILLING
  -- =============================================================================

  -- Fill grid with colors, then black
  local grid = {}
  for i = 1, total_slots do
    if i <= n then
      grid[i] = color_list[i]
    else
      grid[i] = {color = {name = "black", color = 0x000000}, h = 0, s = 0, lv = 0}
    end
  end

  -- =============================================================================
  -- WINDOW CREATION
  -- =============================================================================

  -- Create floating window
  local width = cols * 3
  local height = rows
  local buf = vim.api.nvim_create_buf(false, true)

  -- Set lines: each row is '   ' repeated cols times
  local lines = {}
  for _ = 1, rows do
    local line = ''
    for _ = 1, cols do
      line = line .. '   '
    end
    table.insert(lines, line)
  end
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

  -- =============================================================================
  -- CELL HIGHLIGHTING
  -- =============================================================================

  -- Highlight each cell
  local ns_id = vim.api.nvim_create_namespace('color_picker')
  for r = 0, rows - 1 do
    for c = 0, cols - 1 do
      local idx = r * cols + c + 1
      local hex = utils.int_to_hex(grid[idx].color.color)
      local start_col = c * 3
      vim.hl.range(buf, ns_id, 'Color' .. idx, {r, start_col}, {r, start_col+3})
      vim.cmd('hi Color' .. idx .. ' guibg=' .. hex)
    end
  end

  -- =============================================================================
  -- WINDOW DISPLAY AND INTERACTIONS
  -- =============================================================================
  -- Opens the window and sets up key mappings and autocmds for interaction.

  -- Open window
  local win = vim.api.nvim_open_win(buf, true, {
    relative = 'editor',
    width = width,
    height = height,
    col = math.floor((vim.o.columns - width) / 2),
    row = math.floor((vim.o.lines - height) / 2),
    style = 'minimal',
    border = 'rounded'
  })

  -- Set buffer options
  vim.api.nvim_set_option_value('modifiable', false, { buf = buf })

  -- Hover info
  vim.api.nvim_create_autocmd('CursorMoved', {
    buffer = buf,
    callback = function()
      local cursor = vim.api.nvim_win_get_cursor(win)
      local r, c = cursor[1] - 1, cursor[2]
      local col_idx = math.floor(c / 3)
      local row_idx = r
      local idx = row_idx * cols + col_idx + 1
      if idx <= total_slots then
        local info = grid[idx].color.name .. ' ' .. utils.int_to_hex(grid[idx].color.color)
        vim.api.nvim_echo({{info}}, false, {})
      end
    end
  })

  -- Select on enter
  vim.api.nvim_buf_set_keymap(buf, 'n', '<CR>', '', {
    callback = function()
      local cursor = vim.api.nvim_win_get_cursor(win)
      local r, c = cursor[1] - 1, cursor[2]
      local col_idx = math.floor(c / 3)
      local row_idx = r
      local idx = row_idx * cols + col_idx + 1
      if idx <= total_slots then
        local hex = utils.int_to_hex(grid[idx].color.color)
        -- Insert at original position
        vim.api.nvim_set_current_win(orig_win)
        vim.api.nvim_set_current_buf(orig_buf)
        vim.api.nvim_win_set_cursor(orig_win, orig_cursor)
        vim.api.nvim_put({hex}, 'c', true, true)
        -- Close window
        vim.api.nvim_win_close(win, true)
      end
    end
  })

  -- Close on q or esc
  vim.api.nvim_buf_set_keymap(
    buf, 
    'n',
    'q',
    '',
    { callback = function() vim.api.nvim_win_close(win, true) end }
  )
  vim.api.nvim_buf_set_keymap(
    buf,
    'n',
    '<Esc>',
    '',
    { callback = function() vim.api.nvim_win_close(win, true) end }
  )
end

-- =============================================================================
-- PLUGIN INITIALIZATION
-- =============================================================================

-- Registers the :ColorPick2D command for user access.
vim.api.nvim_create_user_command('ColorPick2D', function()
  M.pick_color()
end, {})

return M
