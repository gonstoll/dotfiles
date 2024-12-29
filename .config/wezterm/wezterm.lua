local wezterm = require('wezterm') --[[@as Wezterm]]
local act = wezterm.action
local keys = require('utils.keys')
local fonts = require('fonts')
local kanagawa = require('colors.kanagawa')

wezterm.on('toggle-kanagawa-theme', function(window)
  local overrides = window:get_config_overrides() or {}

  if not overrides.color_scheme then
    overrides.color_scheme = kanagawa.dark
  end

  if string.find(overrides.color_scheme, 'kanagawa') then
    overrides.color_scheme = overrides.color_scheme == kanagawa.dark and kanagawa.light or kanagawa.dark
  end

  window:set_config_overrides(overrides)
end)

wezterm.on('format-tab-title', function(tab)
  local title = tab.tab_title
  if not title or #title == 0 then
    title = tab.active_pane.title
  end
  return {
    {Text = ' [' .. tab.tab_index + 1 .. ':' .. title .. ']'},
  }
end)

return {
  -- Font
  font = wezterm.font_with_fallback(fonts.getFonts('sf')),
  font_size = 18.0,
  harfbuzz_features = {'calt=0', 'clig=0', 'liga=0'},
  use_cap_height_to_scale_fallback_fonts = true,

  -- Colors
  color_schemes = kanagawa.color_schemes,
  color_scheme = kanagawa.dark,

  -- Window
  window_decorations = 'RESIZE',
  use_fancy_tab_bar = false,
  show_new_tab_button_in_tab_bar = false,
  hide_tab_bar_if_only_one_tab = true,
  tab_bar_at_bottom = true,
  tab_max_width = 26,
  window_frame = {
    font = wezterm.font_with_fallback(fonts.getFonts('sf')),
    font_size = 14.0,
  },
  window_padding = {
    left = '10px',
    right = '10px',
    top = '10px',
    bottom = 0,
  },
  initial_rows = 120,
  initial_cols = 350,
  enable_scroll_bar = false,

  -- Cursor
  cursor_blink_rate = 500,
  default_cursor_style = 'BlinkingBlock',
  cursor_blink_ease_in = 'Constant',
  cursor_blink_ease_out = 'Constant',
  force_reverse_video_cursor = true,

  -- Other
  underline_thickness = 3.0,
  max_fps = 240,
  term = 'wezterm',
  set_environment_variables = {
    TERMINFO_DIRS = '~/.terminfo/',
  },

  -- Keymaps
  keys = {
    {key = 'c', mods = 'CMD|SHIFT', action = wezterm.action.ActivateCopyMode},

    -- Pane navigation
    -- {key = 'd', mods = 'CMD', action = wezterm.action.SplitPane({direction = 'Right', size = {Percent = 50}})},
    {key = 'd', mods = 'CMD|SHIFT', action = wezterm.action.SplitPane({direction = 'Down', size = {Percent = 50}})},
    {key = 'w', mods = 'CMD', action = wezterm.action.CloseCurrentPane({confirm = true})},
    {key = 'h', mods = 'CTRL|CMD', action = act.ActivatePaneDirection('Left')},
    {key = 'l', mods = 'CTRL|CMD', action = act.ActivatePaneDirection('Right')},
    {key = 'k', mods = 'CTRL|CMD', action = act.ActivatePaneDirection('Up')},
    {key = 'j', mods = 'CTRL|CMD', action = act.ActivatePaneDirection('Down')},
    {key = 'LeftArrow', mods = 'CTRL|CMD', action = act.AdjustPaneSize({'Left', 1})},
    {key = 'RightArrow', mods = 'CTRL|CMD', action = act.AdjustPaneSize({'Right', 1})},
    {key = 'UpArrow', mods = 'CTRL|CMD', action = act.AdjustPaneSize({'Up', 1})},
    {key = 'DownArrow', mods = 'CTRL|CMD', action = act.AdjustPaneSize({'Down', 1})},

    -- tmux
    {key = 'e', mods = 'CMD', action = act.Multiple({act.EmitEvent('toggle-gruvbox-theme'), keys.send_tmux_key('e')})},  -- Toggle wezterm and tmux theme
    {key = 'k', mods = 'CMD', action = act.Multiple({act.EmitEvent('toggle-kanagawa-theme'), keys.send_tmux_key('e')})}, -- Toggle wezterm and tmux theme
    keys.key_to_tmux({mods = 'CMD', key = 's', tmux_key = 'S'}),                                                         -- Open tmux-sessionizer
    keys.key_to_tmux({mods = 'CMD', key = 'j', tmux_key = 'T'}),                                                         -- Open t - tmux smart session manager
    keys.key_to_tmux({mods = 'CMD', key = 'b', tmux_key = 'B'}),                                                         -- Open dotfiles session
  },
}
