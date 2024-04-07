local ag = vim.api.nvim_create_augroup
local au = vim.api.nvim_create_autocmd

-- Highlight yanked text
local highlight_group = ag('YankHighlight', {clear = true})
au('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- Disable eslint on node_modules
local disable_node_modules_eslint_group = ag('DisableEslintOnNodeModules', {clear = true})
au({'BufNewFile', 'BufRead'}, {
  pattern = {'**/node_modules/**', 'node_modules', '/node_modules/*'},
  callback = function()
    vim.diagnostic.disable(0)
  end,
  group = disable_node_modules_eslint_group,
})

-- Fugitive keymaps
local fugitive_group = ag('Fugitive', {})
au('BufWinEnter', {
  group = fugitive_group,
  pattern = '*',
  callback = function()
    if (vim.bo.filetype ~= 'fugitive') then
      return
    end

    -- Only run this on fugitive buffers
    local bufnr = vim.api.nvim_get_current_buf()
    vim.keymap.set('n', '<leader>p', function()
      vim.cmd.Git('push')
    end, {buffer = bufnr, remap = false, desc = 'Fugitive: Push'})
    vim.keymap.set('n', '<leader>P', function()
      vim.cmd.Git('pull')
    end, {buffer = bufnr, remap = false, desc = 'Fugitive: Pull'})
  end,
})

-- Disable commenting new lines
vim.cmd('autocmd BufEnter * set formatoptions-=cro')
vim.cmd('autocmd BufEnter * setlocal formatoptions-=cro')

-- Make sure any opened buffer which is contained in a git repo will be tracked
vim.cmd('autocmd BufEnter * :lua require("lazygit.utils").project_root_dir()')

-- Statusline
local statusline_group = ag('StatusLine', {})
au({'WinEnter', 'BufEnter'}, {
  pattern = '*',
  group = statusline_group,
  callback = function()
    if (vim.bo.filetype == 'oil') then
      vim.cmd('setlocal statusline=%!v:lua.Statusline.oil()')
      return
    end
    vim.cmd('setlocal statusline=%!v:lua.Statusline.active()')
  end,
})

au({'WinLeave', 'BufLeave'}, {
  pattern = '*',
  group = statusline_group,
  callback = function()
    vim.cmd('setlocal statusline=%!v:lua.Statusline.inactive()')
  end,
})
