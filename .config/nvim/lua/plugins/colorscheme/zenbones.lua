---@class ColorSet
---@field bg string
---@field bg1 string
---@field bg_stark string
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

---@class LightColorSet : ColorSet
---@field bg_bright string

---@class DarkColorSet : ColorSet
---@field bg_warm string

---@class Palette
---@field dark DarkColorSet
---@field light LightColorSet

return {
  'mcchrish/zenbones.nvim',
  priority = 1000,
  dependencies = {'rktjmp/lush.nvim'},
  config = function()
    -- vim.g.zenbones_transparent_background = true
    -- vim.g.rosebones_transparent_background = true

    vim.api.nvim_create_autocmd('ColorScheme', {
      group = vim.api.nvim_create_augroup('Customize Zenbones', {}),
      callback = function()
        local active_colorscheme = vim.g.colors_name

        if (not string.find(active_colorscheme, 'bones')) then
          return
        end

        local theme = require(active_colorscheme)
        ---@type Palette
        local palette = require(active_colorscheme .. '.palette')
        local lush = require('lush')
        local bg = vim.o.background
        local statusline_bg = bg == 'dark' and palette.dark.bg_warm.li(10) or palette.light.bg1

        ---@diagnostic disable: undefined-global
        local specs = lush.parse(function()
          return {
            Normal({theme.Normal, bg = bg == 'dark' and '#181616' or palette[bg].bg}),
            -- NormalNC({theme.NormalNC, bg = bg == 'dark' and '#2d2929' or palette[bg].bg}),
            -- NormalNC({theme.NormalNC, bg = bg == 'dark' and '#1f1d1d' or palette[bg].bg.da(10)}),
            NormalNC({theme.NormalNC, bg = bg == 'dark' and '#262323' or palette[bg].bg.da(10)}),
            TermCursor({cterm = 'reverse', gui = 'reverse'}),
            FloatBorder({theme.FloatBorder, bg = theme.NormalFloat.bg}),
            FloatTitle({theme.FloatTitle, bg = theme.NormalFloat.bg}),
            Special({theme.Special, gui = 'normal'}),
            Statement({theme.Statement, gui = 'normal'}),
            Directory({theme.Directory, gui = 'normal'}),
            Boolean({theme.Boolean, gui = 'bold'}),
            SnippetTabStop({theme.SnippetTabStop, bg = theme.Normal.bg}),
            Function({theme.Function, fg = bg == 'dark' and palette.dark.bg.li(58) or palette.light.bg.sa(20).da(60)}),
            TodoBgTODO({theme.TodoBgTODO, bg = palette[bg].water, fg = palette[bg].fg}),
            TodoFgTODO({theme.TodoFgTODO, fg = palette[bg].water}),
            -- Statusline
            StatusLine({theme.StatusLine, bg = statusline_bg}),
            --- gitsigns
            StatusLineGitSignsAdd({bg = statusline_bg, fg = theme.GitSignsAdd.fg}),
            StatusLineGitSignsChange({bg = statusline_bg, fg = theme.GitSignsChange.fg}),
            StatusLineGitSignsDelete({bg = statusline_bg, fg = theme.GitSignsDelete.fg}),
            --- diagnostics
            StatusLineDiagnosticSignError({bg = statusline_bg, fg = theme.DiagnosticError.fg}),
            StatusLineDiagnosticSignWarn({bg = statusline_bg, fg = theme.DiagnosticWarn.fg}),
            StatusLineDiagnosticSignInfo({bg = statusline_bg, fg = theme.DiagnosticInfo.fg}),
            StatusLineDiagnosticSignHint({bg = statusline_bg, fg = theme.DiagnosticHint.fg}),
            StatusLineDiagnosticSignOk({bg = statusline_bg, fg = theme.DiagnosticOk.fg}),
          }
        end)

        lush.apply(lush.compile(specs))
      end,
    })
  end,
}
