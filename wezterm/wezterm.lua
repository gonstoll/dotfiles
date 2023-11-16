local wezterm = require('wezterm')
local colors = require('colors')
local color_schemes = require('color_schemes')

-- local function scheme_for_appearance(appearance)
--   if appearance:find 'Dark' then
--     return 'Gruvbox Material Dark'
--   else
--     return 'Gruvbox Material Light'
--   end
-- end
--
-- wezterm.on('window-config-reloaded', function(window, pane)
--   local overrides = window:get_config_overrides() or {}
--   local appearance = window:get_appearance()
--   local scheme = scheme_for_appearance(appearance)
--   if overrides.color_scheme ~= scheme then
--     overrides.color_scheme = scheme
--     window:set_config_overrides(overrides)
--   end
-- end)

-- wezterm.on('update-right-status', function(window, pane)
--   -- "Wed Mar 3 08:14"
--   local date = wezterm.strftime('%a %b %-d %H:%M ')
--
--   local bat = ''
--   for _, b in ipairs(wezterm.battery_info()) do
--     bat = '🔋 ' .. string.format('%.0f%%', b.state_of_charge * 100)
--   end
--
--   window:set_right_status(wezterm.format {
--     {Text = bat .. ' - ' .. date},
--   })
-- end)

wezterm.on('update-right-status', function(window, pane)
  -- Each element holds the text for a cell in a "powerline" style << fade
  local cells = {}

  -- Figure out the cwd and host of the current pane.
  -- This will pick up the hostname for the remote host if your
  -- shell is using OSC 7 on the remote host.
  local cwd_uri = pane:get_current_working_dir()
  if cwd_uri then
    local cwd = ''
    local hostname = ''

    if type(cwd_uri) == 'userdata' then
      -- Running on a newer version of wezterm and we have
      -- a URL object here, making this simple!

      cwd = cwd_uri.file_path
      hostname = cwd_uri.host or wezterm.hostname()
    else
      -- an older version of wezterm, 20230712-072601-f4abf8fd or earlier,
      -- which doesn't have the Url object
      cwd_uri = cwd_uri:sub(8)
      local slash = cwd_uri:find '/'
      if slash then
        hostname = cwd_uri:sub(1, slash - 1)
        -- and extract the cwd from the uri, decoding %-encoding
        cwd = cwd_uri:sub(slash):gsub('%%(%x%x)', function(hex)
          return string.char(tonumber(hex, 16))
        end)
      end
    end

    -- Remove the domain name portion of the hostname
    local dot = hostname:find '[.]'
    if dot then
      hostname = hostname:sub(1, dot - 1)
    end
    if hostname == '' then
      hostname = wezterm.hostname()
    end

    table.insert(cells, cwd)
    table.insert(cells, hostname)
  end

  -- I like my date/time in this style: "Wed Mar 3 08:14"
  local date = wezterm.strftime '%a %b %-d %H:%M'
  table.insert(cells, date)

  -- An entry for each battery (typically 0 or 1 battery)
  for _, b in ipairs(wezterm.battery_info()) do
    table.insert(cells, string.format('%.0f%%', b.state_of_charge * 100))
  end

  -- The powerline < symbol
  local LEFT_ARROW = utf8.char(0xe0b3)
  -- The filled in variant of the < symbol
  local SOLID_LEFT_ARROW = utf8.char(0xe0b2)

  -- Color palette for the backgrounds of each cell
  local statusline_colors = {
    '#3c1361',
    '#52307c',
    '#663a82',
    '#7c5295',
    '#b491c8',
  }

  -- Foreground color for the text across the fade
  local text_fg = '#c0c0c0'

  -- The elements to be formatted
  local elements = {}
  -- How many cells have been formatted
  local num_cells = 0

  -- Translate a cell into elements
  local function push(text, is_last)
    local cell_no = num_cells + 1
    table.insert(elements, {Foreground = {Color = text_fg}})
    table.insert(elements, {Background = {Color = statusline_colors[cell_no]}})
    table.insert(elements, {Text = ' ' .. text .. ' '})
    if not is_last then
      table.insert(elements, {Foreground = {Color = statusline_colors[cell_no + 1]}})
      table.insert(elements, {Text = SOLID_LEFT_ARROW})
    end
    num_cells = num_cells + 1
  end

  while #cells > 0 do
    local cell = table.remove(cells, 1)
    push(cell, #cells == 0)
  end

  window:set_right_status(wezterm.format(elements))
end)

wezterm.on('toggle-colorscheme', function(window, pane)
  local overrides = window:get_config_overrides() or {}

  if not overrides.color_scheme then
    overrides.color_scheme = 'Gruvbox Material Dark'
  else
    if overrides.color_scheme == 'Gruvbox Material Light' then
      overrides.color_scheme = 'Gruvbox Material Dark'
    else
      overrides.color_scheme = 'Gruvbox Material Light'
    end
  end

  window:set_config_overrides(overrides)
end)

local appearance = wezterm.gui.get_appearance()
local scheme = 'light'
if appearance:find('Dark') then
  scheme = 'dark'
end

return {
  font = wezterm.font('FiraCode Nerd Font', {weight = 'Regular', italic = false}),
  font_size = 16.0,
  color_schemes = color_schemes,
  color_scheme = 'Gruvbox Material Dark',

  -- Window
  use_fancy_tab_bar = false,
  window_decorations = 'RESIZE',
  window_frame = {
    font = wezterm.font({family = 'FiraCode Nerd Font'}),
    font_size = 14.0,
    active_titlebar_bg = scheme == 'dark' and colors.dark_colors.ansi.dark or colors.light_colors.ansi.red,
    inactive_titlebar_bg = '#000000',
  },

  -- Opacity and blur
  window_background_opacity = 0.86,
  macos_window_background_blur = 20,

  -- Cursor
  cursor_blink_rate = 500,
  default_cursor_style = 'BlinkingBlock',
  cursor_blink_ease_in = 'Constant',
  cursor_blink_ease_out = 'Constant',

  -- Keymaps
  keys = {
    {
      key = 'e',
      mods = 'CTRL',
      action = wezterm.action.EmitEvent 'toggle-colorscheme',
    },
  },
}
