-- Runs against a fake `rex` (tests/bin/rex) and checks the exact commands
-- the backend sends. Run with tests/run.sh.
local root = vim.fs.dirname(vim.fs.dirname(vim.fs.normalize(debug.getinfo(1, "S").source:sub(2))))
local sidekick_dir = vim.env.SIDEKICK_DIR or vim.fn.expand("~/.local/share/nvim/lazy/sidekick.nvim")
vim.opt.rtp:prepend(sidekick_dir)
vim.opt.rtp:prepend(root)

local fake = vim.fn.tempname()
vim.fn.mkdir(fake, "p")
vim.env.REX_FAKE_DIR = fake
vim.env.PATH = root .. "/tests/bin:" .. vim.env.PATH

local notes = {} ---@type {msg: string, level: integer}[]
vim.notify = function(msg, level)
    notes[#notes + 1] = {msg = msg, level = level or vim.log.levels.INFO}
end

local failed, passed = 0, 0

---@param name string
---@param fn fun()
local function test(name, fn)
    vim.fn.delete(fake, "rf")
    vim.fn.mkdir(fake, "p")
    notes = {}
    local ok, err = xpcall(fn, debug.traceback)
    if ok then
        passed = passed + 1
        print("ok   " .. name)
    else
        failed = failed + 1
        print("FAIL " .. name .. "\n" .. err)
    end
end

---@param file string
---@param data table
local function fixture(file, data)
    vim.fn.writefile({vim.json.encode(data)}, fake .. "/" .. file)
end

--- Every rex call so far, each one a list of arguments
---@return string[][]
local function calls()
    local f = io.open(fake .. "/calls")
    if not f then
        return {}
    end
    local data = f:read("*a")
    f:close()
    local ret = {}
    for call in data:gmatch("([^\30]*)\30") do
        local args = {}
        for arg in call:gmatch("([^\31]*)\31") do
            args[#args + 1] = arg
        end
        ret[#ret + 1] = args
    end
    return ret
end

---@param prefix string[]
local function find(prefix)
    for _, call in ipairs(calls()) do
        if vim.deep_equal(vim.list_slice(call, 1, #prefix), prefix) then
            return call
        end
    end
end

local function eq(actual, expected, what)
    if not vim.deep_equal(actual, expected) then
        error(("%s\nexpected: %s\nactual:   %s"):format(what or "values differ", vim.inspect(expected), vim.inspect(actual)), 2)
    end
end

--- The params of the first `rex api call <method>`
local function api_params(method)
    local call = find({"api", "call", method})
    assert(call, "no api call to " .. method .. ", calls: " .. vim.inspect(calls()))
    return vim.json.decode(call[4])
end

local function errors()
    return vim.tbl_filter(function(n)
        return n.level >= vim.log.levels.WARN
    end, notes)
end

local S, AGENT = "session:test", "block:agent"

-- Outside Rex nothing may register, so must run before Rex's env is set
vim.env.REX_SESSION = nil
require("sidekick-rex").setup()
local Session = require("sidekick.cli.session")
test("registers nothing outside Rex", function()
    eq(Session.backends.rex, nil, "rex backend")
    eq(require("sidekick-rex").did_setup, false, "did_setup")
end)

vim.env.REX_SESSION = S
require("sidekick-rex").setup()
require("sidekick").setup({
    nes = {enabled = false},
    cli = {
        mux = {enabled = true, backend = "rex"},
        tools = {sleeper = {cmd = {"sleep", "31"}, is_proc = "\\<sleep 31\\>"}},
    },
})

test("accepts rex as sidekick's mux backend", function()
    vim.wait(100)
    require("sidekick.config").validate("cli.mux.backend", {"tmux", "zellij"})
    eq(errors(), {}, "notifications")
    assert(Session.backends.rex, "rex backend not registered")
end)

---@param id? string
local function new_session(id)
    local session = Session.new({tool = "sleeper", cwd = "/tmp/project"})
    if id then
        session.rex_block_id = id
        session.id = "rex " .. id
        session.started = true
    end
    return session --[[@as sidekick.cli.muxer.Rex]]
end

test("starts in a new tab named after the tool", function()
    local session = new_session()
    eq(session.backend, "rex", "backend")
    eq(session:start(), nil, "start returns no terminal command")
    eq(find({"run"}), {
        "run", "-s", S, "-c", "/tmp/project", "--label", "sleeper", "--focus=false", "--json",
        "--", "sleep", "31",
    }, "run")
    eq(find({"window", "rename"}), {"window", "rename", "-s", S, "window:new", "sleeper"}, "rename")
    eq(session.rex_block_id, "block:new", "block id")
    eq(session.id, "rex block:new", "session id")
    eq(session.started, true, "started")
end)

test("a second agent of the same tool gets its cwd as a suffix", function()
    fixture("blocks.json", {blocks = {{block_id = AGENT, label = "sleeper", placement = "placed"}}})
    new_session():start()
    eq(find({"run"})[7], "sleeper·project", "label")
end)

test("sends text as a paste, including text that starts with a dash", function()
    local text = "- item\nsecond line\n"
    new_session(AGENT):send(text)
    eq(api_params("block.event"), {
        session_id = S,
        block_id = AGENT,
        event = {type = "paste", payload = {text = text}},
    }, "paste event")
    eq(#calls(), 1, "a single call")
end)

test("sends a focus-in event first to tools that need it", function()
    local session = new_session(AGENT)
    session.tool.mux_focus = true
    session:send("hi")
    vim.wait(200, function()
        return #calls() == 2
    end)
    local events = vim.tbl_map(function(call)
        return vim.json.decode(call[4]).event.type
    end, calls())
    eq(events, {"focus", "paste"}, "event order")
    session.tool.mux_focus = nil
end)

test("submits with an enter key press", function()
    new_session(AGENT):submit()
    eq(calls(), {{"send-key", "-s", S, "-b", AGENT, "enter"}}, "calls")
end)

test("is running until the block's process exits", function()
    local session = new_session(AGENT)
    eq(session:is_running(), true, "running")
    eq(find({"block", "call"}), {"block", "call", "-s", S, "-b", AGENT, "process"}, "process call")
    fixture("process.json", {child = {pid = 1}, last_exit = 0})
    eq(session:is_running(), false, "exited")
end)

test("finds agents across sessions and names them by session and tab", function()
    local a = vim.system({"sleep", "31"})
    local b = vim.system({"sleep", "31"})
    local other = vim.system({"sleep", "32"})
    fixture("list.json", {
        {session_id = S, session_label = "dots", window_index = 2, window_label = "Agents", block_id = "block:a", pid = a.pid, cwd = "/tmp"},
        {session_id = "session:other", session_label = "app", window_index = 1, window_label = "claude", block_id = "block:b", pid = b.pid, cwd = "/tmp"},
        {session_id = S, session_label = "dots", window_index = 3, window_label = "zsh", block_id = "block:shell", pid = other.pid, cwd = "/tmp"},
    })
    local ok, err = pcall(function()
        local found = require("sidekick-rex.backend").sessions()
        table.sort(found, function(x, y)
            return x.id < y.id
        end)
        eq(vim.tbl_map(function(s)
            return {s.id, s.rex_session_id, s.mux_session, s.tool.name, s.rex_block_id}
        end, found), {
            {"rex block:a", S, "dots 2:Agents", "sleeper", "block:a"},
            {"rex block:b", "session:other", "app 1:claude", "sleeper", "block:b"},
        }, "sessions")
        eq(found[1].pids, {a.pid}, "pids")
    end)
    for _, p in ipairs({a, b, other}) do
        p:kill(9)
    end
    assert(ok, err)
end)

test("focus switches to the agent's tab", function()
    new_session(AGENT):focus()
    eq(calls(), {{"api", "call", "session.focus_block", vim.json.encode({session_id = S, block_id = AGENT})}}, "calls")
end)

test("focus switches the app to an agent in another session", function()
    local session = new_session(AGENT)
    session.rex_session_id = "session:other"
    session:focus()
    eq(api_params("session.focus_block"), {session_id = "session:other", block_id = AGENT}, "focus")
    eq(find({"do", "session.select"}), {"do", "session.select", "session_id=session:other"}, "select")
end)

test("sidekick's toggle and focus reach attached Rex sessions", function()
    local session = new_session(AGENT)
    Session.attach(session)
    require("sidekick.cli").toggle({name = "sleeper"})
    assert(vim.wait(500, function()
        return find({"api", "call", "session.focus_block"}) ~= nil
    end), "toggle did not focus, calls: " .. vim.inspect(calls()))
    vim.fn.delete(fake .. "/calls")
    require("sidekick.cli").focus({name = "sleeper"})
    assert(vim.wait(500, function()
        return find({"api", "call", "session.focus_block"}) ~= nil
    end), "focus did not focus, calls: " .. vim.inspect(calls()))
    Session.detach(session)
end)

test("detach leaves the agent running", function()
    local session = new_session(AGENT)
    Session.attach(session)
    local state = require("sidekick.cli.state").get({attached = true, name = "sleeper"})[1]
    vim.fn.delete(fake .. "/calls")
    require("sidekick.cli.state").detach(state)
    eq(session:is_attached(), false, "attached")
    eq(vim.tbl_filter(function(call)
        return call[1] ~= "block" -- the liveness check
    end, calls()), {}, "calls besides liveness checks")
end)

vim.fn.delete(fake, "rf")
print(("\n%d passed, %d failed"):format(passed, failed))
os.exit(failed == 0 and 0 or 1)
