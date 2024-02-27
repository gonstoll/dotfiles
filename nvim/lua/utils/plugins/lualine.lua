local M = {}

M.get_theme = function()
  local lualineTheme = {}
  local is_kanagawa = vim.g.colors_name == 'kanagawa'

  if is_kanagawa then
    local colors = require('kanagawa.colors').setup()
    local palette_colors = colors.palette
    local theme_colors = colors.theme

    lualineTheme = {
      normal = {
        a = {bg = 'none', fg = palette_colors.sakuraPink},
        b = {bg = theme_colors.ui.bg_p2, fg = theme_colors.ui.fg},
        c = {bg = theme_colors.ui.bg_p2, fg = theme_colors.ui.fg},
        z = {bg = theme_colors.ui.bg_p2, fg = theme_colors.ui.fg},
      },
      insert = {
        a = {bg = 'none', fg = palette_colors.springGreen},
        b = {bg = theme_colors.ui.bg_p2, fg = theme_colors.ui.fg},
        c = {bg = theme_colors.ui.bg_p2, fg = theme_colors.ui.fg},
        z = {bg = theme_colors.ui.bg_p2, fg = theme_colors.ui.fg},
      },
      visual = {
        a = {bg = 'none', fg = palette_colors.peachRed},
        b = {bg = theme_colors.ui.bg_p2, fg = theme_colors.ui.fg},
        c = {bg = theme_colors.ui.bg_p2, fg = theme_colors.ui.fg},
        z = {bg = theme_colors.ui.bg_p2, fg = theme_colors.ui.fg},
      },
      replace = {
        a = {bg = 'none', fg = palette_colors.carpYellow},
        b = {bg = theme_colors.ui.bg_p2, fg = theme_colors.ui.fg},
        c = {bg = theme_colors.ui.bg_p2, fg = theme_colors.ui.fg},
        z = {bg = theme_colors.ui.bg_p2, fg = theme_colors.ui.fg},
      },
      command = {
        a = {bg = 'none', fg = palette_colors.crystalBlue},
        b = {bg = theme_colors.ui.bg_p2, fg = theme_colors.ui.fg},
        c = {bg = theme_colors.ui.bg_p2, fg = theme_colors.ui.fg},
        z = {bg = theme_colors.ui.bg_p2, fg = theme_colors.ui.fg},
      },
      terminal = {
        a = {bg = 'none', fg = palette_colors.fujiGray},
        b = {bg = theme_colors.ui.bg_p2, fg = theme_colors.ui.fg},
        c = {bg = theme_colors.ui.bg_p2, fg = theme_colors.ui.fg},
        z = {bg = theme_colors.ui.bg_p2, fg = theme_colors.ui.fg},
      },
      inactive = {
        a = {bg = 'none', fg = theme_colors.ui.fg_dim},
        b = {bg = theme_colors.ui.bg_p2, fg = theme_colors.ui.fg},
        c = {bg = theme_colors.ui.bg_p2, fg = theme_colors.ui.fg},
        z = {bg = theme_colors.ui.bg_p2, fg = theme_colors.ui.fg},
      },
    }
  elseif vim.g.colors_name == 'gruvbox-material' then
    local themeConfig = vim.fn['gruvbox_material#get_configuration']()

    local palette = vim.fn['gruvbox_material#get_palette'](
      themeConfig.background,
      themeConfig.foreground,
      themeConfig.colors_override
    )

    lualineTheme = {
      normal = {
        a = {bg = 'none', fg = palette.purple[1]},
        b = {bg = palette.bg_statusline3[1], fg = palette.fg0[1]},
        c = {bg = palette.bg_statusline3[1], fg = palette.fg0[1]},
        z = {bg = palette.bg_statusline3[1], fg = palette.fg0[1]},
      },
      insert = {
        a = {bg = 'none', fg = palette.green[1]},
        b = {bg = palette.bg_statusline3[1], fg = palette.fg0[1]},
        c = {bg = palette.bg_statusline3[1], fg = palette.fg0[1]},
        z = {bg = palette.bg_statusline3[1], fg = palette.fg0[1]},
      },
      visual = {
        a = {bg = 'none', fg = palette.red[1]},
        b = {bg = palette.bg_statusline3[1], fg = palette.fg0[1]},
        c = {bg = palette.bg_statusline3[1], fg = palette.fg0[1]},
        z = {bg = palette.bg_statusline3[1], fg = palette.fg0[1]},
      },
      replace = {
        a = {bg = 'none', fg = palette.yellow[1]},
        b = {bg = palette.bg_statusline3[1], fg = palette.fg0[1]},
        c = {bg = palette.bg_statusline3[1], fg = palette.fg0[1]},
        z = {bg = palette.bg_statusline3[1], fg = palette.fg0[1]},
      },
      command = {
        a = {bg = 'none', fg = palette.blue[1]},
        b = {bg = palette.bg_statusline3[1], fg = palette.fg0[1]},
        c = {bg = palette.bg_statusline3[1], fg = palette.fg0[1]},
        z = {bg = palette.bg_statusline3[1], fg = palette.fg0[1]},
      },
      terminal = {
        a = {bg = 'none', fg = palette.aqua[1]},
        b = {bg = palette.bg_statusline3[1], fg = palette.fg0[1]},
        c = {bg = palette.bg_statusline3[1], fg = palette.fg0[1]},
        z = {bg = palette.bg_statusline3[1], fg = palette.fg0[1]},
      },
      inactive = {
        a = {bg = 'none', fg = palette.grey2[1]},
        b = {bg = palette.bg_statusline3[1], fg = palette.grey2[1]},
        c = {bg = palette.bg_statusline3[1], fg = palette.grey2[1]},
        z = {bg = palette.bg_statusline3[1], fg = palette.grey2[1]},
      }
    }
  else
    lualineTheme = nil
  end

  return lualineTheme
end

return M
