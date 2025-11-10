local desc = Utils.plugin_keymap_desc("obsidian")

return {
    "obsidian-nvim/obsidian.nvim",
    version = "*",
    event = {
        "BufReadPre " .. vim.fn.expand("~") .. "/notes/obsidian/gonzalo_notes/*.md",
    },
    cmd = "Obsidian",
    keys = {
        {"<leader>on", ":Obsidian new_from_template<CR>", desc = desc("New note from template")},
        {"<leader>ot", ":Obsidian template note<CR>", desc = desc("Apply default template on note")},
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
}
