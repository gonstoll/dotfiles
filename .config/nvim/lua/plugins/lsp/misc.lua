return {
  {'onsails/lspkind-nvim', config = false},

  {
    'williamboman/mason.nvim',
    build = ':MasonUpdate',
    opts = {
      ui = {border = 'single'},
    },
  },

  {
    'williamboman/mason-lspconfig.nvim',
    event = 'VeryLazy',
    opts = {
      ensure_installed = {
        'tailwindcss',
        'cssls',
        'lua_ls',
        'eslint',
        'emmet_language_server',
        'ts_ls',
        'bashls',
        'vtsls',
        'jsonls',
        'bashls',
      },
      automatic_installation = true,
    },
  },

  {
    'j-hui/fidget.nvim',
    event = 'LspAttach',
    opts = {
      notification = {
        window = {
          winblend = 1,
          normal_hl = 'NormalFloat',
        },
      },
    },
  },
}
