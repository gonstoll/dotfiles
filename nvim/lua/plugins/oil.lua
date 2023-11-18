return {
  'stevearc/oil.nvim',
  dependencies = {{'nvim-tree/nvim-web-devicons', lazy = true}},
  opts = {
    view_options = {
      show_hidden = true,
      is_always_hidden = function(name, bufnr)
        return vim.startswith(name, '.DS_Store')
      end,
    },
    float = {
      padding = 4,
    },
  },
  config = function(_, opts)
    require('oil').setup(opts)
    vim.keymap.set('n', '-', require('oil').open_float, {desc = 'Open parent directory'})
  end
}
