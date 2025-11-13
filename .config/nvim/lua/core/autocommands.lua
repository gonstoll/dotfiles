local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Highlight yanked text
autocmd("TextYankPost", {
    desc = "Highlight yanked text",
    group = augroup("YankHighlight", {}),
    callback = function()
        vim.hl.on_yank()
    end,
})

-- Statusline
local statusline_group = augroup("StatusLine", {})
autocmd({"WinEnter", "BufEnter"}, {
    pattern = "*",
    group = statusline_group,
    callback = function()
        if vim.bo.filetype == "oil" then
            vim.wo.statusline = "%{%v:lua.require('statusline').setup('oil')%}"
            return
        end
        vim.wo.statusline = "%{%v:lua.require('statusline').setup('active')%}"
    end,
})

autocmd({"WinLeave", "BufLeave"}, {
    pattern = "*",
    group = statusline_group,
    callback = function(args)
        local leaving_buf_filetype = vim.api.nvim_get_option_value("filetype", {buf = args.buf})
        if leaving_buf_filetype == "oil" then
            vim.wo.statusline = "%{%v:lua.require('statusline').setup('oil')%}"
            return
        end
        vim.wo.statusline = "%{%v:lua.require('statusline').setup('inactive')%}"
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

autocmd({"BufRead", "BufNewFile"}, {
    pattern = vim.fn.expand("~") .. "/notes/obsidian/gonzalo_notes/new/*.md",
    group = augroup("GonzaloNotesNew", {}),
    callback = function()
        vim.keymap.set("n", "<leader>ok", function()
            local flushed_dir = "_flushed"
            local target_dir = vim.fn.expand("~") .. "/notes/obsidian/gonzalo_notes/" .. flushed_dir
            if vim.fn.isdirectory(target_dir) == 0 then
                vim.cmd("silent! !mkdir -p " .. target_dir)
            end
            vim.cmd("silent! !mv '%:p' " .. target_dir .. "/'%:t'")
            vim.cmd("bd")
        end, {desc = "Obsidian: Accept note and move it to flushed directory"})

        vim.keymap.set("n", "<leader>od", ":silent! !rm '%:p'<cr>:bd<cr>", {desc = "Obsidian: Discard note"})

        vim.keymap.set("n", "<leader>of", function()
            -- Search for the first heading line
            vim.cmd("/^# 20")
            -- Remove date prefix from the heading
            vim.cmd([[s/^# \d\{4}-\d\{2}-\d\{2}_\(.*\)/# \1/]])
            -- Replace underscores with spaces in the heading
            vim.cmd([[s/_/ /g]])
        end, {desc = "Format note title"})
    end,
})
