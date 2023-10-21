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
    {
      'rcarriga/nvim-dap-ui',
      keys = {
        {
          '<leader>du',
          function() require('dapui').toggle({}) end,
          desc = 'Dap UI (toggle)'
        },
        {
          '<leader>de',
          function() require('dapui').eval() end,
          desc = 'Dap UI (eval)',
          mode = {'n', 'v'}
        },
      },
      opts = {},
      config = function(_, opts)
        -- setup dap config by VsCode launch.json file
        require('dap.ext.vscode').load_launchjs()
        local dap = require('dap')
        local dapui = require('dapui')
        dapui.setup(opts)
        dap.listeners.after.event_initialized['dapui_config'] = function()
          dapui.open({})
        end
        dap.listeners.before.event_terminated['dapui_config'] = function()
          dapui.close({})
        end
        dap.listeners.before.event_exited['dapui_config'] = function()
          dapui.close({})
        end
      end,
    },

    -- virtual text for the debugger
    {
      'theHamsta/nvim-dap-virtual-text',
      opts = {},
    },

    -- mason.nvim integration
    {
      'jay-babu/mason-nvim-dap.nvim',
      dependencies = 'mason.nvim',
      cmd = {'DapInstall', 'DapUninstall'},
      opts = {
        -- Makes a best effort to setup the various debuggers with
        -- reasonable debug configurations
        automatic_installation = true,

        -- You can provide additional configuration to the handlers,
        -- see mason-nvim-dap README for more information
        handlers = {},

        -- You'll need to check that you have the required things installed
        -- online, please don't ask me how to install them :)
        ensure_installed = {
          -- Update this to ensure that you have the debuggers for the langs you want
        },
      },
    },
  },

  keys = {
    {
      '<leader>dB',
      function() require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: ')) end,
      desc = '(DAP) Breakpoint Condition',
    },
    {
      '<leader>db',
      function() require('dap').toggle_breakpoint() end,
      desc = '(DAP) Toggle Breakpoint',
    },
    {'<leader>dc', function() require('dap').continue() end,         desc = '(DAP) Continue',},
    {
      '<leader>da',
      function() require('dap').continue({before = get_args}) end,
      desc = '(DAP) Run with Args',
    },
    {'<leader>dC', function() require('dap').run_to_cursor() end,    desc = '(DAP) Run to Cursor',},
    {'<leader>dg', function() require('dap').goto_() end,            desc = '(DAP) Go to line (no execute)',},
    {'<leader>di', function() require('dap').step_into() end,        desc = '(DAP) Step Into',},
    {'<leader>dj', function() require('dap').down() end,             desc = '(DAP) Down'},
    {'<leader>dk', function() require('dap').up() end,               desc = '(DAP) Up'},
    {'<leader>dl', function() require('dap').run_last() end,         desc = '(DAP) Run Last',},
    {'<leader>do', function() require('dap').step_out() end,         desc = '(DAP) Step Out',},
    {'<leader>dO', function() require('dap').step_over() end,        desc = '(DAP) Step Over',},
    {'<leader>dp', function() require('dap').pause() end,            desc = '(DAP) Pause'},
    {'<leader>dr', function() require('dap').repl.toggle() end,      desc = '(DAP) Toggle REPL',},
    {'<leader>ds', function() require('dap').session() end,          desc = '(DAP) Session'},
    {'<leader>dt', function() require('dap').terminate() end,        desc = '(DAP) Terminate'},
    {'<leader>dw', function() require('dap.ui.widgets').hover() end, desc = '(DAP) Widgets'},
  },

  config = function()
    local icons = {
      Stopped             = {'󰁕 ', 'DiagnosticWarn', 'DapStoppedLine'},
      Breakpoint          = ' ',
      BreakpointCondition = ' ',
      BreakpointRejected  = {' ', 'DiagnosticError'},
      LogPoint            = '.>',
    }

    vim.api.nvim_set_hl(0, 'DapStoppedLine', {default = true, link = 'Visual'})

    for name, sign in pairs(icons) do
      sign = type(sign) == 'table' and sign or {sign}
      vim.fn.sign_define(
        'Dap' .. name,
        {text = sign[1], texthl = sign[2] or 'DiagnosticInfo', linehl = sign[3], numhl = sign[3]}
      )
    end
  end,
}
