return {
    "hrsh7th/nvim-cmp",
    event = "VeryLazy",
    enabled = not vim.g.blink_enabled,
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/cmp-emoji",
        {"onsails/lspkind-nvim", config = false},
        {
            "garymjr/nvim-snippets",
            opts = {search_paths = {vim.fn.stdpath("config") .. "/snippets/nvim"}},
            keys = {
                {
                    "<Tab>",
                    function()
                        if vim.snippet.active({direction = 1}) then
                            vim.schedule(function()
                                vim.snippet.jump(1)
                            end)
                            return
                        end
                        return "<Tab>"
                    end,
                    expr = true,
                    silent = true,
                    mode = "i",
                },
                {
                    "<Tab>",
                    function()
                        vim.schedule(function()
                            vim.snippet.jump(1)
                        end)
                    end,
                    expr = true,
                    silent = true,
                    mode = "s",
                },
                {
                    "<S-Tab>",
                    function()
                        if vim.snippet.active({direction = -1}) then
                            vim.schedule(function()
                                vim.snippet.jump(-1)
                            end)
                            return
                        end
                        return "<S-Tab>"
                    end,
                    expr = true,
                    silent = true,
                    mode = {"i", "s"},
                },
            },
        },
    },
    config = function()
        local cmp = require("cmp")
        local lspkind = require("lspkind")
        local cmp_select_opts = {behavior = cmp.SelectBehavior.Select}

        cmp.setup({
            snippet = {
                expand = function(args)
                    vim.snippet.expand(args.body)
                end,
            },
            preselect = cmp.PreselectMode.None,
            completion = {
                completeopt = "menu,menuone,noinsert,noselect",
            },
            window = {
                documentation = {
                    max_width = math.floor(vim.o.columns * 0.4),
                    max_height = math.floor(vim.o.lines * 0.5),
                    border = "none",
                },
            },
            mapping = {
                ["<CR>"] = cmp.mapping.confirm({select = false, behavior = cmp.ConfirmBehavior.Insert}),
                ["<C-e>"] = cmp.mapping.abort(),
                ["<C-u>"] = cmp.mapping.scroll_docs(-4),
                ["<C-d>"] = cmp.mapping.scroll_docs(4),
                ["<Up>"] = cmp.mapping.select_prev_item(cmp_select_opts),
                ["<Down>"] = cmp.mapping.select_next_item(cmp_select_opts),
                ["<C-p>"] = cmp.mapping.select_prev_item(cmp_select_opts),
                ["<C-n>"] = cmp.mapping.select_next_item(cmp_select_opts),
                ["<C-y>"] = cmp.mapping.complete({reason = "auto"}),
            },
            sources = cmp.config.sources({
                {name = "lazydev", group_index = 0},
                {
                    name = "snippets",
                    keyword_length = 3,
                    entry_filter = function()
                        local ctx = require("cmp.config.context")
                        local in_string = ctx.in_syntax_group("String") or ctx.in_treesitter_capture("string")
                        local in_comment = ctx.in_syntax_group("Comment") or ctx.in_treesitter_capture("comment")
                        return not in_string and not in_comment
                    end,
                },
                {
                    name = "nvim_lsp",
                    keyword_length = 2,
                    max_item_count = 50,
                    entry_filter = function(entry, ctx)
                        return require("cmp.types").lsp.CompletionItemKind[entry:get_kind()] ~= "Text"
                    end,
                },
            }, {
                {name = "buffer", keyword_length = 3, max_item_count = 20},
                {name = "path"},
                {name = "emoji"},
            }),
            formatting = {
                format = lspkind.cmp_format({
                    mode = "symbol_text",
                }),
                fields = {"abbr", "kind"}, -- Remove 'menu' to avoid truncation
            },
        })

        cmp.setup.cmdline({"/", "?"}, {
            mapping = cmp.mapping.preset.cmdline(),
            sources = {
                {name = "buffer"},
            },
        })

        cmp.setup.cmdline(":", {
            mapping = cmp.mapping.preset.cmdline(),
            sources = cmp.config.sources({
                {name = "path"},
            }, {
                {name = "cmdline"},
            }),
        })
    end,
}
