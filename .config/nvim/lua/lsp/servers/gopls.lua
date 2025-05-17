-- Organize go imports (https://github.com/harrisoncramer/nvim/blob/main/lua/lsp/servers/gopls.lua)
-- local function goimports()
--   local params = vim.lsp.util.make_range_params()
--   params.context = {only = {'source.organizeImports'}}
--   local result = vim.lsp.buf_request_sync(0, 'textDocument/codeAction', params)
--   for cid, res in pairs(result or {}) do
--     for _, r in pairs(res.result or {}) do
--       if r.edit then
--         local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or 'utf-16'
--         vim.lsp.util.apply_workspace_edit(r.edit, enc)
--       end
--     end
--   end
--   vim.lsp.buf.format({async = false})
-- end
--
-- vim.api.nvim_create_autocmd('BufWritePre', {
--   pattern = '*.go',
--   callback = function()
--     goimports()
--   end,
--   desc = 'Run goimports on save in Golang files',
-- })

-- https://github.com/golang/tools/blob/master/gopls/doc/settings.md
return {
    settings = {
        gopls = {
            analyses = {
                fillstruct = false,
            },
            -- staticcheck = true, -- https://github.com/golang/tools/blob/master/gopls/doc/settings.md#staticcheck-bool
            completeFunctionCalls = false,
            gofumpt = true,
            completeUnimported = true,
        },
    },
}
