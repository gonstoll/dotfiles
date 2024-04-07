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
            ui = {bg_gutter = 'none'},
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
        local palette = colors.palette

        return {
          -- Statusline
          StatusLine = {bg = theme.ui.bg_p2, fg = theme.ui.fg},
          --- modes
          StatuslineAccent = {bg = 'none', fg = palette.sakuraPink},
          StatuslineInsertAccent = {bg = 'none', fg = palette.springGreen},
          StatuslineVisualAccent = {bg = 'none', fg = palette.peachRed},
          StatuslineReplaceAccent = {bg = 'none', fg = palette.carpYellow},
          StatuslineCmdLineAccent = {bg = 'none', fg = palette.crystalBlue},
          StatuslineTerminalAccent = {bg = 'none', fg = palette.fujiGray},
          --- gitsigns
          StatusLineGitSignsAdd = {bg = theme.ui.bg_p2, fg = theme.vcs.added},
          StatusLineGitSignsChange = {bg = theme.ui.bg_p2, fg = theme.vcs.changed},
          StatusLineGitSignsDelete = {bg = theme.ui.bg_p2, fg = theme.vcs.removed},
          --- diagnostics
          StatusLineDiagnosticSignError = {bg = theme.ui.bg_p2, fg = theme.diag.error},
          StatusLineDiagnosticSignWarn = {bg = theme.ui.bg_p2, fg = theme.diag.warning},
          StatusLineDiagnosticSignInfo = {bg = theme.ui.bg_p2, fg = theme.diag.info},
          StatusLineDiagnosticSignHint = {bg = theme.ui.bg_p2, fg = theme.diag.hint},
          StatusLineDiagnosticSignOk = {bg = theme.ui.bg_p2, fg = theme.diag.ok},

          NormalFloat = {bg = theme.ui.bg_p1},
          FloatBorder = {fg = theme.ui.shade0, bg = theme.ui.bg_p1},
          FloatTitle = {fg = theme.ui.shade0, bg = theme.ui.bg_p1, bold = false},
          FloatFooter = {fg = theme.ui.nontext, bg = theme.ui.bg_p1},

          Pmenu = {fg = theme.ui.shade0, bg = theme.ui.bg_p1}, -- add `blend = vim.o.pumblend` to enable transparency
          PmenuSel = {fg = 'NONE', bg = theme.ui.bg_p2},
          PmenuSbar = {bg = theme.ui.bg_m1},
          PmenuThumb = {bg = theme.ui.bg_p2},

          CursorLineNr = {bold = false},
          Title = {bold = false},
          Boolean = {bold = false},
          MatchParen = {bold = false},
          IblIndent = {fg = theme.ui.bg_p1},
          IblScope = {fg = theme.ui.whitespace},
          ['@variable.builtin'] = {link = 'Special'},
          ['@lsp.typemod.function.readonly'] = {link = 'Function'},
          ['@boolean'] = {link = 'Boolean'},
          ['@keyword.operator'] = {link = 'Keyword'},
          ['@string.escape'] = {link = 'PrePoc'},
          typescriptParens = {bg = 'none'},
        }
      end,
    },
    config = function(_, opts)
      require('kanagawa').setup(opts)
      vim.cmd('colorscheme kanagawa')
    end
  },
}
