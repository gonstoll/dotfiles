local colors = require('colors')

return {
  ['Gruvbox Material Dark'] = {
    background = '#1d2021',
    foreground = '#e2cca9',
    cursor_bg = '#e2cca9',
    cursor_fg = '#141617',
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
        fg_color = colors.dark_palette.fg0,
      },
      inactive_tab = {
        bg_color = colors.dark_palette.bg3,
        fg_color = colors.dark_palette.grey1,
      },
    },
  },

  ['Gruvbox Material Light'] = {
    background = '#f9f5d7',
    foreground = '#514036',
    cursor_bg = '#514036',
    cursor_fg = '#f3eac7',
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
        fg_color = colors.light_palette.fg0,
      },
      inactive_tab = {
        bg_color = colors.light_palette.bg3,
        fg_color = colors.light_palette.grey1,
      },
    },

  }
}
