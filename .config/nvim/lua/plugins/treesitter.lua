return {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    version = false,
    dependencies = {
        {"windwp/nvim-ts-autotag", opts = {}},
        {"nvim-treesitter/nvim-treesitter-context", opts = {enable = false, max_lines = 3}},
    },
    cmd = {"TSUpdate", "TSInstall", "TSLog", "TSUninstall"},
    build = ":TSUpdate",
    opts = {
        highlight = {enable = true},
        indent = {enable = true},
        context_commentstring = {
            enable = true,
            enable_autocmd = false,
        },
    },
    config = function(_, opts)
        local TS = require("nvim-treesitter")
        TS.setup(opts)
        TS.install({
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
        })
    end,
}
