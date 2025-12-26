local sidekick_desc = Utils.plugin_keymap_desc("Sidekick")
local default_ai_tool = "opencode"

return {
    {
        "zbirenbaum/copilot.lua",
        cmd = "Copilot",
        opts = {
            filetypes = {
                markdown = true,
                sh = function()
                    if string.match(vim.fs.basename(vim.api.nvim_buf_get_name(0)), "^%.env.*") then
                        -- disable for .env files
                        return false
                    end
                    return true
                end,
            },
            suggestion = {
                enabled = true,
                auto_trigger = true,
                keymap = {
                    accept = "<C-j>",
                    next = "<M-]>",
                    prev = "<M-[>",
                    dismiss = "<C-R>",
                },
            },
        },
    },

    {
        "folke/sidekick.nvim",
        event = "VeryLazy",
        ---@type sidekick.Config
        opts = {
            nes = {
                enabled = false,
            },
            cli = {
                mux = {
                    backend = "tmux",
                    enabled = true,
                    create = "terminal",
                },
            },
        },
        keys = {
            {
                "<tab>",
                function()
                    -- if there is a next edit, jump to it, otherwise apply it if any
                    if not require("sidekick").nes_jump_or_apply() then
                        return "<Tab>" -- fallback to normal tab
                    end
                end,
                expr = true,
                desc = sidekick_desc("Goto/Apply next edit suggestion"),
            },
            {
                "<leader>aa",
                function() require("sidekick.cli").toggle() end,
                desc = sidekick_desc("Toggle CLI"),
            },
            {
                "<leader>as",
                function() require("sidekick.cli").select({name = default_ai_tool}) end,
                -- Or to select only installed tools:
                -- require("sidekick.cli").select({ filter = { installed = true } })
                desc = sidekick_desc("Select CLI"),
            },
            {
                "<leader>aD",
                function() require("sidekick.cli").close() end,
                desc = sidekick_desc("Detach a CLI session"),
            },
            {
                "<leader>at",
                function() require("sidekick.cli").send({msg = "{this}", name = default_ai_tool}) end,
                mode = {"x", "n"},
                desc = sidekick_desc("Send this"),
            },
            {
                "<leader>af",
                function() require("sidekick.cli").send({msg = "{file}", name = default_ai_tool}) end,
                desc = sidekick_desc("Send file"),
            },
            {
                "<leader>av",
                function() require("sidekick.cli").send({msg = "{selection}", name = default_ai_tool}) end,
                mode = {"x"},
                desc = sidekick_desc("Send visual selection content"),
            },
            {
                "<leader>ad",
                function() require("sidekick.cli").send({msg = "{diagnostics}", name = default_ai_tool}) end,
                mode = {"x"},
                desc = sidekick_desc("Send selected diagnostics"),
            },
            {
                "<leader>ap",
                function() require("sidekick.cli").prompt({name = default_ai_tool}) end,
                mode = {"n", "x"},
                desc = sidekick_desc("Select prompt"),
            },
            -- Opencode keybinds
            {
                "<leader>ao",
                function() require("sidekick.cli").toggle({name = "opencode", focus = true}) end,
                desc = sidekick_desc("Toggle opencode"),
            },
        },
    },
}
