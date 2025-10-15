local status = {} ---@type table<number, "ok" | "error" | "pending">

return {
    handlers = {
        didChangeStatus = function(err, res, ctx)
            if err then
                return
            end
            status[ctx.client_id] = res.kind ~= "Normal" and "error" or res.busy and "pending" or "ok"
            if res.status == "Error" then
                print("Please use `:LspCopilotSignIn` to sign in to Copilot")
            end
        end,
    },
}
