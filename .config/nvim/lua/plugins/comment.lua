return {
    "numToStr/Comment.nvim",
    event = "VeryLazy",
    dependencies = {"JoosepAlviste/nvim-ts-context-commentstring"},
    init = function()
        vim.g.skip_ts_context_commentstring_module = true
    end,
    config = function()
        local comment = require("Comment")
        local comment_string = require("ts_context_commentstring")
        comment.setup({
            pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
        })
        comment_string.setup()
    end,
}
