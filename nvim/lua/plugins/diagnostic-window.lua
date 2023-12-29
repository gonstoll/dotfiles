local desc = require('utils').pluginKeymapDescriptor('diagnostic window')

return {
  'cseickel/diagnostic-window.nvim',
  dependencies = {'MunifTanjim/nui.nvim'},
  event = 'LspAttach',
  enabled = false,
  init = function()
    vim.keymap.set('n', ';d', ':DiagWindowShow<CR>', {desc = desc('Show diagnostic window')})
  end,
}
