return {
  'lukas-reineke/indent-blankline.nvim',
  event = 'BufReadPre',
  main = 'ibl',
  enable = false,
  opts = function()
    return {
      indent = {
        -- char = '▏',
        char = '',
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
