-- Moves between Neovim windows, and on to the neighboring Rex pane at the
-- edge, like vim-tmux-navigator does for tmux. Rex's side is
-- ~/.config/rex/navigator.lua: it sends ctrl+h/j/k/l to panes running Neovim,
-- and moves between the other panes itself.
local M = {}

local keys = {left = "h", down = "j", up = "k", right = "l"}

---@param msg string
local function warn(msg)
    vim.notify("vim-rex-navigator: " .. msg, vim.log.levels.WARN)
end

---@param result vim.SystemCompleted
---@return boolean
local function ok(result)
    if result.code == 0 then
        return true
    end
    warn(vim.trim(result.stderr ~= "" and result.stderr or result.stdout))
    return false
end

---@param view table
---@return boolean
local function zoomed(view)
    for _, window in ipairs(view.windows or {}) do
        if window.window_id == view.active_window_id then
            return window.zoomed_block_id ~= nil
        end
    end
    return false
end

-- Runs in the background so the key never waits on Rex. Moving focus cancels
-- a zoom, so a zoomed pane keeps the focus, as Rex's side does.
---@param direction "left"|"down"|"up"|"right"
local function focus_rex(direction)
    local session = vim.env.REX_SESSION
    vim.system({"rex", "api", "call", "-s", session, "session.view", "{}"}, {text = true}, vim.schedule_wrap(function(result)
        if not ok(result) then
            return
        end
        local decoded, view = pcall(vim.json.decode, result.stdout, {luanil = {object = true, array = true}})
        if not decoded then
            return warn("can't read the session view: " .. view)
        end
        if zoomed(view) then
            return
        end
        vim.system({"rex", "focus", "-s", session, direction}, {text = true}, vim.schedule_wrap(ok))
    end))
end

---@param direction "left"|"down"|"up"|"right"
function M.navigate(direction)
    local key = keys[direction]
    local at_edge = vim.fn.winnr(key) == vim.fn.winnr()
    local floating = vim.api.nvim_win_get_config(0).relative ~= ""
    if at_edge and not floating and vim.env.REX_SESSION then
        focus_rex(direction)
    else
        vim.cmd.wincmd(key)
    end
end

return M
