-- Config inspired from https://github.com/nikolovlazar/dotfiles/blob/main/.config/nvim/lua/plugins/dap.lua
-- and Lazyvim's https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/extras/dap/core.lua
-- For further explanation, see https://www.youtube.com/watch?v=Ul_WPhS2bis

local desc = require('utils').plugin_keymap_desc('dap')
local js_based_languages = {'typescript', 'javascript', 'typescriptreact', 'javascriptreact'}

---Splice out an inclusive range from a string
---@param string string
---@param start_idx number
---@param end_idx? number
---@return string
local function str_splice(string, start_idx, end_idx)
  local new_content = string:sub(1, start_idx - 1)
  if end_idx then
    return new_content .. string:sub(end_idx + 1)
  else
    return new_content
  end
end

---@param string string
---@param idx number
---@param needle string
---@return number?
local function str_rfind(string, idx, needle)
  for i = idx, 1, -1 do
    if string:sub(i, i - 1 + needle:len()) == needle then
      return i
    end
  end
end

---@param string string
---@param idx number
---@return string
---@return number?
local function get_to_line_end(string, idx)
  local newline = string:find('\n', idx, true)
  local to_end = newline and string:sub(idx, newline - 1) or string:sub(idx)
  return to_end, newline
end

---Decodes a json string that may contain comments or trailing commas
---@param content string
---@return any
local function decode_json(content)
  local ok, data = pcall(vim.json.decode, content, {luanil = {object = true}})
  while not ok do
    local char = data:match('invalid token at character (%d+)$')
    if char then
      local to_end, newline = get_to_line_end(content, char)
      if to_end:match('^//') then
        content = str_splice(content, char, newline)
        goto continue
      end
    end

    char = data:match('Expected object key string but found [^%s]+ at character (%d+)$')
    char = char or data:match('Expected value but found T_ARR_END at character (%d+)')
    if char then
      local comma_idx = str_rfind(content, char, ',')
      if comma_idx then
        content = str_splice(content, comma_idx, comma_idx)
        goto continue
      end
    end

    error(data)
    ::continue::
    ok, data = pcall(vim.json.decode, content, {luanil = {object = true}})
  end
  return data
end

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
    -- vscode-js-debug adapter
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
        adapters = {'chrome', 'pwa-node', 'pwa-chrome', 'pwa-msedge', 'pwa-extensionHost', 'node-terminal'},
      }
    },
    {'theHamsta/nvim-dap-virtual-text', opts = {}},
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
          dap_vscode.json_decode = decode_json
          dap_vscode.load_launchjs(nil, {
            ['chrome'] = js_based_languages,
            ['pwa-node'] = js_based_languages,
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
}

