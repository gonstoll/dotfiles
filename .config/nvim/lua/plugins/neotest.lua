return {
    "nvim-neotest/neotest",
    dependencies = {
        "nvim-neotest/nvim-nio",
        "nvim-treesitter/nvim-treesitter",
        "nvim-lua/plenary.nvim",
        "antoinemadec/FixCursorHold.nvim",
        -- Adapters
        "nvim-neotest/neotest-jest",
        "marilari88/neotest-vitest",
        "thenbe/neotest-playwright",
        "fredrikaverpil/neotest-golang",
    },
    keys = function()
        local desc = Utils.plugin_keymap_desc("neotest")
        return {
            {"<leader>Tt", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = desc("Run File")},
            {"<leader>TT", function() require("neotest").run.run(vim.uv.cwd()) end, desc = desc("Run All Test Files")},
            {"<leader>Tr", function() require("neotest").run.run() end, desc = desc("Run Nearest")},
            {
                "<leader>Tw",
                function()
                    require("neotest").run.run({
                        vim.fn.expand("%"),
                        jestCommand =
                        "node_modules/.bin/jest --watch",
                    })
                end,
                desc = desc("Run test on watch mode"),
            },
            {"<leader>TW", function() require("neotest").watch.toggle(vim.fn.expand("%")) end, desc = desc("Toggle watch mode (not working with jest)")},
            {"<leader>Tl", function() require("neotest").run.run_last() end, desc = desc("Run Last")},
            {"<leader>Ts", function() require("neotest").summary.toggle() end, desc = desc("Toggle Summary")},
            {"<leader>To", function() require("neotest").output.open({enter = true, auto_close = true}) end, desc = desc("Show Output")},
            {"<leader>TO", function() require("neotest").output_panel.toggle() end, desc = desc("Toggle Output Panel")},
            {"<leader>TS", function() require("neotest").run.stop() end, desc = desc("Stop")},
        }
    end,
    opts = {
        status = {virtual_text = true},
        output = {open_on_run = true},
        output_panel = {
            open = "botright vsplit | vertical resize 80",
        },
        adapters = {
            ["neotest-jest"] = {
                env = {CI = true},
                jestCommand = "npm test --",
                jestConfigFile = "jest.config.js",
                -- jestConfigFile = function(file)
                --   if string.find(file, '/apps/') then
                --     return string.match(file, '(.-/[^/]+/)src') .. 'jest.config.ts'
                --   end
                --
                --   return vim.fn.getcwd() .. '/jest.config.js'
                -- end,
                cwd = function(file)
                    if string.find(file, "/apps/") or string.find(file, "/packages/") then
                        return string.match(file, "(.-/[^/]+/)src")
                    end
                    return vim.fn.getcwd()
                end,
            },
            ["neotest-vitest"] = {
                filter_dir = function(name, rel_path, root)
                    return name ~= "node_modules"
                end,
            },
            ["neotest-golang"] = {
                dap_go_enabled = true,
            },
        },
    },
    config = function(_, opts)
        local neotest_ns = vim.api.nvim_create_namespace("neotest")
        vim.diagnostic.config({
            virtual_text = {
                format = function(diagnostic)
                    -- Replace newline and tab characters with space for more compact diagnostics
                    local message = diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
                    return message
                end,
            },
        }, neotest_ns)

        if opts.adapters then
            local adapters = {}
            for name, config in pairs(opts.adapters or {}) do
                if type(name) == "number" then
                    if type(config) == "string" then
                        config = require(config)
                    end
                    adapters[#adapters + 1] = config
                elseif config ~= false then
                    local adapter = require(name)
                    if type(config) == "table" and not vim.tbl_isempty(config) then
                        local meta = getmetatable(adapter)
                        if adapter.setup then
                            adapter.setup(config)
                        elseif meta and meta.__call then
                            adapter(config)
                        else
                            error("Adapter " .. name .. " does not support setup")
                        end
                    end
                    adapters[#adapters + 1] = adapter
                end
            end
            opts.adapters = adapters
        end

        require("neotest").setup(opts)
    end,
}
