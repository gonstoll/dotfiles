local desc = require('utils').plugin_keymap_desc('duck')

return {
  {
    'tamton-aquib/duck.nvim',
    keys = {
      {',dd', function() require('duck').hatch('🐈') end, desc = desc('Hatch')},
      {',dk', function() require('duck').cook() end, mode = 'n', desc = desc('Cook')},
    },
  },
  {
    'eandrju/cellular-automaton.nvim',
    keys = {
      {',fml', '<cmd>CellularAutomaton make_it_rain<CR>', desc = desc('CelullarAutomaton: Make it rain')},
    },
  },
}
