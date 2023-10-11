return {
  'lukas-reineke/indent-blankline.nvim',
  event = 'VimEnter',
  main = 'ibl',
  opts = {
    indent = {
      char = '▏',
      highlight = {'IndentBlanklineIndent1'},
    },
    scope = {
      injected_languages = false,
      highlight = {'IndentBlanklineContextChar'},
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
  },
}
