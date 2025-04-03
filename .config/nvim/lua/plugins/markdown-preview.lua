local desc = Utils.plugin_keymap_desc("markdown preview")

return {
    "iamcco/markdown-preview.nvim",
    build = "cd app && npm install && rm -f package-lock.json && git restore .",
    ft = {"markdown"},
    init = function() vim.g.mkdp_filetypes = {"markdown"} end,
    keys = {
        {"<leader>mp", ":MarkdownPreview<CR>", mode = "n", desc = desc("Preview")},
    },
}
