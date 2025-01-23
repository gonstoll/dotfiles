local desc = Utils.plugin_keymap_desc('dap go')

return {
  'mfussenegger/nvim-dap',
  dependencies = {
    {
      'leoluz/nvim-dap-go',
      opts = {},
      ft = 'go',
      keys = {
        {'<leader>dGt', function() require('dap-go').debug_test() end, desc = desc('Debug closest test')},
        {'<leader>dGl', function() require('dap-go').debug_last_test() end, desc = desc('Debug last test')},
      },
    },
  },
}
