return {
  {
    'rose-pine/neovim',
    lazy = false,
    priority = 1000,
    name = 'rose-pine',
    opts = {
      variant = 'auto',
      dark_variant = 'moon',
      disable_background = true,
      disable_float_background = true,
      disable_italics = true,
      highlight_groups = {
        FloatBorder = {
          fg = 'subtle',
          bg = 'none',
        },
        TelescopeBorder = {
          fg = 'subtle',
          bg = 'none',
        },
        TelescopeNormal = {
          fg = 'none'
        },
        TelescopePromptNormal = {
          bg = 'none',
        },
        TelescopeResultsNormal = {
          fg = 'subtle',
          bg = 'none',
        },
        TelescopeSelection = {
          fg = 'text',
          bg = 'text',
          blend = 10,
        },
        TelescopeSelectionCaret = {
          fg = 'base',
          bg = 'text',
        },
        ColorColumn = {
          bg = 'rose',
        },
        CursorLine = {
          bg = 'text',
          blend = 20,
        },
        StatusLine = {
          fg = 'love',
          bg = 'love',
          blend = 10,
        },
        StatusLineNC = {
          fg = 'subtle',
          bg = 'surface',
        },
        GitSignsAdd = {
          fg = 'iris',
          bg = 'none',
        },
        GitSignsChange = {
          fg = 'foam',
          bg = 'none',
        },
        GitSignsDelete = {
          fg = 'rose',
          bg = 'none',
        },
      }
    },
    config = function(_, opts)
      local theme = require('rose-pine')

      theme.setup(opts)

      vim.cmd.colorscheme('rose-pine')
    end
  },

  {
    'folke/tokyonight.nvim',
    lazy = false,
    enabled = false,
    opts = {
      transparent = true,
      style = 'night',
      light_style = 'day',
      styles = {
        functions = {},
        comments = {},
        keywords = {},
        variables = {},
      },
    },
  },
}
