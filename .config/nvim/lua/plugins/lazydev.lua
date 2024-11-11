return {
  'folke/lazydev.nvim',
  ft = 'lua',
  dependencies = {
    {'gonstoll/wezterm-types', lazy = true},
    {'Bilal2453/luvit-meta', lazy = true},
  },
  opts = {
    library = {
      {path = 'luvit-meta/library', words = {'vim%.uv'}},
      {path = 'wezterm-types', mods = {'wezterm'}},
    },
  },
}
