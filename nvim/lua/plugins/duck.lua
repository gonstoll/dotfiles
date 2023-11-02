return {
  'tamton-aquib/duck.nvim',
  keys = {
    {
      '<leader>dd',
      function()
        require('duck').hatch('🐈')
      end,
      mode = 'n',
      noremap = true,
      silent = true,
      desc = 'Hatch a duck',
    },
    {
      '<leader>dk',
      '<cmd>lua require("duck").cook()<cr>',
      function()
        require('duck').cook()
      end,
      mode = 'n',
      noremap = true,
      silent = true,
      desc = 'Cook the duck',
    },
  },
}
