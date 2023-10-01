return {
  'folke/trouble.nvim',
  opts = {},
  keys = {
    {
      '<leader>yy',
      function()
        require('trouble').open()
      end,
      mode = 'n',
      desc = 'Open Trouble',
    },
    {
      '<leader>yw',
      function()
        require('trouble').open('workspace_diagnostics')
      end,
      mode = 'n',
      desc = 'Workspace diagnostics (Trouble)',
    },
    {
      '<leader>yd',
      function()
        require('trouble').open('document_diagnostics')
      end,
      mode = 'n',
      desc = 'Document diagnostics (Trouble)',
    },
    {
      '<leader>yl',
      function()
        require('trouble').open('quickfix')
      end,
      mode = 'n',
      desc = 'Open Trouble in quickfix mode',
    },
    {
      '<leader>yq',
      function()
        require('trouble').open('loclist')
      end,
      mode = 'n',
      desc = 'Open Trouble in loclist mode',
    },
    {
      '<leader>gR',
      function()
        require('trouble').open('lsp_references')
      end,
      mode = 'n',
      desc = 'Open Trouble in lsp references mode',
    },
  },
}
