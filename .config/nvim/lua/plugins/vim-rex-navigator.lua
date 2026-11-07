---@param direction "left" | "down" | "up" | "right"
local function navigate(direction)
    return function()
        require("vim-rex-navigator").navigate(direction)
    end
end

-- Under tmux, vim-tmux-navigator takes these keys instead
return {
    "gonstoll/vim-rex-navigator.nvim",
    cond = vim.env.TMUX == nil,
    keys = {
        {mode = {"n", "t"}, "<c-h>", navigate("left")},
        {mode = {"n", "t"}, "<c-j>", navigate("down")},
        {mode = {"n", "t"}, "<c-k>", navigate("up")},
        {mode = {"n", "t"}, "<c-l>", navigate("right")},
    },
}
