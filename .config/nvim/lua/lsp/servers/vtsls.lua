local desc = Utils.plugin_keymap_desc("typescript")
local settings = {
    updateImportsOnFileMove = {enabled = "always"},
    format = {
        enable = false,
        insertSpaceAfterOpeningAndBeforeClosingEmptyBraces = false,
        insertSpaceAfterOpeningAndBeforeClosingNonemptyBraces = false,
    },
    preferences = {
        importModuleSpecifier = os.getenv("LSP_TS_IMPORT_MODULE_SPECIFIER_PROJECT_RELATIVE") and "project-relative"
            or "auto",
    },
    inlayHints = {
        parameterNames = {enabled = "literals"},
        parameterTypes = {enabled = true},
        variableTypes = {enabled = true},
        propertyDeclarationTypes = {enabled = true},
        functionLikeReturnTypes = {enabled = true},
        enumMemberValues = {enabled = true},
    },
}

return {
    settings = {
        complete_function_calls = true,
        vtsls = {
            enableMoveToFileCodeAction = true,
            autoUseWorkspaceTsdk = true,
            experimental = {
                completion = {
                    -- https://github.com/yioneko/vtsls/blob/main/packages/service/configuration.schema.json#L1259-L1271
                    enableServerSideFuzzyMatch = true,
                    entriesLimit = 3000,
                },
            },
        },
        javascript = settings,
        typescript = settings,
    },
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
