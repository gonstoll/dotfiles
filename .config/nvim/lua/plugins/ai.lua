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
        "NickvanDyke/opencode.nvim",
        config = function()
            local desc = Utils.plugin_keymap_desc("Opencode")
            ---@type opencode.Opts
            vim.g.opencode_opts = {}

            -- Required for `opts.auto_reload`
            vim.opt.autoread = true

            -- Recommended keymaps
            vim.keymap.set("n", "<leader>ot", function()
                require("opencode").toggle()
            end, {desc = desc("Toggle opencode")})
            vim.keymap.set("n", "<leader>oA", function()
                require("opencode").ask()
            end, {desc = desc("Ask opencode")})
            vim.keymap.set("n", "<leader>oa", function()
                require("opencode").ask("@cursor: ")
            end, {desc = desc("Ask opencode about this")})
            vim.keymap.set("v", "<leader>oa", function()
                require("opencode").ask("@selection: ")
            end, {desc = desc("Ask opencode about selection")})
            vim.keymap.set("n", "<leader>on", function()
                require("opencode").command("session_new")
            end, {desc = desc("New opencode session")})
            vim.keymap.set("n", "<leader>oy", function()
                require("opencode").command("messages_copy")
            end, {desc = desc("Copy last opencode response")})
            vim.keymap.set("n", "<S-C-u>", function()
                require("opencode").command("messages_half_page_up")
            end, {desc = desc("Messages half page up")})
            vim.keymap.set("n", "<S-C-d>", function()
                require("opencode").command("messages_half_page_down")
            end, {desc = desc("Messages half page down")})
            vim.keymap.set({"n", "v"}, "<leader>os", function()
                require("opencode").select()
            end, {desc = desc("Select opencode prompt")})

            -- Example: keymap for custom prompt
            vim.keymap.set("n", "<leader>oe", function()
                require("opencode").prompt("Explain @cursor and its context")
            end, {desc = desc("Explain this code")})
        end,
    },
}
