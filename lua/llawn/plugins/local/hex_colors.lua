--- A Neovim plugin that provides an interactive color picker using Telescope.
--- Features include fuzzy search and visual color comparison previews.

local colors = require('llawn.plugins.local.colors')
local colors_utils = require('llawn.plugins.local.colors_utils')

-- =============================================================================
-- TELESCOPE INTEGRATION
-- =============================================================================
-- Sets up Telescope components for color picker functionality including
-- pickers, finders, sorters, previewers, and actions.

local pickers = require('telescope.pickers')
local finders = require('telescope.finders')
local sorters = require('telescope.sorters')
local previewers = require('telescope.previewers')
local actions = require('telescope.actions')
local action_state = require('telescope.actions.state')

-- =============================================================================
-- HYBRID COLOR SORTER
-- =============================================================================
-- Custom sorter that combines fuzzy matching for color names with
-- color distance scoring when searching by hex values.

local function hybrid_color_sorter()
  local fuzzy_sorter = sorters.get_generic_fuzzy_sorter()
  return sorters.new({
      scoring_function = function(_, prompt, _, entry)
        if prompt:match("^#") then
          local target_hex = colors_utils.expand_input_hex(prompt)
          if not target_hex then return 1000 end
          local r, g, b = colors_utils.hex_to_rgb(target_hex)
          if r and g and b and entry.r then
            return colors_utils.rgb_distance(r, g, b, entry.r, entry.g, entry.b)
          else
            return 1000
          end
        end
        return fuzzy_sorter:scoring_function(prompt, _, entry)
      end,
    highlighter = fuzzy_sorter.highlighter,
  })
end

-- =============================================================================
-- DYNAMIC COLOR PREVIEWER
-- =============================================================================
-- Advanced previewer that shows visual color swatches, match accuracy,
-- and contrast checks on black/white backgrounds for selected and target colors.

local dynamic_previewer = previewers.new_buffer_previewer({
  title = "Color Comparison",
  define_preview = function(self, entry, _)
    local bufnr = self.state.bufnr
    local ns_id = vim.api.nvim_create_namespace('telescope_color_preview')
    vim.api.nvim_buf_clear_namespace(bufnr, ns_id, 0, -1)

    local prompt = action_state.get_current_line()
    local is_hex_mode = prompt:match("^#")
    local target_hex = colors_utils.expand_input_hex(prompt)

    local lines = {}
    local hl_ops = {}

    -- SECTION A: Visual Comparison (Swatches)
    if is_hex_mode and target_hex then
      -- Header side by side
      table.insert(lines, string.format("%-18s%-18s", "TARGET: " .. target_hex, "SELECTED: " .. entry.hex))

      -- Create side-by-side blocks (3 lines tall)
      for _ = 1, 3 do
        table.insert(lines, string.rep(" ", 36))

        -- Highlight Left Block (Target)
        local input_grp = "PreviewInput_" .. target_hex:gsub("#","")
        table.insert(
          hl_ops,
          {
            group = input_grp, fg = target_hex, bg = target_hex,
            line = #lines - 1, col_start = 0, col_end = 18
          }
        )

        -- Highlight Right Block (Selected)
        local select_grp = "PreviewSelect_" .. entry.hex:gsub("#","")
        table.insert(
          hl_ops,
          {
            group = select_grp, fg = entry.hex, bg = entry.hex,
            line = #lines - 1, col_start = 18, col_end = 36
          }
        )
      end

      -- Match Accuracy
      local r, g, b = colors_utils.hex_to_rgb(target_hex)
      if r and g and b then
        local dist = colors_utils.rgb_distance(r, g, b, entry.r, entry.g, entry.b)
        local max_dist = math.sqrt(3)*255
        local match_percent = math.max(0, 100 - ((dist / max_dist) * 100))
        table.insert(lines, "")
        table.insert(lines, string.format("Match Accuracy: %.1f%%", match_percent))
      end

    else
      -- Standard Name Mode (Just show the selected color)
      table.insert(lines, "SELECTED COLOR")
      table.insert(lines, string.format("  %s %s", entry.name, entry.hex))

      for _ = 1, 3 do
        table.insert(lines, "  " .. string.rep(" ", 26))
        local select_grp = "PreviewSelect_" .. entry.hex:gsub("#","")
        table.insert(
          hl_ops,
          {
            group = select_grp, fg = entry.hex, bg = entry.hex,
            line = #lines - 1, col_start = 2, col_end = 28
          }
        )
      end
      table.insert(lines, "")
    end

    -- Add a little extra space between sections
    table.insert(lines, "")
    table.insert(lines, string.rep("─", 40))

    -- SECTION B: Contrast Text Checks (For both selected and target color)
    local sample_text = " This is llawnvim. "
    local hl_fg_clean = entry.hex:gsub("#", "")

    -- Header for Contrast on Black/White
    table.insert(lines, "CONTRAST TEXT CHECKS")
    table.insert(lines, string.rep("─", 40))

    -- On Black (Selected Color)
    table.insert(lines, "  Fg on Black (#000000):")
    table.insert(lines, "  " .. sample_text)
    local group_on_black = "PreviewOnBlack_" .. hl_fg_clean
    table.insert(
      hl_ops,
      {
        group = group_on_black, fg = entry.hex, bg = "#000000",
        line = #lines - 1, col_start = 2, col_end = -1
      }
    )

    -- On White (Selected Color)
    table.insert(lines, "  Fg on White (#ffffff):")
    table.insert(lines, "  " .. sample_text)
    local group_on_white = "PreviewOnWhite_" .. hl_fg_clean
    table.insert(
      hl_ops,
      {
        group = group_on_white, fg = entry.hex, bg = "#ffffff",
        line = #lines - 1, col_start = 2, col_end = -1
      }
    )

    -- SECTION C: Contrast Checks for Target Color
    if is_hex_mode and target_hex then
      local target_clean = target_hex:gsub("#", "")

      -- Target Color Header
      table.insert(lines, "")
      table.insert(lines, "TARGET COLOR CONTRAST CHECKS")
      table.insert(lines, string.rep("─", 40))

      -- Target Color on Black
      table.insert(lines, "  Fg on Black (#000000):")
      table.insert(lines, "  " .. sample_text)
      local target_on_black = "PreviewTargetOnBlack_" .. target_clean
      table.insert(
        hl_ops,
        {
          group = target_on_black, fg = target_hex, bg = "#000000",
          line = #lines - 1, col_start = 2, col_end = -1
        }
      )

      -- Target Color on White
      table.insert(lines, "  Fg on White (#ffffff):")
      table.insert(lines, "  " .. sample_text)
      local target_on_white = "PreviewTargetOnWhite_" .. target_clean
      table.insert(
        hl_ops,
        {
          group = target_on_white, fg = target_hex, bg = "#ffffff",
          line = #lines - 1, col_start = 2, col_end = -1
        }
      )
    end

    -- Final line separator
    table.insert(lines, string.rep("─", 40))

    -- Render and Highlight
    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
    for _, op in ipairs(hl_ops) do
      vim.cmd(string.format("highlight %s guifg=%s guibg=%s", op.group, op.fg, op.bg))
      vim.hl.range(bufnr, ns_id, op.group, {op.line, op.col_start}, {op.line, op.col_end})
    end
  end
})

-- =============================================================================
-- MAIN COLOR PICKER FUNCTION
-- =============================================================================
-- Creates and launches the Telescope color picker with all configured components.
-- Handles user selection and inserts the chosen hex color into the current buffer.

local function pick_colors_dynamic()
  pickers.new({}, {
    prompt_title = "Color Picker",
     finder = finders.new_table({
       results = colors,
       entry_maker = function(entry)
         local hex = colors_utils.int_to_hex(entry.color)
         local r, g, b = colors_utils.int_to_rgb(entry.color)
         return {
           value = entry,
           display = entry.name .. " " .. hex,
           ordinal = entry.name,
           name = entry.name,
           hex = hex,
           r = r, g = g, b = b
         }
       end
     }),
    sorter = hybrid_color_sorter(),
    previewer = dynamic_previewer,
    attach_mappings = function(prompt_bufnr, _)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        if selection then
          -- Insert the selected hex at the current cursor position
          local hex_code = selection.hex
          vim.api.nvim_put({ hex_code }, 'c', true, true)

          -- Optionally, show a notification
          vim.notify("Inserted color " .. hex_code)
        end
      end)
      return true
    end,
  }):find()
end

-- =============================================================================
-- PLUGIN INITIALIZATION
-- =============================================================================
-- Registers the :HexColors command and exports the color palette as a lookup table.

vim.api.nvim_create_user_command('HexColors', pick_colors_dynamic, {})

-- Create a lookup table mapping color names to hex values
local hex_colors = {}
for _, color in ipairs(colors) do
  hex_colors[color.name] = colors_utils.int_to_hex(color.color)
end

return hex_colors
