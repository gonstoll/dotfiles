local M = {}

M.getTheme = function()
  local lualineTheme = {}
  local isRosePineTheme = vim.g.colors_name == 'rose-pine'

  if isRosePineTheme then
    local rosePinePalette = require('rose-pine.palette')

    lualineTheme = {
      normal = {
        a = {bg = rosePinePalette.love, fg = rosePinePalette.base},
        b = {bg = rosePinePalette.base, fg = rosePinePalette.love},
        c = {bg = rosePinePalette.base, fg = rosePinePalette.text},
      },
      insert = {
        a = {bg = rosePinePalette.foam, fg = rosePinePalette.base},
        b = {bg = rosePinePalette.base, fg = rosePinePalette.foam},
        c = {bg = rosePinePalette.base, fg = rosePinePalette.text},
      },
      visual = {
        a = {bg = rosePinePalette.iris, fg = rosePinePalette.base},
        b = {bg = rosePinePalette.base, fg = rosePinePalette.iris},
        c = {bg = rosePinePalette.base, fg = rosePinePalette.text},
      },
      replace = {
        a = {bg = rosePinePalette.pine, fg = rosePinePalette.base},
        b = {bg = rosePinePalette.base, fg = rosePinePalette.pine},
        c = {bg = rosePinePalette.base, fg = rosePinePalette.text},
      },
      command = {
        a = {bg = rosePinePalette.rose, fg = rosePinePalette.base},
        b = {bg = rosePinePalette.base, fg = rosePinePalette.rose},
        c = {bg = rosePinePalette.base, fg = rosePinePalette.text},
      },
      inactive = {
        a = {bg = rosePinePalette.base, fg = rosePinePalette.muted},
        b = {bg = rosePinePalette.base, fg = rosePinePalette.muted},
        c = {bg = rosePinePalette.base, fg = rosePinePalette.muted},
      },
    }
  else
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
  end

  return lualineTheme
end

return M
