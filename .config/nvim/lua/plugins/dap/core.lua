local desc = Utils.plugin_keymap_desc('dap')
local desc_dapui = Utils.plugin_keymap_desc('dapui')

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

local types_enabled = true
local toggle_types = function()
  types_enabled = not types_enabled
  require('dapui').update_render({max_type_length = types_enabled and -1 or 0})
end

return {
  'mfussenegger/nvim-dap',
  dependencies = {
    {'theHamsta/nvim-dap-virtual-text', opts = {}},

    {
      'rcarriga/nvim-dap-ui',
      keys = {
        {'<leader>duo', function() require('dapui').toggle({}) end, desc = desc_dapui('Toggle')},
        {'<leader>due', function() require('dapui').eval() end, desc = desc_dapui('Eval'), mode = {'n', 'v'}},
        -- See https://github.com/rcarriga/nvim-dap-ui/issues/161#issuecomment-1304500935
        {'<leader>dut', function() toggle_types() end, desc = desc_dapui('Toggle types')},
      },
      opts = {
        floating = {border = 'single'},
        layouts = {
          {
            elements = {
              {id = 'scopes', size = 0.25},
              {id = 'breakpoints', size = 0.25},
              {id = 'stacks', size = 0.25},
              {id = 'watches', size = 0.25},
            },
            position = 'left',
            size = 45,
          },
          {
            elements = {
              {id = 'console', size = 1},
            },
            position = 'bottom',
            size = 15,
          },
        },
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

    dap.listeners.after.event_initialized['dapui_config'] = function() dapui.open({}) end

    vim.api.nvim_set_hl(0, 'DapStoppedLine', {default = true, link = 'Visual'})

    for name, sign in pairs(Utils.icons.dap) do
      sign = type(sign) == 'table' and sign or {sign}
      vim.fn.sign_define(
        'Dap' .. name,
        {text = sign[1], texthl = sign[2] or 'DiagnosticInfo', linehl = sign[3], numhl = sign[3]}
      )
    end
  end,
}
