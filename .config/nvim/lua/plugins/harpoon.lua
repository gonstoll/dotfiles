local desc = Utils.plugin_keymap_desc("harpoon")

local keys = {
    open_menu = "<leader>hh",
    add_to_list = "<leader>ha",
    prev_file = "<S-h>",
    next_file = "<S-l>",
    sel_f1 = "<leader>h1",
    sel_f2 = "<leader>h2",
    sel_f3 = "<leader>h3",
    sel_f4 = "<leader>h4",
    sel_f5 = "<leader>h5",
    sel_f6 = "<leader>h6",
    sel_f7 = "<leader>h7",
    sel_f8 = "<leader>h8",
    sel_f9 = "<leader>h9",
}

return {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = {"nvim-lua/plenary.nvim"},
    keys = {
        {keys.open_menu, desc = desc("Open menu")},
        {keys.add_to_list, desc = desc("Add to list")},
        {keys.prev_file, desc = desc("Previous file")},
        {keys.next_file, desc = desc("Next file")},
        {keys.sel_f1, desc = desc("Select file 1")},
        {keys.sel_f2, desc = desc("Select file 2")},
        {keys.sel_f3, desc = desc("Select file 3")},
        {keys.sel_f4, desc = desc("Select file 4")},
        {keys.sel_f5, desc = desc("Select file 5")},
        {keys.sel_f6, desc = desc("Select file 6")},
        {keys.sel_f7, desc = desc("Select file 7")},
        {keys.sel_f8, desc = desc("Select file 8")},
        {keys.sel_f9, desc = desc("Select file 9")},
    },
    config = function()
        local harpoon = require("harpoon")
        local harpoon_extensions = require("harpoon.extensions")
        harpoon:setup({settings = {save_on_toggle = true, sync_on_ui_close = true}})
        harpoon:extend(harpoon_extensions.builtins.highlight_current_file())
        -- harpoon:extend(extensions.builtins.command_on_nav('UfoEnableFold'))
        harpoon:extend({
            UI_CREATE = function(cx)
                vim.keymap.set(
                    "n",
                    "<C-v>",
                    function() harpoon.ui:select_menu_item({vsplit = true}) end,
                    {desc = desc("Open as vertical split"), buffer = cx.bufnr}
                )
                vim.keymap.set(
                    "n",
                    "<C-x>",
                    function() harpoon.ui:select_menu_item({split = true}) end,
                    {desc = desc("Open as split"), buffer = cx.bufnr}
                )
                vim.keymap.set(
                    "n",
                    "<C-t>",
                    function() harpoon.ui:select_menu_item({tabedit = true}) end,
                    {desc = desc("Open in new tab"), buffer = cx.bufnr}
                )
            end,
        })

        ---@type HarpoonToggleOptions
        local menu_opts = {border = "single"}

        vim.keymap.set("n", keys.open_menu, function() harpoon.ui:toggle_quick_menu(harpoon:list(), menu_opts) end,
            {desc = desc("Open menu")})
        vim.keymap.set("n", keys.add_to_list, function() harpoon:list():add() end, {desc = desc("Add to list")})
        vim.keymap.set("n", keys.prev_file, function() harpoon:list():prev() end, {desc = desc("Previous file")})
        vim.keymap.set("n", keys.next_file, function() harpoon:list():next() end, {desc = desc("Next file")})
        vim.keymap.set("n", keys.sel_f1, function() harpoon:list():select(1) end, {desc = desc("Select file 1")})
        vim.keymap.set("n", keys.sel_f2, function() harpoon:list():select(2) end, {desc = desc("Select file 2")})
        vim.keymap.set("n", keys.sel_f3, function() harpoon:list():select(3) end, {desc = desc("Select file 3")})
        vim.keymap.set("n", keys.sel_f4, function() harpoon:list():select(4) end, {desc = desc("Select file 4")})
        vim.keymap.set("n", keys.sel_f5, function() harpoon:list():select(5) end, {desc = desc("Select file 5")})
        vim.keymap.set("n", keys.sel_f6, function() harpoon:list():select(6) end, {desc = desc("Select file 6")})
        vim.keymap.set("n", keys.sel_f7, function() harpoon:list():select(7) end, {desc = desc("Select file 7")})
        vim.keymap.set("n", keys.sel_f8, function() harpoon:list():select(8) end, {desc = desc("Select file 8")})
        vim.keymap.set("n", keys.sel_f9, function() harpoon:list():select(9) end, {desc = desc("Select file 9")}) -- If I ever have more than 9 tabs open, time to rethink my life choices
    end,
}
