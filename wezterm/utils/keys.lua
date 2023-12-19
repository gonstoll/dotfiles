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
    act.SendKey({mods = 'CTRL', key = 'a'}),
    act.SendKey({key = tmux_key}),
  })
end

M.key_to_tmux = function(mods, key, tmux_key)
  return M.key_table(mods, key, M.send_tmux_key(tmux_key))
end

return M
