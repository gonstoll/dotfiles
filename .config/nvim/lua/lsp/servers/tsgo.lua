local desc = Utils.plugin_keymap_desc("typescript")

return {
    keys = {
        {
            "<leader>to",
            function()
                vim.lsp.buf.code_action({
                    apply = true,
                    context = {
                        only = {"source.organizeImports"},
                        diagnostics = {},
                    },
                })
            end,
            desc = desc("Organize imports"),
        },
        {
            "<leader>ta",
            function()
                vim.lsp.buf.code_action({
                    apply = true,
                    context = {
                        only = {"source.addMissingImports.ts"},
                        diagnostics = {},
                    },
                })
            end,
            desc = desc("Add missing imports"),
        },
        {
            "<leader>tr",
            function()
                vim.lsp.buf.code_action({
                    apply = true,
                    context = {
                        only = {"source.removeUnused.ts"},
                        diagnostics = {},
                    },
                })
            end,
            desc = desc("Remove unused imports"),
        },
        {
            "<leader>tf",
            function()
                vim.lsp.buf.code_action({
                    apply = true,
                    context = {
                        only = {"source.fixAll.ts"},
                        diagnostics = {},
                    },
                })
            end,
            desc = desc("Fix all"),
        },
        {
            "<leader>tt",
            function()
                Utils.lsp.execute({command = "typescript.selectTypeScriptVersion"})
            end,
            desc = desc("Select typescript version"),
        },
    },
}
