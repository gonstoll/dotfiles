-- sidekick.nvim session backend that runs CLI tools in Rex tabs or splits.
-- Rex can't be attached inside a Neovim terminal the way tmux can, so every
-- session is external: it lives in a Rex block and outlives Neovim.
local Config = require("sidekick.config")
local Procs = require("sidekick.cli.procs")
local Util = require("sidekick.util")

---@class sidekick.cli.muxer.Rex: sidekick.cli.Session
---@field rex_block_id string
local M = {}
M.__index = M
M.priority = 10
M.external = true

-- Every terminal block in every Rex session with its root process, in one call.
-- A script may only read sessions it's attached to, and one session failing
-- mustn't hide the agents in the others.
local LIST = [[
local ret = {}
for _, s in ipairs(rex.call("session.list", {}).sessions or {}) do
  pcall(rex.session.attach, { session_id = s.session_id })
  local listed = rex.call("session.list_blocks", { session_id = s.session_id })
  for _, b in ipairs(listed and listed.blocks or {}) do
    if b.creator_name == "com.superlogical.terminal" then
      local ok, p = pcall(rex.block.call, "com.superlogical.terminal", "process", { session_id = s.session_id, block_id = b.block_id })
      if ok and p and p.child then
        ret[#ret + 1] = {
          session_id = s.session_id,
          block_id = b.block_id,
          pid = p.child.pid,
          cwd = p.foreground and p.foreground.cwd or p.child.cwd,
        }
      end
    end
  end
end
return ret]]

local function rex_config()
    return require("sidekick-rex").config
end

---@param out string?
local function decode(out)
    local ok, ret = pcall(vim.json.decode, out or "", {luanil = {object = true, array = true}})
    return ok and type(ret) == "table" and ret or nil
end

---@param args string[]
---@param opts? {notify?: boolean, stdin?: string}
local function rex(args, opts)
    local _, out = Util.exec(vim.list_extend({"rex"}, args), opts)
    return out
end

---@param method string
---@param params table
---@param opts? {notify?: boolean}
local function api(method, params, opts)
    return decode(rex({"api", "call", method, vim.json.encode(params)}, opts))
end

---@param session_id string
local function blocks(session_id)
    local ret = api("session.list_blocks", {session_id = session_id}, {notify = false})
    return ret and ret.blocks or {}
end

function M:init()
    if not self.started then
        self.mux_session = vim.env.REX_SESSION
    end
end

-- A second agent of the same tool in this session gets its cwd as a suffix,
-- so the two tabs can be told apart
function M:label()
    for _, block in ipairs(blocks(self.mux_session)) do
        if block.label == self.tool.name then
            return ("%s·%s"):format(self.tool.name, vim.fs.basename(self.cwd))
        end
    end
    return self.tool.name
end

---@return sidekick.cli.terminal.Cmd?
function M:start()
    local config = rex_config()
    local label = self:label()
    local cmd = {"run", "-s", self.mux_session, "-c", self.cwd, "--label", label, "--focus=false", "--json"}
    if config.create == "split" then
        local split = config.split
        vim.list_extend(cmd, {"-b", vim.env.REX_BLOCK, "--split=" .. split.side, "--ratio", tostring(split.ratio)})
    end
    cmd[#cmd + 1] = "--"
    if self.tool.env and next(self.tool.env) then
        cmd[#cmd + 1] = "env"
        for key, value in pairs(self.tool.env) do
            vim.list_extend(cmd, value == false and {"-u", key} or {("%s=%s"):format(key, tostring(value))})
        end
    end
    vim.list_extend(cmd, self.tool.cmd)

    local res = decode(rex(cmd))
    local block_id = res and res.block_ids and res.block_ids[1]
    if not block_id then
        return
    end
    if config.create == "window" and res.window_id then
        rex({"window", "rename", "-s", self.mux_session, res.window_id, label})
    end
    self.id = "rex " .. block_id
    self.rex_block_id = block_id
    self.started = true
    Util.info(("Started **%s** in a new Rex %s"):format(self.tool.name, config.create == "split" and "split" or "tab"))
end

function M:is_running()
    if not self.rex_block_id then
        return false
    end
    local out = rex({"block", "call", "-s", self.mux_session, "-b", self.rex_block_id, "process"}, {notify = false})
    local proc = decode(out)
    return proc ~= nil and proc.last_exit == nil
end

function M.sessions()
    local ret = {} ---@type sidekick.cli.session.State[]
    local panes = decode(rex({"do", "-e", LIST, "--json"}, {notify = false})) or {}
    if #panes == 0 then
        return ret
    end
    local tools = Config.tools()
    local procs = Procs.new()
    for _, pane in ipairs(panes) do
        -- Walk from the block's root process rather than its foreground one, so
        -- an agent running a shell tool in the foreground is still found
        procs:walk(pane.pid, function(proc)
            for _, tool in pairs(tools) do
                if tool:is_proc(proc) then
                    ret[#ret + 1] = {
                        id = "rex " .. pane.block_id,
                        cwd = proc.cwd or pane.cwd,
                        tool = tool,
                        rex_block_id = pane.block_id,
                        mux_session = pane.session_id,
                        pids = Procs.pids(pane.pid),
                    }
                    return true
                end
            end
        end)
    end
    return ret
end

---@param event table
function M:event(event)
    api("block.event", {session_id = self.mux_session, block_id = self.rex_block_id, event = event}, {notify = true})
end

-- Rex delivers a paste event as a bracketed paste when the tool enabled it,
-- and as plain input otherwise
function M:send(text)
    local function send()
        self:event({type = "paste", payload = {text = text}})
    end
    if self.tool.mux_focus then
        -- Some tools ignore input until they get a focus-in event
        self:event({type = "focus", payload = {action = "in"}})
        vim.defer_fn(send, 50)
    else
        send()
    end
end

function M:submit()
    rex({"send-key", "-s", self.mux_session, "-b", self.rex_block_id, "enter"})
end

--- Where the agent's block is, and whether it shares a window with Neovim's block
---@return {placement?: string, window_id?: string} place, boolean beside
function M:place()
    local place, nvim_window = {}, nil
    for _, block in ipairs(blocks(self.mux_session)) do
        if block.block_id == self.rex_block_id then
            place = block
        elseif block.block_id == vim.env.REX_BLOCK then
            nvim_window = block.window_id
        end
    end
    return place, place.placement == "placed" and nvim_window ~= nil and place.window_id == nvim_window
end

-- Puts the block back beside Neovim, which only works when both are in the same session
function M:place_beside_nvim()
    if self.mux_session ~= vim.env.REX_SESSION then
        return
    end
    local split = rex_config().split
    local after = split.side == "right" or split.side == "below"
    local ratio = split.ratio / 100
    api("session.move_block", {
        session_id = self.mux_session,
        block_id = self.rex_block_id,
        anchor_block_id = vim.env.REX_BLOCK,
        direction = (split.side == "left" or split.side == "right") and "horizontal" or "vertical",
        side = after and "after" or "before",
        ratio = after and 1 - ratio or ratio,
    }, {notify = true})
end

---@param focus? boolean
function M:show(focus)
    local place, beside = self:place()
    if place.placement ~= "placed" or (rex_config().create == "split" and not beside) then
        self:place_beside_nvim()
    end
    if focus then
        self:focus()
    end
end

-- Only splits hide: the block leaves the window and keeps running. Tabs are
-- never in view from Neovim, so there is nothing to hide.
function M:is_hideable()
    return rex_config().create == "split" and select(2, self:place())
end

function M:stash()
    api("session.detach_block", {session_id = self.mux_session, block_id = self.rex_block_id}, {notify = true})
end

function M:hide()
    if self:is_hideable() then
        self:stash()
    end
end

---@param focus? boolean
function M:toggle(focus)
    if self:is_hideable() then
        self:stash()
    else
        self:show(focus)
    end
end

function M:focus()
    api("session.focus_block", {session_id = self.mux_session, block_id = self.rex_block_id}, {notify = true})
    if self.mux_session ~= vim.env.REX_SESSION then
        -- The agent lives in another session, so the app has to switch to it
        local place = self:place()
        local args = {"do", "session.select", "session_id=" .. self.mux_session}
        if place.window_id then
            args[#args + 1] = "window_id=" .. place.window_id
        end
        rex(args)
    end
end

return M
