local sidekick_desc = Utils.plugin_keymap_desc("Sidekick")
local default_ai_tool = vim.env.DEFAULT_AI_CLI or "opencode"

-- Sends `msg` to a running agent of any tool, picked from all of them. With no
-- agent running, starts the default tool instead.
local function send_to_running(msg)
    return function()
        local Cli = require("sidekick.cli")
        -- Render before the picker opens, since it ends visual mode and the selection with it
        local rendered, text = Cli.render({msg = msg})
        if rendered == "" or not text then
            return
        end
        if #require("sidekick.cli.state").get({started = true}) == 0 then
            return Cli.send({text = text, name = default_ai_tool})
        end
        require("sidekick.cli.ui.select").select({
            filter = {started = true},
            cb = function(state)
                if state then
                    Cli.send({text = text, filter = {session = state.session.id}})
                end
            end,
        })
    end
end

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
        dependencies = {
            {dir = vim.fn.stdpath("config") .. "/local-plugins/sidekick-rex.nvim", name = "sidekick-rex.nvim"},
        },
        ---@type sidekick.Config
        opts = {
            nes = {
                enabled = false,
            },
            cli = {
                mux = {
                    enabled = true,
                    backend = vim.env.REX_SESSION and vim.env.REX_BLOCK and "rex" or "tmux",
                    -- Rex has its own layout options below, since it can't run agents in a Neovim terminal
                    create = "terminal",
                },
            },
        },
        config = function(_, opts)
            -- Must come first: it lets sidekick accept "rex" as a backend
            require("sidekick-rex").setup({create = "window", split = {side = "right", ratio = 40}})
            require("sidekick").setup(opts)
        end,
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
                send_to_running("{this}"),
                mode = {"x", "n"},
                desc = sidekick_desc("Send this"),
            },
            {
                "<leader>af",
                send_to_running("{file}"),
                desc = sidekick_desc("Send file"),
            },
            {
                "<leader>av",
                send_to_running("{selection}"),
                mode = {"x"},
                desc = sidekick_desc("Send visual selection content"),
            },
            {
                "<leader>ad",
                send_to_running("{diagnostics}"),
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
