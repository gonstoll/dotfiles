-- Like tmux's `switch-client -l`: Rex doesn't tell the config which session a
-- client shows, so the actions that switch sessions record it here, most recent
-- first. Kept in a file so it survives config reloads and server restarts
local FILE = os.getenv("HOME") .. "/.local/state/rex-session-history"
local MAX = 20

local M = {}

local function read()
    local list = {}
    local file = io.open(FILE)
    if file == nil then return list end
    for line in file:lines() do table.insert(list, line) end
    file:close()
    return list
end

local function write(list)
    local file, err = io.open(FILE, "w")
    if file == nil then
        rex.log("warn", "session_history: " .. tostring(err))
        return
    end
    file:write(table.concat(list, "\n", 1, math.min(#list, MAX)), "\n")
    file:close()
end

-- Moves the session to the front of the history
function M.touch(session_id)
    if session_id == nil then return end
    local list = { session_id }
    for _, id in ipairs(read()) do
        if id ~= session_id then table.insert(list, id) end
    end
    write(list)
end

-- The most recent session other than the current one that still exists
function M.previous(current)
    local result, err = rex.call("session.list")
    if err ~= nil then error(err, 0) end
    local alive = {}
    for _, session in ipairs(result.sessions or {}) do
        alive[session.session_id] = true
    end
    for _, id in ipairs(read()) do
        if id ~= current and alive[id] then return id end
    end
end

-- Returns a function to bind to a key that runs a client action, such as
-- session.next, after recording the session it leaves
function M.leave_with(action)
    return function(ctx)
        M.touch(ctx.session_id)
        rex.client.queue(action)
        return true
    end
end

return M
