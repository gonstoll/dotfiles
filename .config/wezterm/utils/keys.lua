local act = require('wezterm').action
local M = {}

M.key_table = function(mods, key, action)
  return {mods = mods, key = key, action = action}
end

M.cmd_key = function(key, action)
  return M.key_table('CMD', key, action)
end

---@param tmux_key string
---@param tmux_mods? string
M.send_tmux_key = function(tmux_key, tmux_mods)
  return act.Multiple({
    act.SendKey({mods = 'CTRL', key = 'f'}),
    act.SendKey({mods = tmux_mods, key = tmux_key}),
  })
end

---@alias KeyToTmux {mods: string, key: string, tmux_key: string, tmux_mods?: string}
---@param opts KeyToTmux
M.key_to_tmux = function(opts)
  return M.key_table(opts.mods, opts.key, M.send_tmux_key(opts.tmux_key, opts.tmux_mods))
end

return M
