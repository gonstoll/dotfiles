local desc = Utils.plugin_keymap_desc("octo")

return {
    "pwntester/octo.nvim",
    cmd = "Octo",
    opts = {
        picker = "fzf-lua",
        enable_builtin = true,
        default_to_projects_v2 = true,
        default_merge_method = "squash",
        picker_config = {
            use_emojis = true,
        },
    },
    keys = {
        {"<leader>q", "", desc = "+octo"},
        {"<leader>qi", "<CMD>Octo issue list<CR>", desc = desc("List GitHub Issues")},
        {"<leader>qI", "<cmd>Octo issue search<CR>", desc = desc("Search Issues")},
        {"<leader>qp", "<CMD>Octo pr list<CR>", desc = desc("List GitHub Pull Requests")},
        {"<leader>qP", "<CMD>Octo pr search<CR>", desc = desc("Search GitHub Pull Requests")},
        {"<leader>qc", "<CMD>tabnew | Octo pr create<CR>", desc = desc("Create GitHub Pull Request")},
        {"<leader>qb", "<CMD>Octo pr browser<CR>", desc = desc("Open Pull Request on browser")},
        {"<leader>qd", "<CMD>Octo discussion list<CR>", desc = desc("List GitHub Discussions")},
        {"<leader>qn", "<CMD>Octo notification list<CR>", desc = desc("List GitHub Notifications")},
        {"<leader>qr", "<cmd>Octo repo list<CR>", desc = desc("List Repos")},
        {"<leader>qS", "<cmd>Octo search<CR>", desc = desc("Search")},
        {
            "<leader>qs",
            function()
                require("octo.utils").create_base_search_command({include_current_repo = true})
            end,
            desc = desc("Search GitHub"),
        },
    },
}
