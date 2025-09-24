local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local methods = vim.lsp.protocol.Methods
local virtual_lines_enabled = false

---@param client vim.lsp.Client
---@param bufnr integer
local function on_attach(client, bufnr)
    ---@param mode string|string[] -- Vim mode
    ---@param keys string -- Key sequence
    ---@param func fun() -- Function to execute
    ---@param desc? string -- Keymap description
    local function keyset(mode, keys, func, desc)
        vim.keymap.set(mode, keys, func, {buffer = bufnr, desc = "LSP: " .. desc})
    end

    keyset("n", "<leader>rn", vim.lsp.buf.rename, "Rename")
    keyset({"n", "v"}, "<leader>ca", vim.lsp.buf.code_action, "Code Action")
    keyset("n", "<leader>td", vim.lsp.buf.type_definition, "Type Definition")
    keyset("n", "<leader>sd", vim.lsp.buf.signature_help, "Signature Documentation")
    keyset("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, "Workspace Add Folder")
    keyset("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, "Workspace Remove Folder")
    keyset("n", "K", vim.lsp.buf.hover, "Hover Documentation")
    -- keyset("n", "gr", vim.lsp.buf.references, "Go to references")
    keyset("n", "gd", Utils.cmd_center(vim.lsp.buf.definition), "Go to Definition")
    keyset("n", "gD", Utils.cmd_center(vim.lsp.buf.declaration), "Go to Declaration")
    keyset("n", "<leader>gd", function()
        vim.cmd(":vsplit | lua vim.lsp.buf.definition()")
    end, "Go to definition (split)")
    keyset("n", "<leader>Gd", function()
        vim.cmd(":belowright split | lua vim.lsp.buf.definition()")
    end, "Go to definitio (vsplit)")
    keyset("n", "gi", Utils.cmd_center(vim.lsp.buf.implementation), "Go to Implementation")
    keyset("n", "[d", Utils.cmd_center(vim.diagnostic.goto_prev), "Previous diagnostic")
    keyset("n", "]d", Utils.cmd_center(vim.diagnostic.goto_next), "Next diagnostic")
    keyset("n", "[e", Utils.cmd_center(function()
        vim.diagnostic.goto_prev({severity = "ERROR"})
    end), "Previous diagnostic (error)"
    )
    keyset("n", "]e", Utils.cmd_center(function()
        vim.diagnostic.goto_next({severity = "ERROR"})
    end), "Next diagnostic (error)"
    )
    keyset("n", "gk", vim.diagnostic.open_float, "Open diagnostics")
    keyset("n", "gK", function()
        virtual_lines_enabled = not virtual_lines_enabled
        if virtual_lines_enabled then
            vim.diagnostic.config({virtual_lines = true, virtual_text = false})
        else
            vim.diagnostic.config({virtual_lines = false, virtual_text = true})
        end
    end, "Toggle virtual lines")

    keyset("n", "<leader>it", function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({bufnr = bufnr}))
    end, "Toggle inlay hints")

    keyset("n", "<leader>fa", function()
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
            return
        end
        require("conform").format({lsp_format = Utils.lsp.get_lsp_format(bufnr), async = true})
    end, "Format current buffer with LSP")

    keyset("n", "<leader>lc", function()
        Utils.fzf.inspect_lsp_client()
    end, "Inspect LSP Client configuration")

    -- Create a command `:Format` local to the LSP buffer
    vim.api.nvim_create_user_command("Format", function(args)
        local range = nil
        if args.count ~= -1 then
            local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
            range = {
                start = {args.line1, 0},
                ["end"] = {args.line2, end_line:len()},
            }
        end
        require("conform").format({lsp_format = "fallback", async = true, range = range})
    end, {range = true})

    -- Toggle signature help
    if client:supports_method(methods.textDocument_signatureHelp) then
        keyset("i", "<C-s>", function()
            vim.lsp.buf.signature_help()
        end, "Signature help")
    end

    -- TODO: Uncomment this when v0.12 drops!
    -- https://github.com/neovim/neovim/pull/33440
    -- if client:supports_method("textDocument/documentColor") then
    --     local document_color_enabled = false
    --     keyset("n", "<leader>Ct", function()
    --         vim.lsp.document_color.enable(not document_color_enabled, bufnr)
    --     end, "Toogle colors highlighting")
    -- end

    if client:supports_method(methods.textDocument_documentHighlight) then
        local highlight_enabled = false
        local group_name = "gonstoll/document_highlight"

        local function enable_document_highlight()
            local under_cursor_highlights_group = augroup(group_name, {clear = true})
            autocmd({"CursorHold", "InsertLeave"}, {
                group = under_cursor_highlights_group,
                desc = "Highlight references under the cursor",
                buffer = bufnr,
                callback = vim.lsp.buf.document_highlight,
            })
            autocmd({"CursorMoved", "InsertEnter", "BufLeave"}, {
                group = under_cursor_highlights_group,
                desc = "Clear highlight references",
                buffer = bufnr,
                callback = vim.lsp.buf.clear_references,
            })
            highlight_enabled = true
        end

        local function disable_document_highlight()
            vim.api.nvim_clear_autocmds({group = group_name})
            vim.lsp.buf.clear_references()
            highlight_enabled = false
        end

        local function toggle_document_highlight()
            if highlight_enabled then
                disable_document_highlight()
            else
                enable_document_highlight()
            end
        end
        keyset("n", "<leader>ma", toggle_document_highlight, "Toggle document highlights")
    end
end

vim.diagnostic.config({
    virtual_text = true,
    severity_sort = true,
    underline = true,
    float = {
        border = "single",
        source = true,
        max_width = 100,
    },
})

local hover = vim.lsp.buf.hover
---@diagnostic disable-next-line: duplicate-set-field
vim.lsp.buf.hover = function()
    return hover({
        border = "single",
        -- max_width = 100,
        max_width = math.floor(vim.o.columns * 0.7),
        max_height = math.floor(vim.o.lines * 0.7),
    })
end

local signature_help = vim.lsp.buf.signature_help
---@diagnostic disable-next-line: duplicate-set-field
vim.lsp.buf.signature_help = function()
    return signature_help({
        title = "Signature help",
        border = "single",
        title_pos = "left",
        -- max_width = 100,
        max_width = math.floor(vim.o.columns * 0.4),
        max_height = math.floor(vim.o.lines * 0.5),
    })
end

-- for type, icon in pairs(Utils.icons.diagnostics) do
--     local hl = 'DiagnosticSign' .. type
--     vim.fn.sign_define(hl, {text = icon, texthl = hl, numhl = hl})
-- end

autocmd("LspAttach", {
    group = augroup("lsp-attach", {}),
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)

        -- Just in case y'know
        if not client then
            return
        end

        on_attach(client, args.buf)
    end,
})

-- Configures the LSP servers with (optionally) their configuration and keybinds
autocmd({"BufReadPre", "BufNewFile"}, {
    once = true,
    callback = function()
        local servers = {
            stylelint_lsp = {},
            basedpyright = {},
            tailwindcss = {},
            copilot_ls = {},
            css_variables = {},
            cssmodules_ls = {},
            jsonls = require("lsp.servers.jsonls"),
            yamlls = require("lsp.servers.yamlls"),
            bashls = require("lsp.servers.bashls"),
            cssls = require("lsp.servers.cssls"),
            eslint = require("lsp.servers.eslint"),
            lua_ls = require("lsp.servers.lua_ls"),
            vtsls = require("lsp.servers.vtsls"),
            gopls = require("lsp.servers.gopls"),
        }

        for server, config in pairs(servers) do
            if config then
                vim.lsp.config(server, config)
                if config.keys then
                    for _, key in ipairs(config.keys) do
                        vim.keymap.set("n", key[1], key[2], {desc = key.desc})
                    end
                end
            end
        end

        local server_names = {}
        for server, _ in pairs(servers) do
            table.insert(server_names, server)
        end
        vim.lsp.enable(server_names)
    end,
})
