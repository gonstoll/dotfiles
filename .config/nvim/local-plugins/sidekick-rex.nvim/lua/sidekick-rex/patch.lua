-- sidekick only shows and focuses sessions that live in a Neovim terminal, and
-- only accepts tmux or zellij as a backend name. These patches route those
-- calls to Rex sessions. They lean on sidekick internals, so each one checks
-- that what it patches still exists and fails loudly if not.
local Cli = require("sidekick.cli")
local Config = require("sidekick.config")
local State = require("sidekick.cli.state")

local M = {}

---@param mod table
---@param modname string
---@param name string
local function original(mod, modname, name)
    local fn = mod[name]
    assert(type(fn) == "function", ("sidekick-rex: `%s.%s` is gone, sidekick changed"):format(modname, name))
    return fn
end

---@param state? sidekick.cli.State
local function is_rex(state)
    return state ~= nil and state.session ~= nil and state.session.backend == "rex"
end

local function patch_validate()
    local validate = original(Config, "sidekick.config", "validate")
    Config.validate = function(key, t)
        if key == "cli.mux.backend" and type(t) == "table" then
            t = vim.list_extend({"rex"}, t)
        end
        return validate(key, t)
    end
end

-- Showing happens when sidekick attaches with `show = true`: on show(),
-- send(), focus() and when picking a session from select()
local function patch_attach()
    local attach = original(State, "sidekick.cli.state", "attach")
    State.attach = function(state, opts)
        local ret, attached = attach(state, opts)
        if is_rex(ret) and opts and opts.show and opts.focus ~= false then
            ret.session:focus()
        end
        return ret, attached
    end
end

--- Wraps a `sidekick.cli` function so that its State.with callback, which
--- returns early for anything that isn't a Neovim terminal, switches to the
--- agent's tab for Rex sessions
---@param name string
local function patch_focus(name)
    local fn = original(Cli, "sidekick.cli", name)
    local with = original(State, "sidekick.cli.state", "with")
    Cli[name] = function(opts)
        State.with = function(cb, with_opts)
            return with(function(state, attached)
                if not is_rex(state) then
                    return cb(state, attached)
                elseif type(opts) ~= "table" or opts.focus ~= false then
                    state.session:focus()
                end
            end, with_opts)
        end
        local ok, err = pcall(fn, opts)
        State.with = with
        if not ok then
            error(err, 0)
        end
    end
end

function M.apply()
    patch_validate()
    patch_attach()
    patch_focus("toggle")
    patch_focus("focus")
end

return M
