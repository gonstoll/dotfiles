local desc = Utils.plugin_keymap_desc("TODO comments")

return {
    "folke/todo-comments.nvim",
    dependencies = {"nvim-lua/plenary.nvim"},
    event = "BufReadPre",
    opts = {
        gui_style = {
            fg = "NONE",
            bg = "NONE",
        },
        colors = {
            info = {"DiffText", "#2563EB"},
        },
    },
    config = function(_, opts)
        local todo_comments = require("todo-comments")
        todo_comments.setup(opts)
        vim.keymap.set("n", "]t", function() todo_comments.jump_next() end, {desc = desc("Next todo comment")})
        vim.keymap.set("n", "[t", function() todo_comments.jump_prev() end, {desc = desc("Previous todo comment")})
    end,
}
