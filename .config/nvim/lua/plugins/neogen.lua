local desc = Utils.plugin_keymap_desc('neogen')

return {
  'danymat/neogen',
  dependencies = 'nvim-treesitter/nvim-treesitter',
  keys = function()
    return {
      {'<leader>nf', function() require('neogen').generate({type = 'func'}) end, desc = desc('Generate function docs')},
      {'<leader>nt', function() require('neogen').generate({type = 'type'}) end, desc = desc('Generate type docs')},
      {'<leader>nc', function() require('neogen').generate({type = 'class'}) end, desc = desc('Generate class docs')},
      {'<leader>ne', function() require('neogen').generate({type = 'file'}) end, desc = desc('Generate file docs')},
    }
  end,
  opts = {snippet_engine = 'nvim'},
}
