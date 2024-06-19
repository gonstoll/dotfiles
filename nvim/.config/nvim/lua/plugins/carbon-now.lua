local desc = require('utils').plugin_keymap_desc('carbon now')

return {
  'kristijanhusak/vim-carbon-now-sh',
  keys = {
    {'<F2>', ':CarbonNowSh<CR>', desc = desc('Take code snapshot'), mode = {'v', 'n'}},
  },
}
