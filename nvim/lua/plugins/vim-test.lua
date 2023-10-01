return {
  'vim-test/vim-test',
  init = function()
    vim.keymap.set('n', '<leader>TN', '<cmd>TestNearest<cr>', {desc = 'Run nearest test'})
    vim.keymap.set('n', '<leader>TF', '<cmd>TestFile<cr>', {desc = 'Run all tests in file'})
    vim.keymap.set('n', '<leader>TS', '<cmd>TestSuite<cr>', {desc = 'Run all tests in suite'})
    vim.keymap.set('n', '<leader>TL', '<cmd>TestLast<cr>', {desc = 'Run last test'})
    vim.keymap.set('n', '<leader>TV', '<cmd>TestVisit<cr>', {desc = 'Visit test file'})
  end,
}
