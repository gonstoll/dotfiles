local desc = require('utils').pluginKeymapDescriptor('trouble')

return {
  'folke/trouble.nvim',
  opts = {},
  keys = {
    {'<leader>yy', function() require('trouble').open() end, desc = desc('Open Trouble')},
    {'<leader>yw', function() require('trouble').open('workspace_diagnostics') end, desc = desc('Workspace diagnostics')},
    {'<leader>yd', function() require('trouble').open('document_diagnostics') end, desc = desc('Document diagnostics')},
    {'<leader>yl', function() require('trouble').open('quickfix') end, desc = desc('Open Trouble in quickfix mode')},
    {'<leader>yq', function() require('trouble').open('loclist') end, desc = desc('Open Trouble in loclist mode')},
    {'<leader>gR', function() require('trouble').open('lsp_references') end, desc = desc('Open Trouble in lsp references mode')},
  },
}
