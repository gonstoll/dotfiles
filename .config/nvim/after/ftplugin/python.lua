vim.opt.tabstop = 4
vim.opt.shiftwidth = 4

vim.keymap.set("n", "<leader>pr", function()
    local filepath = vim.fn.expand("%")
    local py_cmd = "python3 " .. filepath
    local cmd = 'sh -c "' .. py_cmd .. '; exec $SHELL"'
    vim.cmd.new()
    vim.cmd.wincmd("J")
    vim.api.nvim_win_set_height(0, 14)
    vim.wo.winfixheight = true

    -- Open terminal window, execute file and keep terminal open
    vim.cmd.term(cmd)
end, {desc = "Python: Run current file"})
