local desc = require('utils').pluginKeymapDescriptor('spectre')

return {
  'nvim-pack/nvim-spectre',
  keys = {
    {'<leader>S', function() require('spectre').toggle() end, desc = desc('Toggle Spectre')},
    {'<leader>sw', function() require('spectre').open_visual({select_word = true}) end, desc = desc('Search current word')},
    {'<leader>sw', function() require('spectre').open_visual() end, mode = 'v', desc = desc('Search current word')},
    {'<leader>sp', function() require('spectre').open_file_search({select_word = true}) end, desc = desc('Search on current file')},
  },
  opts = {
    mapping = {
      toggle_line = {map = 'dd', cmd = function() require('spectre').toggle_line() end, desc = desc('Toggle item')},
      enter_file = {map = '<cr>', cmd = function() require('spectre.actions').select_entry() end, desc = desc('Open file')},
      send_to_qf = {map = '<leader>q', cmd = function() require('spectre.actions').send_to_qf() end, desc = desc('Send all items to quickfix')},
      replace_cmd = {map = '<leader>c', cmd = function() require('spectre.actions').replace_cmd() end, desc = desc('Input replace command')},
      show_option_menu = {map = '<leader>o', cmd = function() require('spectre').show_options() end, desc = desc('Show options')},
      run_current_replace = {map = '<leader>rc', cmd = function() require('spectre.actions').run_current_replace() end, desc = desc('Replace current line')},
      run_replace = {map = '<leader>R', cmd = function() require('spectre.actions').run_replace() end, desc = desc('Replace all')},
      change_view_mode = {map = '<leader>v', cmd = function() require('spectre').change_view() end, desc = desc('Change result view mode')},
      change_replace_sed = {map = 'trs', cmd = function() require('spectre').change_engine_replace('sed') end, desc = desc('Use sed to replace')},
      change_replace_oxi = {map = 'tro', cmd = function() require('spectre').change_engine_replace('oxi') end, desc = desc('Use oxi to replace')},
      toggle_live_update = {map = 'tu', cmd = function() require('spectre').toggle_live_update() end, desc = desc('Update when vim writes to file')},
      toggle_ignore_case = {map = 'ti', cmd = function() require('spectre').change_options('ignore-case') end, desc = desc('Toggle ignore case')},
      toggle_ignore_hidden = {map = 'th', cmd = function() require('spectre').change_options('hidden') end, desc = desc('Toggle search hidden')},
      resume_last_search = {map = '<leader>l', cmd = function() require('spectre').resume_last_search() end, desc = desc('Repeat last search')},
    },
  },
}
