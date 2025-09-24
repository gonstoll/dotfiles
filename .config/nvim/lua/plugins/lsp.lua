return {
    {"neovim/nvim-lspconfig"},

    {
        "b0o/SchemaStore.nvim",
        -- Loaded by jsonls when needed.
        version = false,
        lazy = true,
    },

    {
        "mason-org/mason.nvim",
        build = ":MasonUpdate",
        event = "VeryLazy",
        opts = {
            ui = {border = "single"},
            ensure_installed = {
                "js-debug-adapter",
                "black",
                "gofumpt",
                "stylua",
            },
        },
        config = function(_, opts)
            require("mason").setup(opts)
            local mr = require("mason-registry")
            mr:on("package:install:success", function()
                vim.defer_fn(function()
                    -- trigger FileType event to possibly load this newly installed LSP server
                    require("lazy.core.handler.event").trigger({
                        event = "FileType",
                        buf = vim.api.nvim_get_current_buf(),
                    })
                end, 100)
            end)

            mr.refresh(function()
                for _, tool in ipairs(opts.ensure_installed) do
                    local p = mr.get_package(tool)
                    if not p:is_installed() then
                        p:install()
                    end
                end
            end)
        end,
    },

    {
        "mason-org/mason-lspconfig.nvim",
        event = "VeryLazy",
        opts = {
            ensure_installed = {
                "tailwindcss",
                "cssls",
                "lua_ls",
                "eslint",
                "bashls",
                "vtsls",
                "jsonls",
                "yamlls",
                "bashls",
                "gopls",
                "basedpyright",
                "copilot",
                "cssmodules_ls",
                "css_variables",
                "stylelint_lsp",
            },
            automatic_installation = true,
            automatic_enable = false,
        },
    },

    {
        "j-hui/fidget.nvim",
        event = "LspAttach",
        opts = {
            notification = {
                window = {
                    border = "single",
                    winblend = 0,
                },
            },
        },
    },
}
