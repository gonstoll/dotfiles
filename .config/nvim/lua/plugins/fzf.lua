local desc = Utils.plugin_keymap_desc("fzf")

local grep_opts = {
    "rg",
    "--vimgrep",
    "--hidden",
    "--follow",
    "--glob",
    '"!**/.git/*"',
    "--column",
    "--line-number",
    "--no-heading",
    "--color=always",
    "--smart-case",
    "--max-columns=4096",
    "-e",
}

return {
    "ibhagwan/fzf-lua",
    dependencies = {"nvim-tree/nvim-web-devicons"},
    cmd = "FzfLua",
    event = "VeryLazy",
    keys = function()
        local fzf = require("fzf-lua")
        return {
            {"<leader>fo", fzf.buffers, desc = desc("Find opened buffers in current neovim instance")},
            {"<leader>fs", fzf.lgrep_curbuf, desc = desc("Fuzzily search in current buffer")},
            {"<leader>ff", fzf.files, desc = desc("Search files")},
            {"<leader>fg", fzf.grep, desc = desc("Search by grep")},
            {"<leader>fl", fzf.live_grep, desc = desc("Search by live grep")},
            {"<leader>fk", fzf.keymaps, desc = desc("Keymaps")},
            {"<leader>fh", fzf.search_history, desc = desc("Get list of searches")},
            {"<leader>fb", fzf.resume, desc = desc("Resume search")},
            {"<leader>fd", fzf.lsp_document_diagnostics, desc = desc("Get file diagnostics")},
            {"<leader>fr", fzf.lsp_references, desc = desc("Goto References")},
            {"<leader>fy", fzf.lsp_document_symbols, desc = desc("Document Symbols")},
            {"<leader>fw", fzf.lsp_live_workspace_symbols, desc = desc("Workspace Symbols")},
            {"<leader>fG", Utils.fzf.folder_grep, desc = desc("Grep on selected folder")},
        }
    end,
    opts = function()
        local actions = require("fzf-lua.actions")
        local img_previewer ---@type string[]?
        for _, v in ipairs({
            {cmd = "ueberzug", args = {}},
            {cmd = "chafa", args = {"{file}", "--format=symbols"}},
            {cmd = "viu", args = {"-b"}},
        }) do
            if vim.fn.executable(v.cmd) == 1 then
                img_previewer = vim.list_extend({v.cmd}, v.args)
                break
            end
        end

        require("fzf-lua").register_ui_select(function(_, items)
            local min_h, max_h = 0.35, 0.70
            local h = (#items + 4) / vim.o.lines
            if h < min_h then
                h = min_h
            elseif h > max_h then
                h = max_h
            end
            return {
                winopts = {height = h, width = 0.60, row = 0.40},
            }
        end)

        return {
            fzf_colors = true,
            defaults = {
                -- formatter = 'path.filename_first',
                formatter = "path.dirname_first",
            },
            previewers = {
                builtin = {
                    extensions = {
                        ["png"] = img_previewer,
                        ["jpg"] = img_previewer,
                        ["jpeg"] = img_previewer,
                        ["gif"] = img_previewer,
                        ["webp"] = img_previewer,
                    },
                    ueberzug_scaler = "fit_contain",
                },
            },
            winopts = {
                width = 0.60,
                height = 0.9,
                backdrop = 100,
                preview = {
                    layout = "vertical",
                    vertical = "down:45%",
                },
            },
            fzf_opts = {
                ["--tiebreak"] = "begin", -- Proper sort of results (see https://github.com/ibhagwan/fzf-lua/issues/411#issuecomment-1125527931)
                ["--info"] = "default",
                ["--layout"] = "default",
                ["--margin"] = "0,1",
                ["--color"] = "16",
            },
            keymap = {
                builtin = {
                    true,
                    ["<C-d>"] = "preview-page-down",
                    ["<C-u>"] = "preview-page-up",
                },
                fzf = {
                    ["ctrl-d"] = "preview-page-down",
                    ["ctrl-u"] = "preview-page-up",
                    ["ctrl-q"] = "select-all+accept",
                },
            },
            files = {
                cwd_prompt = false,
                prompt = Utils.icons.misc.file .. " ",
                git_icons = true,
                hidden = true,
                follow = true,
                -- rg_opts = [[--color=never --files --hidden --follow -g "!.git"]],
                -- fd_opts = [[--color=never --type f --hidden --follow --exclude .git]],
            },
            grep = {
                cwd_prompt = false,
                prompt = Utils.icons.misc.search .. " ",
                input_prompt = "Grep For ❯ ",
                cmd = table.concat(grep_opts, " "),
                hidden = true,
                follow = true,
                -- actions = {
                --   ['ctrl-q'] = {
                --     fn = actions.file_edit_or_qf, prefix = 'select-all+'
                --   },
                -- },
            },
            buffers = {
                actions = {
                    ["ctrl-x"] = {actions.buf_del, actions.resume},
                },
            },
        }
    end,
}
