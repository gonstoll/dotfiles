return {
  {
    'rose-pine/neovim',
    name = 'rose-pine',
    event = 'VeryLazy',
    opts = {
      variant = 'auto',
      dark_variant = 'moon',
      disable_background = true,
      disable_float_background = true,
      disable_italics = true,
      highlight_groups = {
        FloatBorder = {fg = 'subtle', bg = 'none'},
        TelescopeBorder = {fg = 'subtle', bg = 'none'},
        TelescopeNormal = {fg = 'none'},
        TelescopePromptNormal = {bg = 'none'},
        TelescopeResultsNormal = {fg = 'subtle', bg = 'none'},
        TelescopeSelection = {fg = 'text', bg = 'text', blend = 10},
        TelescopeSelectionCaret = {fg = 'base', bg = 'text'},
        Cursor = {fg = 'base', bg = 'text'},
        ColorColumn = {bg = 'rose'},
        CursorLine = {bg = 'text', blend = 30},
        StatusLine = {fg = 'love', bg = 'love', blend = 10},
        StatusLineNC = {fg = 'subtle', bg = 'surface'},
        GitSignsAdd = {fg = 'iris', bg = 'none'},
        GitSignsChange = {fg = 'foam', bg = 'none'},
        GitSignsDelete = {fg = 'rose', bg = 'none'},
      }
    },
  },

  {
    'sainnhe/gruvbox-material',
    name = 'gruvbox-material',
    lazy = false,
    priority = 1000,
    config = function()
      vim.g.gruvbox_material_better_performance = 1
      -- Fonts
      vim.g.gruvbox_material_disable_italic_comment = 1
      vim.g.gruvbox_material_enable_italic = 0
      vim.g.gruvbox_material_enable_bold = 0
      vim.g.gruvbox_material_transparent_background = 1
      -- Themes
      vim.g.gruvbox_material_foreground = 'mix'
      vim.g.gruvbox_material_background = 'hard'
      vim.g.gruvbox_material_ui_contrast = 'high' -- The contrast of line numbers, indent lines, etc.
      vim.g.gruvbox_material_float_style = 'dim'  -- Background of floating windows

      local configuration = vim.fn['gruvbox_material#get_configuration']()
      local palette = vim.fn['gruvbox_material#get_palette'](configuration.background, configuration.foreground,
        configuration.colors_override)

      vim.cmd.colorscheme('gruvbox-material')

      local highlights_groups = {
        FoldColumn = {bg = 'none'},
        SignColumn = {bg = 'none'},
        Normal = {bg = 'none'},
        NormalNC = {bg = 'none'},
        NormalFloat = {bg = 'none'},
        FloatBorder = {bg = 'none'},
        FloatTitle = {bg = 'none', fg = palette.orange[1]},
        TelescopeBorder = {bg = 'none'},
        TelescopeNormal = {fg = 'none'},
        TelescopePromptNormal = {bg = 'none'},
        TelescopeResultsNormal = {bg = 'none'},
        TelescopeSelection = {bg = palette.bg3[1]},
        Visual = {bg = palette.bg_visual_red[1]},
        Cursor = {bg = palette.bg_red[1], fg = palette.bg_dim[1]},
        ColorColumn = {bg = palette.bg_visual_blue[1]},
        CursorLine = {bg = palette.bg3[1], blend = 25},
        GitSignsAdd = {fg = palette.green[1], bg = 'none'},
        GitSignsChange = {fg = palette.yellow[1], bg = 'none'},
        GitSignsDelete = {fg = palette.red[1], bg = 'none'},
      }

      for group, styles in pairs(highlights_groups) do
        vim.api.nvim_set_hl(0, group, styles)
      end
    end
  }
}
