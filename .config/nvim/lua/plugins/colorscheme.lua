return {
    "rose-pine/neovim",
    name = "rose-pine",
    priority = 1000,
    opts = {
        styles = {italic = false},
        dim_inactive_windows = true,
        palette = {
            dawn = {
                no_bg = "#faf4ed",
                cursor_bg = "#998f97",
                cursor_fg = "#575279",
            },
            moon = {
                -- gold = "#f6d5a7",
                -- foam = "#a1d1da",
                -- iris = "#d9c7ef",
                -- rose = "#ebbcba",
                -- pine = "#437e91",
                no_bg = "#141415",
                cursor_bg = "#ffffff",
                cursor_fg = "#000000",
            },
            main = {
                no_bg = "#141415",
                cursor_bg = "#ffffff",
                cursor_fg = "#000000",
            },
        },
        highlight_groups = {
            Normal = {bg = "no_bg"},
            Cursor = {bg = "cursor_bg", fg = "cursor_fg"},
            Directory = {fg = "foam", bold = false},
            StatusLine = {bg = "no_bg", fg = "clear"},
            StatusLineTerm = {bg = "base", fg = "subtle"},
            StatusLineNC = {bg = "no_bg", fg = "subtle"},
        },

        before_highlight = function(group, highlight, palette)
            if group:match("^DiagnosticVirtualText") and highlight.bg == nil then
                highlight.bg = highlight.fg
                highlight.blend = 10
            end
        end,
    },
}
