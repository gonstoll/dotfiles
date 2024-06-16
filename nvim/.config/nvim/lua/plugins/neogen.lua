local desc = require('utils').plugin_keymap_desc('neogen')

return {
  'danymat/neogen',
  dependencies = 'nvim-treesitter/nvim-treesitter',
  keys = function()
    local neogen = require('neogen')
    return {
      {'<leader>nf', function() neogen.generate({type = 'func'}) end, desc = desc('Generate function docs')},
      {'<leader>nt', function() neogen.generate({type = 'type'}) end, desc = desc('Generate type docs')},
      {'<leader>nc', function() neogen.generate({type = 'class'}) end, desc = desc('Generate class docs')},
      {'<leader>ne', function() neogen.generate({type = 'file'}) end, desc = desc('Generate file docs')}
    }
  end,
  opts = {snippet_engine = 'luasnip'},
}
