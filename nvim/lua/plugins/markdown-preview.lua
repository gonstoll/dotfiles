local desc = require('utils').pluginKeymapDescriptor('markdown preview')

return {
  'iamcco/markdown-preview.nvim',
  build = 'cd app && npm install',
  ft = {'markdown'},
  init = function() vim.g.mkdp_filetypes = {'markdown'} end,
  keys = {
    {'<leader>mp', ':MarkdownPreview<CR>', mode = 'n', desc = desc('Preview')},
  },
}
