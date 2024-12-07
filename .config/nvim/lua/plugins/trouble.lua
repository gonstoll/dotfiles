local desc = Utils.plugin_keymap_desc('trouble')

return {
  'folke/trouble.nvim',
  opts = {},
  keys = {
    {'<leader>xx', '<cmd>Trouble diagnostics toggle<cr>', desc = desc('Diagnostics')},
    {'<leader>xX', '<cmd>Trouble diagnostics toggle filter.buf=0<cr>', desc = desc('Buffer Diagnostics')},
    {'<leader>xs', '<cmd>Trouble symbols toggle focus=false<cr>', desc = desc('Symbols')},
    {'<leader>xl', '<cmd>Trouble lsp toggle focus=false win.position=right<cr>', desc = desc('LSP Definitions / references / ...')},
    {'<leader>xL', '<cmd>Trouble loclist toggle<cr>', desc = desc('Location List')},
    {'<leader>xQ', '<cmd>Trouble qflist toggle<cr>', desc = desc('Quickfix List')},
  },
}
