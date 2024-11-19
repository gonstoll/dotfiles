return {
  {'onsails/lspkind-nvim', config = false},

  {
    'mfussenegger/nvim-lint',
    ft = {'javascript', 'typescript', 'typescriptreact', 'javascriptreact'},
    opts = {
      linters_by_ft = {
        javascript = {'eslint_d'},
        typescript = {'eslint_d'},
        typescriptreact = {'eslint_d'},
        javascriptreact = {'eslint_d'},
      },
    },
    config = function(_, opts)
      local lint = require('lint')
      lint.linters_by_ft = opts.linters_by_ft

      vim.api.nvim_create_autocmd({'BufWritePost', 'BufEnter', 'TextChanged', 'InsertLeave'}, {
        pattern = {'*.js', '*.jsx', '*.ts', '*.tsx'},
        callback = function()
          lint.try_lint()
        end,
      })

      vim.keymap.set(
        'n',
        '<leader>ef',
        ':%!eslint_d --stdin --fix-to-stdout --stdin-filename %<CR>',
        {desc = 'Lint: Fix all'}
      )
    end,
  },

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
