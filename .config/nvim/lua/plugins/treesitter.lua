return {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    version = false,
    dependencies = {
        {"windwp/nvim-ts-autotag", opts = {}},
        {"nvim-treesitter/nvim-treesitter-context", opts = {enable = false}},
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

        vim.api.nvim_create_autocmd("FileType", {
            callback = function(args)
                local buf, filetype = args.buf, args.match

                local language = vim.treesitter.language.get_lang(filetype)
                if not language then return end

                -- check if parser exists and load it
                if not vim.treesitter.language.add(language) then return end
                -- enables syntax highlighting and other treesitter features
                vim.treesitter.start(buf, language)

                -- enables treesitter based folds
                -- for more info on folds see `:help folds`
                vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
                vim.wo.foldmethod = "expr"

                -- enables treesitter based indentation
                vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
            end,
        })
    end,
}
