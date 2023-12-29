local desc = require('utils').pluginKeymapDescriptor('duck')

return {
  'tamton-aquib/duck.nvim',
  keys = {
    {',dd', function() require('duck').hatch('🐈') end, desc = desc('Hatch')},
    {',dk', function() require('duck').cook() end, mode = 'n', desc = desc('Cook')},
  },
}
