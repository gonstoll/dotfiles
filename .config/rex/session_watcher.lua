-- Records every session the app shows, however it got there (keys, the
-- sidebar, cmd+.), since Rex has no event for a client switching sessions.
-- The app resizes a session's terminals each time it shows it, so a resize is
-- taken as a visit. A new split resizes terminals too, even in a session in
-- the background, so resizes right after a layout change don't count.
-- Started by .config/zsh/.zshrc from any shell inside Rex
local history = require("./session_history")

local layout_changed_at = {}

rex.on("session_view_changed", function(ctx)
    layout_changed_at[ctx.session_id] = os.time()
end)

rex.on("terminal.size_changed", function(ctx, ev)
    if ev.owner == nil then return end
    local at = layout_changed_at[ctx.session_id]
    if at ~= nil and os.time() - at <= 1 then return end
    history.touch(ctx.session_id)
end)
