return {
  'Fildo7525/pretty_hover',
  event = 'LspAttach',
  opts = {},
  enabled = false,
  keys = {
    {
      ';h',
      function() require('pretty_hover').hover() end,
      mode = 'n',
      noremap = true,
      silent = true,
      desc = 'Pretty hover documentation',
    },
  },
}
