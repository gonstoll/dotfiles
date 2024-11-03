return {
  'nvim-treesitter/nvim-treesitter',
  dependencies = {
    {'windwp/nvim-ts-autotag', opts = {}},
  },
  cmd = {'TSInstall', 'TSBufEnable', 'TSBufDisable', 'TSModuleInfo'},
  build = ':TSUpdate',
  lazy = vim.fn.argc(-1) == 0,
  config = function()
    local configs = require('nvim-treesitter.configs')
    local parsers = require('nvim-treesitter.parsers')

    configs.setup({
      highlight = {
        enable = true,
        disable = {},
      },
      indent = {
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
      context_commentstring = {
        enable = true,
        enable_autocmd = false,
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = '<leader>ti',
          scope_incremental = '<leader>ts',
          node_incremental = '<leader>ti',
          node_decremental = '<leader>td',
        },
      },
    })

    local parser_configs = parsers.get_parser_configs();
    parser_configs.tsx.filetype_to_parsername = {'javascript', 'typescript.tsx'}
  end
}
