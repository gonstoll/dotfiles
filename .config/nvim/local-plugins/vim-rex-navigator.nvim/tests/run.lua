-- Runs against a fake `rex` (tests/bin/rex) and checks the exact commands
-- the navigator sends. Run with tests/run.sh.
local root = vim.fs.dirname(vim.fs.dirname(vim.fs.normalize(debug.getinfo(1, "S").source:sub(2))))
vim.opt.rtp:prepend(root)

local fake = vim.fn.tempname()
vim.env.REX_FAKE_DIR = fake
vim.env.PATH = root .. "/tests/bin:" .. vim.env.PATH

local navigator = require("vim-rex-navigator")

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
    vim.env.REX_SESSION = "session:1"
    vim.cmd("silent! only")
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
---@param data string
local function fixture(file, data)
    vim.fn.writefile({data}, fake .. "/" .. file)
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

local function eq(actual, expected, what)
    if not vim.deep_equal(actual, expected) then
        error(("%s\nexpected: %s\nactual:   %s"):format(what or "values differ", vim.inspect(expected), vim.inspect(actual)), 2)
    end
end

--- Waits for the background calls to finish, so a test that expects none can
--- tell "none yet" from "none at all"
---@param count integer
local function settle(count)
    vim.wait(1000, function()
        return #calls() >= count
    end)
    vim.wait(100)
end

local VIEW = {"api", "call", "-s", "session:1", "session.view", "{}"}

test("moves between windows away from the edge", function()
    vim.cmd("vsplit")
    local left = vim.api.nvim_get_current_win()
    navigator.navigate("right")
    assert(vim.api.nvim_get_current_win() ~= left, "focus stayed in the left window")
    settle(0)
    eq(calls(), {}, "rex was called")
end)

test("focuses the Rex pane at the edge", function()
    vim.cmd("vsplit")
    local win = vim.api.nvim_get_current_win()
    navigator.navigate("left")
    settle(2)
    eq(calls(), {VIEW, {"focus", "-s", "session:1", "left"}})
    eq(vim.api.nvim_get_current_win(), win, "Neovim moved focus")
end)

test("uses each direction's own edge", function()
    vim.cmd("split")
    navigator.navigate("up")
    settle(2)
    eq(calls()[2], {"focus", "-s", "session:1", "up"})
end)

test("keeps the focus in a zoomed pane", function()
    fixture("view.json", '{"active_window_id":"window:1","windows":[{"window_id":"window:2","zoomed_block_id":"block:9"},{"window_id":"window:1","zoomed_block_id":"block:1"}]}')
    navigator.navigate("left")
    settle(1)
    eq(calls(), {VIEW}, "focus was moved")
end)

test("only a zoom in the active window counts", function()
    fixture("view.json", '{"active_window_id":"window:1","windows":[{"window_id":"window:2","zoomed_block_id":"block:9"},{"window_id":"window:1","zoomed_block_id":null}]}')
    navigator.navigate("left")
    settle(2)
    eq(calls()[2], {"focus", "-s", "session:1", "left"})
end)

test("stays inside Neovim outside Rex", function()
    vim.env.REX_SESSION = nil
    navigator.navigate("left")
    settle(0)
    eq(calls(), {}, "rex was called")
end)

test("never leaves a floating window for Rex", function()
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_open_win(buf, true, {relative = "editor", row = 1, col = 1, width = 10, height = 3})
    navigator.navigate("left")
    settle(0)
    eq(calls(), {}, "rex was called")
end)

test("warns when rex fails", function()
    fixture("fail", "Error: no such session")
    navigator.navigate("left")
    vim.wait(1000, function()
        return #notes > 0
    end)
    eq(#calls(), 1, "focus was tried after the view failed")
    eq(notes, {{msg = "vim-rex-navigator: Error: no such session", level = vim.log.levels.WARN}})
end)

test("warns when the view isn't JSON", function()
    fixture("view.json", "not json")
    navigator.navigate("left")
    vim.wait(1000, function()
        return #notes > 0
    end)
    eq(#calls(), 1, "focus was tried after a bad view")
    eq(notes[1].level, vim.log.levels.WARN)
end)

print(("\n%d passed, %d failed"):format(passed, failed))
vim.cmd(failed > 0 and "cquit" or "qall!")
