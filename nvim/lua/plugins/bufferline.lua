return {
  {'famiu/bufdelete.nvim', event = 'BufReadPre'},

  {
    'akinsho/bufferline.nvim',
    event = 'BufReadPre',
    opts = function()
      local bufferline = require('bufferline')
      local groups = require('bufferline.groups')

      function GoToBuffer(bufnr)
        bufferline.go_to(bufnr)
      end

      vim.cmd('command! -nargs=1 GoToBuffer lua GoToBuffer(<f-args>)')

      vim.keymap.set('n', '<leader>x', ':Bdelete!<CR>', {desc = 'Close buffer'})
      vim.keymap.set('n', '<S-l>', function() bufferline.cycle(1) end, {desc = 'Next buffer'})
      vim.keymap.set('n', '<S-h>', function() bufferline.cycle(-1) end, {desc = 'Previous buffer'})
      vim.keymap.set('n', '<leader>P', function() groups.toggle_pin() end, {desc = 'Toggle pin buffer'})
      vim.keymap.set('n', '<leader>XA', function() bufferline.close_others() end,
        {desc = 'Close all other visible buffers'})

      local is_dark_theme = vim.o.background == 'dark'
      local white_color = '#ffffff'
      local black_color = '#1c1c27'

      local colorscheme = vim.g.colors_name
      local palette = {}

      if colorscheme == 'rose-pine' then
        local rp_palette = require('rose-pine.palette')

        palette = {
          text = rp_palette.text,
          dim = rp_palette.subtle,
          red = rp_palette.rose,
          yellow = rp_palette.gold,
          green = rp_palette.foam,
          purple = rp_palette.iris,
          blue = rp_palette.foam,
        }
      end

      if colorscheme == 'gruvbox-material' then
        local configuration = vim.fn['gruvbox_material#get_configuration']()
        local gv_palette = vim.fn['gruvbox_material#get_palette'](
          configuration.background,
          configuration.foreground,
          configuration.colors_override
        )

        palette = {
          text = gv_palette.fg1[1],
          dim = gv_palette.grey1[1],
          red = gv_palette.red[1],
          yellow = gv_palette.yellow[1],
          green = gv_palette.green[1],
          purple = gv_palette.purple[1],
          blue = gv_palette.blue[1],
        }
      end

      return {
        options = {
          numbers = function(opts)
            return string.format('%s:', opts.ordinal)
          end,
          style_preset = {
            bufferline.style_preset.no_italic,
            bufferline.style_preset.no_bold,
          },
          close_command = 'Bdelete! %d',
          right_mouse_command = 'Bdelete! %d',
          left_mouse_command = 'buffer %d',
          -- buffer_close_icon = "[x]",
          buffer_close_icon = '',
          modified_icon = '●',
          left_trunc_marker = '',
          right_trunc_marker = '',
          tab_size = 18,
          diagnostics = 'nvim_lsp',
          diagnostics_update_in_insert = false,
          diagnostics_indicator = function(_, _, diag)
            local icons = {
              Error = ' ',
              Warn = ' ',
              Info = ' ',
            }

            local ret = (diag.error and icons.Error .. diag.error .. ' ' or '') ..
                (diag.warning and icons.Warn .. diag.warning .. ' ' or '') ..
                (diag.info and icons.Info .. diag.info .. ' ' or '')

            return vim.trim(ret)
          end,
          show_buffer_close_icons = false,
          show_close_icon = false,
          show_tab_indicators = true,
          indicator = {
            style = 'none'
          },
          separator_style = {
            '|', -- left
            '|', -- right
          },
          custom_filter = function(bufnr, bufnrs)
            -- Don't show buffers created by oil.nvim
            if vim.bo[bufnr].filetype ~= 'oil' then
              return true
            end
          end
        },
        highlights = {
          tab = {
            bg = 'none',
            fg = palette.text,
          },
          tab_selected = {
            bg = 'none',
            fg = is_dark_theme and white_color or black_color,
          },
          buffer_visible = {
            bg = 'none',
            fg = palette.dim,
          },
          buffer_selected = {
            bg = 'none',
            fg = is_dark_theme and white_color or black_color,
            bold = false,
          },
          separator = {
            bg = 'none',
            fg = palette.text,
          },
          numbers = {
            fg = palette.text,
          },
          numbers_visible = {
            fg = palette.dim,
          },
          background = {
            fg = palette.dim,
          },
          hint = {
            fg = palette.dim,
          },
          hint_visible = {
            fg = palette.dim,
          },
          hint_selected = {
            fg = is_dark_theme and white_color or black_color,
          },
          hint_diagnostic = {
            fg = palette.purple,
          },
          hint_diagnostic_visible = {
            fg = palette.purple,
          },
          hint_diagnostic_selected = {
            fg = palette.purple,
          },
          error = {
            fg = palette.dim,
          },
          error_visible = {
            fg = palette.dim,
          },
          error_selected = {
            fg = is_dark_theme and white_color or black_color,
          },
          error_diagnostic = {
            fg = palette.red,
          },
          error_diagnostic_visible = {
            fg = palette.red,
          },
          error_diagnostic_selected = {
            fg = palette.red,
          },
          warning = {
            fg = palette.dim,
          },
          warning_visible = {
            fg = palette.dim,
          },
          warning_selected = {
            fg = is_dark_theme and white_color or black_color,
          },
          warning_diagnostic = {
            fg = palette.yellow,
          },
          warning_diagnostic_visible = {
            fg = palette.yellow,
          },
          warning_diagnostic_selected = {
            fg = palette.yellow,
          },
          info = {
            fg = palette.dim,
          },
          info_visible = {
            fg = palette.dim,
          },
          info_selected = {
            fg = is_dark_theme and white_color or black_color,
          },
          info_diagnostic = {
            fg = palette.blue,
          },
          info_diagnostic_visible = {
            fg = palette.blue,
          },
          info_diagnostic_selected = {
            fg = palette.blue,
          },
        },
      }
    end,
  }
}
