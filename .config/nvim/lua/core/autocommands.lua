local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

autocmd({"FileType", "BufEnter"}, {
    desc = "Wrap text on text files",
    group = augroup("WrapText", {}),
    callback = function()
        local filetypes_with_wrap = {"markdown", "octo"}
        if vim.tbl_contains(filetypes_with_wrap, vim.bo.filetype) then
            vim.opt_local.wrap = true
            vim.opt_local.linebreak = true
        else
            vim.opt_local.wrap = false
            vim.opt_local.linebreak = false
        end
    end,
})

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

        vim.keymap.set("n", "<leader>ol", function()
            -- Find title, remove date prefix (YYYY_MM_DD_), and replace underscores with spaces
            vim.cmd(
                [[g/^# \d\{4}_\d\{2}_\d\{2}_/s/^# \d\{4}_\d\{2}_\d\{2}_\(.*\)/\=substitute("# " . submatch(1), "_", " ", "g")/]])
        end, {desc = "Format note title"})
    end,
})

autocmd("FileType", {
    callback = function(args)
        local buf, filetype = args.buf, args.match

        local language = vim.treesitter.language.get_lang(filetype)
        if not language then return end

        -- check if parser exists and load it
        if not vim.treesitter.language.add(language) then return end
        -- enables syntax highlighting and other treesitter features
        vim.treesitter.start(buf, language)

        -- enables treesitter based folds
        -- for more info on folds see `:help folds`
        vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
        vim.wo.foldmethod = "expr"

        -- enables treesitter based indentation
        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end,
})
