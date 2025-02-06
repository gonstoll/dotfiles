local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Highlight yanked text
autocmd('TextYankPost', {
    desc = 'Highlight yanked text',
    group = augroup('YankHighlight', {}),
    callback = function()
        vim.highlight.on_yank()
    end,
})

-- Disable eslint on node_modules
autocmd({'BufNewFile', 'BufRead'}, {
    pattern = {'**/node_modules/**', 'node_modules', '/node_modules/*'},
    group = augroup('DisableEslintOnNodeModules', {}),
    callback = function()
        vim.diagnostic.disable(0)
    end,
})

-- Fugitive keymaps
autocmd('BufWinEnter', {
    pattern = 'fugitive',
    group = augroup('Fugitive', {}),
    callback = function()
        if (vim.bo.filetype ~= 'fugitive') then
            return
        end

        -- Only run this on fugitive buffers
        local bufnr = vim.api.nvim_get_current_buf()
        vim.keymap.set('n', '<leader>P', function()
            vim.cmd.Git('push')
        end, {buffer = bufnr, remap = false, desc = 'Fugitive: Push'})
        vim.keymap.set('n', '<leader>p', function()
            vim.cmd.Git('pull')
        end, {buffer = bufnr, remap = false, desc = 'Fugitive: Pull'})
    end,
})

-- Make sure any opened buffer which is contained in a git repo will be tracked
-- vim.cmd('autocmd BufEnter * :lua require("lazygit.utils").project_root_dir()')

-- Statusline
local statusline_group = augroup('StatusLine', {})
autocmd({'WinEnter', 'BufEnter'}, {
    pattern = '*',
    group = statusline_group,
    callback = function()
        if (vim.bo.filetype == 'oil') then
            vim.o.statusline = "%!v:lua.require('statusline').oil()"
            return
        end
        vim.o.statusline = "%!v:lua.require('statusline').active()"
    end,
})

autocmd({'WinLeave', 'BufLeave'}, {
    pattern = '*',
    group = statusline_group,
    callback = function()
        vim.o.statusline = "%!v:lua.require('statusline').inactive()"
    end,
})

autocmd('TermOpen', {
    group = augroup('custom-term-open', {}),
    callback = function()
        vim.opt_local.number = false
        vim.opt_local.relativenumber = false
        vim.opt_local.scrolloff = 0
    end,
})

autocmd('FileType', {
    pattern = '*',
    group = augroup('diable-new-line-comments', {}),
    callback = function()
        vim.opt_local.formatoptions:remove('o')
        vim.opt_local.formatoptions:remove('r')
        vim.opt_local.formatoptions:remove('c')
    end,
})

autocmd('BufWritePost', {
    pattern = 'aerospace.toml',
    group = augroup('Aerospace', {}),
    command = '!aerospace reload-config',
})

autocmd('BufWritePost', {
    pattern = '*',
    group = augroup('FileDetect', {}),
    desc = 'Detect filetype on files with on extension after saving the file',
    callback = function()
        if vim.bo.filetype == '' then
            vim.cmd('filetype detect')
        end
    end,
})

-- Redir
vim.api.nvim_create_user_command('Redir', Utils.redir.redir, {
    nargs = '+',
    complete = 'command',
    range = true,
    bang = true,
})

vim.api.nvim_create_user_command('EvalFile', function(args)
    local bang = args.bang
    Utils.redir.evaler('%')(bang)
end, {bar = true, bang = true})

vim.api.nvim_create_user_command('EvalLine', function(args)
    local bang = args.bang
    Utils.redir.evaler('.')(bang)
end, {bar = true, bang = true})

vim.api.nvim_create_user_command('EvalRange', function(args)
    local bang = args.bang
    Utils.redir.evaler("'<,'>")(bang)
end, {bar = true, bang = true, range = true})
