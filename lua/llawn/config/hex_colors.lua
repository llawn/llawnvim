local colors = require('llawn.config.colors')

local telescope = require('telescope')
local pickers = require('telescope.pickers')
local finders = require('telescope.finders')
local sorters = require('telescope.sorters')
local previewers = require('telescope.previewers')
local actions = require('telescope.actions')
local action_state = require('telescope.actions.state')

-- 1. Color Utilities
local function hex_to_rgb(hex)
  if not hex then return nil end
  hex = hex:lower()
  if #hex == 4 and hex:match("^#%x%x%x$") then
    local r = tonumber(hex:sub(2,2), 16) * 17
    local g = tonumber(hex:sub(3,3), 16) * 17
    local b = tonumber(hex:sub(4,4), 16) * 17
    return r, g, b
  elseif #hex == 7 and hex:match("^#%x%x%x%x%x%x$") then
    local r = tonumber(hex:sub(2,3), 16)
    local g = tonumber(hex:sub(4,5), 16)
    local b = tonumber(hex:sub(6,7), 16)
    return r, g, b
  end
  return nil
end

local function rgb_distance(r1,g1,b1, r2,g2,b2)
  return math.sqrt((r1-r2)^2 + (g1-g2)^2 + (b1-b2)^2)
end

local function expand_input_hex(hex)
  if not hex or not hex:match("^#") then return nil end
  local h = hex:sub(2)
  if #h == 6 and h:match("^%x+$") then return hex end
  if #h == 3 and h:match("^%x+$") then 
    return '#' .. h:sub(1,1):rep(2) .. h:sub(2,2):rep(2) .. h:sub(3,3):rep(2)
  end
  if #h < 6 and h:match("^%x*$") then
    return '#' .. h .. string.rep('0', 6 - #h)
  end
  return hex
end

-- 2. Hybrid Sorter
local function hybrid_color_sorter()
  local fuzzy_sorter = sorters.get_generic_fuzzy_sorter()
  return sorters.new({
    scoring_function = function(self, prompt, _, entry)
      if prompt:match("^#") then
        local target_hex = expand_input_hex(prompt)
        local r, g, b = hex_to_rgb(target_hex)
        if r and entry.r then
          return rgb_distance(r, g, b, entry.r, entry.g, entry.b)
        else
          return 1000
        end
      end
      return fuzzy_sorter:scoring_function(prompt, _, entry)
    end,
    highlighter = fuzzy_sorter.highlighter,
  })
end

-- 3. Side-by-Side Swatch Previewer
local dynamic_previewer = previewers.new_buffer_previewer({
  title = "Color Comparison",
  define_preview = function(self, entry, status)
    local bufnr = self.state.bufnr
    local ns_id = vim.api.nvim_create_namespace('telescope_color_preview')
    vim.api.nvim_buf_clear_namespace(bufnr, ns_id, 0, -1)

    local prompt = action_state.get_current_line()
    local is_hex_mode = prompt:match("^#")
    local target_hex = expand_input_hex(prompt)

    local lines = {}
    local hl_ops = {} 

    -- SECTION A: Visual Comparison (Swatches)
    if is_hex_mode and target_hex then
      -- Header
      local target_color_name = "Unknown"  -- Default name if not found
      for _, color in ipairs(colors) do
        if color.hex == target_hex then
          target_color_name = color.name
          break
        end
      end
      table.insert(lines, string.format("TARGET COLOR: %s (%s)", target_color_name, target_hex))
      table.insert(lines, string.format("SELECTED COLOR: %s (%s)", entry.name, entry.hex))

      -- Create side-by-side blocks (3 lines tall)
      for i = 1, 3 do
        table.insert(lines, "  " .. string.rep(" ", 14) .. "  " .. string.rep(" ", 14))

        -- Highlight Left Block (Target)
        local input_grp = "PreviewInput_" .. target_hex:gsub("#","")
        table.insert(hl_ops, {
          group = input_grp, fg = target_hex, bg = target_hex,
          line = #lines - 1, col_start = 2, col_end = 16
        })

        -- Highlight Right Block (Selected)
        local select_grp = "PreviewSelect_" .. entry.hex:gsub("#","")
        table.insert(hl_ops, {
          group = select_grp, fg = entry.hex, bg = entry.hex,
          line = #lines - 1, col_start = 18, col_end = 32
        })
      end

      -- Match Accuracy
      local r, g, b = hex_to_rgb(target_hex)
      if r then
        local dist = rgb_distance(r, g, b, entry.r, entry.g, entry.b)
        local max_dist = 441.67
        local match_percent = math.max(0, 100 - ((dist / max_dist) * 100))
        table.insert(lines, "")
        table.insert(lines, string.format("Match Accuracy: %.1f%%", match_percent))
      end

    else
      -- Standard Name Mode (Just show the selected color)
      table.insert(lines, "SELECTED COLOR")
      table.insert(lines, string.format("  %s %s", entry.name, entry.hex))

      for i = 1, 3 do
        table.insert(lines, "  " .. string.rep(" ", 26))
        local select_grp = "PreviewSelect_" .. entry.hex:gsub("#","")
        table.insert(hl_ops, {
          group = select_grp, fg = entry.hex, bg = entry.hex,
          line = #lines - 1, col_start = 2, col_end = 28
        })
      end
      table.insert(lines, "")
    end

    -- Add a little extra space between sections
    table.insert(lines, "")
    table.insert(lines, string.rep("─", 40))

    -- SECTION B: Contrast Text Checks (For both selected and target color)
    local sample_text = " The quick brown fox jumps over the lazy dog. "
    local hl_fg_clean = entry.hex:gsub("#", "")

    -- Header for Contrast on Black/White
    table.insert(lines, "CONTRAST TEXT CHECKS")
    table.insert(lines, string.rep("─", 40))

    -- On Black (Selected Color)
    table.insert(lines, "  Fg on Black (#000000):")
    table.insert(lines, "  " .. sample_text)
    local group_on_black = "PreviewOnBlack_" .. hl_fg_clean
    table.insert(hl_ops, {
      group = group_on_black, fg = entry.hex, bg = "#000000",
      line = #lines - 1, col_start = 2, col_end = -1
    })

    -- On White (Selected Color)
    table.insert(lines, "  Fg on White (#ffffff):")
    table.insert(lines, "  " .. sample_text)
    local group_on_white = "PreviewOnWhite_" .. hl_fg_clean
    table.insert(hl_ops, {
      group = group_on_white, fg = entry.hex, bg = "#ffffff",
      line = #lines - 1, col_start = 2, col_end = -1
    })

    -- SECTION C: Contrast Checks for Target Color
    if is_hex_mode and target_hex then
      local target_r, target_g, target_b = hex_to_rgb(target_hex)
      local target_clean = target_hex:gsub("#", "")

      -- Target Color Header
      table.insert(lines, "")
      table.insert(lines, "TARGET COLOR CONTRAST CHECKS")
      table.insert(lines, string.rep("─", 40))

      -- Target Color on Black
      table.insert(lines, "  Fg on Black (#000000):")
      table.insert(lines, "  " .. sample_text)
      local target_on_black = "PreviewTargetOnBlack_" .. target_clean
      table.insert(hl_ops, {
        group = target_on_black, fg = target_hex, bg = "#000000",
        line = #lines - 1, col_start = 2, col_end = -1
      })

      -- Target Color on White
      table.insert(lines, "  Fg on White (#ffffff):")
      table.insert(lines, "  " .. sample_text)
      local target_on_white = "PreviewTargetOnWhite_" .. target_clean
      table.insert(hl_ops, {
        group = target_on_white, fg = target_hex, bg = "#ffffff",
        line = #lines - 1, col_start = 2, col_end = -1
      })
    end

    -- Final line separator
    table.insert(lines, string.rep("─", 40))

    -- Render and Highlight
    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
    for _, op in ipairs(hl_ops) do
      vim.cmd(string.format("highlight %s guifg=%s guibg=%s", op.group, op.fg, op.bg))
      vim.api.nvim_buf_add_highlight(bufnr, ns_id, op.group, op.line, op.col_start, op.col_end)
    end
  end
})

-- 4. Main Command
local function pick_colors_dynamic()
  pickers.new({}, {
    prompt_title = "Color Picker",
    finder = finders.new_table({
      results = colors,
       entry_maker = function(entry)
         local r, g, b = hex_to_rgb(entry.hex)
         return {
           value = entry,
           display = entry.name .. " " .. entry.hex,
           ordinal = entry.name,
           name = entry.name,
           hex = entry.hex,
           r = r, g = g, b = b
         }
       end
    }),
    sorter = hybrid_color_sorter(),
    previewer = dynamic_previewer,
    attach_mappings = function(prompt_bufnr, map)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        if selection then
          -- Insert the selected hex at the current cursor position
          local hex_code = selection.hex
          vim.api.nvim_put({ hex_code }, 'c', true, true)  -- 'c' for character-wise, insert at cursor

          -- Optionally, show a notification
          vim.notify("Inserted color " .. hex_code)
        end
      end)
      return true
    end,
  }):find()
end

vim.api.nvim_create_user_command('HexColors', pick_colors_dynamic, {})

local hex_colors = {}
for _, color in ipairs(colors) do
  hex_colors[color.name] = color.hex
end
return hex_colors
