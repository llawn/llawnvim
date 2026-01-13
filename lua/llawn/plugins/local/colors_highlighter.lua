--- Simple color highlighter for Neovim
--- Highlights hex colors with their own background color and inline hints

local colors_utils = require('llawn.plugins.local.colors_utils')
local colors = require('llawn.plugins.local.colors')

local ns_highlight = vim.api.nvim_create_namespace('color_highlights')
local ns_virtual = vim.api.nvim_create_namespace('color_virtual')
local enabled = true

local function highlight_and_hint(bufnr, ns_highlight_, ns_virtual_, line_idx, start_col, end_col, r, g, b)
  local hl_group = string.format("Color_%02x%02x%02x", r, g, b)
  local luminance = 0.299 * r + 0.587 * g + 0.114 * b
  local fg = luminance > 127 and "#000000" or "#ffffff"
  vim.cmd(string.format("highlight %s guibg=#%02x%02x%02x guifg=%s", hl_group, r, g, b, fg))
  vim.api.nvim_buf_set_extmark(bufnr, ns_highlight_, line_idx, start_col, {
    end_col = end_col,
    hl_group = hl_group,
  })

  -- Find best matching color
  local best_match = nil
  local min_dist = math.huge
  local max_dist = math.sqrt(3) * 255
  for _, c in ipairs(colors) do
    local cr, cg, cb = colors_utils.int_to_rgb(c.color)
    local dist = colors_utils.rgb_distance(r, g, b, cr, cg, cb)
    if dist < min_dist then
      min_dist = dist
      best_match = c
    end
  end

  if best_match then
    local match_hex = colors_utils.int_to_hex(best_match.color)
    local percent = math.max(0, 100 - ((min_dist / max_dist) * 100))
    local hint
    if percent >= 100 then
      hint = "[" .. best_match.name .. "] "
    else
      hint = string.format("[%s %s %.1f%%] ", best_match.name, match_hex, percent)
    end
    vim.api.nvim_buf_set_extmark(bufnr, ns_virtual_, line_idx, start_col, {
      virt_text = {{hint, "Comment"}},
      virt_text_pos = "inline"
    })
  end
end

local function highlight_colors(bufnr)
  if not enabled then return end
  bufnr = bufnr or 0
  vim.api.nvim_buf_clear_namespace(bufnr, ns_highlight, 0, -1)
  vim.api.nvim_buf_clear_namespace(bufnr, ns_virtual, 0, -1)

  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  for i, line in ipairs(lines) do
    -- Handle #hex codes
    for hex in line:gmatch("#[%x]+") do
      local start_col = line:find(hex, 1, true) - 1
      local end_col = start_col + #hex
      local r, g, b = colors_utils.hex_to_rgb(hex)
      if r then
        highlight_and_hint(bufnr, ns_highlight, ns_virtual, i-1, start_col, end_col, r, g, b)
      end
    end

    -- Handle 0xhex codes
    for hex_int in line:gmatch("0x[%x]+") do
      local start_col = line:find(hex_int, 1, true) - 1
      local end_col = start_col + #hex_int
      local hex = "#" .. string.sub(hex_int, 3)
      local r, g, b = colors_utils.hex_to_rgb(hex)
      if r then
        highlight_and_hint(bufnr, ns_highlight, ns_virtual, i-1, start_col, end_col, r, g, b)
      end
    end
  end
end

local M = {}

function M.toggle()
  if enabled then
    enabled = false
    vim.api.nvim_buf_clear_namespace(0, ns_highlight, 0, -1)
    vim.api.nvim_buf_clear_namespace(0, ns_virtual, 0, -1)
  else
    enabled = true
    highlight_colors(0)
  end
end

function M.setup()
  vim.keymap.set('n', '<leader>ct', M.toggle, { silent = true, desc = "Toggle color highlights" })

  vim.api.nvim_create_autocmd({'BufEnter', 'BufRead'}, {
    pattern = '*',
    callback = function(args)
      highlight_colors(args.buf)
    end
  })

  vim.api.nvim_create_autocmd({'TextChanged', 'TextChangedI'}, {
    pattern = '*',
    callback = function(args)
      highlight_colors(args.buf)
    end
  })

  -- Highlight current buffer
  if vim.fn.expand('%') ~= '' then
    highlight_colors()
  end
end

return M
