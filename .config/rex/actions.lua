local history = require("./session_history")

local SHELL = "com.superlogical.terminal.shell"
local HOME = os.getenv("HOME")
local SESSIONIZER = HOME .. "/.config/bin/rex-sessionizer"
local DEFAULT_HYDRATE = HOME .. "/.config/rex-sessionizer/default"

local function basename(path)
    return path:match("([^/]+)$")
end

local function normalize(path)
    path = path:gsub("^~", HOME):gsub("//+", "/")
    if #path > 1 then path = path:gsub("/$", "") end
    return path
end

-- Directories that share a basename (e.g. ~/foo/bar and
-- ~/foo/baz/bar) get their parent's name as a prefix
local function session_name(dir)
    local result, err = rex.exec({ SESSIONIZER, "--list" })
    if result == nil then error(err, 0) end
    if not result.ok then error(result.stderr, 0) end

    local base = basename(dir)
    local matches, count = {}, 0
    for line in result.stdout:gmatch("[^\n]+") do
        local path = normalize(line)
        if basename(path) == base and not matches[path] then
            matches[path] = true
            count = count + 1
        end
    end

    local name = base:gsub("%.", "_")
    if count > 1 then
        local parent = basename(dir:match("^(.*)/[^/]+$")):gsub("%.", "_")
        name = parent .. "_" .. name
    end
    return name
end

local function exists(path)
    local file = io.open(path)
    if file == nil then return false end
    file:close()
    return true
end

-- Like tmux-sessionizer, a new session sources the project's .rex-sessionizer
-- (or the default one) in its first shell, with the session and directory as
-- arguments, so the script can open windows and start commands through `rex`
local function hydrate_input(dir)
    local script = dir .. "/.rex-sessionizer"
    if not exists(script) then script = DEFAULT_HYDRATE end
    if not exists(script) then return nil end
    return string.format("source %q \"$REX_SESSION\" %q", script, dir)
end

local function find_session(label)
    local list, err = rex.call("session.list")
    if err ~= nil then error(err, 0) end
    for _, session in ipairs(list.sessions or {}) do
        if session.label == label then return session.session_id end
    end
end

rex.action({
    name  = "open_project",
    title = "Open Project",
    args  = { dir = "string", input = "string?" },
    run   = function(ctx, args)
        local dir = normalize(args.dir)
        local name = session_name(dir)

        local session_id = find_session(name)
        if session_id == nil then
            -- `input` is only typed into newly created sessions, never into an existing one.
            local input = ""
            local hydrate = hydrate_input(dir)
            if hydrate ~= nil then input = input .. hydrate .. "\n" end
            if args.input ~= nil then input = input .. args.input .. "\n" end
            local options = {
                cwd = dir,
                initial_input = input ~= "" and input or nil,
            }
            local created, err = rex.call("session.create", {
                label = name,
                initial_windows = {
                    { layout = rex.layout.block({ flavor = SHELL, options = options }) },
                },
            })
            if err ~= nil then error(err, 0) end
            session_id = created.session_id
        end

        -- From the sessionizer there's no ctx.session_id; it records the session it leaves itself
        history.touch(ctx.session_id)
        history.touch(session_id)
        rex.client.queue("session.select", { session_id = session_id })
    end,
})

rex.action({
    name  = "last_session",
    title = "Go to Last Session",
    run   = function(ctx)
        local session_id = history.previous(ctx.session_id)
        if session_id == nil then return end

        history.touch(ctx.session_id)
        history.touch(session_id)
        rex.client.queue("session.select", { session_id = session_id })
    end,
})

rex.action({
    name  = "sessionizer",
    title = "Sessionizer",
    run   = function(ctx)
        history.touch(ctx.session_id)

        -- open_project switches sessions through the client, but the sessionizer
        -- calls it from the popup's shell, where no client is targeted
        local command = { SESSIONIZER }
        if ctx.client_id ~= nil then
            command = { SESSIONIZER, "--client", ctx.client_id }
        end

        local _, err = rex.session.new_layer({
            bounds = { 0.15, 0.15, 0.7, 0.7 },
            layout = rex.layout.block({
                flavor  = SHELL,
                options = { command = command, shell = "none" },
            }),
            focus  = true,
        })
        if err ~= nil then error(err, 0) end
    end,
})

rex.action({
    name  = "open_window",
    title = "Open or Focus Window",
    args  = { label = "string", command = "array?" },
    run   = function(ctx, args)
        local _, new_err = rex.session.new_layer({
            bounds = { 0.15, 0.15, 0.7, 0.7 },
            focus = true,
            layout = rex.layout.block({
                flavor  = SHELL,
                label   = args.label,
                options = { command = args.command },
            }),
        })
        if new_err ~= nil then error(new_err, 0) end
    end,
})
