return {
  {
    'vuki656/package-info.nvim',
    dependencies = {'MunifTanjim/nui.nvim'},
    ft = {'json'},
    opts = {package_manager = 'npm'},
    keys = {
      {
        '<leader>ns',
        "<cmd>lua require('package-info').show()<cr>",
        desc = 'Show package info',
        mode = 'n',
        silent = true,
        noremap = true,
      },
      {
        '<leader>nd',
        "<cmd>lua require('package-info').delete()<cr>",
        desc = 'Delete package',
        mode = 'n',
        silent = true,
        noremap = true,
      },
      {
        '<leader>np',
        "<cmd>lua require('package-info').change_version()<cr>",
        desc = 'Change package version',
        mode = 'n',
        silent = true,
        noremap = true,
      },
      {
        '<leader>ni',
        "<cmd>lua require('package-info').install()<cr>",
        desc = 'Install package',
        mode = 'n',
        silent = true,
        noremap = true,
      },
    },
  }
}
