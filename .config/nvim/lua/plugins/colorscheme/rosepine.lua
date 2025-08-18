return {
    "rose-pine/neovim",
    name = "rose-pine",
    priority = 1000,
    opts = {
        dark_variant = "moon",
        styles = {italic = false},
        palette = {
            dawn = {
                no_bg = "#faf4ed",
                cursor_bg = "#000000",
                cursor_fg = "#ffffff",
            },
            moon = {
                gold = "#f6d5a7",
                foam = "#a1d1da",
                iris = "#d9c7ef",
                rose = "#ebbcba",
                pine = "#437e91",
                no_bg = "#000000",
                cursor_bg = "#ffffff",
                cursor_fg = "#000000",
            },
        },
        highlight_groups = {
            Normal = {bg = "no_bg"},
            Cursor = {bg = "cursor_bg", fg = "cursor_fg"},
            Directory = {fg = "foam", bold = false},
            StatusLine = {bg = "none", fg = "clear"},
            StatusLineTerm = {bg = "base", fg = "subtle"},
            StatusLineNC = {bg = "base", fg = "subtle"},
            --- gitsigns
            StatusLineGitSignsAdd = {bg = "none", fg = "pine"},
            StatusLineGitSignsChange = {bg = "none", fg = "gold"},
            StatusLineGitSignsDelete = {bg = "none", fg = "rose"},
            --- diagnostics
            StatusLineDiagnosticSignError = {bg = "none", fg = "love"},
            StatusLineDiagnosticSignWarn = {bg = "none", fg = "gold"},
            StatusLineDiagnosticSignInfo = {bg = "none", fg = "foam"},
            StatusLineDiagnosticSignHint = {bg = "none", fg = "iris"},
            StatusLineDiagnosticSignOk = {bg = "none", fg = "pine"},
        },
    },
}
