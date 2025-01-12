return {
  'rose-pine/neovim',
  name = 'rose-pine',
  lazy = true,
  opts = {
    disable_background = true,
    dark_variant = 'moon',
    styles = {italic = false},
    palette = {
      moon = {
        gold = '#f6d5a7',
        foam = '#a1d1da',
        iris = '#d9c7ef',
        rose = '#ebbcba',
      },
    },
    highlight_groups = {
      Directory = {fg = 'foam', bold = false},
      StatusLine = {bg = 'surface', fg = 'subtle'},
      StatusLineTerm = {link = 'StatusLine'},
      StatusLineNC = {link = 'StatusLine'},
      --- gitsigns
      StatusLineGitSignsAdd = {bg = 'surface', fg = 'pine'},
      StatusLineGitSignsChange = {bg = 'surface', fg = 'gold'},
      StatusLineGitSignsDelete = {bg = 'surface', fg = 'rose'},
      --- diagnostics
      StatusLineDiagnosticSignError = {bg = 'surface', fg = 'love'},
      StatusLineDiagnosticSignWarn = {bg = 'surface', fg = 'gold'},
      StatusLineDiagnosticSignInfo = {bg = 'surface', fg = 'foam'},
      StatusLineDiagnosticSignHint = {bg = 'surface', fg = 'iris'},
      StatusLineDiagnosticSignOk = {bg = 'surface', fg = 'pine'},
    },
  },
}
