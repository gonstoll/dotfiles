vim.opt.tabstop = 4
vim.opt.shiftwidth = 4

vim.keymap.set('n', '<leader>pr', function()
    local filepath = vim.fn.expand('%')
    local cmd = 'python3 ' .. filepath
    vim.cmd.new()
    vim.cmd.wincmd('J') -- Move to the window below
    vim.api.nvim_win_set_height(0, 12)
    vim.wo.winfixheight = true
    vim.cmd.term(cmd)
    -- Open terminal window, execute file and keep terminal open
    -- vim.cmd.term('sh -c "' .. cmd .. '; exec $SHELL"')
end, {desc = ''})
