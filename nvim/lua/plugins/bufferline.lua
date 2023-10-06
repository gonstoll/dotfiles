return {
  'akinsho/bufferline.nvim',
  lazy = true,
  event = 'VimEnter',
  dependencies = {'famiu/bufdelete.nvim'},
  opts = function()
    local bufferline = require('bufferline')
    local groups = require('bufferline.groups')
    local rp_palette = require('rose-pine.palette')

    local is_dark_theme = vim.o.background == 'dark'
    local white_color = '#ffffff'
    local black_color = '#1c1c27'


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

    return {
      options = {
        numbers = function(opts)
          return string.format('%s.', opts.ordinal)
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
      },
      highlights = {
        tab = {
          bg = 'none',
          fg = rp_palette.text,
        },
        tab_selected = {
          bg = 'none',
          fg = is_dark_theme and white_color or black_color,
        },
        buffer_visible = {
          bg = 'none',
          fg = rp_palette.subtle,
        },
        buffer_selected = {
          bg = 'none',
          fg = is_dark_theme and white_color or black_color,
          bold = false,
        },
        separator = {
          bg = 'none',
          fg = rp_palette.text,
        },
        numbers = {
          fg = rp_palette.text,
        },
        numbers_visible = {
          fg = rp_palette.subtle,
        },
        background = {
          fg = rp_palette.subtle, -- Color of buffer when not selected
        },
        hint = {
          fg = rp_palette.subtle,
        },
        hint_visible = {
          fg = rp_palette.subtle,
        },
        hint_selected = {
          fg = is_dark_theme and white_color or black_color,
        },
        hint_diagnostic = {
          fg = rp_palette.iris,
        },
        hint_diagnostic_visible = {
          fg = rp_palette.iris,
        },
        hint_diagnostic_selected = {
          fg = rp_palette.iris,
        },
        error = {
          fg = rp_palette.subtle,
        },
        error_visible = {
          fg = rp_palette.subtle,
        },
        error_selected = {
          fg = is_dark_theme and white_color or black_color,
        },
        error_diagnostic = {
          fg = rp_palette.rose,
        },
        error_diagnostic_visible = {
          fg = rp_palette.rose,
        },
        error_diagnostic_selected = {
          fg = rp_palette.rose,
        },
        warning = {
          fg = rp_palette.subtle,
        },
        warning_visible = {
          fg = rp_palette.subtle,
        },
        warning_selected = {
          fg = is_dark_theme and white_color or black_color,
        },
        warning_diagnostic = {
          fg = rp_palette.gold,
        },
        warning_diagnostic_visible = {
          fg = rp_palette.gold,
        },
        warning_diagnostic_selected = {
          fg = rp_palette.gold,
        },
        info = {
          fg = rp_palette.subtle,
        },
        info_visible = {
          fg = rp_palette.subtle,
        },
        info_selected = {
          fg = is_dark_theme and white_color or black_color,
        },
        info_diagnostic = {
          fg = rp_palette.foam,
        },
        info_diagnostic_visible = {
          fg = rp_palette.foam,
        },
        info_diagnostic_selected = {
          fg = rp_palette.foam,
        },
      },
    }
  end,
}
