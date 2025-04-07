return {
    -- blink.cmp
    {
        "saghen/blink.cmp",
        version = "*",
        event = "InsertEnter",
        enabled = vim.g.blink_enabled,
        ---@module 'blink.cmp'
        ---@type blink.cmp.Config
        opts = {
            keymap = {
                preset = "enter",
                ["<C-y>"] = {"show", "show_documentation", "hide_documentation"},
                ["<C-u>"] = {"scroll_documentation_up", "fallback"},
                ["<C-d>"] = {"scroll_documentation_down", "fallback"},
            },
            cmdline = {
                enabled = true,
                completion = {
                    menu = {auto_show = true},
                    list = {
                        selection = {preselect = false},
                    },
                },
                keymap = {
                    preset = "enter",
                    ["<C-y>"] = {"show_and_insert"},
                    ["<CR>"] = {"accept_and_enter", "fallback"},
                    ["<Tab>"] = {"select_next", "fallback"},
                    ["<S-Tab>"] = {"select_prev", "fallback"},
                },
            },
            sources = {
                default = {"lsp", "path", "snippets", "buffer", "lazydev"},
                providers = {
                    lazydev = {
                        name = "LazyDev",
                        module = "lazydev.integrations.blink",
                        score_offset = 100, -- show at a higher priority than lsp
                    },
                    lsp = {
                        fallbacks = {"buffer", "path"},
                    },
                    snippets = {
                        name = "Snippets",
                        module = "blink.cmp.sources.snippets",
                        min_keyword_length = 3,
                        opts = {
                            friendly_snippets = false,
                            search_paths = {vim.fn.stdpath("config") .. "/snippets/nvim"},
                        },
                    },
                },
            },
            signature = {
                enabled = true,
                window = {
                    border = "single",
                    max_width = math.floor(vim.o.columns * 0.4),
                    max_height = math.floor(vim.o.lines * 0.5),
                },
            },
            completion = {
                accept = {
                    auto_brackets = {
                        enabled = false,
                    },
                },
                trigger = {
                    show_on_accept_on_trigger_character = false,
                },
                list = {
                    selection = {
                        preselect = false,
                        auto_insert = false,
                    },
                },
                menu = {
                    draw = {
                        treesitter = {"lsp"},
                        columns = {
                            {"label", gap = 2}, {"kind_icon", gap = 1, "kind"},
                        },
                    },
                },
                documentation = {
                    auto_show = true,
                    auto_show_delay_ms = 200,
                    window = {
                        border = "none",
                        max_width = math.floor(vim.o.columns * 0.4),
                        max_height = math.floor(vim.o.lines * 0.5),
                    },
                },
            },
        },
        opts_extend = {"sources.default"},
    },

    -- nvim-cmp
    {
        "hrsh7th/nvim-cmp",
        event = "VeryLazy",
        enabled = not vim.g.blink_enabled,
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
            "hrsh7th/cmp-emoji",
            "garymjr/nvim-snippets",
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
    },
}
