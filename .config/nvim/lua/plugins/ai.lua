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
        "CopilotC-Nvim/CopilotChat.nvim",
        cmd = { "CopilotChat" },
        dependencies = { "zbirenbaum/copilot.lua", "nvim-lua/plenary.nvim" },
        opts = { debug = false },
    },

    {
        "yetone/avante.nvim",
        version = false,
        build = "make",
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "stevearc/dressing.nvim",
            "nvim-lua/plenary.nvim",
            "MunifTanjim/nui.nvim",
            "ibhagwan/fzf-lua",
            "nvim-tree/nvim-web-devicons",
            "zbirenbaum/copilot.lua",
        },
        keys = {
            { "<leader>ak", ":AvanteChat<CR>", desc = "Avante: Chat" },
        },
        opts = {
            provider = "gemini",
            windows = {
                postion = "right",
                width = 40,
                sidebar_header = {
                    enabled = true,
                    align = "left",
                    rounded = false,
                },
            },
            file_selector = {
                provider = "fzf",
            },
        },
    },
}
