-- Add `t_RB` so that neovim detect background
-- https://github.com/neovim/neovim/issues/17070#issuecomment-1086775760
-- vim.loop.fs_write(2, '\27Ptmux;\27\27]11;?\7\27\\', -1, nil)

_G.Utils = require("utils")

require("core")
require("lsp")
