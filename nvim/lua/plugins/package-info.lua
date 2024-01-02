local desc = require('utils').plugin_keymap_desc('package info')

return {
  'vuki656/package-info.nvim',
  dependencies = {'MunifTanjim/nui.nvim'},
  ft = {'json'},
  opts = {package_manager = 'npm'},
  keys = {
    {'<leader>ns', function() require('package-info').show() end, desc = desc('Show package info')},
    {'<leader>nd', function() require('package-info').delete() end, desc = desc('Delete package')},
    {'<leader>np', function() require('package-info').change_version() end, desc = desc('Change package version')},
    {'<leader>ni', function() require('package-info').install() end, desc = desc('Install package')},
  },
}
