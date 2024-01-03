return {
  'nvim-lualine/lualine.nvim',
  -- event = 'BufReadPre',
  opts = function()
    local icons = require('utils.icons')
    local theme = require('utils.plugins.lualine').getTheme()

    local mode = {
      'mode',
      color = {gui = ''},
      padding = 0,
      fmt = function(str)
        local mode = str:sub(1, 1):upper() .. str:sub(2):lower()
        return '[' .. mode .. ']'
      end,
    }

    local filetype = {'filetype', colored = true}
    local branch = {'branch', icon = ''}

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
        modified = '●',
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

    return {
      options = {
        theme = theme or 'auto',
        component_separators = '',
        section_separators = '',
        globalstatus = true,
      },
      sections = {
        lualine_a = {mode},
        lualine_b = {filename, branch, diff},
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
