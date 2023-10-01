-- PREVIOUS VERSION OF INDENT BLANKLINE
-- return {
--   'lukas-reineke/indent-blankline.nvim',
--   version = '2.20.8',
--   event = 'VimEnter',
--   init = function()
--     vim.g.indent_blankline_filetype_exclude = {'dashboard'}
--   end,
--   opts = function()
--     local rp_palette = require('rose-pine.palette')
--
--     vim.api.nvim_set_hl(0, 'IndentBlanklineContextChar', {fg = rp_palette.subtle})
--     vim.api.nvim_set_hl(0, 'IndentBlanklineIndent1', {fg = rp_palette.highlight_med})
--
--     return {
--       space_char_blankline = ' ',
--       show_current_context = true,
--       show_current_context_start = true,
--       char_highlight_list = {
--         'IndentBlanklineIndent1',
--       },
--     }
--   end,
-- }

return {
  'lukas-reineke/indent-blankline.nvim',
  event = 'VimEnter',
  main = 'ibl',
  opts = function()
    local rp_palette = require('rose-pine.palette')

    vim.api.nvim_set_hl(0, 'IndentBlanklineContextChar', {fg = rp_palette.subtle})
    vim.api.nvim_set_hl(0, 'IndentBlanklineIndent1', {fg = rp_palette.highlight_med})

    return {
      indent = {
        char = '▏',
        highlight = {'IndentBlanklineIndent1'},
      },
      scope = {
        injected_languages = false,
        highlight = {'IndentBlanklineContextChar'},
        include = {
          node_type = {
            -- ['*'] = {
            --   'field',
            --   'method',
            --   'function',
            --   'constructor',
            --   'table_constructor',
            --   'if_statement',
            --   'function_declaration',
            --   'export_statement',
            --   'return_statement',
            -- },
            ['*'] = {
              '^argument',
              '^expression',
              '^for',
              '^if',
              '^import',
              '^export',
              '^type',
              'arguments',
              'block',
              'bracket',
              'declaration',
              'field',
              'func_literal',
              'function',
              'import_spec_list',
              'list',
              'return_statement',
              'short_var_declaration',
              'statement',
              'switch_body',
              'try',
              'object',
            },
          },
        },
      },
      exclude = {
        filetypes = {'dashboard'},
      }
    }
  end
}
