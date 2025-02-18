return {
    {"onsails/lspkind-nvim", config = false, enabled = vim.g.cmp_enable, lazy = true},

    {
        "b0o/SchemaStore.nvim",
        -- Loaded by jsonls when needed.
        version = false,
        lazy = true,
    },

    {
        "williamboman/mason.nvim",
        build = ":MasonUpdate",
        opts = {
            ui = {border = "single"},
        },
    },

    {
        "williamboman/mason-lspconfig.nvim",
        event = "VeryLazy",
        opts = {
            ensure_installed = {
                "tailwindcss",
                "cssls",
                "lua_ls",
                "eslint",
                "emmet_language_server",
                "ts_ls",
                "bashls",
                "vtsls",
                "jsonls",
                "yamlls",
                "bashls",
                "gopls",
                "basedpyright",
            },
            automatic_installation = true,
        },
    },

    {
        "j-hui/fidget.nvim",
        event = "LspAttach",
        opts = {
            notification = {
                window = {
                    winblend = 1,
                    normal_hl = "NormalFloat",
                },
            },
        },
    },
}
