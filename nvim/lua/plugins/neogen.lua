local desc = require('utils').plugin_keymap_desc('neogen')

return {
  'danymat/neogen',
  dependencies = 'nvim-treesitter/nvim-treesitter',
  event = 'BufReadPre',
  config = function()
    local neogen = require('neogen')
    neogen.setup({snippet_engine = 'luasnip'})
    vim.keymap.set('n', '<leader>nf', function() neogen.generate({type = 'func'}) end, {desc = desc('Generate function docs')})
    vim.keymap.set('n', '<leader>nt', function() neogen.generate({type = 'type'}) end, {desc = desc('Generate type docs')})
    vim.keymap.set('n', '<leader>nc', function() neogen.generate({type = 'class'}) end, {desc = desc('Generate class docs')})
    vim.keymap.set('n', '<leader>ne', function() neogen.generate({type = 'file'}) end, {desc = desc('Generate file docs')})
  end
}
