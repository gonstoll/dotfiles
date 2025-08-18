return {
    "folke/tokyonight.nvim",
    lazy = true,
    opts = {
        style = "night",
        on_highlights = function(hl, colors)
            local is_dark = vim.o.background == "dark"
            if is_dark then
                hl.Normal = {bg = "#000000"}
                hl.FoldColumn = {bg = "none"}
                hl.SignColumn = {bg = "none"}
                hl.Cursor = {bg = "#ffffff"}
                hl.StatusLine = {bg = "none"}
            end
        end,
    },
}
