local desc = require('utils').plugin_keymap_desc('dap')
local js_filetypes = {'typescript', 'javascript', 'typescriptreact', 'javascriptreact'}

---@param config {args?:string[]|fun():string[]?}
local function get_args(config)
  local args = type(config.args) == 'function' and (config.args() or {}) or config.args or {}
  config = vim.deepcopy(config)
  ---@cast args string[]
  config.args = function()
    local new_args = vim.fn.input('Run with args: ', table.concat(args, ' ')) --[[@as string]]
    return vim.split(vim.fn.expand(new_args) --[[@as string]], ' ')
  end
  return config
end

return {
  'mfussenegger/nvim-dap',
  dependencies = {
    {'stevearc/overseer.nvim', opts = {dap = false}},
    {
      'rcarriga/nvim-dap-ui',
      keys = {
        {'<leader>du', function() require('dapui').toggle({}) end, desc = desc('Dap UI')},
        {'<leader>de', function() require('dapui').eval() end, desc = desc('Eval'), mode = {'n', 'v'}},
      },
      opts = {
        floating = {border = 'single'},
        layouts = {
          {
            elements = {
              {id = 'scopes', size = 0.25},
              {id = 'breakpoints', size = 0.25},
              {id = 'stacks', size = 0.25},
              {id = 'watches', size = 0.25}
            },
            position = 'left',
            size = 45
          },
          {
            elements = {
              {id = 'console', size = 1}
            },
            position = 'bottom',
            size = 15,
          }
        },
      },
    },
    -- vscode-js-debug adapter
    {
      'microsoft/vscode-js-debug',
      build = 'npm i && npm run compile vsDebugServerBundle && rm -rf out && mv -f dist out',
      version = '1.91.0',
    },
    {
      'mxsdev/nvim-dap-vscode-js',
      opts = {
        debugger_path = vim.fn.resolve(vim.fn.stdpath('data') .. '/lazy/vscode-js-debug'),
        adapters = {'pwa-node', 'pwa-chrome', 'pwa-msedge', 'node-terminal', 'pwa-extensionHost'},
      }
    },
    {'theHamsta/nvim-dap-virtual-text', opts = {}},
    -- Lua adapter
    {
      'jbyuki/one-small-step-for-vimkind',
      keys = {
        {'<leader>dL', function() require('osv').launch({port = 8086}) end, desc = desc('Launch Lua adapter')},
        {'<leader>dT', function() require('osv').run_this() end, desc = desc('Lua adapter: Run this')},
      },
    },
  },
  keys = {
    {'<leader>Td', function() require('neotest').run.run({strategy = 'dap'}) end, desc = desc('Debug Nearest')},
    {'<leader>dB', function() require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, desc = desc('Breakpoint Condition')},
    {'<leader>db', function() require('dap').toggle_breakpoint() end, desc = desc('Toggle Breakpoint')},
    {'<leader>dc', function() require('dap').continue() end, desc = desc('Continue')},
    {'<leader>da', function() require('dap').continue({before = get_args}) end, desc = desc('Run with Args')},
    {'<leader>dC', function() require('dap').run_to_cursor() end, desc = desc('Run to Cursor')},
    {'<leader>dg', function() require('dap').goto_() end, desc = desc('Go to line (no execute)')},
    {'<leader>dj', function() require('dap').down() end, desc = desc('Down')},
    {'<leader>dk', function() require('dap').up() end, desc = desc('Up')},
    {'<leader>dl', function() require('dap').run_last() end, desc = desc('Run Last')},
    {'<leader>di', function() require('dap').step_into() end, desc = desc('Step Into')},
    {'<leader>dO', function() require('dap').step_out() end, desc = desc('Step Out')},
    {'<leader>do', function() require('dap').step_over() end, desc = desc('Step Over')},
    {'<leader>dp', function() require('dap').pause() end, desc = desc('Pause')},
    {'<leader>dr', function() require('dap').repl.toggle() end, desc = desc('Toggle REPL')},
    {'<leader>ds', function() require('dap').session() end, desc = desc('Session')},
    {'<leader>dt', function() require('dap').terminate() end, desc = desc('Terminate')},
    {'<leader>dh', function() require('dap.ui.widgets').hover() end, desc = desc('Widgets')},
  },
  config = function()
    local dap = require('dap')
    local dapui = require('dapui')
    local icons = require('utils.icons')

    dap.listeners.after.event_initialized['dapui_config'] = function() dapui.open({}) end

    if not dap.adapters['node'] then
      dap.adapters['node'] = function(cb, config)
        if config.type == 'node' then
          config.type = 'pwa-node'
        end
        local nativeAdapter = dap.adapters['pwa-node']
        if type(nativeAdapter) == 'function' then
          nativeAdapter(cb, config)
        else
          cb(nativeAdapter)
        end
      end
    end

    vim.api.nvim_set_hl(0, 'DapStoppedLine', {default = true, link = 'Visual'})

    for name, sign in pairs(icons.dap) do
      sign = type(sign) == 'table' and sign or {sign}
      vim.fn.sign_define(
        'Dap' .. name,
        {text = sign[1], texthl = sign[2] or 'DiagnosticInfo', linehl = sign[3], numhl = sign[3]}
      )
    end

    -- setup dap config by VsCode launch.json file
    local dap_vscode = require('dap.ext.vscode')
    local json = require('plenary.json')
    ---@diagnostic disable-next-line: duplicate-set-field
    dap_vscode.json_decode = function(str)
      return vim.json.decode(json.json_strip_comments(str, {}))
    end

    -- Extends dap.configurations with entries read from .vscode/launch.json
    if vim.fn.filereadable('.vscode/launch.json') then
      dap_vscode.load_launchjs()
    end

    dap_vscode.type_to_filetypes['node'] = js_filetypes

    for _, language in ipairs(js_filetypes) do
      dap.configurations[language] = {
        -- Debug single nodejs files
        {
          name = 'Launch file',
          type = 'pwa-node',
          request = 'launch',
          program = '${file}',
          cwd = '${workspaceFolder}',
          args = {'${file}'},
          sourceMaps = true,
          sourceMapPathOverrides = {
            ['./*'] = '${workspaceFolder}/src/*',
          },
        },
        -- Debug nodejs processes (make sure to add --inspect when you run the process)
        {
          name = 'Attach',
          type = 'pwa-node',
          request = 'attach',
          processId = require('dap.utils').pick_process,
          cwd = '${workspaceFolder}',
          sourceMaps = true,
        },
        {
          name = 'Debug Jest Tests',
          type = 'pwa-node',
          request = 'launch',
          runtimeExecutable = 'node',
          runtimeArgs = {'${workspaceFolder}/node_modules/.bin/jest', '--runInBand'},
          rootPath = '${workspaceFolder}',
          cwd = '${workspaceFolder}',
          console = 'integratedTerminal',
          internalConsoleOptions = 'neverOpen',
          -- args = {'${file}', '--coverage', 'false'},
          -- sourceMaps = true,
          -- skipFiles = {'<node_internals>/**', 'node_modules/**'},
        },
        {
          name = 'Debug Vitest Tests',
          type = 'pwa-node',
          request = 'launch',
          cwd = vim.fn.getcwd(),
          program = '${workspaceFolder}/node_modules/vitest/vitest.mjs',
          args = {'run', '${file}'},
          autoAttachChildProcesses = true,
          smartStep = true,
          skipFiles = {'<node_internals>/**', 'node_modules/**'},
        },
        -- Debug web applications (client side)
        {
          name = 'Launch & Debug Chrome',
          type = 'pwa-chrome',
          request = 'launch',
          url = function()
            local co = coroutine.running()
            return coroutine.create(function()
              vim.ui.input({prompt = 'Enter URL: ', default = 'http://localhost:3000'}, function(url)
                if url == nil or url == '' then
                  return
                else
                  coroutine.resume(co, url)
                end
              end)
            end)
          end,
          webRoot = vim.fn.getcwd(),
          protocol = 'inspector',
          sourceMaps = true,
          userDataDir = false,
          resolveSourceMapLocations = {
            '${workspaceFolder}/**',
            '!**/node_modules/**',
          },

          -- From https://github.com/lukas-reineke/dotfiles/blob/master/vim/lua/plugins/dap.lua
          -- To test how it behaves
          rootPath = '${workspaceFolder}',
          cwd = '${workspaceFolder}',
          console = 'integratedTerminal',
          internalConsoleOptions = 'neverOpen',
          sourceMapPathOverrides = {
            ['./*'] = '${workspaceFolder}/src/*',
          },
        },
        {
          name = '----- ↑ launch.json configs (if available) ↑ -----',
          type = '',
          request = 'launch',
        },
      }
    end

    -- Lua configurations.
    dap.adapters.nlua = function(callback, config)
      callback({type = 'server', host = config.host or '127.0.0.1', port = config.port or 8086})
    end

    dap.configurations['lua'] = {
      {
        type = 'nlua',
        request = 'attach',
        name = 'Attach to running Neovim instance',
        host = '127.0.0.1',
      },
    }
  end,
}
