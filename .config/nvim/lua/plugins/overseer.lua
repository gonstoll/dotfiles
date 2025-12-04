local desc = Utils.plugin_keymap_desc("Overseer")

return {
    "stevearc/overseer.nvim",
    cmd = {
        "OverseerOpen",
        "OverseerClose",
        "OverseerToggle",
        "OverseerSaveBundle",
        "OverseerLoadBundle",
        "OverseerDeleteBundle",
        "OverseerRunCmd",
        "OverseerRun",
        "OverseerInfo",
        "OverseerBuild",
        "OverseerQuickAction",
        "OverseerTaskAction",
        "OverseerClearCache",
    },
    ---@type overseer.Config
    opts = {
        dap = false,
        task_list = {
            keymaps = {
                ["<C-h>"] = false,
                ["<C-j>"] = false,
                ["<C-k>"] = false,
                ["<C-l>"] = false,
            },
        },
        form = {
            win_opts = {
                winblend = 0,
            },
        },
        confirm = {
            win_opts = {
                winblend = 0,
            },
        },
        task_win = {
            win_opts = {
                winblend = 0,
            },
        },
    },
    keys = {
        {"<leader>k", "", desc = "+overseer"},
        {
            "<leader>kr",
            function()
                local overseer = require("overseer")

                overseer.run_task({}, function(task)
                    if task then
                        overseer.open({enter = false})
                    end
                end)
            end,
            desc = desc("Run task"),
        },
        {"<leader>kt", "<cmd>OverseerToggle<cr>", desc = desc("Toggle task window")},
        {"<leader>kq", "<cmd>OverseerQuickAction<cr>", desc = desc("Action recent task")},
        {"<leader>ki", "<cmd>OverseerInfo<cr>", desc = desc("Overseer Info")},
        {"<leader>kb", "<cmd>OverseerBuild<cr>", desc = desc("Task builder")},
        {"<leader>ka", "<cmd>OverseerTaskAction<cr>", desc = desc("Task action")},
        {"<leader>kc", "<cmd>OverseerClearCache<cr>", desc = desc("Clear cache")},
    },
}
