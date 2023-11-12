return {
  'stevearc/oil.nvim',
  dependencies = {{'nvim-tree/nvim-web-devicons', lazy = true}},
  event = 'VeryLazy',
  opts = {
    default_file_explorer = false,
  },
  config = function(_, opts)
    require('oil').setup(opts)
    vim.keymap.set('n', '-', require('oil').open, {desc = 'Open parent directory'})
  end
}
