return {
  'nvim-treesitter/nvim-treesitter',
  dependencies = {
    {'windwp/nvim-ts-autotag', opts = {}},
  },
  cmd = {'TSInstall', 'TSBufEnable', 'TSBufDisable', 'TSModuleInfo'},
  build = ':TSUpdate',
  config = function()
    local configs = require('nvim-treesitter.configs')
    local parsers = require('nvim-treesitter.parsers')

    configs.setup {
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
          init_selection = '<leader>gi',
          scope_incremental = '<leader>gs',
          node_incremental = '<leader>gi',
          node_decremental = '<leader>gd',
        },
      },
    }

    local parser_configs = parsers.get_parser_configs();
    parser_configs.tsx.filetype_to_parsername = {'javascript', 'typescript.tsx'}
  end
}
