vim.api.nvim_create_user_command("ConformDisable", function(args)
    if args.bang then
        -- FormatDisable! will disable formatting just for this buffer
        vim.b.disable_autoformat = true
    else
        vim.g.disable_autoformat = true
    end
end, {desc = "Disable conform-autoformat-on-save", bang = true})

vim.api.nvim_create_user_command("ConformEnable", function()
    vim.b.disable_autoformat = false
    vim.g.disable_autoformat = false
end, {desc = "Re-enable conform-autoformat-on-save"})

return {
    "stevearc/conform.nvim",
    event = {"BufWritePre"},
    cmd = {"ConformInfo"},
    ---@module "conform"
    ---@type conform.setupOpts
    opts = {
        quiet = true,
        formatters_by_ft = {
            typescript = {"prettier"},
            typescriptreact = {"prettier"},
            javascript = {"prettier"},
            javascriptreact = {"prettier"},
            html = {"prettier"},
            css = {"prettier"},
            scss = {"prettier"},
            lua = {"stylua", lsp_format = "prefer"},
            markdown = {"prettier"},
            yaml = {"prettier"},
            graphql = {"prettier"},
            vue = {"prettier"},
            angular = {"prettier"},
            less = {"prettier"},
            flow = {"prettier"},
            sh = {"beautysh"},
            bash = {"beautysh"},
            zsh = {"beautysh"},
            http = {"kulala-fmt"},
            python = {"black"},
            go = {"gofmt"},
            ["_"] = {"trim_whitespace"},
        },
        format_on_save = function(bufnr)
            -- Disable autoformat for files in a certain path
            local bufname = vim.api.nvim_buf_get_name(bufnr)
            if bufname:match("/node_modules/") then
                return
            end

            if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
                return
            end

            ---@type conform.FormatOpts
            return {timeout_ms = 500, lsp_format = Utils.lsp.get_lsp_format(bufnr)}
        end,
        log_level = vim.log.levels.DEBUG,
        formatters = {
            prettier = {
                prepend_args = function()
                    return {
                        "--no-semi",
                        "--single-quote",
                        "--no-bracket-spacing",
                        "--print-width",
                        "80",
                        "--config-precedence",
                        "prefer-file",
                    }
                end,
            },
            beautysh = {
                prepend_args = function()
                    return {"--indent-size", "4", "--force-function-style", "fnpar"}
                end,
            },
        },
    },
}
