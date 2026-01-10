return {
    {
        "rose-pine/neovim",
        name = "rose-pine",
        priority = 1000,
        opts = {
            styles = {italic = false},
            dim_inactive_windows = true,
            palette = {
                dawn = {
                    -- no_bg = "#faf4ed",
                    cursor_bg = "#998f97",
                    cursor_fg = "#575279",
                },
                main = {
                    -- no_bg = "#141415",
                    cursor_bg = "#ffffff",
                    cursor_fg = "#000000",
                    -- gold = "#f6d5a7",
                    -- foam = "#a1d1da",
                    -- iris = "#d9c7ef",
                    -- rose = "#ebbcba",
                    -- pine = "#437e91",
                },
            },
            highlight_groups = {
                Cursor = {bg = "cursor_bg", fg = "cursor_fg"},
                Directory = {fg = "pine", bold = false},
            },

            before_highlight = function(group, highlight, palette)
                if group:match("^DiagnosticVirtualText") and highlight.bg == nil then
                    highlight.bg = highlight.fg
                    highlight.blend = 10
                end
            end,
        },
    },

    {
        "catppuccin/nvim",
        name = "catppuccin",
        lazy = true,
        opts = {
            term_colors = true,
            no_italic = true,
            lsp_styles = {
                underlines = {
                    errors = {"undercurl"},
                    hints = {"undercurl"},
                    warnings = {"undercurl"},
                    information = {"undercurl"},
                    ok = {"undercurl"},
                },
            },
            auto_integrations = true,
        },
    },
}
