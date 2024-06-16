vim.loop.fs_write(2, '\27Ptmux;\27\27]11;?\7\27\\', -1, nil)

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_bufsettings = 'noma nomod nu nobl nowrap ro'
vim.g.netrw_localrmdir = 'rm -rf'

vim.opt.termguicolors = true
