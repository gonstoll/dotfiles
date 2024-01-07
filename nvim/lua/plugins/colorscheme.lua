return {
  {
    'sainnhe/gruvbox-material',
    name = 'gruvbox-material',
    event = 'VeryLazy',
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

      -- vim.cmd('colorscheme gruvbox-material')
    end
  },

  {
    'rebelot/kanagawa.nvim',
    lazy = false,
    priority = 1000,
    opts = {
      commentStyle = {italic = false, bold = false},
      keywordStyle = {italic = false, bold = false},
      statementStyle = {italic = false, bold = false},
      functionStyle = {italic = false, bold = false},
      typeStyle = {italic = false, bold = false},
      background = {dark = 'dragon', light = 'lotus'},
      colors = {
        theme = {
          all = {
            ui = {
              bg_gutter = 'none',
              float = {
                bg = 'none',
                bg_border = 'none',
              },
            },
            diff = {
              add = 'none',
              change = 'none',
              delete = 'none',
              text = 'none',
            }
          }
        },
      },
      overrides = function(colors)
        local theme = colors.theme

        return {
          CursorLineNr = {bold = false},
          FloatTitle = {bold = false},
          Title = {bold = false},
          Boolean = {bold = false},
          IblIndent = {fg = theme.ui.bg_p1},
          IblScope = {fg = theme.ui.whitespace},
          ['@lsp.typemod.function.readonly'] = {link = 'Function'},
          ['@boolean'] = {link = 'Boolean'},
          ['@keyword.operator'] = {link = 'Keyword'},
        }
      end,
    },
    config = function(_, opts)
      require('kanagawa').setup(opts)
      vim.cmd('colorscheme kanagawa')
    end
  },
}
