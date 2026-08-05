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

local PEEK_MAX_HEIGHT = 20

---Line range (0-indexed, end-inclusive) covering the whole declaration
---@param location table lsp.Location|lsp.LocationLink
---@param target_bufnr integer
local function declaration_range(location, target_bufnr)
    local range = location.targetRange or location.range
    local start_line = range.start.line
    local end_line = range["end"].line

    -- Plain Locations only point at the identifier, so grow to the enclosing
    -- node as long as it still starts on the same line
    if end_line == start_line then
        local ok, node = pcall(vim.treesitter.get_node, {
            bufnr = target_bufnr,
            pos = {start_line, range.start.character},
        })
        while ok and node do
            local node_start, _, node_end, _ = node:range()
            if node_start ~= start_line then
                break
            end
            if node_end > node_start then
                end_line = node_end
                break
            end
            node = node:parent()
        end
    end

    return start_line, math.min(end_line, start_line + PEEK_MAX_HEIGHT - 1)
end

---Markdown lines for a hover response, or nil when it carries no content
---@param result table lsp.Hover
local function hover_lines(result)
    local contents = result.contents

    if not contents then
        return nil
    end

    -- MarkupContent, MarkedString (string or pair) and MarkedString[]
    local value = type(contents) == "table"
            and (vim.tbl_get(contents, "value") or vim.tbl_get(contents, 1, "value") or contents[1])
        or contents

    if type(value) ~= "string" or value == "" then
        return nil
    end

    return vim.lsp.util.convert_input_to_markdown_lines(contents)
end

function M.peek_definition()
    local bufnr = vim.api.nvim_get_current_buf()
    local win = vim.api.nvim_get_current_win()
    local methods = {"textDocument/typeDefinition", "textDocument/definition", "textDocument/hover"}

    ---@return boolean handled
    local function open_location(result)
        local location = vim.islist(result) and result[1] or result
        local uri = location and (location.targetUri or location.uri)

        if not uri then
            return false
        end

        local target_bufnr = vim.uri_to_bufnr(uri)
        if not vim.api.nvim_buf_is_loaded(target_bufnr) then
            vim.fn.bufload(target_bufnr)
        end

        local start_line, end_line = declaration_range(location, target_bufnr)
        local lines = vim.api.nvim_buf_get_lines(target_bufnr, start_line, end_line + 1, false)
        local filename = vim.fn.fnamemodify(vim.uri_to_fname(uri), ":~:.")

        local float_bufnr = vim.lsp.util.open_floating_preview(lines, "", {
            border = "single",
            focus_id = "peek_definition",
            title = string.format("%s:%d", filename, start_line + 1),
            title_pos = "left",
            wrap = false,
            max_width = math.floor(vim.o.columns * 0.7),
            max_height = math.min(PEEK_MAX_HEIGHT, math.floor(vim.o.lines * 0.5)),
        })

        local lang = vim.treesitter.language.get_lang(vim.bo[target_bufnr].filetype)
        if lang then
            pcall(vim.treesitter.start, float_bufnr, lang)
        end

        return true
    end

    ---@return boolean handled
    local function open_hover(result)
        local lines = hover_lines(result)

        if not lines or vim.tbl_isempty(lines) then
            return false
        end

        -- open_floating_preview stylizes and highlights markdown on its own
        vim.lsp.util.open_floating_preview(lines, "markdown", {
            border = "single",
            focus_id = "peek_definition",
            title = "Hover",
            title_pos = "left",
            max_width = math.floor(vim.o.columns * 0.7),
            max_height = math.floor(vim.o.lines * 0.7),
        })

        return true
    end

    local function request(method_index)
        local method = methods[method_index]
        local clients = method and vim.lsp.get_clients {bufnr = bufnr, method = method} or {}

        if vim.tbl_isempty(clients) then
            if methods[method_index + 1] then
                request(method_index + 1)
            else
                vim.notify("No type information provider found", vim.log.levels.INFO)
            end
            return
        end

        vim.lsp.buf_request_all(bufnr, method, function(client)
            return vim.lsp.util.make_position_params(win, client.offset_encoding)
        end, function(results)
            local open = method == "textDocument/hover" and open_hover or open_location

            for _, response in pairs(results) do
                local result = response and response.result
                if result and not vim.tbl_isempty(result) and open(result) then
                    return
                end
            end

            if methods[method_index + 1] then
                request(method_index + 1)
            else
                vim.notify("No type information found", vim.log.levels.INFO)
            end
        end)
    end

    request(1)
end

return M
