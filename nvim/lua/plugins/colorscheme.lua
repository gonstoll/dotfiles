return {
  {
    'rose-pine/neovim',
    name = 'rose-pine',
    event = 'VeryLazy',
    opts = {
      styles = {
        bold = false,
        transparency = true,
      },
      highlight_groups = {
        -- StatusLine
        StatusLine = {bg = 'overlay', fg = 'subtle'},
        --- modes
        StatusLineAccent = {bg = 'none', fg = 'love'},
        StatusLineInsertAccent = {bg = 'none', fg = 'gold'},
        StatusLineVisualAccent = {bg = 'none', fg = 'rose'},
        StatusLineReplaceAccent = {bg = 'none', fg = 'pine'},
        StatusLineCmdLineAccent = {bg = 'none', fg = 'foam'},
        StatusLineTerminalAccent = {bg = 'none', fg = 'iris'},
        --- gitsigns
        StatusLineGitSignsAdd = {bg = 'overlay', fg = 'foam'},
        StatusLineGitSignsChange = {bg = 'overlay', fg = 'rose'},
        StatusLineGitSignsDelete = {bg = 'overlay', fg = 'love'},
        --- diagnostics
        StatusLineDiagnosticSignError = {bg = 'overlay', fg = 'love'},
        StatusLineDiagnosticSignWarn = {bg = 'overlay', fg = 'gold'},
        StatusLineDiagnosticSignInfo = {bg = 'overlay', fg = 'foam'},
        StatusLineDiagnosticSignHint = {bg = 'overlay', fg = 'iris'},
        StatusLineDiagnosticSignOk = {bg = 'overlay', fg = 'pine'},

        Cursor = {bg = 'text', fg = 'base'},
        CursorLine = {bg = 'none'},
      },
    },
    config = function(_, opts)
      require('rose-pine').setup(opts)
      -- vim.cmd('colorscheme rose-pine')
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
          StatusLine = {bg = theme.ui.bg_p1, fg = theme.ui.fg},
          --- modes
          StatusLineAccent = {bg = 'none', fg = palette.sakuraPink},
          StatusLineInsertAccent = {bg = 'none', fg = palette.springGreen},
          StatusLineVisualAccent = {bg = 'none', fg = palette.peachRed},
          StatusLineReplaceAccent = {bg = 'none', fg = palette.carpYellow},
          StatusLineCmdLineAccent = {bg = 'none', fg = palette.crystalBlue},
          StatusLineTerminalAccent = {bg = 'none', fg = palette.fujiGray},
          --- gitsigns
          StatusLineGitSignsAdd = {bg = theme.ui.bg_p1, fg = theme.vcs.added},
          StatusLineGitSignsChange = {bg = theme.ui.bg_p1, fg = theme.vcs.changed},
          StatusLineGitSignsDelete = {bg = theme.ui.bg_p1, fg = theme.vcs.removed},
          --- diagnostics
          StatusLineDiagnosticSignError = {bg = theme.ui.bg_p1, fg = theme.diag.error},
          StatusLineDiagnosticSignWarn = {bg = theme.ui.bg_p1, fg = theme.diag.warning},
          StatusLineDiagnosticSignInfo = {bg = theme.ui.bg_p1, fg = theme.diag.info},
          StatusLineDiagnosticSignHint = {bg = theme.ui.bg_p1, fg = theme.diag.hint},
          StatusLineDiagnosticSignOk = {bg = theme.ui.bg_p1, fg = theme.diag.ok},

          --- floats
          NormalFloat = {bg = theme.ui.bg_p1},
          FloatBorder = {fg = theme.ui.shade0, bg = theme.ui.bg_p1},
          FloatTitle = {fg = theme.ui.shade0, bg = theme.ui.bg_p1, bold = false},
          FloatFooter = {fg = theme.ui.nontext, bg = theme.ui.bg_p1},

          --- popups
          Pmenu = {fg = theme.ui.shade0, bg = theme.ui.bg_p1}, -- add `blend = vim.o.pumblend` to enable transparency
          PmenuSel = {fg = 'NONE', bg = theme.ui.bg_p2},
          PmenuSbar = {bg = theme.ui.bg_m1},
          PmenuThumb = {bg = theme.ui.bg_p2},

          --- misc
          WinSeparator = {fg = theme.ui.bg_p2},
          TelescopeSelection = {bg = theme.ui.bg_p2},
          Cursor = {bg = 'none'},
          CursorLine = {bg = 'none'},
          CursorLineNr = {bold = false},
          Title = {bold = false},
          Boolean = {bold = false},
          MatchParen = {bold = false, bg = theme.ui.bg_p2},
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

  {
    'mcchrish/zenbones.nvim',
    dependencies = {'rktjmp/lush.nvim'},
    event = 'VeryLazy',
    config = function()
      -- vim.cmd('colorscheme rosebones')
      vim.g.darkness = 'stark'
    end
  },
}
