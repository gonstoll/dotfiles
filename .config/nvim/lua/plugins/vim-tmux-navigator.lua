-- Outside tmux, vim-rex-navigator takes these keys instead
return {
    "christoomey/vim-tmux-navigator",
    cond = vim.env.TMUX ~= nil,
    cmd = {
        "TmuxNavigateLeft",
        "TmuxNavigateDown",
        "TmuxNavigateUp",
        "TmuxNavigateRight",
        "TmuxNavigatorProcessList",
    },
    keys = {
        {mode = "n", "<c-h>", "<cmd>TmuxNavigateLeft<cr>"},
        {mode = "n", "<c-j>", "<cmd>TmuxNavigateDown<cr>"},
        {mode = "n", "<c-k>", "<cmd>TmuxNavigateUp<cr>"},
        {mode = "n", "<c-l>", "<cmd>TmuxNavigateRight<cr>"},
        {mode = "t", "<c-h>", "<C-w><cmd>TmuxNavigateLeft<cr>"},
        {mode = "t", "<c-j>", "<C-w><cmd>TmuxNavigateDown<cr>"},
        {mode = "t", "<c-k>", "<C-w><cmd>TmuxNavigateUp<cr>"},
        {mode = "t", "<c-l>", "<C-w><cmd>TmuxNavigateRight<cr>"},
    },
    init = function()
        vim.g.tmux_navigator_no_mappings = 1
    end,
}
