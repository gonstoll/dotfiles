return {
  'nvim-treesitter/nvim-treesitter',
  dependencies = {
    'nvim-treesitter/nvim-treesitter-textobjects',
    'windwp/nvim-ts-autotag',
  },
  build = ':TSUpdate',
  config = function()
    local treesitter_config = require('nvim-treesitter.configs')
    local treesitter_parsers = require('nvim-treesitter.parsers')

    treesitter_config.setup {
      highlight = {
        enable = true,
        disable = {},
      },
      indent = {
        enable = true,
        disable = {},
      },
      matchup = {
        enable = true,
        disable = {},
      },
      ensure_installed = {
        'markdown',
        'markdown_inline',
        'tsx',
        'typescript',
        'php',
        'json',
        'yaml',
        'css',
        'scss',
        'html',
        'javascript',
        'lua',
        'vim',
        'vimdoc',
        'jsdoc',
        'graphql',
        'bash',
        'prisma',
        'svelte',
        'sql',
        'regex',
      },
      autotag = {
        enable = true,
        enable_rename = true,
        enable_close = true,
        enable_close_on_slash = false,
      },
      context_commentstring = {
        enable = true,
        enable_autocmd = false,
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = '<c-space>',
          node_incremental = '<c-space>',
          scope_incremental = '<c-s>',
          node_decremental = '<M-space>',
        },
      },
    }

    local parser_config = treesitter_parsers.get_parser_configs();
    parser_config.tsx.filetype_to_parsername = {'javascript', 'typescript.tsx'}
  end
}
