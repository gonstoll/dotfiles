return {
    "saghen/blink.cmp",
    version = "1.*",
    event = "InsertEnter",
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
                        {"label", gap = 2},
                        {"kind_icon", gap = 1, "kind"},
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
}
