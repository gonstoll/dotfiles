local wezterm = require('wezterm')
local colors = require('colors')

return {
  ['Gruvbox Material Dark'] = {
    background = colors.dark_palette.bg0,
    foreground = colors.dark_palette.fg0,
    cursor_bg = colors.dark_palette.fg0,
    cursor_fg = colors.dark_palette.bg0,
    scrollbar_thumb = colors.dark_palette.bg5,

    ansi = {
      colors.dark_palette.bg0,    -- Black
      colors.dark_palette.red,    -- Red
      colors.dark_palette.green,  -- Green
      colors.dark_palette.yellow, -- Yellow
      colors.dark_palette.blue,   -- Blue
      colors.dark_palette.purple, -- Magenta
      colors.dark_palette.aqua,   -- Cyan
      colors.dark_palette.fg0,    -- White
    },
    brights = {
      wezterm.color.parse(colors.dark_palette.bg0):lighten(0.4), -- Black
      colors.dark_palette.red,                                   -- Red
      colors.dark_palette.green,                                 -- Green
      colors.dark_palette.yellow,                                -- Yellow
      colors.dark_palette.blue,                                  -- Blue
      colors.dark_palette.purple,                                -- Magenta
      colors.dark_palette.aqua,                                  -- Cyan
      colors.dark_palette.fg0,                                   -- White
    },

    tab_bar = {
      background = colors.dark_palette.bg3,
      active_tab = {
        bg_color = colors.dark_palette.bg3,
        fg_color = colors.dark_palette.purple,
      },
      inactive_tab = {
        bg_color = colors.dark_palette.bg3,
        fg_color = colors.dark_palette.fg0,
      },
    },
  },

  ['Gruvbox Material Light'] = {
    background = colors.light_palette.bg0,
    foreground = colors.light_palette.fg0,
    cursor_bg = colors.light_palette.fg0,
    cursor_fg = colors.light_palette.bg_dim,
    scrollbar_thumb = colors.dark_palette.bg5,

    ansi = {
      colors.light_palette.fg0,    -- Black
      colors.light_palette.red,    -- Red
      colors.light_palette.green,  -- Green
      colors.light_palette.yellow, -- Yellow
      colors.light_palette.blue,   -- Blue
      colors.light_palette.purple, -- Magenta
      colors.light_palette.aqua,   -- Cyan
      colors.light_palette.bg0,    -- White
    },
    brights = {
      wezterm.color.parse(colors.light_palette.fg0):lighten(0.4), -- Black
      colors.light_palette.red,                                   -- Red
      colors.light_palette.green,                                 -- Green
      colors.light_palette.yellow,                                -- Yellow
      colors.light_palette.blue,                                  -- Blue
      colors.light_palette.purple,                                -- Magenta
      colors.light_palette.aqua,                                  -- Cyan
      colors.light_palette.bg0,                                   -- White
    },

    tab_bar = {
      background = colors.light_palette.bg3,
      active_tab = {
        bg_color = colors.light_palette.bg3,
        fg_color = colors.light_palette.purple,
      },
      inactive_tab = {
        bg_color = colors.light_palette.bg3,
        fg_color = colors.light_palette.fg0,
      },
    },

  }
}
