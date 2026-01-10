local duck_desc = Utils.plugin_keymap_desc("duck")
local cel_desc = Utils.plugin_keymap_desc("CellularAutomaton")

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
}
