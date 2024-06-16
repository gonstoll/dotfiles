local wezterm = require('wezterm')

local theme_names = {
  light = 'gruvbox_material_light',
  dark = 'gruvbox_material_dark',
}

local dark_palette = {
  bg_dim = '#141617',
  bg0 = '#1d2021',
  bg1 = '#282828',
  bg2 = '#282828',
  bg3 = '#3c3836',
  bg4 = '#3c3836',
  bg5 = '#504945',
  bg_statusline1 = '#282828',
  bg_statusline2 = '#32302f',
  bg_statusline3 = '#504945',
  bg_diff_green = '#32361a',
  bg_visual_green = '#333e34',
  bg_diff_red = '#3c1f1e',
  bg_visual_red = '#442e2d',
  bg_diff_blue = '#0d3138',
  bg_visual_blue = '#2e3b3b',
  bg_visual_yellow = '#473c29',
  bg_current_word = '#32302f',
  fg0 = '#e2cca9',
  fg1 = '#e2cca9',
  red = '#f2594b',
  orange = '#f28534',
  yellow = '#e9b143',
  green = '#b0b846',
  aqua = '#8bba7f',
  blue = '#80aa9e',
  purple = '#d3869b',
  bg_red = '#db4740',
  bg_green = '#b0b846',
  bg_yellow = '#e9b143',
  grey0 = '#7c6f64',
  grey1 = '#928374',
  grey2 = '#a89984',
}

local light_palette = {
  bg_dim = '#f3eac7',
  bg0 = '#f9f5d7',
  bg1 = '#f5edca',
  bg2 = '#f3eac7',
  bg3 = '#f2e5bc',
  bg4 = '#eee0b7',
  bg5 = '#ebdbb2',
  bg_statusline1 = '#f5edca',
  bg_statusline2 = '#f3eac7',
  bg_statusline3 = '#eee0b7',
  bg_diff_green = '#e4edc8',
  bg_visual_green = '#dde5c2',
  bg_diff_red = '#f8e4c9',
  bg_visual_red = '#f0ddc3',
  bg_diff_blue = '#e0e9d3',
  bg_visual_blue = '#d9e1cc',
  bg_visual_yellow = '#f9eabf',
  bg_current_word = '#f3eac7',
  fg0 = '#514036',
  fg1 = '#514036',
  red = '#af2528',
  orange = '#b94c07',
  yellow = '#b4730e',
  green = '#72761e',
  aqua = '#477a5b',
  blue = '#266b79',
  purple = '#924f79',
  bg_red = '#ae5858',
  bg_green = '#6f8352',
  bg_yellow = '#a96b2c',
  grey0 = '#a89984',
  grey1 = '#928374',
  grey2 = '#7c6f64',
}

return {
  dark = theme_names.dark,
  light = theme_names.light,

  colors = {
    light_palette = light_palette,
    dark_palette = dark_palette,
  },

  color_schemes = {
    [theme_names.dark] = {
      background = dark_palette.bg0,
      foreground = dark_palette.fg0,
      cursor_bg = dark_palette.fg0,
      cursor_fg = dark_palette.bg0,
      scrollbar_thumb = dark_palette.bg5,

      ansi = {
        dark_palette.bg0,    -- Black
        dark_palette.red,    -- Red
        dark_palette.green,  -- Green
        dark_palette.yellow, -- Yellow
        dark_palette.blue,   -- Blue
        dark_palette.purple, -- Magenta
        dark_palette.aqua,   -- Cyan
        dark_palette.fg0,    -- White
      },
      brights = {
        wezterm.color.parse(dark_palette.bg0):lighten(0.4), -- Black
        dark_palette.red,                                   -- Red
        dark_palette.green,                                 -- Green
        dark_palette.yellow,                                -- Yellow
        dark_palette.blue,                                  -- Blue
        dark_palette.purple,                                -- Magenta
        dark_palette.aqua,                                  -- Cyan
        dark_palette.fg0,                                   -- White
      },

      tab_bar = {
        background = dark_palette.bg3,
        active_tab = {
          bg_color = dark_palette.bg3,
          fg_color = dark_palette.purple,
        },
        inactive_tab = {
          bg_color = dark_palette.bg3,
          fg_color = dark_palette.fg0,
        },
      },
    },

    [theme_names.light] = {
      background = light_palette.bg0,
      foreground = light_palette.fg0,
      cursor_bg = light_palette.fg0,
      cursor_fg = light_palette.bg_dim,
      scrollbar_thumb = dark_palette.bg5,

      ansi = {
        light_palette.fg0,    -- Black
        light_palette.red,    -- Red
        light_palette.green,  -- Green
        light_palette.yellow, -- Yellow
        light_palette.blue,   -- Blue
        light_palette.purple, -- Magenta
        light_palette.aqua,   -- Cyan
        light_palette.bg0,    -- White
      },
      brights = {
        wezterm.color.parse(light_palette.fg0):lighten(0.4), -- Black
        light_palette.red,                                   -- Red
        light_palette.green,                                 -- Green
        light_palette.yellow,                                -- Yellow
        light_palette.blue,                                  -- Blue
        light_palette.purple,                                -- Magenta
        light_palette.aqua,                                  -- Cyan
        light_palette.bg0,                                   -- White
      },

      tab_bar = {
        background = light_palette.bg3,
        active_tab = {
          bg_color = light_palette.bg3,
          fg_color = light_palette.purple,
        },
        inactive_tab = {
          bg_color = light_palette.bg3,
          fg_color = light_palette.fg0,
        },
      },
    }
  },
}
