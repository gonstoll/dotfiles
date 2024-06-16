local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(vim.env.LAZY or lazypath)

require('lazy').setup('plugins', {
  change_detection = {
    notify = false,
    enabled = true,
  },
  install = {
    colorscheme = {'kanagawa'},
  },
  performance = {
    cache = {enabled = true},
  },
  ui = {
    border = 'rounded',
    size = {
      width = 0.7,
      height = 0.7,
    },
  },
})
