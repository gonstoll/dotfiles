local desc = require('utils').plugin_keymap_desc('vim test')

return {
  'vim-test/vim-test',
  keys = {
    {'<leader>TN', '<cmd>TestNearest<cr>', desc = desc('Run nearest test')},
    {'<leader>TF', '<cmd>TestFile<cr>', desc = desc('Run all tests in file')},
    {'<leader>TS', '<cmd>TestSuite<cr>', desc = desc('Run all tests in suite')},
    {'<leader>TL', '<cmd>TestLast<cr>', desc = desc('Run last test')},
    {'<leader>TV', '<cmd>TestVisit<cr>', desc = desc('Visit test file')},
  },
}
