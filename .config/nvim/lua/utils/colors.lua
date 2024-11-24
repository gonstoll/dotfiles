-- Taken from https://github.com/rachartier/tiny-inline-diagnostic.nvim
---@param hex string
local function hex_to_rgb(hex)
  if hex == nil or hex == 'None' then
    return {0, 0, 0}
  end

  hex = hex:gsub('#', '')
  hex = string.lower(hex)

  return {
    tonumber(hex:sub(1, 2), 16),
    tonumber(hex:sub(3, 4), 16),
    tonumber(hex:sub(5, 6), 16),
  }
end

-- Taken from https://github.com/rachartier/tiny-inline-diagnostic.nvim
---@param foreground string foreground color
---@param background string background color
---@param alpha number|string number between 0 and 1. 0 results in bg, 1 results in fg
local function blend(foreground, background, alpha)
  alpha = type(alpha) == 'string' and (tonumber(alpha, 16) / 0xff) or alpha

  local fg = hex_to_rgb(foreground)
  local bg = hex_to_rgb(background)

  local blend_channel = function(i)
    local ret = (alpha * fg[i] + ((1 - alpha) * bg[i]))
    return math.floor(math.min(math.max(0, ret), 255) + 0.5)
  end

  return string.format('#%02x%02x%02x', blend_channel(1), blend_channel(2), blend_channel(3)):upper()
end

return {blend = blend}
