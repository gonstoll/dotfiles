local colors = require('colors')

return {
  ['Gruvbox Material Dark'] = {
    background = '#1d2021',
    foreground = '#e2cca9',
    cursor_bg = '#e2cca9',
    cursor_fg = '#141617',
    -- ansi table with values from dark_colors.ansi properties
    ansi = {
      colors.dark_colors.ansi.dark,
      colors.dark_colors.ansi.red,
      colors.dark_colors.ansi.green,
      colors.dark_colors.ansi.yellow,
      colors.dark_colors.ansi.blue,
      colors.dark_colors.ansi.magenta,
      colors.dark_colors.ansi.cyan,
      colors.dark_colors.ansi.white,
    },
    brights = {
      colors.dark_colors.brights.dark,
      colors.dark_colors.brights.red,
      colors.dark_colors.brights.green,
      colors.dark_colors.brights.yellow,
      colors.dark_colors.brights.blue,
      colors.dark_colors.brights.magenta,
      colors.dark_colors.brights.cyan,
      colors.dark_colors.brights.white,
    },
  },
  ['Gruvbox Material Light'] = {
    background = '#f9f5d7',
    foreground = '#514036',
    cursor_bg = '#514036',
    cursor_fg = '#f3eac7',
    ansi = {
      colors.light_colors.ansi.dark,
      colors.light_colors.ansi.red,
      colors.light_colors.ansi.green,
      colors.light_colors.ansi.yellow,
      colors.light_colors.ansi.blue,
      colors.light_colors.ansi.magenta,
      colors.light_colors.ansi.cyan,
      colors.light_colors.ansi.white,
    },
    brights = {
      colors.light_colors.brights.dark,
      colors.light_colors.brights.red,
      colors.light_colors.brights.green,
      colors.light_colors.brights.yellow,
      colors.light_colors.brights.blue,
      colors.light_colors.brights.magenta,
      colors.light_colors.brights.cyan,
      colors.light_colors.brights.white,
    },
  }
}
