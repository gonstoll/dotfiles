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

function M.peek_definition()
    local bufnr = vim.api.nvim_get_current_buf()
    local win = vim.api.nvim_get_current_win()
    local methods = {"textDocument/typeDefinition", "textDocument/definition"}

    local function open_location(location, offset_encoding)
        local uri = location.targetUri or location.uri
        local range = location.targetSelectionRange or location.targetRange or location.range

        if not uri or not range then
            vim.notify("No definition found", vim.log.levels.INFO)
            return
        end

        local target_bufnr = vim.uri_to_bufnr(uri)
        if not vim.api.nvim_buf_is_loaded(target_bufnr) then
            vim.fn.bufload(target_bufnr)
        end

        local lines = vim.api.nvim_buf_get_lines(target_bufnr, 0, -1, false)
        local width = math.max(20, math.min(math.floor(vim.o.columns * 0.8), 120))
        local height = math.max(1, math.min(math.floor(vim.o.lines * 0.5), #lines))
        local row = math.max(0, math.floor((vim.o.lines - height) / 2 - 1))
        local col = math.max(0, math.floor((vim.o.columns - width) / 2))
        local float_bufnr = vim.api.nvim_create_buf(false, true)

        vim.bo[float_bufnr].buftype = "nofile"
        vim.bo[float_bufnr].bufhidden = "wipe"
        vim.bo[float_bufnr].swapfile = false
        vim.bo[float_bufnr].filetype = vim.bo[target_bufnr].filetype
        vim.bo[float_bufnr].syntax = vim.bo[target_bufnr].syntax
        vim.api.nvim_buf_set_lines(float_bufnr, 0, -1, false, lines)
        vim.bo[float_bufnr].modifiable = false
        vim.bo[float_bufnr].readonly = true

        local float_win = vim.api.nvim_open_win(float_bufnr, true, {
            border = "rounded",
            col = col,
            height = height,
            relative = "editor",
            row = row,
            style = "minimal",
            title = vim.fn.fnamemodify(vim.uri_to_fname(uri), ":~:."),
            width = width,
        })

        vim.wo[float_win].cursorline = true
        vim.wo[float_win].number = true
        vim.wo[float_win].relativenumber = false
        vim.wo[float_win].wrap = false

        local line = math.min(range.start.line + 1, #lines)
        local character = vim.str_byteindex(lines[line] or "", offset_encoding, range.start.character, false)
        vim.api.nvim_win_set_cursor(float_win, {line, character})
        vim.api.nvim_win_call(float_win, function()
            vim.cmd "normal! zt"
        end)

        vim.keymap.set("n", "q", "<cmd>close<CR>", {buffer = float_bufnr, silent = true})
        vim.keymap.set("n", "<Esc>", "<cmd>close<CR>", {buffer = float_bufnr, silent = true})
    end

    local function request(method_index)
        local method = methods[method_index]
        local clients = method and vim.lsp.get_clients {bufnr = bufnr, method = method} or {}

        if vim.tbl_isempty(clients) then
            if methods[method_index + 1] then
                request(method_index + 1)
            else
                vim.notify("No definition provider found", vim.log.levels.INFO)
            end
            return
        end

        vim.lsp.buf_request_all(bufnr, method, function(client)
            return vim.lsp.util.make_position_params(win, client.offset_encoding)
        end, function(results)
            for client_id, response in pairs(results) do
                local result = response and response.result
                if result and not vim.tbl_isempty(result) then
                    local location = vim.islist(result) and result[1] or result
                    local client = vim.lsp.get_client_by_id(client_id)
                    open_location(location, client and client.offset_encoding or "utf-16")
                    return
                end
            end

            if methods[method_index + 1] then
                request(method_index + 1)
            else
                vim.notify("No definition found", vim.log.levels.INFO)
            end
        end)
    end

    request(1)
end

return M
