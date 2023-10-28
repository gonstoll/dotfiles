return {
  'nvim-lualine/lualine.nvim',
  event = 'BufReadPre',
  init = function()
    vim.keymap.set('n', '<leader>l', ':lua require("lualine").refresh<CR>', {desc = 'Refresh status line'})
  end,
  opts = function()
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
      local gruvboxConfiguration = vim.fn['gruvbox_material#get_configuration']()

      local gruvboxPalette = vim.fn['gruvbox_material#get_palette'](
        gruvboxConfiguration.background,
        gruvboxConfiguration.foreground,
        gruvboxConfiguration.colors_override
      )

      lualineTheme = {
        normal = {
          a = {bg = 'none', fg = gruvboxPalette.fg0[1]},
          b = {bg = gruvboxPalette.bg_statusline2[1], fg = gruvboxPalette.fg0[1]},
          c = {bg = gruvboxPalette.bg_statusline2[1], fg = gruvboxPalette.fg0[1]},
          z = {bg = gruvboxPalette.bg_statusline2[1], fg = gruvboxPalette.fg0[1]},
        },
        insert = {
          a = {bg = 'none', fg = gruvboxPalette.green[1]},
          b = {bg = gruvboxPalette.bg_statusline2[1], fg = gruvboxPalette.fg0[1]},
          c = {bg = gruvboxPalette.bg_statusline2[1], fg = gruvboxPalette.fg0[1]},
          z = {bg = gruvboxPalette.bg_statusline2[1], fg = gruvboxPalette.fg0[1]},
        },
        visual = {
          a = {bg = 'none', fg = gruvboxPalette.red[1]},
          b = {bg = gruvboxPalette.bg_statusline2[1], fg = gruvboxPalette.fg0[1]},
          c = {bg = gruvboxPalette.bg_statusline2[1], fg = gruvboxPalette.fg0[1]},
          z = {bg = gruvboxPalette.bg_statusline2[1], fg = gruvboxPalette.fg0[1]},
        },
        replace = {
          a = {bg = 'none', fg = gruvboxPalette.yellow[1]},
          b = {bg = gruvboxPalette.bg_statusline2[1], fg = gruvboxPalette.fg0[1]},
          c = {bg = gruvboxPalette.bg_statusline2[1], fg = gruvboxPalette.fg0[1]},
          z = {bg = gruvboxPalette.bg_statusline2[1], fg = gruvboxPalette.fg0[1]},
        },
        command = {
          a = {bg = 'none', fg = gruvboxPalette.blue[1]},
          b = {bg = gruvboxPalette.bg_statusline2[1], fg = gruvboxPalette.fg0[1]},
          c = {bg = gruvboxPalette.bg_statusline2[1], fg = gruvboxPalette.fg0[1]},
          z = {bg = gruvboxPalette.bg_statusline2[1], fg = gruvboxPalette.fg0[1]},
        },
        terminal = {
          a = {bg = 'none', fg = gruvboxPalette.purple[1]},
          b = {bg = gruvboxPalette.bg_statusline2[1], fg = gruvboxPalette.fg0[1]},
          c = {bg = gruvboxPalette.bg_statusline2[1], fg = gruvboxPalette.fg0[1]},
          z = {bg = gruvboxPalette.bg_statusline2[1], fg = gruvboxPalette.fg0[1]},
        },
        inactive = {
          a = {bg = 'none', fg = gruvboxPalette.grey2[1]},
          b = {bg = gruvboxPalette.bg_statusline2[1], fg = gruvboxPalette.grey2[1]},
          c = {bg = gruvboxPalette.bg_statusline2[1], fg = gruvboxPalette.grey2[1]},
          z = {bg = gruvboxPalette.bg_statusline2[1], fg = gruvboxPalette.grey2[1]},
        }
      }
    end

    return {
      options = {
        theme = lualineTheme,
        component_separators = '│',
        section_separators = '',
        globalstatus = true,
      },
      sections = {
        lualine_a = {
          {
            'mode',
            color = {gui = ''},
            padding = 0,
            fmt = function(str)
              local mode = str:sub(1, 1):upper() .. str:sub(2):lower()
              return '[' .. mode .. ']'
            end,
          }
        },
        lualine_b = {
          {
            'filename',
            file_status = true,
            path = 4,
            shorting_target = 40,
          },
          'branch',
          'diff',
        },
        lualine_c = {
          {'diagnostics'},
        },
        lualine_x = {
          {
            'datetime',
            style = '%H:%M:%S',
          },
          'encoding',
          {
            'filetype',
            colored = true,
          },
        },
        lualine_y = {'progress'},
        lualine_z = {
          {
            'location',
            color = {gui = ''},
          }
        },
      },
      inactive_sections = {
        lualine_a = {
          {
            'filename',
            file_status = true,
            path = 1,
          },
          'diagnostics',
          'diff',
        },
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {'location'},
      },
      tabline = {},
      extensions = {
        'trouble',
        'fzf',
        'nvim-dap-ui',
      },
    }
  end,
}
