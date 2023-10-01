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

-- Disable commenting new lines
vim.cmd('autocmd BufEnter * set formatoptions-=cro')
vim.cmd('autocmd BufEnter * setlocal formatoptions-=cro')

-- Make sure any opened buffer which is contained in a git repo will be tracked
vim.cmd('autocmd BufEnter * :lua require("lazygit.utils").project_root_dir()')
