local theme_names = {
  light = 'kanagawa_light',
  dark = 'kanagawa_dark',
}

return {
  dark = theme_names.dark,
  light = theme_names.light,

  color_schemes = {
    [theme_names.dark] = {
      foreground = '#c5c9c5',
      background = '#181616',

      cursor_bg = '#c8c093',
      cursor_fg = '#c8c093',
      cursor_border = '#c8c093',

      selection_fg = '#c8c093',
      selection_bg = '#2d4f67',

      scrollbar_thumb = '#16161d',
      split = '#16161d',

      ansi = {
        '#0d0c0c', -- black
        '#c4746e', -- red
        '#8a9a7b', -- green
        '#c4b28a', -- yellow
        '#8ba4b0', -- blue
        '#a292a3', -- magenta
        '#8ea4a2', -- cyan
        '#c8c093', -- white
      },

      brights = {
        '#a6a69c', -- black
        '#E46876', -- red
        '#87a987', -- green
        '#E6C384', -- yellow
        '#7FB4CA', -- blue
        '#938AA9', -- magenta
        '#7AA89F', -- cyan
        '#c5c9c5', -- white
      },

      indexed = {[16] = '#b6927b', [17] = '#b98d7b'},
    },

    [theme_names.light] = {
      foreground = '#545464',
      background = '#f2ecbc',

      cursor_fg = '#181616',
      cursor_bg = '#c5c9c5',
      cursor_border = '#c8c093',

      selection_fg = '#f2ecbc',
      selection_bg = '#545464',

      scrollbar_thumb = '#16161d',
      split = '#16161d',

      ansi = {
        '#545464', -- black
        '#c84053', -- red
        '#6f894e', -- green
        '#77713f', -- yellow
        '#4d699b', -- blue
        '#624c83', -- magenta
        '#4e8ca2', -- cyan
        '#f2ecbc', -- white
      },

      brights = {
        '#727169', -- black
        '#e82424', -- red
        '#98bb6c', -- green
        '#e6c384', -- yellow
        '#7fb4ca', -- blue
        '#938aa9', -- magenta
        '#7aa89f', -- cyan
        '#dcd7ba', -- white
      },

      indexed = {[16] = '#ffa066', [17] = '#ff5d62'},
    },
  },
}
