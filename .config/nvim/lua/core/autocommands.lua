local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Highlight yanked text
autocmd("TextYankPost", {
    desc = "Highlight yanked text",
    group = augroup("YankHighlight", {}),
    callback = function()
        vim.highlight.on_yank()
    end,
})

-- Disable eslint on node_modules
autocmd({"BufNewFile", "BufRead"}, {
    pattern = {"**/node_modules/**", "node_modules", "/node_modules/*"},
    group = augroup("DisableEslintOnNodeModules", {}),
    callback = function()
        vim.diagnostic.enable(false)
    end,
})

-- Statusline
local statusline_group = augroup("StatusLine", {})
autocmd({"WinEnter", "BufEnter"}, {
    pattern = "*",
    group = statusline_group,
    callback = function()
        if (vim.bo.filetype == "oil") then
            vim.wo.statusline = "%!v:lua.require('statusline').oil()"
            return
        end
        vim.wo.statusline = "%!v:lua.require('statusline').active()"
    end,
})

autocmd({"WinLeave", "BufLeave"}, {
    pattern = "*",
    group = statusline_group,
    callback = function(args)
        local leaving_buf_filetype = vim.api.nvim_get_option_value("filetype", {buf = args.buf})
        if (leaving_buf_filetype == "oil") then
            vim.wo.statusline = "%!v:lua.require('statusline').oil()"
            return
        end
        vim.wo.statusline = "%!v:lua.require('statusline').inactive()"
    end,
})

autocmd("ColorScheme", {
    group = augroup("cursor-highlight", {}),
    callback = function()
        if vim.o.background == "light" then
            vim.cmd("highlight! clear Cursor")
        end
    end,
})

autocmd("TermOpen", {
    group = augroup("custom-term-open", {}),
    callback = function()
        vim.opt_local.number = false
        vim.opt_local.relativenumber = false
        vim.opt_local.scrolloff = 0
    end,
})

autocmd("FileType", {
    pattern = "*",
    group = augroup("diable-new-line-comments", {}),
    callback = function()
        vim.opt_local.formatoptions:remove("o")
        vim.opt_local.formatoptions:remove("r")
        vim.opt_local.formatoptions:remove("c")
    end,
})

autocmd("BufWritePost", {
    pattern = "aerospace.toml",
    group = augroup("Aerospace", {}),
    command = "!aerospace reload-config",
})

autocmd("BufWritePost", {
    pattern = "*",
    group = augroup("FileDetect", {}),
    desc = "Detect filetype on files with on extension after saving the file",
    callback = function()
        if vim.bo.filetype == "" then
            vim.cmd("filetype detect")
        end
    end,
})

-- Redir
vim.api.nvim_create_user_command("Redir", Utils.redir.redir, {
    nargs = "+",
    complete = "command",
    range = true,
    bang = true,
})

vim.api.nvim_create_user_command("EvalFile", function(args)
    local bang = args.bang
    Utils.redir.evaler("%")(bang)
end, {bar = true, bang = true})

vim.api.nvim_create_user_command("EvalLine", function(args)
    local bang = args.bang
    Utils.redir.evaler(".")(bang)
end, {bar = true, bang = true})

vim.api.nvim_create_user_command("EvalRange", function(args)
    local bang = args.bang
    Utils.redir.evaler("'<,'>")(bang)
end, {bar = true, bang = true, range = true})
