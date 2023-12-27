local lspconfig = require('plugins.lsp.lspconfig')

return {
  {
    'onsails/lspkind-nvim',
    init = function()
      return {mode = 'symbol'}
    end,
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
      {
        '<leader>gb',
        '<Cmd>Lspsaga show_buf_diagnostics<CR>',
        mode = 'n',
        noremap = true,
        silent = true,
        desc = "Diagnostics: Show buffer's (lspsaga)",
      },
      {
        '<leader>gf',
        '<Cmd>Lspsaga finder<CR>',
        mode = 'n',
        noremap = true,
        silent = true,
        desc = 'Find references (lspsaga)',
      },
      {
        '<leader>gp',
        '<Cmd>Lspsaga peek_definition<CR>',
        mode = 'n',
        noremap = true,
        silent = true,
        desc = 'Peek definition (lspsaga)',
      },
      {
        '<leader>gt',
        '<Cmd>Lspsaga peek_type_definition<CR>',
        mode = 'n',
        noremap = true,
        silent = true,
        desc = 'Peek type definition (lspsaga)',
      },
      {
        '<leader>go',
        '<Cmd>Lspsaga outline<CR>',
        mode = 'n',
        noremap = true,
        silent = true,
        desc = "Show file outline (lspsaga) - 'e' to jump, 'o' to toggle",
      },
      {
        '<leader>ga',
        '<cmd>Lspsaga code_action<CR>',
        mode = {'n', 'v'},
        desc = 'Show code action (lspsaga)',
      },
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
    dependencies = {
      'SmiteshP/nvim-navic',
      'nvim-tree/nvim-web-devicons',
    },
    opts = {
      attach_navic = false,
    },
  },

  lspconfig.config()
}
