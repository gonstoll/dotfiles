-- Steps to debug neovim and lua
-- 1. Open a Neovim instance (instance A)
-- 2. Launch the DAP server with (A) >
--    :lua require"osv".launch({port=8086})
-- 3. Open another Neovim instance (instance B)
-- 4. Open `myscript.lua` (B)
-- 5. Place a breakpoint on line 2 using (B) >
--    :lua require"dap".toggle_breakpoint()
-- 6. Connect the DAP client using (B) >
--    :lua require"dap".continue()
-- 7. Run `myscript.lua` in the other instance (A) >
--    :luafile myscript.lua
-- 8. The breakpoint should hit and freeze the instance (B)

local desc = Utils.plugin_keymap_desc('dap lua')

return {
  'mfussenegger/nvim-dap',
  dependencies = {
    {
      'jbyuki/one-small-step-for-vimkind',
      keys = {
        {'<leader>dL', function() require('osv').launch({port = 8086}) end, desc = desc('Launch Lua adapter')},
        {'<leader>dT', function() require('osv').run_this() end, desc = desc('Lua adapter: Run this')},
      },
    },
  },
  opts = function()
    local dap = require('dap')

    ---@param callback fun(adapter:table)
    ---@param config table
    dap.adapters.nlua = function(callback, config)
      local adapter = {
        type = 'server',
        host = config.host or '127.0.0.1',
        port = config.port or 8086,
      }
      if config.start_neovim then
        local dap_run = dap.run
        dap.run = function(c)
          adapter.port = c.port
          adapter.host = c.host
        end
        require('osv').run_this()
        dap.run = dap_run
      end
      callback(adapter)
    end

    dap.configurations.lua = {
      {
        type = 'nlua',
        request = 'attach',
        name = 'Run this file',
        start_neovim = {},
      },
      {
        type = 'nlua',
        request = 'attach',
        name = 'Attach to running Neovim instance (port = 8086)',
        port = 8086,
      },
    }
  end,
}
