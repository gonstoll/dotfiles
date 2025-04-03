local desc = Utils.plugin_keymap_desc("oil")

return {
    "stevearc/oil.nvim",
    dependencies = {
        {"nvim-treesitter/nvim-treesitter"},
        {"nvim-tree/nvim-web-devicons", lazy = true},
    },
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {
        delete_to_trash = true,
        skip_confirm_for_simple_edits = true,
        view_options = {
            show_hidden = true,
            is_always_hidden = function(name, _)
                return vim.startswith(name, ".DS_Store")
            end,
        },
        keymaps = {
            ["<C-h>"] = false, -- Split
            ["<C-l>"] = false, -- refresh
            ["<leader>os"] = "actions.select_split",
            ["<leader>ov"] = "actions.select_vsplit",
            ["<C-g>"] = "actions.refresh",
        },
        float = {padding = 4},
    },
    config = function(_, opts)
        local oil = require("oil")
        oil.setup(opts)
        vim.keymap.set("n", "-", oil.open, {desc = desc("Open parent directory")})
    end,
}
