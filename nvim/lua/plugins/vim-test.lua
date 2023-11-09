return {
  'vim-test/vim-test',
  keys = {
    {
      '<leader>TN',
      '<cmd>TestNearest<cr>',
      desc = 'Run nearest test',
    },
    {
      '<leader>TF',
      '<cmd>TestFile<cr>',
      desc = 'Run all tests in file',
    },
    {
      '<leader>TS',
      '<cmd>TestSuite<cr>',
      desc = 'Run all tests in suite',
    },
    {
      '<leader>TL',
      '<cmd>TestLast<cr>',
      desc = 'Run last test',
    },
    {
      '<leader>TV',
      '<cmd>TestVisit<cr>',
      desc = 'Visit test file',
    },
  },
}
