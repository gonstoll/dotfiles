local desc = Utils.plugin_keymap_desc("typescript")
local settings = {
    updateImportsOnFileMove = {enabled = "always"},
    format = {
        enable = false,
        insertSpaceAfterOpeningAndBeforeClosingEmptyBraces = false,
        insertSpaceAfterOpeningAndBeforeClosingNonemptyBraces = false,
    },
    preferences = {
        importModuleSpecifier = os.getenv("LSP_TS_IMPORT_MODULE_SPECIFIER_PROJECT_RELATIVE") and "project-relative" or
            "auto",
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

Utils.lsp.on_attach(function(client, buffer)
    client.commands["_typescript.moveToFileRefactoring"] = function(command, ctx)
        ---@type string, string, lsp.Range
        local action, uri, range = unpack(command.arguments)

        local function move(newf)
            client.request("workspace/executeCommand", {
                command = command.command,
                arguments = {action, uri, range, newf},
            })
        end

        local fname = vim.uri_to_fname(uri)
        client.request("workspace/executeCommand", {
            command = "typescript.tsserverRequest",
            arguments = {
                "getMoveToRefactoringFileSuggestions",
                {
                    file = fname,
                    startLine = range.start.line + 1,
                    startOffset = range.start.character + 1,
                    endLine = range["end"].line + 1,
                    endOffset = range["end"].character + 1,
                },
            },
        }, function(_, result)
            ---@type string[]
            local files = result.body.files
            table.insert(files, 1, "Enter new path...")
            vim.ui.select(files, {
                prompt = "Select move destination:",
                format_item = function(f)
                    return vim.fn.fnamemodify(f, ":~:.")
                end,
            }, function(f)
                if f and f:find("^Enter new path") then
                    vim.ui.input({
                        prompt = "Enter move destination:",
                        default = vim.fn.fnamemodify(fname, ":h") .. "/",
                        completion = "file",
                    }, function(newf)
                        return newf and move(newf)
                    end)
                elseif f then
                    move(f)
                end
            end)
        end)
    end
end, "vtsls")

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
        -- {
        --     "<leader>tD",
        --     function()
        --         local params = vim.lsp.util.make_position_params()
        --         Utils.lsp.execute({
        --             command = "typescript.goToSourceDefinition",
        --             arguments = {params.textDocument.uri, params.position},
        --             -- open = true,
        --         })
        --     end,
        --     desc = desc("Go to source definition"),
        -- },
        -- {
        --     "<leader>tr",
        --     function()
        --         Utils.lsp.execute({
        --             command = "typescript.findAllFileReferences",
        --             arguments = {vim.uri_from_bufnr(0)},
        --             -- open = true,
        --         })
        --     end,
        --     desc = desc("Fin all file references"),
        -- },
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
