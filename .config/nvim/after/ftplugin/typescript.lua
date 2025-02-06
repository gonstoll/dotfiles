local ts_utils = require("nvim-treesitter.ts_utils")

---@param key string
local function newline_comment(key)
    local node = ts_utils.get_node_at_cursor()
    if not node then
        return key
    end
    local line = vim.api.nvim_get_current_line():gsub("^%s+", "")
    if string.find(line, "^/?%*") then
        return key .. "*"
    end
    return key
end

vim.keymap.set("n", "o", function() return newline_comment("o") end, {buffer = true, expr = true})
vim.keymap.set("n", "O", function() return newline_comment("O") end, {buffer = true, expr = true})
vim.keymap.set("i", "<cr>", function() return newline_comment("<cr>") end, {buffer = true, expr = true})
