local desc = require('utils').plugin_keymap_desc('oil')

return {
  'stevearc/oil.nvim',
  dependencies = {
    {'nvim-treesitter/nvim-treesitter'},
    {'nvim-tree/nvim-web-devicons', lazy = true},
  },
  opts = {
    view_options = {
      show_hidden = true,
      is_always_hidden = function(name, _)
        return vim.startswith(name, '.DS_Store')
      end,
    },
    keymaps = {
      ['<C-h>'] = false, -- Split
      ['<C-s>'] = false, -- Vsplit
      ['<C-l>'] = false, -- refresh
      ['<M-s>'] = 'actions.select_split',
      ['<M-v>'] = 'actions.select_vsplit',
      ['<M-l>'] = 'actions.refresh',
    },
    float = {padding = 4},
  },
  config = function(_, opts)
    local oil = require('oil')
    oil.setup(opts)
    vim.keymap.set('n', '-', oil.open, {desc = desc('Open parent directory')})
  end
}
