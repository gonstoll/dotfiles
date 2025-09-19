vim.opt.tabstop = 4
vim.opt.shiftwidth = 3

vim.cmd([[set makeprg=go\ run\ %]])

vim.keymap.set("n", "<leader>gi", ":!go install %<CR>", {desc = "Go: Install current file"})
