local wezterm = require('wezterm')
local act = wezterm.action
local keys = require('utils.keys')
local fonts = require('fonts')
local gruvbox = require('colors.gruvbox')
local kanagawa = require('colors.kanagawa')

local function merge_table(t1, t2)
  for k, v in pairs(t2) do
    t1[k] = v
  end
  return t1
end

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
      local slash = cwd_uri:find('/')

      if slash then
        hostname = cwd_uri:sub(1, slash - 1)
        cwd = cwd_uri
            :sub(slash)
            :gsub(wezterm.home_dir, '~')
            :gsub('%%(%x%x)', function(hex)
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

  local date = wezterm.strftime('%a %d %b - %H:%M:%S')
  table.insert(cells, date)

  for _, b in ipairs(wezterm.battery_info()) do
    table.insert(cells, string.format('%.0f%%', b.state_of_charge * 100))
  end

  local overrides = window:get_config_overrides() or {}
  local is_dark_theme = not overrides.color_scheme and true or overrides.color_scheme == gruvbox.dark
  local statusline_fg = is_dark_theme and gruvbox.colors.dark_palette.fg0 or gruvbox.colors.light_palette.fg0
  local statusline_bg = is_dark_theme and gruvbox.colors.dark_palette.bg3 or gruvbox.colors.light_palette.bg3

  local elements = {}
  local num_cells = 0

  local function push(text, is_last)
    table.insert(elements, {Foreground = {Color = statusline_fg}})
    table.insert(elements, {Background = {Color = statusline_bg}})
    table.insert(elements, {Text = ' ' .. text .. ' '})
    if not is_last then
      table.insert(elements, {Foreground = {Color = statusline_fg}})
      table.insert(elements, {Text = '|'})
    end
    num_cells = num_cells + 1
  end

  while #cells > 0 do
    local cell = table.remove(cells, 1)
    push(cell, #cells == 0)
  end

  window:set_right_status(wezterm.format(elements))
end)

wezterm.on('toggle-gruvbox-theme', function(window)
  local overrides = window:get_config_overrides() or {}

  if not overrides.color_scheme then
    overrides.color_scheme = gruvbox.dark
  end

  if string.find(overrides.color_scheme, 'Gruvbox') then
    overrides.color_scheme = overrides.color_scheme == gruvbox.dark and gruvbox.light or gruvbox.dark
  end

  window:set_config_overrides(overrides)
end)

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
  color_schemes = merge_table(gruvbox.color_schemes, kanagawa.color_schemes),
  color_scheme = kanagawa.dark,

  -- Window
  window_decorations = 'RESIZE',
  use_fancy_tab_bar = false,
  show_new_tab_button_in_tab_bar = false,
  hide_tab_bar_if_only_one_tab = true,
  tab_bar_at_bottom = true,
  tab_max_width = 26,
  window_frame = {
    font = wezterm.font({family = 'FiraCode Nerd Font'}),
    font_size = 14.0,
    active_titlebar_bg = gruvbox.colors.dark_palette.bg0,
    active_titlebar_fg = gruvbox.colors.dark_palette.fg0,
    inactive_titlebar_bg = gruvbox.colors.dark_palette.bg1,
    inactive_titlebar_fg = gruvbox.colors.dark_palette.fg1,
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

  -- Opacity and blur
  -- window_background_opacity = 0.9,
  -- macos_window_background_blur = 25,

  -- Cursor
  cursor_blink_rate = 500,
  default_cursor_style = 'BlinkingBlock',
  cursor_blink_ease_in = 'Constant',
  cursor_blink_ease_out = 'Constant',
  force_reverse_video_cursor = true,

  underline_thickness = 3.0,

  -- Keymaps
  keys = {
    {key = 'c', mods = 'CMD|SHIFT', action = wezterm.action.ActivateCopyMode},

    -- Pane navigation
    {key = 'd', mods = 'CMD', action = wezterm.action.SplitPane({direction = 'Right', size = {Percent = 50}})},
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
    keys.key_to_tmux({mods = 'CMD|SHIFT', key = 'b', tmux_key = 'B'}),                                                   -- Open dotfiles session
    keys.key_to_tmux({mods = 'CMD', key = 's', tmux_key = 'S'}),                                                         -- Open tmux-sessionizer
    keys.key_to_tmux({mods = 'CMD', key = 'j', tmux_key = 'T'}),                                                         -- Open t - tmux smart session manager
    keys.key_to_tmux({mods = 'CMD', key = '0', tmux_key = '0'}),
    keys.key_to_tmux({mods = 'CMD', key = '1', tmux_key = '1'}),
    keys.key_to_tmux({mods = 'CMD', key = '2', tmux_key = '2'}),
    keys.key_to_tmux({mods = 'CMD', key = '3', tmux_key = '3'}),
    keys.key_to_tmux({mods = 'CMD', key = '4', tmux_key = '4'}),
    keys.key_to_tmux({mods = 'CMD', key = '5', tmux_key = '5'}),
    keys.key_to_tmux({mods = 'CMD', key = '6', tmux_key = '6'}),
    keys.key_to_tmux({mods = 'CMD', key = '7', tmux_key = '7'}),
    keys.key_to_tmux({mods = 'CMD', key = '8', tmux_key = '8'}),
    keys.key_to_tmux({mods = 'CMD', key = '9', tmux_key = '9'}),
    keys.key_to_tmux({mods = 'CMD', key = 'c', tmux_key = 'c'}), -- Create new window
    keys.key_to_tmux({mods = 'CMD', key = ']', tmux_key = 'n'}), -- Next window
    keys.key_to_tmux({mods = 'CMD', key = '[', tmux_key = 'p'}), -- Previous window
    keys.key_to_tmux({mods = 'CMD', key = 'x', tmux_key = 'x'}), -- Kill pane
  },
}
