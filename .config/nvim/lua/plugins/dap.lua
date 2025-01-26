local desc = Utils.plugin_keymap_desc('dap')
local desc_dapui = Utils.plugin_keymap_desc('dapui')
local desc_go = Utils.plugin_keymap_desc('dap go')
local desc_lua = Utils.plugin_keymap_desc('dap lua')

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
                {'<leader>duo', function() require('dapui').toggle() end, desc = desc_dapui('Toggle')},
                {'<leader>due', function() require('dapui').eval() end, desc = desc_dapui('Eval'), mode = {'n', 'v'}},
                -- See https://github.com/rcarriga/nvim-dap-ui/issues/161#issuecomment-1304500935
                {'<leader>dut', function() toggle_types() end, desc = desc_dapui('Toggle types')},
            },
            ---@type dapui.Config
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
                        size = 40,
                    },
                    {
                        elements = {
                            {id = 'console', size = 0.5},
                            {id = 'repl', size = 0.5},
                        },
                        position = 'bottom',
                        size = 10,
                    },
                },
            },
        },

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

        -- Lua adapter
        {
            'jbyuki/one-small-step-for-vimkind',
            keys = {
                {'<leader>dL', function() require('osv').launch({port = 8086}) end, desc = desc_lua('Launch Lua adapter')},
                {'<leader>dT', function() require('osv').run_this() end, desc = desc_lua('Lua adapter: Run this')},
            },
        },

        -- Go
        {
            'leoluz/nvim-dap-go',
            opts = {},
            ft = 'go',
            keys = {
                {'<leader>dGt', function() require('dap-go').debug_test() end, desc = desc_go('Debug closest test')},
                {'<leader>dGl', function() require('dap-go').debug_last_test() end, desc = desc_go('Debug last test')},
            },
        },
    },
    keys = function()
        local dap = require('dap')
        local widgets = require('dap.ui.widgets')

        return {
            {'<leader>dB', function() dap.set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, desc = desc('Breakpoint Condition')},
            {'<leader>db', function() dap.toggle_breakpoint() end, desc = desc('Toggle Breakpoint')},
            {'<leader>dc', function() dap.continue() end, desc = desc('Continue')},
            {'<leader>da', function() dap.continue({before = get_args}) end, desc = desc('Run with Args')},
            {'<leader>dC', function() dap.run_to_cursor() end, desc = desc('Run to Cursor')},
            {'<leader>dg', function() dap.goto_() end, desc = desc('Go to line (no execute)')},
            {'<leader>dj', function() dap.down() end, desc = desc('Down')},
            {'<leader>dk', function() dap.up() end, desc = desc('Up')},
            {'<leader>dl', function() dap.run_last() end, desc = desc('Run Last')},
            {'<leader>di', function() dap.step_into() end, desc = desc('Step Into')},
            {'<leader>dO', function() dap.step_out() end, desc = desc('Step Out')},
            {'<leader>do', function() dap.step_over() end, desc = desc('Step Over')},
            {'<leader>dp', function() dap.pause() end, desc = desc('Pause')},
            {'<leader>dr', function() dap.repl.toggle() end, desc = desc('Toggle REPL')},
            {'<leader>ds', function() dap.session() end, desc = desc('Session')},
            {'<leader>dt', function() dap.terminate() end, desc = desc('Terminate')},
            {'<leader>Td', function() require('neotest').run.run({strategy = 'dap'}) end, desc = desc('Debug Nearest')},
            {'<leader>dwh', function() widgets.hover() end, desc = desc('Widget - Hover')},
            {
                '<leader>dws',
                function()
                    -- widgets.sidebar(widgets.scopes,
                    --     {width = math.floor(vim.o.columns * 0.20)},
                    --     'aboveleft vsplit'
                    -- ).toggle()
                    widgets.centered_float(widgets.scopes, {border = 'single'})
                end,
                desc = desc('Widget - Scopes'),
            },
        }
    end,
    config = function()
        local dap = require('dap')
        local dapui = require('dapui')

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

        for name, sign in pairs(Utils.icons.dap) do
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
                    -- skipFiles = {'node_internals/**', 'node_modules/**'},
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
