-- Records every session the app shows, however it got there (keys, the
-- sidebar, cmd+., the sessionizer), since Rex has no event for a client
-- switching sessions. The app resizes a session's terminals each time it shows
-- it, and only resizes the ones on screen, so a resize is taken as a visit.
-- Started by .config/zsh/.zshrc from any shell inside Rex
local history = require("./session_history")

rex.on("terminal.size_changed", function(ctx, ev)
    if ev.owner == nil then return end
    history.touch(ctx.session_id)
end)
