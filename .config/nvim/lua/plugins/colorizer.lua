local desc = require('utils').plugin_keymap_desc('colorizer')

return {
  'NvChad/nvim-colorizer.lua',
  keys = {
    {
      '<leader>Ct',
      '<cmd>ColorizerToggle<CR>',
      desc = desc('Toggle highlighting of the current buffer'),
    },
  },
  opts = {
    filetypes = {'*'},
    user_default_options = {
      RGB = true,
      RRGGBB = true,
      names = false,
      RRGGBBAA = true,
      AARRGGBB = true,
      rgb_fn = true,
      hsl_fn = true,
      css = true,
      css_fn = true,
      mode = 'background', -- foreground, background,  virtualtext
      tailwind = false,    -- false / true / "normal" / "lsp" / "both"
      sass = {enable = false, parsers = {'css'}},
      virtualtext = '■',
      always_update = false,
    },
    buftypes = {},
  },
}
