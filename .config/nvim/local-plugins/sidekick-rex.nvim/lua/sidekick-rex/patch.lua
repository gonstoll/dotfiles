-- sidekick only shows, focuses and hides sessions that live in a Neovim
-- terminal, and only accepts tmux or zellij as a backend name. These patches
-- route those calls to Rex sessions. They lean on sidekick internals, so each
-- one checks that what it patches still exists and fails loudly if not.
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

---@param opts? table|string
local function focus_opt(opts)
    return type(opts) ~= "table" or opts.focus ~= false
end

local function patch_validate()
    local Config = require("sidekick.config")
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
    local State = require("sidekick.cli.state")
    local attach = original(State, "sidekick.cli.state", "attach")
    State.attach = function(state, opts)
        local ret, attached = attach(state, opts)
        if is_rex(ret) and opts and opts.show then
            ret.session:show(opts.focus ~= false)
        end
        return ret, attached
    end
end

--- Wraps a `sidekick.cli` function so that its State.with callback, which
--- returns early for anything that isn't a Neovim terminal, goes to `rex_cb`
--- for Rex sessions
---@param name string
---@param rex_cb fun(session: sidekick.cli.muxer.Rex, attached?: boolean, opts?: table|string)
local function intercept(name, rex_cb)
    local Cli = require("sidekick.cli")
    local State = require("sidekick.cli.state")
    local fn = original(Cli, "sidekick.cli", name)
    local with = original(State, "sidekick.cli.state", "with")
    Cli[name] = function(opts)
        State.with = function(cb, with_opts)
            return with(function(state, attached)
                if is_rex(state) then
                    return rex_cb(state.session, attached, opts)
                end
                return cb(state, attached)
            end, with_opts)
        end
        local ok, err = pcall(fn, opts)
        State.with = with
        if not ok then
            error(err, 0)
        end
    end
end

-- sidekick's hide() only looks at sessions with a Neovim terminal, so Rex
-- sessions never reach its callback. Hide the attached Rex ones afterwards.
local function patch_hide()
    local Cli = require("sidekick.cli")
    local State = require("sidekick.cli.state")
    local hide = original(Cli, "sidekick.cli", "hide")
    Cli.hide = function(opts)
        hide(opts)
        local name = type(opts) == "string" and opts or type(opts) == "table" and opts.name or nil
        for _, state in ipairs(State.get({attached = true, name = name})) do
            if is_rex(state) then
                state.session:hide()
            end
        end
    end
end

function M.apply()
    patch_validate()
    patch_attach()
    intercept("toggle", function(session, attached, opts)
        if attached then
            -- Just started or attached, so there's nothing to hide yet
            session:show(focus_opt(opts))
        else
            session:toggle(focus_opt(opts))
        end
    end)
    intercept("focus", function(session)
        session:focus()
    end)
    patch_hide()
end

return M
