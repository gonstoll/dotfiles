local M = {}

-- Merge two tables
---@param t1 table
---@param t2 table
M.merge_table = function(t1, t2)
  for k, v in pairs(t2) do
    t1[k] = v
  end
  return t1
end

-- Create a function that returns a tagged keymap description
---@param plugin_name string
M.plugin_keymap_desc = function(plugin_name)
  ---@param desc string
  return function(desc)
    -- Capitalize plugin name and concat with desc
    return plugin_name:gsub('^%l', string.upper) .. ': ' .. desc
  end
end

-- Create a command that centers the screen after running the callback
---@param callback function
M.cmd_center = function(callback)
  return function()
    callback()
    vim.cmd('normal! zz')
  end
end

return M
