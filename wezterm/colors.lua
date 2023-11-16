local dark_colors = {
  ansi = {
    dark = '#141617',
    red = '#f2594b',
    green = '#b0b846',
    yellow = '#e9b143',
    blue = '#80aa9e',
    magenta = '#d3869b',
    cyan = '#8bba7f',
    white = '#ffffff',
  },
  brights = {
    dark = '#706f8c',
    red = '#f2594b',
    green = '#b0b846',
    yellow = '#e9b143',
    blue = '#80aa9e',
    magenta = '#d3869b',
    cyan = '#8bba7f',
    white = '#ffffff',
  },
}

local light_colors = {
  ansi = {
    dark = '#141617',
    red = '#af2528',
    green = '#72761e',
    yellow = '#b4730e',
    blue = '#266b79',
    magenta = '#924f79',
    cyan = '#477a5b',
    white = '#ffffff',
  },
  brights = {
    dark = '#706f8c',
    red = '#af2528',
    green = '#72761e',
    yellow = '#b4730e',
    blue = '#266b79',
    magenta = '#924f79',
    cyan = '#477a5b',
    white = '#ffffff',
  },
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
}

local colors = {
  dark_colors = dark_colors,
  light_colors = light_colors,
  dark_palette = dark_palette,
  light_palette = light_palette,
}

return colors
