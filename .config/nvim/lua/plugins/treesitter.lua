return {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    dependencies = {
        {"windwp/nvim-ts-autotag", opts = {}},
        {"nvim-treesitter/nvim-treesitter-context", opts = {enable = false}},
    },
    cmd = {"TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo"},
    build = ":TSUpdate",
    lazy = vim.fn.argc(-1) == 0,
    config = function()
        local configs = require("nvim-treesitter.configs")
        local parsers = require("nvim-treesitter.parsers")

        configs.setup({
            ensure_installed = {
                "bash",
                "css",
                "diff",
                "dockerfile",
                "go",
                "gomod",
                "gowork",
                "graphql",
                "html",
                "javascript",
                "jsdoc",
                "json",
                "json5",
                "lua",
                "markdown",
                "markdown_inline",
                "php",
                "prisma",
                "python",
                "regex",
                "rust",
                "scss",
                "sql",
                "tsx",
                "typescript",
                "vim",
                "vimdoc",
                "yaml",
                "toml",
            },
            highlight = {enable = true},
            indent = {enable = true},
            context_commentstring = {
                enable = true,
                enable_autocmd = false,
            },
            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = "<leader>ti",
                    scope_incremental = "<leader>ts",
                    node_incremental = "v",
                    node_decremental = "V",
                },
            },
        })

        local parser_configs = parsers.get_parser_configs()
        parser_configs.tsx.filetype_to_parsername = {"javascript", "typescript.tsx"}
    end,
}
