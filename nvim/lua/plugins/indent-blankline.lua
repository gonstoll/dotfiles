return {
  'lukas-reineke/indent-blankline.nvim',
  event = 'VimEnter',
  main = 'ibl',
  opts = function()
    local isDarkTheme = vim.o.background == 'dark'

    local darkIndentHighlights = {
      indent = '#5a524c',
      scope = '#928374',
    }

    local lightIndentHighlights = {
      indent = '#d4be98',
      scope = '#928374',
    }

    if isDarkTheme then
      vim.api.nvim_set_hl(0, 'IBLIndent', {fg = darkIndentHighlights.indent})
      vim.api.nvim_set_hl(0, 'IBLScope', {fg = darkIndentHighlights.scope})
    else
      vim.api.nvim_set_hl(0, 'IBLIndent', {fg = lightIndentHighlights.indent})
      vim.api.nvim_set_hl(0, 'IBLScope', {fg = lightIndentHighlights.scope})
    end

    return {
      indent = {
        char = '▏',
        highlight = {'IBLIndent'},
      },
      scope = {
        injected_languages = false,
        highlight = {'IBLScope'},
        include = {
          node_type = {
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
  end,
}
