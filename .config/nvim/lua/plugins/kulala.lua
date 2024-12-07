local desc = Utils.plugin_keymap_desc('kulala')

return {
  'mistweaverco/kulala.nvim',
  opts = {},
  ft = {'http'},
  keys = {
    {'<leader>kr', function() require('kulala').run() end, desc = desc('Run')},
    {'<leader>kn', function() require('kulala').jump_next() end, desc = desc('Next request')},
    {'<leader>kp', function() require('kulala').jump_prev() end, desc = desc('Previous request')},
  },
}
