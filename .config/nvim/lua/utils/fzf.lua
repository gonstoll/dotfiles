local M = {}

---@param client_name string LSP client name
local function open_lsp_float(client_name)
    local client = vim.lsp.get_clients({ name = client_name })

    if #client == 0 then
        vim.notify("No active LSP clients found with this name: " .. client_name, vim.log.levels.WARN)
        return
    end

    -- Create a temporary buffer to show the configuration
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_open_win(buf, true, {
        relative = "editor",
        width = math.floor(vim.o.columns * 0.75),
        height = math.floor(vim.o.lines * 0.90),
        col = math.floor(vim.o.columns * 0.125),
        row = math.floor(vim.o.lines * 0.05),
        border = "single",
        title = " " .. (client_name:gsub("^%l", string.upper)) .. ": LSP Configuration ",
        title_pos = "center",
    })

    local lines = {}
    for i, this_client in ipairs(client) do
        if i > 1 then
            table.insert(lines, string.rep("-", 80))
        end
        table.insert(lines, "Client: " .. this_client.name)
        table.insert(lines, "ID: " .. this_client.id)
        table.insert(lines, "")
        table.insert(lines, "Configuration:")

        local config_lines = vim.split(vim.inspect(this_client.config), "\n")
        vim.list_extend(lines, config_lines)
    end

    -- Set the lines in the buffer
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

    -- Set buffer options
    vim.bo[buf].modifiable = false
    vim.bo[buf].filetype = "lua"
    vim.bo[buf].bh = "delete"

    vim.api.nvim_buf_set_keymap(buf, "n", "q", ":q<CR>", { noremap = true, silent = true })
end

-- Inspects active LSPs configuration
-- Taken from https://www.reddit.com/r/neovim/comments/1gf7kyn/lsp_configuration_debugging/
function M.inspect_lsp_client()
    local fzf = require("fzf-lua")
    local clients = vim.lsp.get_clients()
    local client_names = {}

    for _, client in ipairs(clients) do
        table.insert(client_names, client.name)
    end

    fzf.fzf_exec(client_names, {
        prompt = "LSP Client name: ",
        winopts = { height = 0.33 },
        actions = {
            ["default"] = function(selected, opts)
                local selected_client = selected[1]
                open_lsp_float(selected_client)
            end,
        },
    })
end

function M.scratch_select()
    local entries = {}
    local items = Snacks.scratch.list()
    local item_map = {}
    local utils = require("fzf-lua.utils")

    local function hl_validate(hl)
        return not utils.is_hl_cleared(hl) and hl or nil
    end

    local function ansi_from_hl(hl, s)
        return utils.ansi_from_hl(hl_validate(hl), s)
    end

    for _, item in ipairs(items) do
        item.icon = item.icon or Snacks.util.icon(item.ft, "filetype")
        item.branch = item.branch and ("branch:%s"):format(item.branch) or ""
        item.cwd = item.cwd and vim.fn.fnamemodify(item.cwd, ":p:~") or ""
        local display = string.format("%s %s %s %s", item.cwd, item.icon, item.name, item.branch) -- same as what Snacks.scratch uses to display items
        table.insert(entries, display)
        item_map[display] = item
    end

    local fzf = require("fzf-lua")

    fzf.fzf_exec(entries, {
        prompt = "Scratch buffers: ",
        fzf_opts = {
            ["--header"] = string.format(
                ":: <%s> to %s | <%s> to %s",
                ansi_from_hl("FzfLuaHeaderBind", "enter"),
                ansi_from_hl("FzfLuaHeaderText", "Select Scratch"),
                ansi_from_hl("FzfLuaHeaderBind", "ctrl-x"),
                ansi_from_hl("FzfLuaHeaderText", "Delete Scratch")
            ),
        },
        winopts = { height = 0.5 },
        actions = {
            ["default"] = function(selected)
                local item = item_map[selected[1]]
                Snacks.scratch.open({
                    icon = item.icon,
                    file = item.file,
                    name = item.name,
                    ft = item.ft,
                    width = 150,
                    height = 40,
                    border = "single",
                })
            end,
            ["ctrl-x"] = {
                function(selected)
                    local selected_item = selected[1]
                    local item = item_map[selected_item]
                    vim.fn.delete(item.file)
                    vim.notify("Deleted scratch file: " .. item.file)
                    M.scratch_select()
                end,
            },
        },
    })
end

-- Folder grep function
-- Allows selecting a folder and running grep in it
function M.folder_grep()
    local fzf = require("fzf-lua")

    fzf.fzf_exec("find . -type d", {
        prompt = "Folder: ",
        actions = {
            ["default"] = function(selected)
                if selected and #selected > 0 then
                    fzf.live_grep({ cwd = selected[1] })
                end
            end,
        },
    })
end

return M
