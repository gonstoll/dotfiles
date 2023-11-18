local wezterm = require('wezterm')
local act = wezterm.action
local colors = require('colors')
local color_schemes = require('color_schemes')

wezterm.on('update-right-status', function(window, pane)
  local cells = {}

  local cwd_uri = pane:get_current_working_dir()
  if cwd_uri then
    local cwd = ''
    local hostname = ''

    if type(cwd_uri) == 'userdata' then
      cwd = cwd_uri.file_path
      hostname = cwd_uri.host or wezterm.hostname()
    else
      cwd_uri = cwd_uri:sub(8)
      local slash = cwd_uri:find '/'
      if slash then
        hostname = cwd_uri:sub(1, slash - 1)
        cwd = cwd_uri:sub(slash):gsub('%%(%x%x)', function(hex)
          return string.char(tonumber(hex, 16))
        end)
      end
    end

    local dot = hostname:find('[.]')
    if dot then
      hostname = hostname:sub(1, dot - 1)
    end
    if hostname == '' then
      hostname = wezterm.hostname()
    end

    table.insert(cells, cwd)
    table.insert(cells, hostname)
  end

  local date = wezterm.strftime('%a %-d %b - %H:%M:%S')
  table.insert(cells, date)

  for _, b in ipairs(wezterm.battery_info()) do
    table.insert(cells, string.format('%.0f%%', b.state_of_charge * 100))
  end

  local overrides = window:get_config_overrides() or nil
  local is_dark_theme = true

  if overrides then
    is_dark_theme = overrides.color_scheme == 'Gruvbox Material Dark'
  end

  local statusline_colors = {
    colors.dark_palette.bg0,
    colors.dark_palette.bg1,
    colors.dark_palette.bg4,
    colors.dark_palette.bg5,
  }

  if not is_dark_theme then
    statusline_colors = {
      colors.light_palette.bg0,
      colors.light_palette.bg1,
      colors.light_palette.bg3,
      colors.light_palette.bg5,
    }
  end

  local text_fg = is_dark_theme and colors.dark_palette.fg0 or colors.light_palette.fg0

  local elements = {}
  local num_cells = 0

  local function push(text, is_last)
    local cell_no = num_cells + 1
    table.insert(elements, {Foreground = {Color = text_fg}})
    table.insert(elements, {Background = {Color = statusline_colors[cell_no]}})
    table.insert(elements, {Text = ' ' .. text .. ' '})
    if not is_last then
      table.insert(elements, {Foreground = {Color = statusline_colors[cell_no + 1]}})
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

return {
  -- Font
  font = wezterm.font_with_fallback({
    {
      family = 'FiraCode Nerd Font',
      weight = 450,
      italic = false,
      stretch = 'Normal',
    },
  }),
  font_size = 16.0,
  harfbuzz_features = {'calt=0', 'clig=0', 'liga=0'},

  -- Colors
  color_schemes = color_schemes,
  color_scheme = 'Gruvbox Material Dark',

  -- Window
  window_decorations = 'RESIZE',
  use_fancy_tab_bar = false,
  tab_bar_at_bottom = true,
  tab_max_width = 26,
  window_frame = {
    font = wezterm.font({family = 'FiraCode Nerd Font'}),
    font_size = 14.0,
    active_titlebar_bg = colors.dark_palette.bg0,
    active_titlebar_fg = colors.dark_palette.fg0,
    inactive_titlebar_bg = colors.dark_palette.bg1,
    inactive_titlebar_fg = colors.dark_palette.fg1,
  },
  window_padding = {
    top = '15px',
    bottom = '15px',
  },
  initial_rows = 120,
  initial_cols = 350,
  enable_scroll_bar = false,

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
      mods = 'CMD',
      action = act.EmitEvent('toggle-colorscheme'),
    },
    {
      key = 'k',
      mods = 'CMD',
      action = act.ClearScrollback('ScrollbackAndViewport'),
    },
  },
}
