local js_filetypes = {'typescript', 'javascript', 'typescriptreact', 'javascriptreact'}

return {
  'mfussenegger/nvim-dap',
  dependencies = {
    -- Sets up adapters for javascript debugging
    -- {
    --   'mxsdev/nvim-dap-vscode-js',
    --   opts = {
    --     debugger_path = vim.fn.resolve(vim.fn.stdpath('data') .. '/lazy/vscode-js-debug'),
    --     adapters = {'pwa-node', 'pwa-chrome', 'pwa-msedge', 'node-terminal', 'pwa-extensionHost'},
    --   },
    -- },

    -- vscode-js-debug (so, javascript) adapter
    {
      'microsoft/vscode-js-debug',
      build = 'npm i && npm run compile vsDebugServerBundle && rm -rf out && mv -f dist out',
    },
  },
  opts = function()
    local dap = require('dap')

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

    -- setup dap config by VsCode launch.json file
    local dap_vscode = require('dap.ext.vscode')
    local json = require('plenary.json')
    ---@diagnostic disable-next-line: duplicate-set-field
    dap_vscode.json_decode = function(str)
      return vim.json.decode(json.json_strip_comments(str, {}))
    end

    dap_vscode.type_to_filetypes['node'] = js_filetypes

    if not dap.adapters['pwa-node'] then
      dap.adapters['pwa-node'] = {
        type = 'server',
        host = 'localhost',
        port = '${port}',
        executable = {
          command = 'node',
          args = {
            Utils.get_pkg_path('js-debug-adapter', '/js-debug/src/dapDebugServer.js'),
            '${port}',
          },
        },
      }
    end

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
  end,
}
