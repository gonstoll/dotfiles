-- Taken from https://github.com/rachartier/tiny-inline-diagnostic.nvim
local function hex_to_rgb(hex)
  if hex == nil or hex == 'None' then
    return {0, 0, 0}
  end

  hex = hex:gsub('#', '')
  hex = string.lower(hex)

  return {
    tonumber(hex:sub(1, 2), 16),
    tonumber(hex:sub(3, 4), 16),
    tonumber(hex:sub(5, 6), 16),
  }
end

-- Taken from https://github.com/rachartier/tiny-inline-diagnostic.nvim
---@param foreground string foreground color
---@param background string background color
---@param alpha number|string number between 0 and 1. 0 results in bg, 1 results in fg
local function blend(foreground, background, alpha)
  alpha = type(alpha) == 'string' and (tonumber(alpha, 16) / 0xff) or alpha

  local fg = hex_to_rgb(foreground)
  local bg = hex_to_rgb(background)

  local blend_channel = function(i)
    local ret = (alpha * fg[i] + ((1 - alpha) * bg[i]))
    return math.floor(math.min(math.max(0, ret), 255) + 0.5)
  end

  return string.format('#%02x%02x%02x', blend_channel(1), blend_channel(2), blend_channel(3)):upper()
end

return {
  {
    'rebelot/kanagawa.nvim',
    lazy = true,
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
          StatusLine = {bg = theme.ui.bg_p1, fg = theme.syn.fun},
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
          StatusLineDiagnosticSignError = {bg = theme.ui.bg_p1, fg = palette.peachRed},
          StatusLineDiagnosticSignWarn = {bg = theme.ui.bg_p1, fg = theme.diag.warning},
          StatusLineDiagnosticSignInfo = {bg = theme.ui.bg_p1, fg = theme.diag.info},
          StatusLineDiagnosticSignHint = {bg = theme.ui.bg_p1, fg = theme.diag.hint},
          StatusLineDiagnosticSignOk = {bg = theme.ui.bg_p1, fg = theme.diag.ok},

          --- floats
          NormalFloat = {bg = theme.ui.bg_p1},
          FloatBorder = {fg = theme.ui.shade0, bg = theme.ui.bg_p1},
          FloatTitle = {fg = theme.ui.shade0, bg = theme.ui.bg_p1, bold = false},
          FloatFooter = {fg = theme.ui.nontext, bg = theme.ui.bg_p1},

          --- daignostics
          DiagnosticError = {fg = palette.peachRed},
          DiagnosticSignError = {fg = palette.peachRed},
          DiagnosticFloatingError = {fg = palette.peachRed},
          DiagnosticUnderlineError = {sp = palette.peachRed},
          DiagnosticVirtualTextError = {fg = palette.peachRed, bg = blend(palette.peachRed, theme.ui.bg, 0.10)},
          DiagnosticVirtualTextHint = {fg = theme.diag.hint, bg = blend(theme.diag.hint, theme.ui.bg, 0.10)},
          DiagnosticVirtualTextInfo = {fg = theme.diag.info, bg = blend(theme.diag.info, theme.ui.bg, 0.10)},
          DiagnosticVirtualTextOk = {fg = theme.diag.ok, bg = blend(theme.diag.ok, theme.ui.bg, 0.10)},
          DiagnosticVirtualTextWarn = {fg = theme.diag.warning, bg = blend(theme.diag.warning, theme.ui.bg, 0.10)},

          --- popups
          Pmenu = {fg = theme.ui.shade0, bg = theme.ui.bg_p1}, -- add `blend = vim.o.pumblend` to enable transparency
          PmenuSel = {fg = 'NONE', bg = theme.ui.bg_p2},
          PmenuSbar = {bg = theme.ui.bg_m1},
          PmenuThumb = {bg = theme.ui.bg_p2},

          --- misc
          ModeMsg = {fg = theme.syn.comment, bold = false},
          WinSeparator = {fg = theme.ui.bg_p2},
          TelescopeSelection = {bg = theme.ui.bg_p2},
          Cursor = {bg = 'none'},
          CursorLine = {bg = 'none'},
          CursorLineNr = {bold = false},
          Title = {bold = false},
          Boolean = {bold = false},
          MatchParen = {bold = false, bg = theme.ui.bg_p2},
          IblIndent = {fg = theme.ui.bg_p2},
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
  },

  {
    'mcchrish/zenbones.nvim',
    priority = 1000,
    dependencies = {'rktjmp/lush.nvim'},
    config = function()
      ---@class ColorSet
      ---@field bg string
      ---@field bg1 string
      ---@field bg_stark string
      ---@field bg_warm string
      ---@field fg string
      ---@field fg1 string
      ---@field blossom string
      ---@field blossom1 string
      ---@field leaf string
      ---@field leaf1 string
      ---@field rose string
      ---@field rose1 string
      ---@field sky string
      ---@field sky1 string
      ---@field water string
      ---@field water1 string
      ---@field wood string
      ---@field wood1 string

      ---@class Palette
      ---@field dark ColorSet
      ---@field light ColorSet

      vim.g.zenbones_transparent_background = true
      vim.g.rosebones_transparent_background = true

      vim.api.nvim_create_autocmd('ColorScheme', {
        group = vim.api.nvim_create_augroup('Customize Zenbones', {}),
        callback = function()
          local active_colorscheme = vim.g.colors_name

          if (not string.find(active_colorscheme, 'bones')) then
            return
          end

          local theme = require('zenbones')
          ---@type Palette
          local palette = require('zenbones.palette')
          local lush = require('lush')
          local bg = vim.o.background

          ---@diagnostic disable: undefined-global
          local specs = lush.parse(function()
            return {
              TermCursor({cterm = 'reverse', gui = 'reverse'}),
              FloatBorder({theme.FloatBorder, bg = theme.NormalFloat.bg}),
              FloatTitle({theme.FloatTitle, bg = theme.NormalFloat.bg}),
              Special({theme.Special, gui = 'normal'}),
              Statement({theme.Statement, gui = 'normal'}),
              Directory({theme.Directory, gui = 'normal'}),
              Function({theme.Function, fg = palette[bg].fg1, gui = 'italic'}),
              -- Statusline
              StatusLine({theme.StatusLine, bg = palette.dark.bg_warm}),
              --- gitsigns
              StatusLineGitSignsAdd({bg = palette.dark.bg_warm, fg = theme.GitSignsAdd.fg}),
              StatusLineGitSignsChange({bg = palette.dark.bg_warm, fg = theme.GitSignsChange.fg}),
              StatusLineGitSignsDelete({bg = palette.dark.bg_warm, fg = theme.GitSignsDelete.fg}),
              --- diagnostics
              StatusLineDiagnosticSignError({bg = palette.dark.bg_warm, fg = theme.DiagnosticError.fg}),
              StatusLineDiagnosticSignWarn({bg = palette.dark.bg_warm, fg = theme.DiagnosticWarn.fg}),
              StatusLineDiagnosticSignInfo({bg = palette.dark.bg_warm, fg = theme.DiagnosticInfo.fg}),
              StatusLineDiagnosticSignHint({bg = palette.dark.bg_warm, fg = theme.DiagnosticHint.fg}),
              StatusLineDiagnosticSignOk({bg = palette.dark.bg_warm, fg = theme.DiagnosticOk.fg}),
            }
          end)

          lush.apply(lush.compile(specs))
        end,
      })
    end,
  },
}
