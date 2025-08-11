local M = {}

---@param opts table<string, any>
function M.execute(opts)
    local params = {
        command = opts.command,
        arguments = opts.arguments,
    }
    if opts.open then
        -- require('trouble').open({
        --   mode = 'lsp_command',
        --   params = params,
        -- })
    else
        return vim.lsp.buf_request(0, "workspace/executeCommand", params, opts.handler)
    end
end

---@param on_attach fun(client:vim.lsp.Client, buffer)
---@param name? string
function M.on_attach(on_attach, name)
    return vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
            local buffer = args.buf ---@type number
            local client = vim.lsp.get_client_by_id(args.data.client_id)
            if client and (not name or client.name == name) then
                return on_attach(client, buffer)
            end
        end,
    })
end

---@param bufnr integer
function M.get_lsp_format(bufnr)
    local filetype = vim.api.nvim_buf_get_option(bufnr, "filetype")
    return filetype == "lua" and "prefer" or "fallback"
end

return M
