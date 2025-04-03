local duck_desc = Utils.plugin_keymap_desc("duck")
local cel_desc = Utils.plugin_keymap_desc("CellularAutomaton")

return {
    {
        "tamton-aquib/duck.nvim",
        keys = {
            {",dd", function() require("duck").hatch("🐈") end, desc = duck_desc("Hatch")},
            {",dk", function() require("duck").cook() end, mode = "n", desc = duck_desc("Cook")},
        },
    },

    {
        "eandrju/cellular-automaton.nvim",
        keys = {
            {",fml", "<cmd>CellularAutomaton make_it_rain<CR>", desc = cel_desc("Make it rain")},
        },
    },

    {
        "marcussimonsen/let-it-snow.nvim",
        cmd = "LetItSnow",
        opts = {},
    },
}
