-- Config inspired from https://github.com/nikolovlazar/dotfiles/blob/main/.config/nvim/lua/plugins/dap.lua
-- and Lazyvim's https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/extras/dap/core.lua
-- For further explanation, see https://www.youtube.com/watch?v=Ul_WPhS2bis

local desc = require('utils').pluginKeymapDescriptor('dap')
local js_based_languages = {'typescript', 'javascript', 'typescriptreact', 'javascriptreact'}

---@param config {args?:string[]|fun():string[]?}
local function get_args(config)
  local args = type(config.args) == 'function' and (config.args() or {}) or config.args or {}
  config = vim.deepcopy(config)

  ---@cast args string[]
  config.args = function()
    ---@diagnostic disable-next-line: redundant-parameter
    local new_args = vim.fn.input('Run with args: ', table.concat(args, ' ')) --[[@as string]]
    return vim.split(vim.fn.expand(new_args) --[[@as string]], ' ')
  end

  return config
end

return {

  {
    'mfussenegger/nvim-dap',
    dependencies = {
      {
        'rcarriga/nvim-dap-ui',
        keys = {
          {'<leader>du', function() require('dapui').toggle({}) end, desc = desc('Dap UI')},
          {'<leader>de', function() require('dapui').eval() end, desc = desc('Eval'), mode = {'n', 'v'}},
        },
        opts = {},
      },
      -- Install the vscode-js-debug adapter
      {
        'microsoft/vscode-js-debug',
        -- After install, build it and rename the dist directory to out
        build = 'npm install --legacy-peer-deps --no-save && npx gulp vsDebugServerBundle && rm -rf out && mv dist out',
        version = '1.*',
      },
      {
        'mxsdev/nvim-dap-vscode-js',
        opts = {
          debugger_path = vim.fn.resolve(vim.fn.stdpath('data') .. '/lazy/vscode-js-debug'),
        },
      },
      {
        'theHamsta/nvim-dap-virtual-text',
        opts = {},
      },
      -- {
      --   'Joakker/lua-json5',
      --   build = './install.sh',
      -- },
    },
    keys = {
      {'<leader>dB', function() require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, desc = desc('Breakpoint Condition')},
      {'<leader>db', function() require('dap').toggle_breakpoint() end, desc = desc('Toggle Breakpoint')},
      {'<leader>dc', function() require('dap').continue() end, desc = desc('Continue')},
      {'<leader>dC', function() require('dap').run_to_cursor() end, desc = desc('Run to Cursor')},
      {'<leader>dg', function() require('dap').goto_() end, desc = desc('Go to line (no execute)')},
      {'<leader>di', function() require('dap').step_into() end, desc = desc('Step Into')},
      {'<leader>dj', function() require('dap').down() end, desc = desc('Down')},
      {'<leader>dk', function() require('dap').up() end, desc = desc('Up')},
      {'<leader>dl', function() require('dap').run_last() end, desc = desc('Run Last')},
      {'<leader>do', function() require('dap').step_out() end, desc = desc('Step Out')},
      {'<leader>dO', function() require('dap').step_over() end, desc = desc('Step Over')},
      {'<leader>dp', function() require('dap').pause() end, desc = desc('Pause')},
      {'<leader>dr', function() require('dap').repl.toggle() end, desc = desc('Toggle REPL')},
      {'<leader>ds', function() require('dap').session() end, desc = desc('Session')},
      {'<leader>dt', function() require('dap').terminate() end, desc = desc('Terminate')},
      {'<leader>dw', function() require('dap.ui.widgets').hover() end, desc = desc('Widgets')},
      {
        '<leader>da',
        function()
          if vim.fn.filereadable('.vscode/launch.json') then
            local dap_vscode = require('dap.ext.vscode')
            dap_vscode.load_launchjs(nil, {
              ['pwa-node'] = js_based_languages,
              ['chrome'] = js_based_languages,
              ['pwa-chrome'] = js_based_languages,
            })
          end
          require('dap').continue({before = get_args})
        end,
        desc = desc('Run with Args'),
      },
    },
    config = function()
      local dap = require('dap')
      local dapui = require('dapui')
      local icons = require('utils.icons')

      dap.listeners.after.event_initialized['dapui_config'] = function() dapui.open({}) end
      dap.listeners.before.event_terminated['dapui_config'] = function() dapui.close({}) end
      dap.listeners.before.event_exited['dapui_config'] = function() dapui.close({}) end

      vim.api.nvim_set_hl(0, 'DapStoppedLine', {default = true, link = 'Visual'})

      for name, sign in pairs(icons.dap) do
        sign = type(sign) == 'table' and sign or {sign}
        vim.fn.sign_define(
          'Dap' .. name,
          {text = sign[1], texthl = sign[2] or 'DiagnosticInfo', linehl = sign[3], numhl = sign[3]}
        )
      end

      for _, language in ipairs(js_based_languages) do
        dap.configurations[language] = {
          -- Debug single nodejs files
          {
            type = 'pwa-node',
            request = 'launch',
            name = 'Launch file',
            program = '${file}',
            cwd = vim.fn.getcwd(),
            sourceMaps = true,
          },
          -- Debug nodejs processes (make sure to add --inspect when you run the process)
          {
            type = 'pwa-node',
            request = 'attach',
            name = 'Attach',
            processId = require('dap.utils').pick_process,
            cwd = vim.fn.getcwd(),
            sourceMaps = true,
          },
          -- Debug web applications (client side)
          {
            type = 'pwa-chrome',
            request = 'launch',
            name = 'Launch & Debug Chrome',
            url = function()
              local co = coroutine.running()
              return coroutine.create(function()
                vim.ui.input({
                  prompt = 'Enter URL: ',
                  default = 'http://localhost:3000',
                }, function(url)
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
          },
          -- Divider for the launch.json derived configs
          {
            name = '----- ↓ launch.json configs (if available) ↓ -----',
            type = '',
            request = 'launch',
          },
        }
      end
    end,
  },
}
