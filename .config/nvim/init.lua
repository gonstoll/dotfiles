-- Add `t_RB` so that neovim detect background
-- https://github.com/neovim/neovim/issues/17070#issuecomment-1086775760
-- vim.loop.fs_write(2, '\27Ptmux;\27\27]11;?\7\27\\', -1, nil)

_G.Utils = require("utils")

require("core")
require("lsp")

-- Remove --color flag on fzf opts. Using this until colorscheme adapts
-- to new base16 color introduced in 0.66.0 (https://github.com/junegunn/fzf/releases/tag/v0.66.0)
vim.env.FZF_DEFAULT_OPTS = (vim.env.FZF_DEFAULT_OPTS or ""):gsub("%s*%-%-color%=bw", "")
