local lspconfig = require('plugins.lsp.lspconfig')
local desc = require('utils').pluginKeymapDescriptor('lspsaga')

return {
  lspconfig.setup(),

  {
    'onsails/lspkind-nvim',
    init = function() return {mode = 'symbol'} end,
  },

  {
    'nvimdev/lspsaga.nvim',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      {'nvim-tree/nvim-web-devicons', lazy = true},
    },
    opts = {
      ui = {border = 'rounded'},
      symbol_in_winbar = {enable = false},
      lightbulb = {
        enable = false,
        sign = false,
      },
      outline = {
        layout = 'float',
        max_height = 0.7,
        left_width = 0.4,
      },
    },
    keys = {
      {'<leader>gb', '<Cmd>Lspsaga show_buf_diagnostics<CR>', desc = desc("Diagnostics: Show buffer's")},
      {'<leader>gf', '<Cmd>Lspsaga finder<CR>', desc = desc('Find references')},
      {'<leader>gp', '<Cmd>Lspsaga peek_definition<CR>', desc = desc('Peek definition')},
      {'<leader>gt', '<Cmd>Lspsaga peek_type_definition<CR>', desc = desc('Peek type definition')},
      {'<leader>go', '<Cmd>Lspsaga outline<CR>', desc = desc("Show file outline - 'e' to jump, 'o' to toggle")},
      {'<leader>ga', '<cmd>Lspsaga code_action<CR>', mode = {'n', 'v'}, desc = desc('Show code action')},
    },
  },

  -- Stops inactive LSP clients to free RAM
  {
    'zeioth/garbage-day.nvim',
    event = {'BufReadPost', 'BufNewFile', 'BufWritePre'},
    dependencies = 'neovim/nvim-lspconfig',
    opts = {notifications = true},
  },

  -- VS code like winbar with breadcrumbs
  {
    'utilyre/barbecue.nvim',
    name = 'barbecue',
    event = 'BufReadPre',
    version = '*',
    dependencies = {'SmiteshP/nvim-navic', 'nvim-tree/nvim-web-devicons'},
    opts = {attach_navic = false},
  },
}
