local duck_desc = Utils.plugin_keymap_desc("duck")
local cel_desc = Utils.plugin_keymap_desc("CellularAutomaton")
local i18n_desc = Utils.plugin_keymap_desc("i18n")

return {
    {
        "gonstoll/duck.nvim",
        keys = {
            {"<leader>,dd", function() require("duck").hatch("🐈") end, desc = duck_desc("Hatch")},
            {"<leader>,dk", function() require("duck").cook() end, mode = "n", desc = duck_desc("Cook")},
        },
    },

    {
        "eandrju/cellular-automaton.nvim",
        keys = {
            {"<leader>,fml", "<cmd>CellularAutomaton make_it_rain<CR>", desc = cel_desc("Make it rain")},
        },
    },

    {
        "marcussimonsen/let-it-snow.nvim",
        keys = {
            {"<leader>,lis", "<cmd>CellularAutomaton make_it_rain<CR>", desc = cel_desc("Make it rain")},
        },
        opts = {},
    },

    {
        "chrisgrieser/nvim-early-retirement",
        config = true,
        event = "VeryLazy",
    },

    {
        "gonstoll/i18n.nvim",
        keys = {
            {"<leader>io", function() require("i18n").toggle_origin() end, desc = i18n_desc("Toggle origin")},
            {"<leader>is", function() require("i18n").set_show_mode("both") end, desc = i18n_desc("Show translation")},
            {"<leader>it", function() require("i18n").toggle_translation() end, desc = i18n_desc("Toggle translation")},
            {"<leader>id", function() require("i18n").i18n_definition() end, desc = i18n_desc("Go to translation definition")},
            {"<leader>iu", function() require("i18n").i18n_key_usages() end, desc = i18n_desc("Key usages")},
            {"<leader>if", function() require("i18n").show_i18n_keys_with_fzf() end, desc = i18n_desc("Search keys")},
        },
        opts = {
            locales = {"en", "es-LA"},
            sources = {
                "apps/translations/locales/{locales}.json",
                "apps/app-employee/src/locales/{locales}.json",
            },
            func_pattern = {
                "t",
                "$t",
                "i18nextTranslate",
                "$i18nextTranslate",
            },
            usage = {
                popup_type = "fzf-lua",
                notify_no_key = false,
            },
            i18n_keys = {
                popup_type = "fzf-lua",
                value_key = "message",
            },
        },
        config = function(_, opts)
            require("i18n").setup(opts)

            -- Add i18n source to blink. Lazy loaded as it needs to parse big files
            local blink = require("blink.cmp")
            local blink_config = require("blink.cmp.config")

            blink.add_source_provider("i18n", {
                name = "i18n",
                module = "i18n.integration.blink_source",
                opts = {},
                async = true,
                min_keyword_length = 3,
                max_items = 20,
            })
            -- ---@diagnostic disable-next-line: param-type-mismatch
            -- blink_config.sources.default = vim.list_extend(blink_config.sources.default, {"i18n"})
            blink_config.sources.default = {"i18n"}
        end,
    },
}
