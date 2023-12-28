return {
  'nvim-lualine/lualine.nvim',
  event = 'BufReadPre',
  opts = function()
    local icons = require('utils.icons')
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

    local mode = {
      'mode',
      color = {gui = ''},
      padding = 0,
      fmt = function(str)
        local mode = str:sub(1, 1):upper() .. str:sub(2):lower()
        return '[' .. mode .. ']'
      end,
    }

    local diagnostics = {
      'diagnostics',
      sources = {'nvim_diagnostic'},
      sections = {'error', 'warn', 'info', 'hint'},
      colored = true,
      update_in_insert = false,
      always_visible = false,
      symbols = {
        error = icons.diagnostics.Error,
        hint = icons.diagnostics.Hint,
        info = icons.diagnostics.Info,
        warn = icons.diagnostics.Warn,
      },
    }

    local filename = {
      'filename',
      file_status = true,
      newfile_status = true,
      path = 4,
      shorting_target = 40,
      symbols = {
        modified = icons.git.changed,
        readonly = icons.git.deleted,
        newfile = icons.git.added,
      }
    }

    local diff = {
      'diff',
      colored = true,
      always_visible = false,
      symbols = {
        added = icons.git.added .. ' ',
        untracked = icons.git.added .. ' ',
        modified = icons.git.changed .. ' ',
        removed = icons.git.deleted .. ' ',
      },
      source = function()
        local gitsigns = vim.b.gitsigns_status_dict
        if gitsigns then
          return {
            added = gitsigns.added,
            modified = gitsigns.changed,
            removed = gitsigns.removed,
          }
        end
      end,
    }

    local filetype = {'filetype', colored = true}

    return {
      options = {
        theme = lualineTheme,
        component_separators = '',
        section_separators = '',
        globalstatus = true,
      },
      sections = {
        lualine_a = {mode},
        lualine_b = {filename, 'branch', diff},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {diagnostics, filetype, 'progress'},
      },
      inactive_sections = {
        lualine_a = {filename, diagnostics, diff},
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
      },
      tabline = {},
      extensions = {'trouble', 'fzf'},
    }
  end,
}
