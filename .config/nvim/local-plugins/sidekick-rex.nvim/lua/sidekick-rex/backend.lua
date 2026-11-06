-- sidekick.nvim session backend that runs CLI tools in their own Rex tabs.
-- Rex can't be attached inside a Neovim terminal the way tmux can, so every
-- session is external: it lives in a Rex block and outlives Neovim.
local Config = require("sidekick.config")
local Procs = require("sidekick.cli.procs")
local Util = require("sidekick.util")

---@class sidekick.cli.muxer.Rex: sidekick.cli.Session
---@field rex_block_id string
---@field rex_session_id string
local M = {}
M.__index = M
M.priority = 10
M.external = true

-- Every terminal block in every Rex session with its root process, in one call.
-- A script may only read sessions it's attached to, and one session failing
-- mustn't hide the agents in the others. Windows come in tab order.
local LIST = [[
local ret = {}
for _, s in ipairs(rex.call("session.list", {}).sessions or {}) do
  pcall(rex.session.attach, { session_id = s.session_id })
  local view = rex.call("session.view", { session_id = s.session_id })
  for index, w in ipairs(view and view.windows or {}) do
    for _, layer in ipairs(w.layers or {}) do
      for _, b in ipairs(layer.blocks or {}) do
        if b.creator_name == "com.superlogical.terminal" then
          local ok, p = pcall(rex.block.call, "com.superlogical.terminal", "process", { session_id = s.session_id, block_id = b.block_id })
          if ok and p and p.child then
            ret[#ret + 1] = {
              session_id = s.session_id,
              session_label = s.label,
              window_index = index,
              window_label = w.label,
              block_id = b.block_id,
              pid = p.child.pid,
              cwd = p.foreground and p.foreground.cwd or p.child.cwd,
            }
          end
        end
      end
    end
  end
end
return ret]]

---@param out string?
local function decode(out)
    local ok, ret = pcall(vim.json.decode, out or "", {luanil = {object = true}})
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

function M:init()
    if not self.started then
        self.rex_session_id = vim.env.REX_SESSION
        self.mux_session = self.rex_session_id
    end
end

-- A second agent of the same tool in this session gets its cwd as a suffix,
-- so the two tabs can be told apart
function M:label()
    local listed = api("session.list_blocks", {session_id = self.rex_session_id}, {notify = false})
    for _, block in ipairs(listed and listed.blocks or {}) do
        if block.label == self.tool.name then
            return ("%s·%s"):format(self.tool.name, vim.fs.basename(self.cwd))
        end
    end
    return self.tool.name
end

---@return sidekick.cli.terminal.Cmd?
function M:start()
    local label = self:label()
    local cmd = {"run", "-s", self.rex_session_id, "-c", self.cwd, "--label", label, "--focus=false", "--json", "--"}
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
    rex({"window", "rename", "-s", self.rex_session_id, res.window_id, label})
    self.id = "rex " .. block_id
    self.rex_block_id = block_id
    self.started = true
    Util.info(("Started **%s** in a new Rex tab"):format(self.tool.name))
end

function M:is_running()
    if not self.rex_block_id then
        return false
    end
    local out = rex({"block", "call", "-s", self.rex_session_id, "-b", self.rex_block_id, "process"}, {notify = false})
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
                        -- Rex already knows the cwd, and asking `proc` for it runs lsof
                        cwd = pane.cwd or proc.cwd,
                        tool = tool,
                        rex_block_id = pane.block_id,
                        rex_session_id = pane.session_id,
                        -- sidekick's picker shows this, so it names where the
                        -- agent is: session, then tab position and title
                        mux_session = ("%s %d:%s"):format(pane.session_label, pane.window_index, pane.window_label),
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
    api("block.event", {session_id = self.rex_session_id, block_id = self.rex_block_id, event = event}, {notify = true})
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
    rex({"send-key", "-s", self.rex_session_id, "-b", self.rex_block_id, "enter"})
end

-- Switches Rex to the agent's tab
function M:focus()
    api("session.focus_block", {session_id = self.rex_session_id, block_id = self.rex_block_id}, {notify = true})
    if self.rex_session_id ~= vim.env.REX_SESSION then
        -- The agent lives in another session, so the app has to switch to it too
        rex({"do", "session.select", "session_id=" .. self.rex_session_id})
    end
end

return M
