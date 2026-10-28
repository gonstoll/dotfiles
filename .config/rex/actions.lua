local SHELL = "com.superlogical.terminal.shell"
local HOME = os.getenv("HOME")
local SESSIONIZER = HOME .. "/.config/bin/rex-sessionizer"

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
    args  = { dir = "string" },
    run   = function(ctx, args)
        local dir = normalize(args.dir)
        local name = session_name(dir)

        local session_id = find_session(name)
        if session_id == nil then
            local created, err = rex.call("session.create", {
                label = name,
                initial_windows = {
                    { layout = rex.layout.block({ flavor = SHELL, options = { cwd = dir } }) },
                },
            })
            if err ~= nil then error(err, 0) end
            session_id = created.session_id
        end

        rex.client.queue("session.select", { session_id = session_id })
    end,
})

rex.action({
    name  = "sessionizer",
    title = "Sessionizer",
    run   = function()
        local _, err = rex.session.new_layer({
            bounds = { 0.15, 0.15, 0.7, 0.7 },
            layout = rex.layout.block({
                flavor  = SHELL,
                options = { command = { SESSIONIZER }, shell = "none" },
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
