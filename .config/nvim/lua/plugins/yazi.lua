local desc = Utils.plugin_keymap_desc("yazi")

return {
    "mikavilpas/yazi.nvim",
    keys = {
        {"<leader>-", "<cmd>Yazi<cr>", desc = desc("Open yazi at the current file")},
        -- Open in the current working directory
        {"<leader>cw", "<cmd>Yazi cwd<cr>", desc = desc("Open yazi in nvim's working directory")},
        {"<C-up>", "<cmd>Yazi toggle<cr>", desc = desc("Resume the last yazi session")},
    },
    ---@module 'yazi.config'
    ---@type YaziConfig
    opts = {
        open_for_directories = false,
        keymaps = {
            show_help = "<f1>",
            open_file_in_horizontal_split = "os",
            open_file_in_vertical_split = "ov",
            grep_in_directory = "<c-g>",
        },
        highlight_groups = {
            -- hovered_buffer = {bg = 'none', fg = 'none'},
            hovered_buffer_in_same_directory = {bg = "none", fg = "none"},
        },
    },
}
