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

require('lazy').setup({
  spec = 'plugins',
  change_detection = {
    notify = false,
  },
  install = {
    missing = true,                -- install missing plugins on startup.
    colorscheme = {'rose-pine'},   -- try to load one of these colorschemes when installation
  },
  ui = {
    border = 'rounded',
    size = {
      width = 0.7,
      height = 0.7,
    },
  },
})
