local act = require('wezterm').action
local M = {}

M.key_table = function(mods, key, action)
  return {mods = mods, key = key, action = action}
end

M.cmd_key = function(key, action)
  return M.key_table('CMD', key, action)
end

M.send_tmux_key = function(tmux_key)
  return act.Multiple({
    act.SendKey({mods = 'CTRL', key = 'z'}),
    act.SendKey({key = tmux_key}),
  })
end

---@alias KeyToTmux {mods: string, key: string, tmux_key: string}
---@param opts KeyToTmux
M.key_to_tmux = function(opts)
  return M.key_table(opts.mods, opts.key, M.send_tmux_key(opts.tmux_key))
end

return M
