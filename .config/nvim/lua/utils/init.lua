local M = {
    colors = require("utils.colors"),
    icons = require("utils.icons"),
    fzf = require("utils.fzf"),
    lsp = require("utils.lsp"),
    browse = require("utils.browse"),
}

-- Merge two tables
---@param t1 table
---@param t2 table
function M.merge_table(t1, t2)
    for k, v in pairs(t2) do
        t1[k] = v
    end
    return t1
end

-- Create a function that returns a tagged keymap description
---@param plugin_name string
function M.plugin_keymap_desc(plugin_name)
    ---@param desc string
    return function(desc)
        -- Capitalize plugin name and concat with desc
        -- Examples:
        -- - 'nvim-tree': 'Nvim-tree: ${desc}'
        -- - 'conform': 'Conform: ${desc}'
        return plugin_name:gsub("^%l", string.upper) .. ": " .. desc
    end
end

-- Create a command that centers the screen after running the callback
---@param callback function
function M.cmd_center(callback)
    return function()
        callback()
        vim.cmd("normal! zz")
    end
end

--- Gets a path to a package in the Mason registry.
--- Prefer this to `get_package`, since the package might not always be
--- available yet and trigger errors.
---@param pkg string
---@param path? string
function M.get_pkg_path(pkg, path)
    pcall(require, "mason") -- make sure Mason is loaded. Will fail when generating docs
    local root = vim.env.MASON or (vim.fn.stdpath("data") .. "/mason")
    path = path or ""
    local ret = root .. "/packages/" .. pkg .. "/" .. path
    return ret
end

-- Check if a command-line tool exists
-- @param cmd string: The command to check
-- @return boolean: True if the command exists, false otherwise
function M.check_cmd_exists(cmd)
    if not cmd or cmd == "" then
        return false
    end

    -- Use vim.fn.executable to check if the command exists
    return vim.fn.executable(cmd) == 1
end

return M
