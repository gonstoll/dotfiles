return {
  'nvim-lualine/lualine.nvim',
  event = 'BufReadPre',
  init = function()
    vim.keymap.set('n', '<leader>l', ':lua require("lualine").refresh<CR>', {desc = 'Refresh status line'})
  end,
  opts = function()
    local rp_palette = require('rose-pine.palette')

    local customRosePineTheme = {
      normal = {
        a = {bg = rp_palette.love, fg = rp_palette.base, gui = 'bold'},
        b = {bg = rp_palette.base, fg = rp_palette.love},
        c = {bg = rp_palette.base, fg = rp_palette.text},
      },
      insert = {
        a = {bg = rp_palette.foam, fg = rp_palette.base, gui = 'bold'},
        b = {bg = rp_palette.base, fg = rp_palette.foam},
        c = {bg = rp_palette.base, fg = rp_palette.text},
      },
      visual = {
        a = {bg = rp_palette.iris, fg = rp_palette.base, gui = 'bold'},
        b = {bg = rp_palette.base, fg = rp_palette.iris},
        c = {bg = rp_palette.base, fg = rp_palette.text},
      },
      replace = {
        a = {bg = rp_palette.pine, fg = rp_palette.base, gui = 'bold'},
        b = {bg = rp_palette.base, fg = rp_palette.pine},
        c = {bg = rp_palette.base, fg = rp_palette.text},
      },
      command = {
        a = {bg = rp_palette.rose, fg = rp_palette.base, gui = 'bold'},
        b = {bg = rp_palette.base, fg = rp_palette.rose},
        c = {bg = rp_palette.base, fg = rp_palette.text},
      },
      inactive = {
        a = {bg = rp_palette.base, fg = rp_palette.muted, gui = 'bold'},
        b = {bg = rp_palette.base, fg = rp_palette.muted},
        c = {bg = rp_palette.base, fg = rp_palette.muted},
      },
    }

    local isRosePineTheme = vim.g.colors_name == 'rose-pine'

    return {
      options = {
        theme = isRosePineTheme and customRosePineTheme or 'gruvbox-material',
        component_separators = '│',
      },
      sections = {
        lualine_a = {'mode'},
        lualine_b = {
          {
            'filename',
            file_status = true,
            path = 1,
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
        lualine_z = {'location'},
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
