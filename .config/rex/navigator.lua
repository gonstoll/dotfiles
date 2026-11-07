-- Like vim-tmux-navigator: ctrl+h/j/k/l move between Rex panes, except in
-- panes running one of these programs, which get the key so they can move
-- inside themselves. Neovim hands focus back with `rex focus` at its edge
local TERMINAL = "com.superlogical.terminal"
local PASS_THROUGH = { nvim = true, vim = true, fzf = true }

local M = {}

local function foreground(ctx)
    local process, err = rex.block.call(TERMINAL, "process", { block_id = ctx.block_id })
    if process == nil then
        rex.log("warn", "navigator: " .. tostring(err))
        return nil
    end
    return process.foreground and process.foreground.name
end

local function zoomed(ctx)
    local view, err = rex.session.view({ session_id = ctx.session_id })
    if view == nil then
        rex.log("warn", "navigator: " .. tostring(err))
        return false
    end
    for _, window in ipairs(view.windows or {}) do
        if window.window_id == view.active_window_id then
            return window.zoomed_block_id ~= nil
        end
    end
    return false
end

-- Returns a function to bind to a key. Moving focus cancels a zoom, so a
-- zoomed pane keeps the focus and swallows the key
function M.navigate(direction)
    return function(ctx)
        if PASS_THROUGH[foreground(ctx)] then return false end
        if zoomed(ctx) then return true end

        local _, err = rex.session.focus_direction({
            session_id = ctx.session_id,
            direction  = direction,
            wrap       = false,
        })
        if err ~= nil then rex.log("warn", "navigator: " .. tostring(err)) end
        return true
    end
end

return M
