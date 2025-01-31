return {
    'folke/tokyonight.nvim',
    lazy = true,
    opts = {
        style = 'storm',
        terminal_colors = true,
        styles = {
            comments = {italic = false},
            keywords = {italic = false},
            sidebars = 'dark',
            floats = 'dark',
        },
        on_colors = function(colors)
            colors.bg = '#000000'
        end,
    },
}
