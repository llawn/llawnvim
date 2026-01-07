--- Color utility functions shared across plugins.
--- Provides common color conversion and manipulation utilities.

local M = {}

--- Converts an integer color value to RGB components.
--- @param int integer: The color as an integer (e.g., 0xRRGGBB)
--- @return number r, number g, number b: The red, green, and blue components (0-255)
function M.int_to_rgb(int)
  local r = bit.band(bit.rshift(int, 16), 255)
  local g = bit.band(bit.rshift(int, 8), 255)
  local b = bit.band(int, 255)
  return r, g, b
end

--- Converts a hex color string to RGB components.
--- @param hex string: The hex color (e.g., "#FF0000" or "#F00")
--- @return number|nil r, number|nil g, number|nil b: The red, green, and blue components (0-255), or nil if invalid
function M.hex_to_rgb(hex)
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

--- Converts an integer color value to a hex string.
--- @param int integer: The color as an integer (e.g., 0xRRGGBB)
--- @return string: The hex color string (e.g., "#ff0000")
function M.int_to_hex(int)
  return string.format("#%06x", int)
end

--- Calculates the Euclidean distance between two RGB colors.
--- @param r1 number: Red component of first color (0-255)
--- @param g1 number: Green component of first color (0-255)
--- @param b1 number: Blue component of first color (0-255)
--- @param r2 number: Red component of second color (0-255)
--- @param g2 number: Green component of second color (0-255)
--- @param b2 number: Blue component of second color (0-255)
--- @return number: The distance between the two colors
function M.rgb_distance(r1,g1,b1, r2,g2,b2)
  return math.sqrt((r1-r2)^2 + (g1-g2)^2 + (b1-b2)^2)
end

--- Expands a short hex color to full 6-digit format, or pads with zeros if needed.
--- @param hex string: The hex color string (e.g., "#F00", "#FF0000")
--- @return string|nil: The expanded hex string, or nil if invalid
function M.expand_input_hex(hex)
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

--- Converts RGB values to HSL.
--- @param r number: Red component (0-255)
--- @param g number: Green component (0-255)
--- @param b number: Blue component (0-255)
--- @return number h, number s, number l: Hue (0-1), Saturation (0-1), Lightness (0-1)
function M.rgb_to_hsl(r, g, b)
  r, g, b = r / 255, g / 255, b / 255
  local max = math.max(r, g, b)
  local min = math.min(r, g, b)
  local h, s, l = 0, 0, (max + min) / 2

  if max ~= min then
    local d = max - min
    s = l > 0.5 and d / (2 - max - min) or d / (max + min)
    if max == r then
      h = (g - b) / d + (g < b and 6 or 0)
    elseif max == g then
      h = (b - r) / d + 2
    else
      h = (r - g) / d + 4
    end
    h = h / 6
  end

  return h, s, l
end

--- Converts HSL values to RGB.
--- @param h number: Hue (0-1)
--- @param s number: Saturation (0-1)
--- @param l number: Lightness (0-1)
--- @return number r, number g, number b: Red, Green, Blue components (0-255)
function M.hsl_to_rgb(h, s, l)
  local r, g, b
  if s == 0 then
    r, g, b = l, l, l
  else
    local function hue2rgb(p, q, t)
      if t < 0 then t = t + 1 end
      if t > 1 then t = t - 1 end
      if t < 1/6 then return p + (q - p) * 6 * t end
      if t < 1/2 then return q end
      if t < 2/3 then return p + (q - p) * (2/3 - t) * 6 end
      return p
    end
    local q = l < 0.5 and l * (1 + s) or l + s - l * s
    local p = 2 * l - q
    r = hue2rgb(p, q, h + 1/3)
    g = hue2rgb(p, q, h)
    b = hue2rgb(p, q, h - 1/3)
  end
  return math.floor(r * 255 + 0.5), math.floor(g * 255 + 0.5), math.floor(b * 255 + 0.5)
end

return M
