local desc = Utils.plugin_keymap_desc("neotest")

return {
    "nvim-neotest/neotest",
    -- event = "VeryLazy",
    dependencies = {
        "nvim-neotest/nvim-nio",
        "nvim-neotest/neotest-plenary",
        "antoinemadec/FixCursorHold.nvim",
        -- "haydenmeade/neotest-jest",
        "marilari88/neotest-vitest",
        "nvim-neotest/neotest-jest",
        "fredrikaverpil/neotest-golang",
    },
    keys = {
        {"<leader>T", "", desc = "+test"},
        {"<leader>Tt", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = desc("Run File")},
        {"<leader>Ts", function() vim.cmd([[Neotest summary]]) end, desc = "Neotest toggle summary"},
        {"<leader>Tr", function() vim.cmd([[Neotest run]]) end, desc = desc("Run Nearest")},
        {"<leader>Tl", function() require("neotest").run.run_last() end, desc = desc("Run Last")},
        {"<leader>TO", function() require("neotest").output.open({enter = true, auto_close = true}) end, desc = desc("Show Output")},
        {"<leader>To", function() require("neotest").output_panel.toggle() end, desc = desc("Toggle Output Panel")},
        {"<leader>TS", function() require("neotest").run.stop() end, desc = desc("Stop")},
        {"<leader>Ta", function() vim.cmd([[Neotest attach]]) end, desc = "Neotest attach"},

        {"<leader>TwW", function() require("neotest").watch.toggle(vim.fn.expand("%")) end, desc = desc("Toggle watch mode (not working with jest)")},
        {
            "<leader>Tww",
            function()
                require("neotest").run.run({
                    vim.fn.expand("%"),
                    jestCommand = "jest --watch ",
                    vitestCommand = "npx vitest --watch",
                })
            end,
            desc = desc("Run test on watch mode"),
        },
    },
    config = function(opts)
        require("neotest").setup({
            adapters = {
                require("neotest-vitest")({
                    ---@async
                    ---@param name string Name of directory
                    ---@param rel_path string Path to directory, relative to root
                    ---@param root string Root directory of project
                    ---@return boolean
                    filter_dir = function(name, rel_path, root)
                        return name ~= "node_modules" and not name:match("e2e")
                    end,
                }),
                require("neotest-jest")({
                    jestCommand = "npm test --",
                    jestArguments = function(defaultArguments, context)
                        return defaultArguments
                    end,
                    jestConfigFile = "custom.jest.config.ts",
                    env = {CI = true},
                    cwd = function(path)
                        return vim.fn.getcwd()
                    end,
                    isTestFile = require("neotest-jest.jest-util").defaultIsTestFile,
                }),
                require("neotest-golang")({
                    dap_go_enabled = true,
                }),
            },
            quickfix = {open = false},
            output = {
                enabled = true,
                open = "botright split | resize 15",
            },
        })
    end,
}
