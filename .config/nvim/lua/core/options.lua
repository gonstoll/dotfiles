vim.cmd("colorscheme rose-pine")

vim.opt.guicursor = "a:block/,a:blinkoff200-blinkon400-Cursor/lCursor"
vim.opt.cursorline = false

vim.opt.clipboard = "unnamedplus"

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.scrolloff = 8
vim.opt.scroll = 10
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.colorcolumn = "120"

vim.opt.signcolumn = "yes"
vim.opt.foldcolumn = "1"
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.foldenable = true
vim.wo.foldmethod = "expr" -- Set foldmethod to expr
vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.fillchars = { fold = " ", foldopen = "", foldsep = " ", foldclose = "" }
vim.opt.diffopt = {
    "internal",
    "filler",
    "closeoff",
    "indent-heuristic",
    "linematch:60",
    "algorithm:histogram",
    "context:20",
    "iwhiteall",
}

vim.opt.swapfile = false
vim.opt.backup = false

vim.opt.wrap = false
vim.opt.textwidth = 80
vim.opt.formatexpr = "v:lua.require'conform'.formatexpr()"

vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.inccommand = "split"

vim.opt.splitright = true
vim.opt.conceallevel = 0

vim.g.markdown_recommended_style = 0 -- see https://www.reddit.com/r/neovim/comments/z2lhyz/comment/ixjb7je
vim.opt.updatetime = 300
vim.opt.mouse = "a"
vim.opt.wildignore:append({ "*/node_modules/*" })
vim.opt.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
-- vim.opt.showtabline = 0

-- Grep format
vim.opt.grepprg = "rg --vimgrep"
vim.opt.grepformat = "%f:%l:%c:%m"

-- Wrap long lines at a character in 'breakat'
-- vim.opt.linebreak = true

-- Don't break lines after a one-letter word
-- vim.cmd('set fo-=1')

-- Avoid comments to continue on new lines
-- vim.opt.formatoptions = vim.o.formatoptions:gsub('cro', '')

-- Keep indentantion on wrapped lines
-- vim.opt.breakindent = true
