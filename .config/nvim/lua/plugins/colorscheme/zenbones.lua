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
    "mcchrish/zenbones.nvim",
    dependencies = {"rktjmp/lush.nvim"},
    lazy = true,
    config = function()
        vim.g.zenbones_italic_comments = false
        vim.g.rosebones_italic_comments = false

        vim.api.nvim_create_autocmd("ColorScheme", {
            group = vim.api.nvim_create_augroup("Customize Zenbones", {}),
            callback = function()
                local active_colorscheme = vim.g.colors_name

                if (not string.find(active_colorscheme, "bones")) then
                    return
                end

                local theme = require(active_colorscheme)
                ---@type Palette
                local palette = require(active_colorscheme .. ".palette")
                local lush = require("lush")
                local bg = vim.o.background
                local statusline_bg = bg == "dark" and palette.dark.bg_warm.li(10) or palette.light.bg1

                ---@diagnostic disable: undefined-global
                local specs = lush.parse(function()
                    return {
                        -- Normal({theme.Normal, bg = bg == 'dark' and '#181616' or palette[bg].bg}),
                        Normal({theme.Normal, bg = bg == "dark" and "#000000" or palette[bg].bg}),
                        -- NormalNC({theme.NormalNC, bg = bg == 'dark' and '#2d2929' or palette[bg].bg}),
                        -- NormalNC({theme.NormalNC, bg = bg == 'dark' and '#1f1d1d' or palette[bg].bg.da(10)}),
                        NormalNC({theme.NormalNC, bg = bg == "dark" and "#262323" or palette[bg].bg.da(10)}),
                        TermCursor({cterm = "reverse", gui = "reverse"}),
                        Cursor({theme.Cursor, bg = bg == "dark" and "#ffffff" or "#000000"}),
                        FloatBorder({theme.FloatBorder, bg = theme.NormalFloat.bg}),
                        FloatTitle({theme.FloatTitle, bg = theme.NormalFloat.bg}),
                        Special({theme.Special, gui = "normal"}),
                        Statement({theme.Statement, gui = "normal"}),
                        Directory({theme.Directory, gui = "normal"}),
                        Boolean({
                            theme.Boolean,
                            gui = "bold",
                            fg = active_colorscheme == "rosebones" and palette[bg].rose or theme.Boolean.fg,
                        }),
                        SnippetTabStop({theme.SnippetTabStop, bg = theme.Normal.bg}),
                        Function({
                            theme.Function,
                            fg = bg == "dark" and palette.dark.bg.li(58) or
                                palette.light.bg.sa(20).da(60),
                        }),
                        TodoBgTODO({theme.TodoBgTODO, bg = palette[bg].water, fg = palette[bg].fg}),
                        TodoFgTODO({theme.TodoFgTODO, fg = palette[bg].water}),
                        -- Statusline
                        StatusLine({theme.StatusLine, bg = statusline_bg}),
                    }
                end)

                lush.apply(lush.compile(specs))

                if (active_colorscheme == "rosebones") then
                    vim.api.nvim_set_hl(0, "@tag.tsx", {link = "Function"})
                    vim.api.nvim_set_hl(0, "@tag.builtin.tsx", {link = "Function"})
                end
            end,
        })
    end,
}
