local theme_names = {
    light = 'kanagawa_light',
    dark = 'kanagawa_dark',
}

return {
    dark = theme_names.dark,
    light = theme_names.light,

    color_schemes = {
        [theme_names.dark] = {
            foreground = '#c5c9c5',
            background = '#000000',

            cursor_bg = '#c8c093',
            cursor_fg = '#c8c093',
            cursor_border = '#c8c093',

            selection_fg = '#c8c093',
            selection_bg = '#2d4f67',

            scrollbar_thumb = '#16161d',
            split = '#16161d',

            ansi = {
                '#0d0c0c', -- black
                '#c4746e', -- red
                '#8a9a7b', -- green
                '#c4b28a', -- yellow
                '#8ba4b0', -- blue
                '#a292a3', -- magenta
                '#8ea4a2', -- cyan
                '#c8c093', -- white
            },

            brights = {
                '#a6a69c', -- black
                '#E46876', -- red
                '#87a987', -- green
                '#E6C384', -- yellow
                '#7FB4CA', -- blue
                '#938AA9', -- magenta
                '#7AA89F', -- cyan
                '#c5c9c5', -- white
            },

            indexed = {[16] = '#b6927b', [17] = '#b98d7b'},
        },

        [theme_names.light] = {
            foreground = '#545464',
            background = '#f0edec',

            cursor_fg = '#f2ecbc',
            cursor_bg = '#43436c',
            cursor_border = '#c8c093',

            selection_fg = '#43436c',
            selection_bg = '#c9cbd1',

            scrollbar_thumb = '#16161d',
            split = '#16161d',

            ansi = {
                '#1f1f28', -- black
                '#c84053', -- red
                '#6f894e', -- green
                '#77713f', -- yellow
                '#4d699b', -- blue
                '#b35b79', -- magenta
                '#597b75', -- cyan
                '#545464', -- white
            },

            brights = {
                '#8a8980', -- black
                '#d7474b', -- red
                '#6e915f', -- green
                '#836f4a', -- yellow
                '#6693bf', -- blue
                '#624c83', -- magenta
                '#5e857a', -- cyan
                '#43436c', -- white
            },

            indexed = {[16] = '#cc6d00', [17] = '#e82424'},
        },
    },
}
