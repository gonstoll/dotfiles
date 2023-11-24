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
      colors.dark_palette.bg0,
      colors.dark_palette.red,
      colors.dark_palette.green,
      colors.dark_palette.yellow,
      colors.dark_palette.blue,
      colors.dark_palette.purple,
      colors.dark_palette.aqua,
      '#ffffff',
    },
    brights = {
      '#706f8c',
      colors.dark_palette.red,
      colors.dark_palette.green,
      colors.dark_palette.yellow,
      colors.dark_palette.blue,
      colors.dark_palette.purple,
      colors.dark_palette.aqua,
      '#ffffff',
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
      colors.light_palette.fg0,
      colors.light_palette.red,
      colors.light_palette.green,
      colors.light_palette.yellow,
      colors.light_palette.blue,
      colors.light_palette.purple,
      colors.light_palette.aqua,
      '#ffffff',
    },
    brights = {
      '#706f8c',
      colors.light_palette.red,
      colors.light_palette.green,
      colors.light_palette.yellow,
      colors.light_palette.blue,
      colors.light_palette.purple,
      colors.light_palette.aqua,
      '#ffffff',
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
