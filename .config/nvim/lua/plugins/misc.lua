local duck_desc = Utils.plugin_keymap_desc("duck")
local cel_desc = Utils.plugin_keymap_desc("CellularAutomaton")

return {
    {
        "gonstoll/duck.nvim",
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

    {
        "chrisgrieser/nvim-early-retirement",
        config = true,
        event = "VeryLazy",
    },

    {
        "obsidian-nvim/obsidian.nvim",
        version = "*",
        event = {
            "BufReadPre " .. vim.fn.expand("~") .. "/notes/obsidian/gonzalo_notes/*.md",
        },
        cmd = "Obsidian",
        keys = {
            {"<leader>on", ":Obsidian new_from_template<CR>"},
            {"<leader>ot", ":Obsidian template note<CR>"},
        },
        ---@module 'obsidian'
        ---@type obsidian.config
        opts = {
            legacy_commands = false,
            ui = {
                -- enable = false,
                ignore_conceal_warn = true,
            },
            completion = {
                blink = true,
                nvim_cmp = false,
            },
            notes_subdir = "new",
            new_notes_location = "notes_subdir",
            workspaces = {
                {
                    name = "personal",
                    path = "~/notes/obsidian/gonzalo_notes/",
                },
            },
            picker = {
                name = "fzf-lua",
            },
            callbacks = {
                -- Make sure I don't have any formatting (not sure if this affects frontmatter)
                enter_note = function()
                    vim.cmd("ConformDisable")
                end,
                leave_note = function()
                    vim.cmd("ConformEnable")
                end,
            },
            note_path_func = function(spec)
                local date = os.date("%Y_%m_%d")
                local title = spec.title and spec.title:gsub(" ", "_"):lower() or ""
                local filename = date .. "_" .. title .. ".md"
                return filename
            end,
            open_notes_in = "vsplit",
            templates = {
                subdir = "templates",
                date_format = "%Y-%m-%d",
                time_format = "%H:%M:%S",
            },
            frontmatter = {
                enabled = false,
            },
            daily_notes = {
                folder = "dailies",
                date_format = "%Y-%m-%d",
                template = "note",
            },
        },
    },
}
